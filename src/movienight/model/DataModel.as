package movienight.model
{
	import movienight.model.vo.CategoryVO;
	import movienight.model.vo.LeaderboardEntryVO;
	import movienight.model.vo.LeaderboardVO;
	import movienight.model.vo.QuestionVO;
	import movienight.model.vo.ResultVO;
	
	import starling.textures.Texture;
	
	public class DataModel
	{
		
		private var _originalCategoryData : Object;
		private var _categories : Vector.<CategoryVO>;
		private var _leaderboard : LeaderboardVO;
		private var _currentCategory : CategoryVO;
		private var _currentQuestion : QuestionVO;
		private var _userName : String = "";
		private var _avatarTexture : Texture;
		private var _results : Vector.<ResultVO>;
		private var _photoPending : Boolean;
		
		////////////////////////////////////////////////////////////////
		
		public function get categories() : Vector.<CategoryVO> { return _categories; }
		
		public function get leaderboard() : LeaderboardVO { return _leaderboard; }
		
		public function get currentCategory() : CategoryVO { return _currentCategory; }
		
		public function get currentQuestion() : QuestionVO { return _currentQuestion; }
		
		public function get results() : Vector.<ResultVO> { 
			if( !_results ) _results = new Vector.<ResultVO>();
			return _results; 
		}
		
		public function get userName() : String{ return _userName; }
		public function set userName( value : String ) : void { _userName = value; }		
		
		public function get photoPending() : Boolean { return _avatarTexture ? true : false; }
		
		public function get avatarTexture() : Texture { return _avatarTexture; }
		public function set avatarTexture( value : Texture ) : void { _avatarTexture = value; }
		
		public function get lastRoundResult() : ResultVO
		{
			if( !_results || _results.length < 1 ) return null;
			return _results[ _results.length - 1 ];
		}
			
		public function get totalScore() : int
		{
			var score : int = 0;
			for( var i : int; i < _results.length; i++ ) score += _results[i].score;
			return score;
		}
		
		////////////////////////////////////////////////////////////////
		
		public function get userLeaderboardVO() : LeaderboardEntryVO
		{
			var vo : LeaderboardEntryVO = new LeaderboardEntryVO();
			vo.player = userName;
			vo.score = totalScore;
			return vo;
		}
		
		////////////////////////////////////////////////////////////////
		
		public function startNewGame() : void 
		{
			_currentCategory = null;
			_currentQuestion = null;
			_categories = null;
			_results = new Vector.<ResultVO>();
			parseCategoryData( _originalCategoryData );
		}
		
		////////////////////////////////////////////////////////////////
		
		public function getRandomValidCategoryIndex() : int 
		{
			var catIndex : int = Math.floor( Math.random() * ( _categories.length - 1 ) );
			while( _categories[catIndex].questions.length < 1 )
			{
				catIndex = Math.floor( Math.random() * _categories.length );
			}
			return catIndex;
		}
		
		////////////////////////////////////////////////////////////////
		
		public function selectCategory( categoryIndex : int ) : void 
		{
			_currentCategory = _categories[ categoryIndex ];
			_currentQuestion = selectRandomQuestion( _currentCategory );
		}
		
		////////////////////////////////////////////////////////////////
		
		public function storeResult( vo : ResultVO ) : void 
		{
			if( !_results ) _results = new Vector.<ResultVO>();
			_results.push( vo );
		}
		
		////////////////////////////////////////////////////////////////
		
		public function parseCategoryData( data : Object ) : void 
		{
			if( !_originalCategoryData ) _originalCategoryData = data;
			_categories = new Vector.<CategoryVO>();
			for( var i : int; i < data.categories.length; i++ )
			{
				_categories.push( CategoryVO.deserialise( data.categories[i] ) );
			}
		}
		
		////////////////////////////////////////////////////////////////
		
		private function selectRandomQuestion( category : CategoryVO ) : QuestionVO
		{
			var randomIndex : int = Math.floor( Math.random() * category.questions.length );
			return category.questions.splice( randomIndex, 1 )[0];
		}
		
		////////////////////////////////////////////////////////////////
		
		public function parseLeaderboardData( data : Object ) : void 
		{
			_leaderboard = LeaderboardVO.deserialise( data );
		}
		
		////////////////////////////////////////////////////////////////
	}
}
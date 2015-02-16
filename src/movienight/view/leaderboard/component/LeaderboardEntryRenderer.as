package movienight.view.leaderboard.component
{
	import fonts.PlutoSansMedium;
	import fonts.PlutoSansRegular;
	
	import movienight.enum.Constants;
	import movienight.model.vo.LeaderboardEntryVO;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.TextureAtlas;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class LeaderboardEntryRenderer extends Sprite
	{
		
		public var vo : LeaderboardEntryVO;
		
		private var _bg : Image;
		private var _rankBg : Image;
		private var _rankText : TextField;
		private var _nameText : TextField;
		private var _scoreText : TextField;
		private var _ptsText : TextField;
		
		////////////////////////////////////////////////////////////////
		
		public function LeaderboardEntryRenderer( leaderboardEntry : LeaderboardEntryVO, rank : int )
		{
			vo = leaderboardEntry;
			
			var atlas : TextureAtlas = Constants.COMMON_ATLAS;
			
			_bg = new Image( atlas.getTexture("leaderboard_renderer_bg") );
			
			_rankBg = new Image( atlas.getTexture("leaderboard_renderer_rank_bg") );
			_rankBg.x = 10;
			_rankBg.y = 7;
			
			_rankText = new TextField( _rankBg.width, _rankBg.height, rank.toString(), new PlutoSansRegular().fontName, 50, 0xFFFFFF );
			_rankText.hAlign = HAlign.CENTER;
			_rankText.vAlign = VAlign.CENTER;
			_rankText.x = 7;
			_rankText.y = 9;
			
			_nameText = new TextField( _bg.width, _bg.height, vo.player.toUpperCase(), new PlutoSansMedium().fontName, 32, 0x3ea9f5 );
			_nameText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			_nameText.x = ( _bg.width - _nameText.width ) >> 1;
			_nameText.y = 10;
			
			_scoreText = new TextField( _bg.width, _bg.height, vo.score.toString(), new PlutoSansRegular().fontName, 25, 0x333333 );
			_scoreText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			_scoreText.x = ( _bg.width - _scoreText.width ) >> 1;
			_scoreText.y = 45;
			
			_ptsText = new TextField( _bg.width, _bg.height, "pts", new PlutoSansRegular().fontName, 16, 0x333333 );
			_ptsText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			_ptsText.x = _scoreText.x + _scoreText.width;
			_ptsText.y = _scoreText.y + _scoreText.height - _ptsText.height - 4;
			
			addChild( _bg );
			addChild( _rankBg );
			addChild( _rankText );
			addChild( _nameText )
			addChild( _scoreText );
			addChild( _ptsText );
			
		}
		
		////////////////////////////////////////////////////////////////
		
		override public function dispose() : void
		{
			while( numChildren > 0 ) removeChildAt(0, true);
			super.dispose();
		}
		
		////////////////////////////////////////////////////////////////
	}
}
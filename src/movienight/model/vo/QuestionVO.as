package movienight.model.vo
{
	public class QuestionVO
	{
		public var question : String;
		public var imageURL : String;
		public var answerIdx : int = -1;
		public var answers : Vector.<String>;
		
		////////////////////////////////////////////////////////////////
		
		public static function deserialise( jsonObj : Object ) : QuestionVO
		{
			var vo : QuestionVO = new QuestionVO();
			for( var prop : String in jsonObj )
			{
				if( vo.hasOwnProperty( prop ) )
				{
					if( prop == "answers" )
					{
						vo.answers = new Vector.<String>();
						for( var i : int; i < jsonObj.answers.length; i++ )
						{
							vo.answers.push( jsonObj.answers[i] );
						}
					}
					else vo[prop] = jsonObj[prop];
				}
			}
			return vo;
		}
		
		////////////////////////////////////////////////////////////////
		
		public function validate() : Boolean 
		{
			var valid : Boolean = true;
			if( !question ) return false;
			if( !imageURL ) return false;
			if( !answers || answers.length !== 3 ) return false;
			if( answerIdx < 0 || answerIdx > answers.length - 1 ) return false;
			return valid;
		}
		
		////////////////////////////////////////////////////////////////
	}
}
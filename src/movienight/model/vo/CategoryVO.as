package movienight.model.vo
{
	public class CategoryVO
	{
		public var name : String;
		public var questions : Vector.<QuestionVO>;
		
		////////////////////////////////////////////////////////////////
		
		public static function deserialise( jsonObj : Object ) : CategoryVO
		{
			var vo : CategoryVO = new CategoryVO();
			for( var prop : String in jsonObj )
			{
				if( vo.hasOwnProperty( prop ) )
				{
					if( prop == "questions" )
					{
						vo.questions = new Vector.<QuestionVO>();
						var q : QuestionVO;
						for( var i : int; i < jsonObj.questions.length; i++ )
						{
							q = QuestionVO.deserialise( jsonObj.questions[i] )
							if( q.validate() ) vo.questions.push( q );
						}
					}
					else vo[prop] = jsonObj[prop];
				}
			}
			return vo;
		}
		
		////////////////////////////////////////////////////////////////
	}
}
package movienight.model.vo
{
	public class LeaderboardEntryVO
	{
		
		public var player : String;
		public var score : int;

		////////////////////////////////////////////////////////////////
		
		public static function deserialise( jsonObj : Object ) : LeaderboardEntryVO
		{
			var vo : LeaderboardEntryVO = new LeaderboardEntryVO();
			for( var prop : String in jsonObj )
			{
				if( vo.hasOwnProperty( prop ) )
				{
					vo[prop] = jsonObj[prop];
				}
			}
			return vo;
		}
		
		////////////////////////////////////////////////////////////////
	}
}
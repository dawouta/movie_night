package movienight.model.vo
{
	public class LeaderboardVO
	{
		
		public var entries : Vector.<LeaderboardEntryVO> 
		
		////////////////////////////////////////////////////////////////
		
		public static function deserialise( jsonObj : Object ) : LeaderboardVO
		{
			var vo : LeaderboardVO = new LeaderboardVO();
			for( var prop : String in jsonObj )
			{
				if( prop == "leaderboard" )
				{
					vo.entries = new Vector.<LeaderboardEntryVO>();
					for( var i : int; i < jsonObj.leaderboard.length; i++ )
					{
						vo.entries.push( LeaderboardEntryVO.deserialise( jsonObj.leaderboard[i] ) );
					}
				}
			}
			return vo;
		}
		
		////////////////////////////////////////////////////////////////
	}
}
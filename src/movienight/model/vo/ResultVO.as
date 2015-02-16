package movienight.model.vo
{
	import movienight.enum.Constants;

	public class ResultVO
	{
		
		public var roundIndex : int = -1;
		public var score : int;
		public var wasCorrect : Boolean;
		public var bonusScore : int;
		public var multiplier : Number;
		private var _time : int;
		
		////////////////////////////////////////////////////////////////

		public function get timeString() : String { return formatToTimeString( time ); }
		public function get time() : int { return _time; }
		public function set time( value : int ) : void 
		{
			_time = value;
			var p : Number = ( Constants.TIME_PER_QUESTION - _time ) / Constants.TIME_PER_QUESTION;
			if( p < 0.1 ) multiplier = 1.5;
			else if( p < 0.2 ) multiplier = 1.4;
			else if( p < 0.3 ) multiplier = 1.3;
			else if( p < 0.4 ) multiplier = 1.2;
			else if( p < 0.5 ) multiplier = 1;
			else if( p < 0.8 ) multiplier = 0.5;
			else multiplier = 0.25;
			score = _time * multiplier;
			bonusScore = score - _time;
			p=0;
		}
		
		////////////////////////////////////////////////////////////////
		
		private function formatToTimeString( milliseconds : int ) : String
		{
			var msStr : String = milliseconds.toString();
			msStr = msStr.substr( msStr.length - 3, 2 );
			
			var s : int = ( ( milliseconds * 0.001 ) % 60 );
			var sStr : String = s < 10 ? "0" + s.toString() : s.toString();
			
			return sStr + ":" + msStr;
		}
	}
}
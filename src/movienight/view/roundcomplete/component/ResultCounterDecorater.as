package movienight.view.roundcomplete.component
{
	import starling.text.TextField;

	public class ResultCounterDecorater
	{
		
		private var _result : int = 0;
		private var _text : TextField;
		
		////////////////////////////////////////////////////////////////

		public function get result():int { return _result; }
		public function set result(value:int):void
		{
			_result = value;
		}
		
		////////////////////////////////////////////////////////////////
		
		public function ResultCounterDecorater( textField : TextField )
		{
			_text = textField;
		}
		
		////////////////////////////////////////////////////////////////

	}
}
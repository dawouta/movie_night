package movienight.controller.signal
{

	import movienight.util.Tracer;
	
	import org.osflash.signals.Signal;
	
	public class SignalNavigate extends Signal
	{
		
		private var _destination : String;
		
		////////////////////////////////////////////////////////////////
		
		public function SignalNavigate(...parameters)
		{
			super( String );
		}
		
		////////////////////////////////////////////////////////////////
		
		override public function dispatch(...params):void
		{
			Tracer.out( "NAVIGATING : " + params[0] );
			_destination = params[0];
			super.dispatch( _destination );
		}
		
		////////////////////////////////////////////////////////////////
		
		public function get destination():String { return _destination; }
		
		////////////////////////////////////////////////////////////////
		
	}
}



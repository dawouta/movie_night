package movienight.controller.signal
{
	import org.osflash.signals.Signal;
	
	public class SignalAppDataLoadError extends Signal
	{
		
		////////////////////////////////////////////////////////////////
		
		public function SignalAppDataLoadError(...parameters)
		{
			super(Error);
		}
		
		////////////////////////////////////////////////////////////////
	}
}
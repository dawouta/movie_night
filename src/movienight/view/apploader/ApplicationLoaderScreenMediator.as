package movienight.view.apploader
{
	import movienight.controller.signal.SignalAppDataLoadError;
	import movienight.controller.signal.SignalAppDataLoaded;
	import movienight.controller.signal.SignalRequestAppData;
	import movienight.enum.Screens;
	
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;
	
	import starling.core.Starling;
	
	public class ApplicationLoaderScreenMediator extends StarlingMediator
	{
		[Inject]
		public var view : ApplicationLoaderScreen;
		
		[Inject]
		public var signalRequestData : SignalRequestAppData;
		
		[Inject]
		public var signalAppDataLoaded : SignalAppDataLoaded;
		
		[Inject]
		public var signalAppDataLoadError : SignalAppDataLoadError;
		
		private var _readyToStart : Boolean;
		
		////////////////////////////////////////////////////////////////
		
		override public function initialize():void
		{
			super.initialize();
			
			signalAppDataLoaded.add( confirmReadyToStart );
			signalAppDataLoadError.add( onDataError );
			view.signalShowComplete.add( confirmReadyToStart );
			view.signalTryAgain.add( onTryAgain );
			view.build();
			view.displayLoader();
			
			Starling.juggler.delayCall( signalRequestData.dispatch, 2 );
		}
		
		////////////////////////////////////////////////////////////////
		
		private function confirmReadyToStart() : void 
		{
			if( _readyToStart ) view.signalChangeScreen.dispatch( Screens.START_SCREEN );
			_readyToStart = true;
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onDataError( error : Error ) : void 
		{
			view.displayError( error.message );
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onTryAgain() : void 
		{
			Starling.juggler.delayCall( signalRequestData.dispatch, 0.8 );
			view.displayLoader();
		}
		
		////////////////////////////////////////////////////////////////
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		////////////////////////////////////////////////////////////////
	}
}
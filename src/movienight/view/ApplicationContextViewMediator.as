package movienight.view
{
	import movienight.controller.signal.SignalAppDataLoaded;
	import movienight.controller.signal.SignalNavigate;
	import movienight.enum.Constants;
	import movienight.enum.Screens;
	import movienight.util.Tracer;
	
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;
	
	import starling.core.Starling;
	
	public class ApplicationContextViewMediator extends StarlingMediator
	{
		
		[Inject]
		public var signalNavigate : SignalNavigate;

		[Inject]
		public var view : ApplicationContextView;
		
		[Inject]
		public var signalAppDataLoaded : SignalAppDataLoaded;
		
		////////////////////////////////////////////////////////////////
		
		override public function initialize():void
		{
			Tracer.out();
			AudioAssets.init();
			Constants.COMMON_ATLAS = Assets.getTextureAtlas( "CommonAtlas", "CommonAtlasXML" );
			signalNavigate.add( navigate );
			signalAppDataLoaded.add( onAppDataLoaded );
			view.init();
			Starling.juggler.delayCall( view.showScreen, 2.0, Constants.INIT_SCREEN );
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onAppDataLoaded() : void
		{
			view.showScreen( Screens.START_SCREEN );
		}
		
		////////////////////////////////////////////////////////////////

		private function navigate( screenName : String ) : void 
		{
			view.showScreen( screenName );
		}
		
		////////////////////////////////////////////////////////////////
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		////////////////////////////////////////////////////////////////
		
	}
}
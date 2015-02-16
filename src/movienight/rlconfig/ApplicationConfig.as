package movienight.rlconfig
{
	import movienight.controller.command.RequestAppDataCommand;
	import movienight.controller.signal.SignalAppDataLoadError;
	import movienight.controller.signal.SignalAppDataLoaded;
	import movienight.controller.signal.SignalNavigate;
	import movienight.controller.signal.SignalRequestAppData;
	import movienight.model.DataModel;
	import movienight.util.Tracer;
	import movienight.view.ApplicationContextView;
	import movienight.view.ApplicationContextViewMediator;
	import movienight.view.apploader.ApplicationLoaderScreen;
	import movienight.view.apploader.ApplicationLoaderScreenMediator;
	import movienight.view.camera.CameraScreen;
	import movienight.view.camera.CameraScreenMediator;
	import movienight.view.categoryselect.CategorySelectScreen;
	import movienight.view.categoryselect.CategorySelectScreenMediator;
	import movienight.view.game.GameScreen;
	import movienight.view.game.GameScreenMediator;
	import movienight.view.leaderboard.LeaderboardScreen;
	import movienight.view.leaderboard.LeaderboardScreenMediator;
	import movienight.view.roundcomplete.RoundCompleteScreen;
	import movienight.view.roundcomplete.RoundCompleteScreenMediator;
	import movienight.view.start.StartScreen;
	import movienight.view.start.StartScreenMediator;
	
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.api.LogLevel;
	
	public class ApplicationConfig implements IConfig
	{
		
		[Inject]
		public var context : IContext;
		
		[Inject]
		public var mediatorMap : IMediatorMap;
		
		[Inject]
		public var signalCommandMap : ISignalCommandMap;
		
		[Inject]
		public var injector : IInjector;
		
		////////////////////////////////////////////////////////////////
		
		public function configure():void
		{
			context.logLevel = LogLevel.DEBUG;
			mapSingletons();
			mapMediators();
			mapCommandsAndSignals();
			mapInstances();
			context.afterInitializing( configComplete );
		}
		
		////////////////////////////////////////////////////////////////
		
		private function mapSingletons() : void 
		{
			injector.map( DataModel ).asSingleton();
			injector.map( SignalAppDataLoaded ).asSingleton();
			injector.map( SignalAppDataLoadError ).asSingleton();
			injector.map( SignalNavigate ).asSingleton();
		}
		
		////////////////////////////////////////////////////////////////
		
		private function mapMediators() : void
		{
			
			mediatorMap.map( ApplicationContextView ).toMediator( ApplicationContextViewMediator );
			
			mediatorMap.map( ApplicationLoaderScreen ).toMediator( ApplicationLoaderScreenMediator );
			mediatorMap.map( StartScreen ).toMediator( StartScreenMediator );
			mediatorMap.map( CameraScreen ).toMediator( CameraScreenMediator );
			mediatorMap.map( CategorySelectScreen ).toMediator( CategorySelectScreenMediator );
			mediatorMap.map( GameScreen ).toMediator( GameScreenMediator );
			mediatorMap.map( RoundCompleteScreen ).toMediator( RoundCompleteScreenMediator );
			mediatorMap.map( LeaderboardScreen ).toMediator( LeaderboardScreenMediator );
		}
		
		////////////////////////////////////////////////////////////////
		
		private function mapCommandsAndSignals() : void 
		{
			signalCommandMap.map( SignalRequestAppData ).toCommand( RequestAppDataCommand );
		}
		
		////////////////////////////////////////////////////////////////
		
		private function mapInstances() : void 
		{
		}
		
		////////////////////////////////////////////////////////////////
		
		private function configComplete() : void 
		{
			Tracer.out( "Application Configure complete" );
		}
		
		////////////////////////////////////////////////////////////////
		
	}
}



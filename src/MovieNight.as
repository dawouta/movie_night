package
{
	
	import com.greensock.TweenMax;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageAspectRatio;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.utils.Timer;
	
	import movienight.enum.Constants;
	import movienight.rlconfig.ApplicationConfig;
	import movienight.view.ApplicationContextView;
	
	import robotlegs.bender.bundles.mvcs.MVCSBundle;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.signalCommandMap.SignalCommandMapExtension;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.Context;
	import robotlegs.extensions.starlingViewMap.StarlingViewMapExtension;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	public class MovieNight extends Sprite
	{
		
		private var _splash : Sprite;
		private var _context : IContext;
		private var _starling : Starling;
		private var _aspectRatio:String;
		private var t:Timer;
		
		////////////////////////////////////////////////////////////////
		
		public function MovieNight()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			stage.color = 0xFFFFFF;
			stage.addEventListener(flash.events.Event.RESIZE, init);
			_aspectRatio = StageAspectRatio.PORTRAIT;
			stage.setAspectRatio(StageAspectRatio.PORTRAIT);
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		
		////////////////////////////////////////////////////////////////
		
		public function init( event : flash.events.Event ) : void 
		{
			
			stage.removeEventListener(flash.events.Event.RESIZE, init);
			
			var ratio:Number = stage.fullScreenWidth / stage.fullScreenHeight;
			Constants.APP_HEIGHT = 960;
			Constants.APP_WIDTH = Constants.APP_HEIGHT * ratio;
			
			_splash = new Sprite();
			addChild( _splash );
			
			var backgroundLoader:Loader = new Loader();
			backgroundLoader.contentLoaderInfo.addEventListener( flash.events.Event.COMPLETE, onSplashLoaded );
			
			var file:File;
			var path : String;
			if( Capabilities.screenDPI < 220 )
			{
				path = "Default-Portrait.png"
			}
			else
			{
				path = "Default-Portrait@2x.png"
			}
			file = File.applicationDirectory.resolvePath( path );
			backgroundLoader.load(new URLRequest(file.url));
		}
		
		////////////////////////////////////////////////////////////////
		
		private function setupStarling() : void 
		{
			var viewport : Rectangle = new Rectangle( 0, 0, stage.fullScreenWidth, stage.fullScreenHeight );
			_starling = new Starling( ApplicationContextView, stage, viewport );
			_starling.simulateMultitouch = Constants.DEBUG;
			_starling.addEventListener( starling.events.Event.ROOT_CREATED, onStarlingCreated ); 
			_starling.stage.stageWidth = Constants.APP_WIDTH;
			_starling.stage.stageHeight = Constants.APP_HEIGHT;
			if( Constants.DEBUG )_starling.showStatsAt( "right", "bottom" );
			
			Assets.contentScaleFactor = _starling.contentScaleFactor;
			Constants.ASSET_SCALE = "x"+Assets.contentScaleFactor;
		}
		
		////////////////////////////////////////////////////////////////
		
		private function setupRobotLegs() : void 
		{
			_context = new Context();
			_context.install( MVCSBundle, StarlingViewMapExtension, SignalCommandMapExtension );
			_context.configure( ApplicationConfig, new ContextView( this ), _starling );
		}
		
		////////////////////////////////////////////////////////////////
		
		
		private function onSplashLoaded( event : flash.events.Event ) : void 
		{
			var background:Bitmap = new Bitmap(event.currentTarget.content.bitmapData, "auto", true);
			background.width = stage.fullScreenWidth;
			background.height = stage.fullScreenHeight;
			_splash.addChildAt(background, 0);
			setupStarling();
			setupRobotLegs();
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onStarlingCreated( event : starling.events.Event ) : void 
		{
			if(_splash)
			{
				TweenMax.to(_splash, 0.2, {delay:1.0, alpha:0.0, onComplete:function():void{
					removeChild(_splash);
					for (var i:int = 0; i < _splash.numChildren; i++) 
					{
						var bitmap:Bitmap = _splash.getChildAt(i) as Bitmap;
						bitmap.bitmapData.dispose();
						bitmap == null;
					}
					
					_splash = null;
				}});
			}
			
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, 
				function (e:flash.events.Event):void { 
					_starling.start(); 
				} 
			);
			
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, 
				function (e:flash.events.Event):void {
					_starling.stop(); 
					SoundMixer.stopAll();
				} 
			);
			
			_starling.start();
		}
		
		////////////////////////////////////////////////////////////////
		
	}
}
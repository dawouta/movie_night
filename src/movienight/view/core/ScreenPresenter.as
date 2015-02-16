package movienight.view.core
{
	import flash.system.System;
	
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	
	import movienight.util.Tracer;
	import movienight.util.Utils;
	
	import org.osflash.signals.Signal;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class ScreenPresenter extends Sprite
	{
		
		public var signalCacheScreenChangeRequest : Signal = new Signal( String );
		public var signalCommitToHistory : Signal = new Signal( String );
		
		public var navigator : ScreenNavigator;
		
		private var _locked:Boolean = false;
		private var _cachedDest:String;
		private var _prevScreen:ScreenView;
		
		////////////////////////////////////////////////////////////////
		
		public function ScreenPresenter()
		{
			
			navigator = new ScreenNavigator();
			addChild( navigator );
			
			navigator.addEventListener( Event.CHANGE, handleScreenShown );
			
		}
		
		////////////////////////////////////////////////////////////////
		
		public function addScreen( name : String, viewClass : Class ) : void 
		{
			Tracer.out( name );
			if ( Utils.isSubclassOf( viewClass, ScreenView ) )
			{
				navigator.addScreen( name, new ScreenNavigatorItem( viewClass ) );
			}
			else 
			{
				throw new ArgumentError( "Views must subclass 'ScreenView'" );
			}
		}
		
		////////////////////////////////////////////////////////////////
		
		public function showScreen( name : String ) : void 
		{
			signalCacheScreenChangeRequest.dispatch( name );
			Tracer.out( name );
			if (_locked)
			{
				Tracer.out("Screen change to '" + name + "' aborted due to previous transition to '" + _cachedDest + "' in progress");
				return;
			}
			
			if (navigator.activeScreenID == name)
			{
				Tracer.out("Screen change to '" + name + "' aborted because current screen is already showing");
				return;
			}
			
			//Only deal with one request at a time for good hygiene 
			_locked = true;
			
			_cachedDest = name;
			
			var screen:ScreenView = navigator.activeScreen as ScreenView;
			if (screen != null)
			{
				_prevScreen = screen;
				_prevScreen.signalChangeScreen.remove(handleChangeScreen);
				screen.signalHideComplete.addOnce(handleShowScreenPrimed);
				screen.hide();
				return
			}
			handleShowScreenPrimed();
		}
		
		////////////////////////////////////////////////////////////////
		
		private function handleShowScreenPrimed():void
		{
			if (_cachedDest == null)
			{
				Tracer.out("clearing screen")
				navigator.clearScreen();
				handleScreenShownComplete();
				return;
			}
			navigator.showScreen(_cachedDest);
			//function will complete on handleScreenShown listener
		}
		
		////////////////////////////////////////////////////////////////
		
		private function handleScreenShown(e:Event):void 
		{
			Tracer.out();
			var screen:ScreenView = navigator.activeScreen as ScreenView;
			
			// show loader if needed
			
			if (screen != null)
			{
				screen.signalShowComplete.addOnce( handleScreenShownComplete );
				screen.signalChangeScreen.add( handleChangeScreen );
				screen.show();
				
				return;
			}
			
			handleScreenShownComplete();
		}
		
		////////////////////////////////////////////////////////////////
		
		private function handleScreenShownComplete():void
		{
			//Once the transition is complete, free the memory of the previous view
			//Need ot be careful that hit of loading next mem before unloading prev mem is too severe 
			if (_prevScreen)
			{
				_prevScreen.destroy();
				_prevScreen = null;
				
				//run garbage collection. Seeing as this happens after all animation it shouldn't cause jumps, but will need to verify this
				System.gc();
			}
			
			signalCommitToHistory.dispatch( _cachedDest );
			_cachedDest = null;
			_locked = false;
			//Ready for next showScreen call
		}
		
		////////////////////////////////////////////////////////////////
		
		private function handleChangeScreen(destination:String):void
		{
			showScreen(destination);
		}
		
		////////////////////////////////////////////////////////////////
		
	}
}
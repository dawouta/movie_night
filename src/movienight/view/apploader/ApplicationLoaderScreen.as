package movienight.view.apploader
{
	
	import fonts.PlutoSansLight;
	
	import movienight.enum.Constants;
	import movienight.enum.Strings;
	import movienight.util.Factory;
	import movienight.util.Tracer;
	import movienight.util.Utils;
	import movienight.view.core.ScreenView;
	import movienight.view.ui.components.SignalButton;
	
	import org.osflash.signals.Signal;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class ApplicationLoaderScreen extends ScreenView
	{
		
		public var signalTryAgain : Signal = new Signal();
		
		private var _cwSpinner : Image;
		private var _acwSpinner : Image;
		private var _loadingText : TextField;
		private var _errorText : TextField;
		private var _errorButton : SignalButton;
		private var _logo : Image;
		
		////////////////////////////////////////////////////////////////
		
		public function build():void
		{
			Tracer.out();
			
			var atlas : TextureAtlas = Constants.COMMON_ATLAS;
			
			_logo = new Image( atlas.getTexture( "logo_large" ) );
			Utils.centerPivot( _logo );
			_logo.x = Constants.APP_WIDTH >> 1;
			_logo.y = 216;
			addChild( _logo );
			
			var t : Texture = atlas.getTexture("application_loader_spinner");
			_cwSpinner = new Image( t );
			_acwSpinner = new Image( t );
			
			Utils.centerPivot( _cwSpinner );
			Utils.centerPivot( _acwSpinner );
			_cwSpinner.x = _acwSpinner.x = Constants.APP_WIDTH >> 1;
			_cwSpinner.y = _acwSpinner.y = Constants.APP_HEIGHT * 0.75;
			_acwSpinner.scaleX = -1;
			
			_loadingText = new TextField( 300, 60, Strings.LOADING_DATA, new PlutoSansLight().fontName, 24, 0xFFFFFF );
			_loadingText.autoSize = TextFieldAutoSize.HORIZONTAL;
			_loadingText.x = ( Constants.APP_WIDTH - _loadingText.width ) * 0.5;
			_loadingText.y = _cwSpinner.y + _cwSpinner.height;
			
			addChild( _cwSpinner );
			addChild( _acwSpinner );
			addChild( _loadingText );
		}
		
		////////////////////////////////////////////////////////////////
		
		public function displayLoader() : void 
		{
			Starling.juggler.tween( _cwSpinner, 0.3, {delay: 0.3, alpha : 1} );
			Starling.juggler.tween( _acwSpinner, 0.3, {delay: 0.3, alpha : 1} );
			Starling.juggler.tween( _loadingText, 0.3, {delay: 0.3, alpha : 1} );
		}
		
		////////////////////////////////////////////////////////////////
		
		public function displayError( message : String ) : void 
		{
			
			if( message == "ConnectionError" ) message = Strings.CONNECTION_ERROR.toUpperCase();
			_errorButton = Factory.createDefaultButton( Strings.TRY_AGAIN );
			_errorButton.x = ( Constants.APP_WIDTH - _errorButton.width ) * 0.5;
			_errorButton.y = 820;
			_errorButton.signalTriggered.add( onTryAgain );
			_errorButton.alpha = 0;
			addChild( _errorButton );
			
			_errorText = new TextField( Constants.APP_WIDTH - 150, 100, message, new PlutoSansLight().fontName, 24, 0xFFFFFF );
			_errorText.autoSize = TextFieldAutoSize.VERTICAL;
			_errorText.x = ( Constants.APP_WIDTH - _errorText.width ) * 0.5;
			_errorText.y = _errorButton.y - _errorText.height - 40;
			_errorText.alpha = 0;
			addChild( _errorText );
			
			Starling.juggler.tween( _cwSpinner, 0.3, {alpha : 0} );
			Starling.juggler.tween( _acwSpinner, 0.3, {alpha : 0} );
			Starling.juggler.tween( _loadingText, 0.3, {alpha : 0} );
			Starling.juggler.tween( _errorText, 0.3, {delay: 0.3, alpha : 1} );
			Starling.juggler.tween( _errorButton, 0.3, {delay: 0.3, alpha : 1} );
			
		}
		
		////////////////////////////////////////////////////////////////
		
		override protected function onShowHook():*
		{
			Tracer.out();
			var signalShowComplete : Signal = new Signal();
			
			_logo.alpha = 0;
			_logo.scaleX = _logo.scaleY = 0;
			Starling.juggler.tween( _logo, 1.2, { alpha : 1, scaleX : 1, scaleY : 1, transition : Transitions.EASE_OUT_ELASTIC, onComplete : onShowComplete, onCompleteArgs : [ signalShowComplete ] } );
			
			return signalShowComplete;
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onShowComplete( signalComplete : Signal ) : void 
		{
			addEventListener( Event.ENTER_FRAME, updateLoader );
			signalShowComplete.dispatch();
		}
		
		override protected function onHideHook() : *
		{
			var signalHideComplete : Signal = new Signal();
			
			Starling.juggler.tween( _logo, 0.6, { alpha : 0, scaleX : 0, scaleY : 0, transition : Transitions.EASE_IN_BACK } );
			Starling.juggler.tween( this, 0.5, { delay : 0.3, alpha : 1, onComplete : hideComplete, onCompleteArgs : [ signalHideComplete ] } );
			
			return signalHideComplete;
		}
		
		////////////////////////////////////////////////////////////////
		
		private function hideComplete( signal : Signal ) : void 
		{
			removeEventListener( Event.ENTER_FRAME, updateLoader );
			signal.dispatch();
		}
		
		////////////////////////////////////////////////////////////////
		
		private function updateLoader( event : Event ) : void 
		{
			_cwSpinner.rotation += 0.05;
			_acwSpinner.rotation -= 0.06;
		}
		  
		////////////////////////////////////////////////////////////////

		private function onTryAgain( target : SignalButton ) : void 
		{
			_errorButton.signalTriggered.removeAll();
			Starling.juggler.tween( _errorText, 0.3, { alpha : 0 } );
			Starling.juggler.tween( _errorButton, 0.3, { alpha : 0 } );
			Starling.juggler.delayCall( signalTryAgain.dispatch, 0.8 );
		}
		
		////////////////////////////////////////////////////////////////
		
		override public function dispose():void
		{
			while( numChildren > 0 ) removeChildAt(0, true);
			super.dispose();
		}
		
		////////////////////////////////////////////////////////////////
	}
}
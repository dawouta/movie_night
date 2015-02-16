package movienight.view.start
{
	import feathers.controls.TextInput;
	import feathers.events.FeathersEventType;
	
	import fonts.PlutoSansLight;
	
	import movienight.enum.Constants;
	import movienight.enum.Strings;
	import movienight.util.DeviceTypes;
	import movienight.util.Factory;
	import movienight.util.Utils;
	import movienight.view.core.ScreenView;
	import movienight.view.ui.components.SignalButton;
	
	import org.osflash.signals.Signal;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.deg2rad;
	
	public class StartScreen extends ScreenView
	{
		
		public var signalAvatar : Signal = new Signal();
		public var signalSubmit : Signal = new Signal( String );
		
		private var _logo : Image;
		private var _avatarButton : SignalButton;
		private var _avatar : Image;
		private var _inputUserName : TextInput;
		private var _inputUnderline : Quad;
		private var _submitButton : SignalButton;
		private var _hasAvatar : Boolean
		
		////////////////////////////////////////////////////////////////
		
		public function build( avatarTexture : Texture, userName : String ):void
		{
			
			var atlas : TextureAtlas = Constants.COMMON_ATLAS;
			
			_logo = new Image( atlas.getTexture( "logo_large" ) );
			Utils.centerPivot( _logo );
			_logo.x = Constants.APP_WIDTH >> 1;
			_logo.y = 216;
			
			if( !avatarTexture )
			{
				_avatarButton = new SignalButton( atlas.getTexture("avatar_button_up"), atlas.getTexture("avatar_button_down") );
				Utils.centerPivot( _avatarButton );
			} else 
			{
				_hasAvatar = true;
				_avatarButton = new SignalButton( avatarTexture, avatarTexture );
				Utils.centerPivot( _avatarButton );
				_avatarButton.width = _avatarButton.height = 205;
				if( !DeviceTypes.isSimulator() ) _avatarButton.rotation = deg2rad( -90 );
				
			}
			_avatarButton.x = Constants.APP_WIDTH >> 1;
			_avatarButton.y = 530;
			
			_inputUserName = Factory.createInputField( 330, 40, new PlutoSansLight().fontName, 16, 0xFFFFFF );
			_inputUserName.maxChars = 16;
			_inputUserName.text = userName.length > 0 ? userName : Strings.USERNAME_DEFAULT;
			_inputUserName.x = ( Constants.APP_WIDTH - _inputUserName.width ) >> 1;
			_inputUserName.y = 690;
			_inputUserName.addEventListener( Event.CHANGE, onTextEvent );
			_inputUserName.addEventListener( FeathersEventType.FOCUS_IN, onTextEvent );
			
			_inputUnderline = new Quad( 330, 2, 0xFFFFFF, true );
			Utils.centerPivot( _inputUnderline );
			_inputUnderline.x = Constants.APP_WIDTH >> 1;
			_inputUnderline.y = _inputUserName.y + 40;
			
			_submitButton = Factory.createDefaultButton( Strings.START_GAME, "icon_arrow", new PlutoSansLight().fontName, 25, 0x333333 );
			_submitButton.x = ( Constants.APP_WIDTH - _submitButton.width ) >> 1;
			_submitButton.y = 820;
			_submitButton.visible = false;
			_submitButton.alpha = 0;

			addChild( _logo );
			addChild( _avatarButton );
			addChild( _inputUserName );
			addChild( _inputUnderline );
			addChild( _submitButton );
			
		}
		
		////////////////////////////////////////////////////////////////
		
		override protected function onShowHook():*
		{
			var signalShowComplete : Signal = new Signal();
			
			_logo.alpha = 0;
			_logo.scaleX = _logo.scaleY = 0;
			Starling.juggler.tween( _logo, 0.6, { alpha : 1, scaleX : 1, scaleY : 1, transition : Transitions.EASE_OUT_BACK } );
			
			_avatarButton.alpha = 0;
			Starling.juggler.tween( _avatarButton, 0.6, { delay : 0.3, alpha : 1, transition : Transitions.EASE_OUT_BACK } );
			
			_inputUserName.alpha = 0;
			_inputUserName.y = 740;
			Starling.juggler.tween( _inputUserName, 0.3, { delay : 0.4, alpha : 1, y : 690, transition : Transitions.EASE_IN_OUT } );
			
			_inputUnderline.alpha = 0;
			_inputUnderline.scaleX = 0;
			Starling.juggler.tween( _inputUnderline, 0.3, { delay : 0.6, alpha : 1, scaleX : 1, transition : Transitions.EASE_OUT_BACK, onComplete : onShowComplete, onCompleteArgs : [ signalShowComplete ] } );
			
			return signalShowComplete;
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onShowComplete( signalShowComplete : Signal ) : void 
		{
			_avatarButton.signalTriggered.add( onAvatarButton );
			if( _hasAvatar && ( _inputUserName.text.length > 0 && _inputUserName.text !== Strings.USERNAME_DEFAULT ) ) revealSubmitButton();
			signalShowComplete.dispatch();
		}
		
		////////////////////////////////////////////////////////////////
		
		override protected function onHideHook() : *
		{
			var signalHideComplete : Signal = new Signal();
			
			Starling.juggler.tween( _submitButton, 0.4, { y : 920, alpha : 0, transition : Transitions.EASE_IN_OUT } );
			Starling.juggler.tween( _inputUnderline, 0.3, { delay : 0.2, alpha : 0, scaleX : 0, transition : Transitions.EASE_OUT_BACK } );
			Starling.juggler.tween( _inputUserName, 0.3, { delay : 0.2, alpha : 0, transition : Transitions.EASE_IN_OUT } );
			Starling.juggler.tween( _avatarButton, 0.4, { delay : 0.4, alpha : 0, scaleX : 0, scaleY : 0, transition : Transitions.EASE_IN_OUT } );
			Starling.juggler.tween( _logo, 0.6, { delay : 0.6, alpha : 0, scaleX : 0, scaleY : 0, transition : Transitions.EASE_IN_BACK, onComplete : signalHideComplete.dispatch } );
			
			return signalHideComplete;
		}
		
		////////////////////////////////////////////////////////////////
		
		private function revealSubmitButton() : void
		{
			if( _submitButton.visible ) return;
			_submitButton.visible = true;
			_submitButton.y = 920
			Starling.juggler.tween( _submitButton, 0.4, { y : 820, alpha : 1, transition : Transitions.EASE_IN_OUT } );
			_submitButton.signalTriggered.add( onSubmit );
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onTextEvent( event : Event ) : void 
		{
			switch( event.type )
			{
				case Event.CHANGE : 
					if( _inputUserName.text.length > 0 && _inputUserName.text !== Strings.USERNAME_DEFAULT )
					{
						if( _hasAvatar ) revealSubmitButton();
					}
					break;
				
				case FeathersEventType.FOCUS_IN : 
					if( _inputUserName.text == Strings.USERNAME_DEFAULT )
					{
						_inputUserName.text = "";
					}
					break;
			}
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onAvatarButton( target : SignalButton ) : void 
		{
			_avatarButton.enabled = _submitButton.enabled = false;
			_avatarButton.signalTriggered.removeAll();
			var username : String = ( _inputUserName.text ==  Strings.USERNAME_DEFAULT || _inputUserName.text.length < 1 ) ? "" : _inputUserName.text; 
			signalAvatar.dispatch( username );
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onSubmit( target : SignalButton ) : void 
		{
			_avatarButton.enabled = _submitButton.enabled = false;
			signalSubmit.dispatch( _inputUserName.text );
		}
		
		////////////////////////////////////////////////////////////////
		
		override public function dispose():void
		{
			signalAvatar.removeAll();
			signalSubmit.removeAll();
			while( numChildren > 0 ) removeChildAt(0, true);
			super.dispose();
		}
		
		////////////////////////////////////////////////////////////////
	}
}
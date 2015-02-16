package movienight.view.camera
{
	import fonts.PlutoSansLight;
	
	import movienight.enum.Constants;
	import movienight.enum.Strings;
	import movienight.util.DeviceTypes;
	import movienight.util.Factory;
	import movienight.util.Utils;
	import movienight.view.camera.component.CameraImage;
	import movienight.view.core.ScreenView;
	import movienight.view.ui.components.SignalButton;
	
	import org.osflash.signals.Signal;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class CameraScreen extends ScreenView
	{
		
		public var signalCapture : Signal = new Signal( Texture );
		
		private var _cameraImage : CameraImage;
		private var _cameraBg : Image;
		private var _buttonCapture : SignalButton;
		
		////////////////////////////////////////////////////////////////
		
		public function build():void
		{
			var atlas : TextureAtlas = Constants.COMMON_ATLAS;

			_cameraBg = new Image( atlas.getTexture( "camera_frame" ) );
			Utils.centerPivot( _cameraBg );
			_cameraBg.x = Constants.APP_WIDTH >> 1;
			_cameraBg.y = 250;
			addChild( _cameraBg );
			
			_buttonCapture = Factory.createDefaultButton( Strings.CAPTURE, "icon_camera", new PlutoSansLight().fontName, 25, 0x333333 );
			_buttonCapture.audioID = AudioAssets.SOUND_CAMERA_SHUTTER;
			_buttonCapture.x = ( Constants.APP_WIDTH - _buttonCapture.width ) >> 1;
			_buttonCapture.y = 820;
			addChild( _buttonCapture );
		}
		
		////////////////////////////////////////////////////////////////
		
		override protected function onShowHook():*
		{
			var signalShowComplete : Signal = new Signal();
			
			_cameraBg.alpha = 0;
			_cameraBg.scaleX = _cameraBg.scaleY = 0.5;
			Starling.juggler.tween( _cameraBg, 1.2, { alpha : 1, scaleX : 1, scaleY : 1, transition : Transitions.EASE_OUT_ELASTIC } );
			
			_buttonCapture.alpha = 0;
			_buttonCapture.y = 920;
			Starling.juggler.tween( _buttonCapture, 0.4, { delay : 0.6, y : 820, alpha : 1, transition : Transitions.EASE_IN_OUT } );
			
			Starling.juggler.tween( this, 1.2, { onComplete : onShowComplete, onCompleteArgs:[ signalShowComplete ] } );
			
			return signalShowComplete;
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onShowComplete( signalShowComplete : Signal ) : void 
		{
			
			_cameraImage = new CameraImage();
			Utils.centerPivot( _cameraImage );
			_cameraImage.x = Constants.APP_WIDTH >> 1;
			_cameraImage.y = 250;
			if( !DeviceTypes.isSimulator() ) _cameraImage.rotation = -Math.PI * 0.5;
			addChild( _cameraImage );
			
			_buttonCapture.signalTriggered.add( onCapture );
			
			signalShowComplete.dispatch();
		}
		
		////////////////////////////////////////////////////////////////
		
		override protected function onHideHook() : *
		{
			var signalHideComplete : Signal = new Signal();
			
			Starling.juggler.tween( _buttonCapture, 0.4, { y : 920, alpha : 0, transition : Transitions.EASE_IN_OUT } );
			Starling.juggler.tween( _cameraImage, 0.4, { alpha : 0 } );
			Starling.juggler.tween( _cameraBg, 0.4, { delay : 0.4, alpha : 0, scaleX : 0, scaleY : 0, transition : Transitions.EASE_IN_OUT, onComplete : signalHideComplete.dispatch } );
			
			return signalHideComplete;
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onCapture( target : SignalButton ) : void 
		{
			_cameraImage.capture();
			signalCapture.dispatch( _cameraImage.texture );
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
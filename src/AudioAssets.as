package
{
	import flash.media.Sound;
	
	import starling.extensions.SoundManager;
	
	public class AudioAssets
	{
		
		[Embed(source = "../media/audio/global_click.mp3")]
		private static const Click:Class;
		
		[Embed(source = "../media/audio/take_picture.mp3")]
		private static const CameraShutter:Class;
		
//		[Embed(source = "../media/audio/spin.mp3")]
//		private static const CategoryWheelSpin:Class;
		
		////////////////////////////////////////////////////////////////
		
		public static const SOUND_CLICK : String = "clickSound";
		public static const SOUND_CAMERA_SHUTTER : String = "cameraSound";
//		public static const CATEGORY_WHEEL_SPIN : String = "categroyWheelSpin";
		
		////////////////////////////////////////////////////////////////
		
		public static function init() : void 
		{
			var sm : SoundManager = SoundManager.getInstance();
			
			sm.addSound( SOUND_CLICK, new Click() as Sound );
			sm.addSound( SOUND_CAMERA_SHUTTER, new CameraShutter() as Sound );
//			sm.addSound( CATEGORY_WHEEL_SPIN, new CategoryWheelSpin() as Sound );
			
		}
		
		////////////////////////////////////////////////////////////////
		
		public static function play( soundId : String ) : void 
		{
			SoundManager.getInstance().playSound( soundId );
		}
		
		////////////////////////////////////////////////////////////////
	}
}



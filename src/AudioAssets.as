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
		
		[Embed(source = "../media/audio/answer_correct.mp3")]
		private static const CorrectAnswer:Class;
		
		[Embed(source = "../media/audio/answer_wrong.mp3")]
		private static const IncorrectAnswer:Class;
		
		[Embed(source = "../media/audio/wheel_category_change.mp3")]
		private static const CategoryWheelTick:Class;
		
		////////////////////////////////////////////////////////////////
		
		public static const SOUND_CLICK : String = "clickSound";
		public static const SOUND_CAMERA_SHUTTER : String = "cameraSound";
		public static const SOUND_CORRECT : String = "answerCorrectSound";
		public static const SOUND_INCORRECT : String = "answerIncorrectSound";
		public static const SOUND_CATEGORY_WHEEL_TICK : String = "categoryWheelTickSound";
		
		
		////////////////////////////////////////////////////////////////
		
		public static function init() : void 
		{
			var sm : SoundManager = SoundManager.getInstance();
			
			sm.addSound( SOUND_CLICK, new Click() as Sound );
			sm.addSound( SOUND_CAMERA_SHUTTER, new CameraShutter() as Sound );
			sm.addSound( SOUND_CORRECT, new CorrectAnswer() as Sound );
			sm.addSound( SOUND_INCORRECT, new IncorrectAnswer() as Sound );
			sm.addSound( SOUND_CATEGORY_WHEEL_TICK, new CategoryWheelTick() as Sound );
		}
		
		////////////////////////////////////////////////////////////////
		
		public static function play( soundId : String ) : void 
		{
			SoundManager.getInstance().playSound( soundId );
		}
		
		////////////////////////////////////////////////////////////////
	}
}



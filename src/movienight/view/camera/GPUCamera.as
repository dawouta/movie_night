package movienight.view.camera
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.CameraPosition;
	import flash.media.Video;
	
	import movienight.enum.Constants;
	import movienight.util.Tracer;
	
	import ru.inspirit.gpu.image.GPUImage;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class GPUCamera extends Sprite
	{
		
		public static const CAMERA_CAPTURE : String = "cameraCapture";
		
		// camera
		public var streamW : int = Constants.APP_WIDTH;
		public var streamH : int = Constants.APP_HEIGHT;
		public var streamFPS : int = 15;
		
		protected var _camVideo : Video;
		protected var _camBmp : BitmapData;
		
		private var _gpuImg : GPUImage;
		private var _isLive : Boolean;
		
		private var videoX:Number;
		private var videoY:Number;
		private var videoW:Number;
		private var videoH:Number;
		
		private var _scale:Number = 0.4;
		
		////////////////////////////////////////////////////////////////
		
		public function GPUCamera()
		{
			addEventListener( Event.ADDED_TO_STAGE, handleAddedToStage );
		}
		
		////////////////////////////////////////////////////////////////
		
		public function set isLive ( value : Boolean ) : void {
			_isLive = value;
		}
		
		////////////////////////////////////////////////////////////////
		
		public function capture() : BitmapData {
			isLive = false;
			return _camBmp;
		}
		
		////////////////////////////////////////////////////////////////
		
		public override function render( support : RenderSupport, parentAlpha : Number ) : void {
			
			super.render( support, parentAlpha );
			
			if ( !_isLive ) return;
			if ( _gpuImg ) {
				var a : Number = -Math.PI *0.5
				var m : Matrix = new Matrix( Math.cos(a), -Math.sin(a), Math.cos(a), Math.cos(a) );
				_camBmp.draw( _camVideo, m );
				_gpuImg.uploadBitmap( _camBmp );
				_gpuImg.render( true );
			}
		}
		
		////////////////////////////////////////////////////////////////
		
		public override function dispose() : void {
			
			Tracer.out();
			if(_camVideo)
				_camVideo.attachCamera( null );
			if(_gpuImg)
				_gpuImg.dispose();
			
			super.dispose();
			if ( hasEventListener( Event.ADDED_TO_STAGE ) ) {
				removeEventListener( Event.ADDED_TO_STAGE, handleAddedToStage );
			}
		}
		
		////////////////////////////////////////////////////////////////
		
		protected function initFlashNativeCapture( w : int, h : int ) : void {
			
			var cam : Camera = tryGetFrontCamera();
			if( !cam ) cam = Camera.getCamera( "0" );
			
			Tracer.out();
			
			cam.setMode( w, h, streamFPS, true );
			cam.setQuality(0, 100);
			
			_camVideo = new Video( w, h );
			_camVideo.smoothing = true;
			
			_camVideo.attachCamera( cam );
			_camBmp = new BitmapData( w, h, false, 0xFF0000 );
		}
		
		////////////////////////////////////////////////////////////////
		
		private function tryGetFrontCamera() : Camera {
			var numCameras:uint = (Camera.isSupported) ? Camera.names.length : 0;
			for (var i:uint = 0; i < numCameras; i++) {
				var cam : Camera = Camera.getCamera(String(i));
				if (cam && cam.position == CameraPosition.FRONT) {
					return cam;
				}
			} 
			return null;
		}
		////////////////////////////////////////////////////////////////
		
		private function handleAddedToStage( e : Event ) : void {
			
//			streamW = Starling.current.nativeStage.fullScreenWidth;
//			streamH = Starling.current.nativeStage.fullScreenHeight;
			
			removeEventListener( Event.ADDED_TO_STAGE, handleAddedToStage );
			initFlashNativeCapture( streamW, streamH );
			createGPUImage();
			isLive = true;
		}
		
		////////////////////////////////////////////////////////////////
		
		private function createGPUImage() : void {
			_gpuImg = new GPUImage();
			_gpuImg.init( Starling.current.context, 0, false, stage.stageWidth, stage.stageHeight, streamW, streamH );
//			_gpuImg.init( Starling.current.context, 0, false, streamH, streamW, streamH, streamW );
			_gpuImg.scaleX = _gpuImg.scaleY = _scale;
			_gpuImg.setFillMode( GPUImage.FILL_MODE_STRETCH );
		}
		
		////////////////////////////////////////////////////////////////
		
	}
}



package movienight.view.camera.component
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.media.Camera;
	import flash.media.CameraPosition;
	import flash.media.Video;
	
	import movienight.enum.Constants;
	
	import starling.core.RenderSupport;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class CameraImage extends Image
	{
		
		private var WIDTH : int =  400;
		private var HEIGHT : int = 300;
		
		private var _camera : Camera;
		private var _sourceBmd : BitmapData;
		private var _outputBmd : BitmapData;
		private var _shapeMask : Shape;
		private var _video : Video;
		
		private var _isCapture : Boolean;
		
		////////////////////////////////////////////////////////////////
		
		public function CameraImage()
		{
			startCamera();
			super( Texture.fromBitmapData( _outputBmd ) );
		}
		
		////////////////////////////////////////////////////////////////
		
		public function capture() : void 
		{
			_isCapture = true;
		}
		
		////////////////////////////////////////////////////////////////
		
		public override function render( support : RenderSupport, parentAlpha : Number ) : void 
		{
			if( !_isCapture )
			{
				_sourceBmd.draw( _video );
				
				_shapeMask.graphics.clear();
				_shapeMask.graphics.beginBitmapFill( _sourceBmd, new Matrix( 1,0,0,1,-50,0 ) );
				_shapeMask.graphics.drawCircle( 150,150,150);
				
				_outputBmd.draw( _shapeMask, null, null, null, null, true );
					
				texture.dispose();
				texture = Texture.fromBitmapData( _outputBmd );
			}
			super.render( support, parentAlpha );
		}
		
		////////////////////////////////////////////////////////////////
		
		public function startCamera() : void 
		{
			
			_isCapture = false;
			
			_camera = tryGetFrontCamera();
			_camera.setMode( WIDTH, HEIGHT, 15, true );
			_camera.setQuality(0, 100);
			
			_video = new Video( _camera.width, _camera.height );
			_video.smoothing = true;
			_video.attachCamera( _camera );
			
			_sourceBmd = new BitmapData( _video.width, _video.height, false, 0 );
			_sourceBmd.draw( _video );
			
			_shapeMask = new Shape();
			_shapeMask.graphics.beginBitmapFill( _sourceBmd );
			_shapeMask.graphics.drawCircle( 150,150,150);
			
			_outputBmd = new BitmapData( 300,300,true,0 );
		}
		
		////////////////////////////////////////////////////////////////
		
		private function tryGetFrontCamera() : Camera {
			
			if( !Camera.isSupported ) return null;
			
			var numCameras : int = Camera.names.length;
			var cam : Camera;
			for( var i : int = 0; i < numCameras; i++ ) {
				cam = Camera.getCamera( String( i ) );
				if ( cam && cam.position == CameraPosition.FRONT ) {
					return cam;
				}
			} 
			return Camera.getCamera( "0" );
		}
		
		////////////////////////////////////////////////////////////////
	}
}
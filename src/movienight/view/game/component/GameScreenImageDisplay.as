package movienight.view.game.component
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	
	import movienight.util.CacheableBitmapLoader;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class GameScreenImageDisplay extends Sprite
	{
		
		private const SHAPE_RADIUS : int = 160;
		
		private var _image : Image;
		private var _loader : CacheableBitmapLoader;
		
		////////////////////////////////////////////////////////////////
		
		
		public function GameScreenImageDisplay( imageUrl : String )
		{
			fetchImage( imageUrl );
		}
		
		////////////////////////////////////////////////////////////////
		
		private function fetchImage( url : String ) : void 
		{
			_loader = new CacheableBitmapLoader();
			_loader.signalComplete.add( onImageLoaded );
			_loader.loadExternalBitmap( url );
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onImageLoaded( bmp : Bitmap ) : void {
			
			var d : int = SHAPE_RADIUS * 2;
			var sx : Number;
			var sy : Number;
			if( bmp.width < d || bmp.height < d )
			{
				sx = bmp.width / d;
				sy = bmp.height / d;
			} 
			else
			{
				sx = d / bmp.width;
				sy = d / bmp.height;
			}
			
			var s : Number = sx > sy ? sx : sy;
			
			var tx : Number = SHAPE_RADIUS - ( bmp.width * s ) * 0.5;
			var ty : Number = SHAPE_RADIUS - ( bmp.height * s ) * 0.5;
			
			var shape : Shape = new Shape();
			shape.graphics.beginBitmapFill( bmp.bitmapData, new Matrix( s, 0, 0, s, tx, ty ), false, true );
			shape.graphics.drawCircle( SHAPE_RADIUS, SHAPE_RADIUS, SHAPE_RADIUS );
			shape.graphics.endFill();
			
			var bmd : BitmapData = new BitmapData( d, d, true, 0 );
			bmd.draw( shape );
			
			_image = new Image( Texture.fromBitmapData( bmd ) );
			_image.x = -SHAPE_RADIUS;
			_image.y = -SHAPE_RADIUS;
			_image.alpha = 0;
			addChild( _image );
			
			Starling.juggler.tween( _image, 0.4, {alpha :1} );
			
		}
		
		////////////////////////////////////////////////////////////////
	}
}
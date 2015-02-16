package movienight.view.game.component
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import fonts.PlutoSansLight;
	
	import movienight.enum.Strings;
	import movienight.util.Utils;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class GameFeedbackDisplay extends Sprite
	{
		
		private var _image : Image;
		private var _correctTexture : Texture;
		private var _incorrectTexture : Texture;
		private var _timeUpTexture : Texture;
		private var _radius : int = 180;
		
		////////////////////////////////////////////////////////////////
		
		public function GameFeedbackDisplay()
		{
			_correctTexture = draw( 0x00FF66, Strings.CORRECT );
			_incorrectTexture = draw( 0xFF3333, Strings.INCORRECT );
			_timeUpTexture = draw( 0xFF3333, Strings.TIME_UP );
		}
		
		////////////////////////////////////////////////////////////////
		
		public function show( isCorrect : Boolean ) : void
		{
			_image = new Image( isCorrect ? _correctTexture : _incorrectTexture );
			Utils.centerPivot( _image );
			_image.alpha = 0;
			_image.scaleX = _image.scaleY = 0;
			addChild( _image );
			
			Starling.juggler.tween( _image, 0.6, { alpha : 1, scaleX : 1, scaleY : 1, transition : Transitions.EASE_OUT_BOUNCE } );
		}
		
		////////////////////////////////////////////////////////////////
		
		public function showTimeUp() : void 
		{
			_image = new Image( _timeUpTexture );
			Utils.centerPivot( _image );
			_image.alpha = 0;
			_image.scaleX = _image.scaleY = 0;
			addChild( _image );
			Starling.juggler.tween( _image, 0.6, { alpha : 1, scaleX : 1, scaleY : 1, transition : Transitions.EASE_OUT_BOUNCE } );
		}
		
		////////////////////////////////////////////////////////////////
		
		public function hide( delay : Number = 0 ) : Number 
		{
			Starling.juggler.tween( _image, 0.6, { alpha : 0, scaleX : 0, scaleY : 0, transition : Transitions.EASE_IN_BACK } );
			return delay + 0.6;
		}
		
		////////////////////////////////////////////////////////////////
		
		private function draw( color : uint, text : String ) : Texture 
		{
			var s : Shape = new Shape();
			s.graphics.beginFill( color, 1 );
			s.graphics.drawCircle( _radius, _radius, _radius );
			s.graphics.endFill();
			
			var t : TextField = new TextField();
			t.embedFonts = true;
			t.autoSize = TextFieldAutoSize.LEFT;
			var tf : TextFormat = new TextFormat( new PlutoSansLight().fontName, 48, 0xFFFFFF );
			t.defaultTextFormat = tf;
			t.text = text;
			
			var bmd : BitmapData = new BitmapData( s.width, s.height, true, 0 );
			bmd.draw( s, null,null,null,null,true );
			bmd.draw( t, new Matrix( 1, 0, 0, 1,( s.width-t.width ) >> 1,(s.height-t.height) >> 1 ), null, null, null, true );
			
			return Texture.fromBitmapData( bmd );
		}
		
		////////////////////////////////////////////////////////////////
		
		override public function dispose() : void
		{
			_correctTexture.dispose();
			_incorrectTexture.dispose();
			_timeUpTexture.dispose();
			while( numChildren > 0 ) removeChildAt(0, true);
			super.dispose();
		}
		
		////////////////////////////////////////////////////////////////
	}
}
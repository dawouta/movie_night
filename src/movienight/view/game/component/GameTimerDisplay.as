package movienight.view.game.component
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.utils.getTimer;
	
	import fonts.PlutoSansRegular;
	
	import movienight.enum.Constants;
	import movienight.util.Tracer;
	import movienight.util.Utils;
	
	import org.osflash.signals.Signal;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class GameTimerDisplay extends Sprite
	{
		
		public var signalTimeUp : Signal = new Signal();
		
		private const DEG_TO_RAD : Number = Math.PI / 180;
		private const SHAPE_RADIUS : int = 180;
		
		private var _timerImage : Image;
//		private var _imageTexture : Texture;
		private var _timeText : TextField;
		
		private var _startTime : int;
		private var _time : int;
		private var _shape : Shape;
		private var _shape2 : Shape;
		
		////////////////////////////////////////////////////////////////
		
		public function get timeRemaining() : int { return Constants.TIME_PER_QUESTION - _time; }
		public function get timeElapsed() : int { return _time; }
		
		////////////////////////////////////////////////////////////////
		
		public function GameTimerDisplay()
		{
			
			_timeText = new TextField( 200, 60, formatToTimeString( Constants.TIME_PER_QUESTION ), new PlutoSansRegular().fontName, 60, 0xFFFFFF );
			_timeText.hAlign = HAlign.LEFT;
			_timeText.vAlign = VAlign.CENTER;
			_timeText.x = -_timeText.width >> 1;
			_timeText.y = 400;
			_timeText.alpha = 0;
			addChild( _timeText );
		}
		
		////////////////////////////////////////////////////////////////
		
		public function show( delay : Number = 0 ) : Number 
		{
			_timeText.alpha = 0;
			_timeText.y = 450;
			Starling.juggler.tween( _timeText, 0.4, { alpha : 1, y : 400, transition : Transitions.EASE_IN_OUT } );
						
			return 0.4;
		}
		
		////////////////////////////////////////////////////////////////
		
		public function hide( delay : Number = 0 ) : Number 
		{
			Starling.juggler.tween( _timerImage, 0.4, { delay : delay, scaleX : 0, scaleY : 0, alpha : 0, transition : Transitions.EASE_IN_OUT } );
			Starling.juggler.tween( _timeText, 0.4, { delay : delay, alpha : 0 } );
			return delay + 0.4;
		}
		
		
		////////////////////////////////////////////////////////////////
		
		public function startTimer() : void
		{
			_startTime = getTimer();
			
			if( !_timerImage )
			{
				_timerImage = new Image( drawTimerImageTexture() );
				Utils.centerPivot( _timerImage );
				_timerImage.y = 200;
				_timerImage.alpha = 0.5;
				_timerImage.rotation = -Math.PI * 0.5;
				addChildAt( _timerImage, 0 );
			}
			
			_timeText.text = formatToTimeString( Constants.TIME_PER_QUESTION );
			addEventListener( Event.ENTER_FRAME, timerUpdate );
		}
		
		////////////////////////////////////////////////////////////////
		
		public function stopTimer() : void 
		{
			removeEventListener( Event.ENTER_FRAME, timerUpdate );
		}
		
		////////////////////////////////////////////////////////////////
		
		private function timerUpdate( event : Event ) : void 
		{
			_time = getTimer() - _startTime;
			if( _time > Constants.TIME_PER_QUESTION )
			{
				_timeText.text = "00:00";
				_time = 0;
				stopTimer();
				signalTimeUp.dispatch() 
			}
			else
			{
				_timeText.text = formatToTimeString( timeRemaining );
			}
			
			_timerImage.texture.dispose();
			_timerImage.texture = drawTimerImageTexture();
			_timeText.x = -_timeText.width >> 1;
		}
		
		////////////////////////////////////////////////////////////////
		
		private function drawTimerImageTexture() : Texture 
		{
			var p : Number = timeElapsed / Constants.TIME_PER_QUESTION;
			var a : Number = 360 - 360 * p;
			var xpos : Number, ypos : Number;
			
			if( !_shape )
			{
				_shape = new Shape();
				_shape.graphics.beginFill( 0xFF3333, 1 );
				_shape.graphics.moveTo( 0, 0 );
			}
			
			xpos = Math.cos( a * DEG_TO_RAD ) * SHAPE_RADIUS;
			ypos = Math.sin( a * DEG_TO_RAD ) * SHAPE_RADIUS;
			
			_shape.graphics.lineTo( xpos, ypos );
			
			var bmd : BitmapData = new BitmapData( SHAPE_RADIUS*2, SHAPE_RADIUS*2, true, 0 );
			bmd.draw( _shape, new Matrix( 1,0,0,1,SHAPE_RADIUS,SHAPE_RADIUS ) );
			
			if( !_shape2 )
			{
				_shape2 = new Shape();
				_shape2.graphics.beginFill( 0, 1 );
				_shape2.graphics.drawCircle( 0, 0, SHAPE_RADIUS - 20 );
				_shape2.graphics.endFill();
			}
			bmd.draw( _shape2, new Matrix( 1,0,0,1,SHAPE_RADIUS,SHAPE_RADIUS ) );
			
			return Texture.fromBitmapData( bmd );
			
		}
		
		////////////////////////////////////////////////////////////////
		
		private function formatToTimeString( milliseconds : int ) : String
		{
			var msStr : String = milliseconds.toString();
			msStr = msStr.substr( msStr.length - 3, 2 );
			
			var s : int = ( ( milliseconds * 0.001 ) % 60 );
			var sStr : String = s < 10 ? "0" + s.toString() : s.toString();
				
			return sStr + ":" + msStr;
		}
		
		////////////////////////////////////////////////////////////////
		
		override public function dispose() : void
		{
			while( numChildren > 0 ) removeChildAt(0, true);
			super.dispose();
		}
		
		////////////////////////////////////////////////////////////////
		
	}
}
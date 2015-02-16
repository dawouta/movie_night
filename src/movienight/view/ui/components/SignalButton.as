package movienight.view.ui.components
{
	import org.osflash.signals.Signal;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class SignalButton extends Sprite
	{
		
		public var signalTriggered : Signal = new Signal( SignalButton );
		
		protected var _label : TextField;
		protected var _upState : Texture;
		protected var _downState : Texture;
		protected var _bg : Image;
		
		protected var _audioID : String;
		
		private var _paddingLeft : int = 3;
		private var _paddingRight : int = 3;
		private var _paddingTop : int = 2;
		private var _paddingBottom : int = 2;
		
		////////////////////////////////////////////////////////////////
		
		public function SignalButton( upState:Texture, downState:Texture=null, audioID : String = AudioAssets.SOUND_CLICK )
		{
			_upState = upState;
			_downState = downState ? downState : upState;
			_audioID = audioID;
			_bg = new Image( _upState );
			addChild( _bg );
			if( text.length > 0 ) setLabel( text );
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		////////////////////////////////////////////////////////////////
		
		public function setLabel( text : String, fontName : String = "Verdana", fontSize : int = 12, fontColor : uint = 0xFFFFFF, 
								  		hAlign : String = HAlign.CENTER, vAlign : String = VAlign.CENTER ) : void 
		{
			if( _label ) removeChild( _label, true );
			var labelWidth : int = _bg.width - _paddingLeft - _paddingRight;
			var labelHeight : int = _bg.height - _paddingTop - _paddingBottom;
			_label = new TextField( labelWidth, labelHeight, text, fontName, fontSize, fontColor );
			_label.x = _paddingLeft;
			_label.y = _paddingTop;
			_label.hAlign = hAlign;
			_label.vAlign = vAlign;
			addChild( _label );
		}
		
		////////////////////////////////////////////////////////////////
		
		protected function onTouch( event : TouchEvent ):void
		{
			var t : Touch = event.getTouch( this );
			if( !t ) return;
			switch(t.phase)
			{
				case TouchPhase.BEGAN:
					_bg.texture = _downState;
					break;
				
				case TouchPhase.ENDED:
					_bg.texture = _upState;
					AudioAssets.play( _audioID );
					signalTriggered.dispatch( this );
					break;
			}
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onAddedToStage( event : Event ) : void
		{
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			addEventListener( TouchEvent.TOUCH, onTouch );
		}
		
		////////////////////////////////////////////////////////////////
		
		override public function dispose() : void
		{
			signalTriggered.removeAll();
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			removeEventListener( TouchEvent.TOUCH, onTouch );
			while( numChildren > 0 ) removeChildAt(0, true);
			super.dispose();
		}
		
		////////////////////////////////////////////////////////////////
		
		public function get enabled() : Boolean { return hasEventListener( TouchEvent.TOUCH ); }
		public function set enabled( value : Boolean ) : void 
		{
			if( !value ) removeEventListener( TouchEvent.TOUCH, onTouch );
			else if( !hasEventListener( TouchEvent.TOUCH ) ) addEventListener( TouchEvent.TOUCH, onTouch );
		}
		
		////////////////////////////////////////////////////////////////
		
		public function set text( label : String ) : void 
		{
			if( _label ) _label.text = label;
			else setLabel( label );
		}
		public function get text() : String { 
			if( _label ) return _label.text;
			else return "";
		}
		
		////////////////////////////////////////////////////////////////
		
		public function set padding( value : int ) : void 
		{
			paddingLeft = paddingRight = paddingTop = paddingBottom = value;
		}
		public function set paddingLeft( value : int ) : void {
			_paddingLeft = value;
			_label.x = _paddingLeft;
			_label.width = _bg.width - _paddingLeft - _paddingRight;
		}
		public function set paddingRight( value : int ) : void {
			_paddingRight = value;
			_label.width = _bg.width - _paddingLeft - _paddingRight;
		}
		public function set paddingTop( value : int ) : void { 
			_paddingTop = value;
			_label.y = _paddingTop;
		}
		public function set paddingBottom( value : int ) : void 
		{
			_paddingRight = value;
			_label.height = _bg.height - _paddingTop - _paddingBottom;
		}
		
		////////////////////////////////////////////////////////////////
		
		public function get audioID() : String { return _audioID; }
		public function set audioID( value : String ) : void 
		{
			_audioID = value;
		}
		
		////////////////////////////////////////////////////////////////
		
	}
}
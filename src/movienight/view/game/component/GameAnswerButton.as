package movienight.view.game.component
{
	import fonts.PlutoSansLight;
	import fonts.PlutoSansRegular;
	
	import movienight.enum.Constants;
	import movienight.view.ui.components.SignalButton;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class GameAnswerButton extends SignalButton
	{
		
		private var _isCorrectAnswer : Boolean;
		private var _icon : Image;
		private var _resultTexture : Texture;
		
		////////////////////////////////////////////////////////////////
		
		public function get isCorrectAnswer() : Boolean { return _isCorrectAnswer; }
		
		////////////////////////////////////////////////////////////////
		
		public function GameAnswerButton( answer : String, answerIndex : int, isCorrectAnswer : Boolean )
		{
			var atlas : TextureAtlas = Constants.COMMON_ATLAS;
			super( atlas.getTexture("answer_button_background_up"), atlas.getTexture("answer_button_background_down") );
			
			_isCorrectAnswer = isCorrectAnswer;
			
			var texId : String = "answer_button_icon_" + (answerIndex + 1).toString()
			_icon = new Image( atlas.getTexture(  texId ) );
			_icon.x = 8;
			_icon.y = 6;
			addChild( _icon ); 
			
			var affix : String = _isCorrectAnswer ? "_correct" : "_incorrect";
			_resultTexture = atlas.getTexture( texId + affix );
			
			setLabel( answer, new PlutoSansRegular().fontName, 22, 0x333333 );
			_label.alpha = 0;
		}
		
		////////////////////////////////////////////////////////////////
		
		public function showLabel() : void 
		{
			Starling.juggler.tween( _label, 0.2, { alpha : 1 } );
			enabled = true;
		}
		
		////////////////////////////////////////////////////////////////
		
		public function showIsCorrect() : void 
		{
			_icon.texture = _resultTexture;
			if( !isCorrectAnswer ){
				_bg.texture = _downState;
				Starling.juggler.tween( this, 0.3, { alpha : 0.5, scaleX : 0.8, scaleY : 0.8, transition : Transitions.EASE_IN_OUT } );
			}
		}
		
		////////////////////////////////////////////////////////////////
		
		override protected function onTouch( event : TouchEvent ) : void
		{
			super.onTouch( event );
			if( !event.getTouch( this, TouchPhase.ENDED ) ) return;
			_icon.texture = _resultTexture;
		}
		
		////////////////////////////////////////////////////////////////
		
		override public function dispose() : void
		{
			_resultTexture.dispose();
			super.dispose();
		}
		
		////////////////////////////////////////////////////////////////
	}
}
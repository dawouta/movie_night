package movienight.view.game
{
	import fonts.PlutoSansRegular;
	
	import movienight.enum.Constants;
	import movienight.model.vo.QuestionVO;
	import movienight.model.vo.ResultVO;
	import movienight.util.Utils;
	import movienight.view.core.ScreenView;
	import movienight.view.game.component.GameAnswerButton;
	import movienight.view.game.component.GameFeedbackDisplay;
	import movienight.view.game.component.GameRoundRenderer;
	import movienight.view.game.component.GameScreenAvatarDisplay;
	import movienight.view.game.component.GameScreenImageDisplay;
	import movienight.view.game.component.GameTimerDisplay;
	
	import org.osflash.signals.Signal;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class GameScreen extends ScreenView
	{
		
		public var signalAnswer : Signal = new Signal( Boolean, int );
		
		private var _question : QuestionVO;
		private var _results : Vector.<ResultVO>;
		
		private var _avatarDisplay : GameScreenAvatarDisplay;
		private var _posterDisplay : GameScreenImageDisplay;
		private var _timer : GameTimerDisplay;
		private var _feedbackDisplay : GameFeedbackDisplay;
		private var _questionText : TextField;
		private var _buttons : Vector.<GameAnswerButton>;
		private var _roundRenderer : GameRoundRenderer;
		
		////////////////////////////////////////////////////////////////
		
		public function build( question : QuestionVO, avatarTexture : Texture, results : Vector.<ResultVO> ):void
		{
			
			_question = question;
			_results = results;
			
			_posterDisplay = new GameScreenImageDisplay( _question.imageURL );
			_posterDisplay.x = Constants.APP_WIDTH >> 1;
			_posterDisplay.y = 200;
			addChild( _posterDisplay );
			
			_timer = new GameTimerDisplay();
			_timer.x = Constants.APP_WIDTH >> 1;
			_timer.signalTimeUp.add( onTimeUp );
			addChild( _timer );
			
			_feedbackDisplay = new GameFeedbackDisplay();
			_feedbackDisplay.x = Constants.APP_WIDTH >> 1;
			_feedbackDisplay.y = 200;
			addChild( _feedbackDisplay );
			
			_avatarDisplay = new GameScreenAvatarDisplay( avatarTexture );
			_avatarDisplay.x = _avatarDisplay.y = 87;
			Utils.centerPivot( _avatarDisplay );
			addChild( _avatarDisplay );
			
			_questionText = new TextField( Constants.APP_WIDTH - 60, 140, _question.question, new PlutoSansRegular().fontName, 28, 0xFFFFFF );
			_questionText.autoScale = true;
			_questionText.hAlign = HAlign.CENTER;
			_questionText.vAlign = VAlign.CENTER;
			_questionText.x = 30;
			_questionText.y = 460;
			_questionText.alpha = 0;
			addChild( _questionText );
			
			_buttons = new Vector.<GameAnswerButton>();
			var button : GameAnswerButton;
			var ypos : int = 657;
			for( var i : int; i < question.answers.length; i++ )
			{
				button = new GameAnswerButton( question.answers[i], i, i == question.answerIdx );
				Utils.centerPivot( button );
				button.x = Constants.APP_WIDTH >> 1;
				button.y = ypos;
				button.signalTriggered.add( onAnswer );
				ypos += 68;
				addChild( button );
				button.enabled = false;
				_buttons.push( button );
			}
			
			_roundRenderer = new GameRoundRenderer( _results );
			_roundRenderer.y = Constants.APP_HEIGHT - _roundRenderer.height;
			addChild( _roundRenderer );
		}
		
		////////////////////////////////////////////////////////////////
		
		override protected function onShowHook():*
		{
			var signalShowComplete : Signal = new Signal();
			
			var delay : Number = 0;
			
			_roundRenderer.show( delay );
			
			_posterDisplay.alpha = 0;
			_posterDisplay.scaleX = _posterDisplay.scaleY = 0;
			Starling.juggler.tween( _posterDisplay, 0.4, { delay : delay, alpha : 1, scaleX : 1, scaleY : 1, transition : Transitions.EASE_IN_OUT } );
			
			_avatarDisplay.alpha = 0;
			_avatarDisplay.scaleX = _avatarDisplay.scaleY = 0
			Starling.juggler.tween( _avatarDisplay, 0.9, { delay : delay + 0.2, alpha : 1, scaleX : 1, scaleY : 1, transition : Transitions.EASE_OUT_BACK } );
			
			delay += 0.4;
			var button : GameAnswerButton;
			for( var i : int; i < _buttons.length; i++ )
			{
				button = _buttons[i];
				button.alpha = 0;
				button.scaleX = button.scaleY = 0.5;
				Starling.juggler.tween( button, 0.4, { delay : delay, alpha : 1, scaleX : 1, scaleY : 1, transition : Transitions.EASE_IN_OUT } );
				delay += 0.2;
			}
			
			_timer.show( delay );
			
			Starling.juggler.tween( this, delay + 0.4, { onComplete : onShowComplete, onCompleteArgs : [ signalShowComplete ] } );
			
			return signalShowComplete;
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onShowComplete( signalShowComplete : Signal ) : void 
		{
			signalShowComplete.dispatch();
			for( var i : int; i < _buttons.length; i++ ) _buttons[i].showLabel();
			Starling.juggler.tween( _questionText, 0.2, { alpha : 1 } );
			_timer.startTimer();
		}
		
		////////////////////////////////////////////////////////////////
		
		override protected function onHideHook() : *
		{
			var signalHideComplete : Signal = new Signal();
			
			var delay : Number = _roundRenderer.hide();
			_timer.hide();
			Starling.juggler.tween( _posterDisplay, 0.4, { delay : 0.2, alpha : 0, scaleX : 0, scaleY : 0, transition : Transitions.EASE_IN_OUT } );
			Starling.juggler.tween( _avatarDisplay, 0.6, { delay : 0.1, alpha : 0, scaleX : 0, scaleY : 0, transition : Transitions.EASE_IN_BACK } );
			Starling.juggler.tween( _questionText, 0.4, { delay : 0.2, alpha : 0 } );
			var button : GameAnswerButton;
			for( var i : int; i < _buttons.length; i++ ) 
			{
				button = _buttons[i];
				Starling.juggler.tween( button, 0.4, { delay : i * 0.1, alpha : 0, scaleX : 0, scaleY : 0, transition : Transitions.EASE_IN_OUT } );
				delay += 0.1
			}
			_feedbackDisplay.hide();
			Starling.juggler.tween( this, 0, { delay : 1.0, onComplete : signalHideComplete.dispatch } );
			
			return signalHideComplete;
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onTimeUp() : void 
		{
			for( var i : int; i < _buttons.length; i++ ) _buttons[i].enabled = false;
			_feedbackDisplay.showTimeUp();
			signalAnswer.dispatch( false, 0 );
		}
		
		private function onAnswer( target : GameAnswerButton ) : void 
		{
			_timer.stopTimer();
			for( var i : int; i < _buttons.length; i++ ) _buttons[i].enabled = false;
			_feedbackDisplay.show( target.isCorrectAnswer );
			showCorrectAnswer();
			Starling.juggler.delayCall( signalAnswer.dispatch, 0.5, target.isCorrectAnswer, target.isCorrectAnswer ? _timer.timeRemaining : 0 );
		}
		
		////////////////////////////////////////////////////////////////
		
		private function showCorrectAnswer() : void
		{
			for( var i : int; i < _buttons.length; i++ ) _buttons[i].showIsCorrect();
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
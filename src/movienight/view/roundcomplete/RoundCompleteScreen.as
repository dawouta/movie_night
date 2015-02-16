package movienight.view.roundcomplete
{
	import fonts.PlutoSansLight;
	import fonts.PlutoSansRegular;
	
	import movienight.enum.Constants;
	import movienight.enum.Strings;
	import movienight.model.vo.ResultVO;
	import movienight.util.Factory;
	import movienight.util.Utils;
	import movienight.view.core.ScreenView;
	import movienight.view.game.component.GameScreenAvatarDisplay;
	import movienight.view.ui.components.SignalButton;
	
	import org.osflash.signals.Signal;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.TextureAtlas;
	
	public class RoundCompleteScreen extends ScreenView
	{
		
		public var signalContinue : Signal = new Signal();
		
		private var _roundResult : ResultVO;
		private var _roundLabelBackground : Quad;
		private var _roundLabelText : TextField;
		private var _avatarDisplay : GameScreenAvatarDisplay;
		
		private var _timeRemaining : RoundResultRenderer;
		private var _score : RoundResultRenderer;
		private var _multiplier : RoundResultRenderer;
		private var _bonusScore : RoundResultRenderer;
		private var _roundTotal : RoundResultRenderer;
		private var _gameTotal : RoundResultRenderer;
		
		private var _continueButton : SignalButton;
		
		private var _totalScore : int;
		
		////////////////////////////////////////////////////////////////
		
		public function build( roundResult : ResultVO, totalScore : int, avatarTexture ):void
		{
			
			_roundResult = roundResult;
			_totalScore = totalScore;
			
			var atlas : TextureAtlas = Constants.COMMON_ATLAS;
			
			_roundLabelBackground = new Quad( Constants.APP_WIDTH, 82, 0x333333, true );
			
			var roundStr : String = Strings.ROUND + " " + roundResult.roundIndex;
			_roundLabelText = new TextField( Constants.APP_WIDTH, 82, roundStr, new PlutoSansRegular().fontName, 40, 0xFFFFFF );
			_roundLabelText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			_roundLabelText.x = ( Constants.APP_WIDTH - _roundLabelText.width ) >> 1;
			_roundLabelText.y = ( _roundLabelBackground.height - _roundLabelText.height ) >> 1;
			
			_avatarDisplay = new GameScreenAvatarDisplay( avatarTexture );
			_avatarDisplay.x = _avatarDisplay.y = 87;
			Utils.centerPivot( _avatarDisplay );
			
			_timeRemaining = new RoundResultRenderer( Strings.TIME_REMAINING, "round_complete_default_renderer_bg" );
			_timeRemaining.x = Constants.APP_WIDTH >> 1;
			_timeRemaining.y = 168;
			
			_score = new RoundResultRenderer( Strings.SCORE, "round_complete_default_renderer_bg" );
			_score.x = Constants.APP_WIDTH >> 1;
			_score.y = 268;
			
			_multiplier = new RoundResultRenderer( Strings.MULTIPLIER, "round_complete_default_renderer_bg" );
			_multiplier.x = Constants.APP_WIDTH >> 1;
			_multiplier.y = 368;
			
			_bonusScore = new RoundResultRenderer( Strings.BONUS_SCORE, "round_complete_default_renderer_bg" );
			_bonusScore.x = Constants.APP_WIDTH >> 1;
			_bonusScore.y = 468;
			
			_roundTotal = new RoundResultRenderer( Strings.ROUND_SCORE, "round_complete_default_renderer_bg" );
			_roundTotal.x = Constants.APP_WIDTH >> 1;
			_roundTotal.y = 568;
			
			_gameTotal = new RoundResultRenderer( Strings.TOTAL_SCORE, "round_complete_bottom_renderer_bg" );
			_gameTotal.x = Constants.APP_WIDTH >> 1;
			_gameTotal.y = 668;
			
			_continueButton = Factory.createDefaultButton( Strings.CONTINUE, "icon_arrow", new PlutoSansLight().fontName, 25, 0x333333 );
			_continueButton.x = ( Constants.APP_WIDTH - _continueButton.width ) >> 1;
			_continueButton.y = 820;
			_continueButton.signalTriggered.add( onContinue );
			_continueButton.visible = false;
			_continueButton.alpha = 0;
			
			addChild( _roundLabelBackground );
			addChild( _roundLabelText );
			addChild( _avatarDisplay );
			addChild( _timeRemaining );
			addChild( _score );
			addChild( _multiplier );
			addChild( _bonusScore );
			addChild( _roundTotal );
			addChild( _gameTotal );
			addChild( _continueButton );
			
		}
		
		////////////////////////////////////////////////////////////////
		
		override protected function onShowHook():*
		{
			var signalShowComplete : Signal = new Signal();
			
			_roundLabelBackground.y = -_roundLabelBackground.height;
			Starling.juggler.tween( _roundLabelBackground, 0.4, { delay : 0.0, y : 0, transition : Transitions.EASE_IN_OUT } );
			
			_roundLabelText.alpha = 0;
			Starling.juggler.tween( _roundLabelText, 0.4, { delay : 0.4, alpha : 1 } );
			
			_avatarDisplay.alpha = 0;
			_avatarDisplay.scaleX = _avatarDisplay.scaleY = 0
			Starling.juggler.tween( _avatarDisplay, 0.6, { delay : 0.6, alpha : 1, scaleX : 1, scaleY : 1, transition : Transitions.EASE_OUT_BACK } );
			
			_timeRemaining.showResult( _roundResult.timeString, 0.4 );
			_score.showResult( _roundResult.time, 0.5, 5 );
			_multiplier.showResult( _roundResult.multiplier.toString(), 0.6 );
			_bonusScore.showResult( _roundResult.bonusScore, 0.7, 5 );
			_roundTotal.showResult( _roundResult.score, 0.8, 5 );
			_gameTotal.showResult( _totalScore, 0.9, 6 );
			
			Starling.juggler.tween( this, 1.0, { onComplete : onShowComplete, onCompleteArgs : [ signalShowComplete ] } );
			
			return signalShowComplete;
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onShowComplete( signalShowComplete : Signal ) : void 
		{
			revealContinueButton()
			signalShowComplete.dispatch();
		}
		
		////////////////////////////////////////////////////////////////
		
		override protected function onHideHook() : *
		{
			var signalHideComplete : Signal = new Signal();
			
			Starling.juggler.tween( _continueButton, 0.4, { y : 920, alpha : 0, transition : Transitions.EASE_IN_OUT } );
			Starling.juggler.tween( _roundLabelBackground, 0.4, { delay : 0.5, y : -_roundLabelBackground.height, transition : Transitions.EASE_IN_OUT, onComplete : signalHideComplete.dispatch } );
			Starling.juggler.tween( _roundLabelText, 0.4, { delay : 0.1, alpha : 0 } );
			Starling.juggler.tween( _avatarDisplay, 0.4, { delay : 0.1, alpha : 0, scaleX : 0, scaleY : 0, transition : Transitions.EASE_IN_OUT } );
			
			Starling.juggler.tween( _timeRemaining, 0.4, { delay : 0, alpha : 0 } );
			Starling.juggler.tween( _score, 0.4, { delay : 0.1, alpha : 0 } );
			Starling.juggler.tween( _multiplier, 0.4, { delay : 0.2, alpha : 0 } );
			Starling.juggler.tween( _bonusScore, 0.4, { delay : 0.3, alpha : 0 } );
			Starling.juggler.tween( _roundTotal, 0.4, { delay : 0.4, alpha : 0 } );
			Starling.juggler.tween( _gameTotal, 0.4, { delay : 0.5, alpha : 0 } );
			
			
			return signalHideComplete;
		}
		
		////////////////////////////////////////////////////////////////
		
		private function revealContinueButton() : void
		{
			if( _continueButton.visible ) return;
			_continueButton.visible = true;
			_continueButton.y = 920
			Starling.juggler.tween( _continueButton, 0.4, { y : 820, alpha : 1, transition : Transitions.EASE_IN_OUT } );
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onContinue( target : SignalButton ) : void 
		{
			_continueButton.enabled = false;
			signalContinue.dispatch();
		}
		
		////////////////////////////////////////////////////////////////
		
		override public function dispose():void
		{
			signalContinue.removeAll();
			while( numChildren > 0 ) removeChildAt(0, true);
			super.dispose();
		}
		
		////////////////////////////////////////////////////////////////
	}
}
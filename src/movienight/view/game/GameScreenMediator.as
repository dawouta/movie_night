package movienight.view.game
{
	import movienight.enum.Screens;
	import movienight.model.DataModel;
	import movienight.model.vo.ResultVO;
	
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;
	
	import starling.core.Starling;
	
	public class GameScreenMediator extends StarlingMediator
	{
		[Inject]
		public var view : GameScreen;
		
		[Inject]
		public var dataModel : DataModel;
		
		private var _nextScreen : String;
		
		////////////////////////////////////////////////////////////////
		
		override public function initialize():void
		{
			view.signalAnswer.add( onAnswer );
			view.build( dataModel.currentQuestion, dataModel.avatarTexture, dataModel.results );
			super.initialize();
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onAnswer( isCorrect : Boolean, time : int ) : void 
		{
			var result : ResultVO = new ResultVO();
			result.roundIndex = dataModel.results.length + 1;
			result.score = 0;
			result.wasCorrect = isCorrect;
			result.time = time;
			dataModel.storeResult( result );
			_nextScreen = Screens.ROUND_COMPLETE;  
			Starling.juggler.delayCall( changeScreen, 0.8 );
		}
		
		////////////////////////////////////////////////////////////////
		
		private function changeScreen() : void 
		{
			view.signalChangeScreen.dispatch( _nextScreen );	
		}
		
		////////////////////////////////////////////////////////////////
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		////////////////////////////////////////////////////////////////
	}
}
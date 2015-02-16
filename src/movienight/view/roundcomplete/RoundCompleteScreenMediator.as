package movienight.view.roundcomplete
{
	import movienight.enum.Constants;
	import movienight.enum.Screens;
	import movienight.model.DataModel;
	
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;
	
	public class RoundCompleteScreenMediator extends StarlingMediator
	{
		[Inject]
		public var view : RoundCompleteScreen;
		
		[Inject]
		public var dataModel : DataModel;
		
		////////////////////////////////////////////////////////////////
		
		override public function initialize():void
		{
			view.signalContinue.add( onContinue ); 
			view.build( dataModel.lastRoundResult, dataModel.totalScore, dataModel.avatarTexture );
			super.initialize();
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onContinue() : void 
		{
			view.signalChangeScreen.dispatch( ( dataModel.results.length < Constants.NUM_ROUNDS ) ? Screens.CATEGORY_SELECT_SCREEN : Screens.LEADERBOARD_SCREEN );  
		}
		
		////////////////////////////////////////////////////////////////
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		////////////////////////////////////////////////////////////////
	}
}
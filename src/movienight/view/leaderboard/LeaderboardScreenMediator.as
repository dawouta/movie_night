package movienight.view.leaderboard
{
	import movienight.enum.Screens;
	import movienight.model.DataModel;
	
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;
	
	public class LeaderboardScreenMediator extends StarlingMediator
	{
		[Inject]
		public var view : LeaderboardScreen;
		
		[Inject]
		public var dataModel : DataModel;
		
		////////////////////////////////////////////////////////////////
		
		override public function initialize():void
		{
			view.signalPlayAgain.add( onPlayAgain );
			view.build( dataModel.leaderboard.entries, dataModel.userLeaderboardVO );
			super.initialize();
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onPlayAgain() : void 
		{
			dataModel.startNewGame();
			view.signalChangeScreen.dispatch( Screens.START_SCREEN );
		}
		
		////////////////////////////////////////////////////////////////
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		////////////////////////////////////////////////////////////////
	}
}
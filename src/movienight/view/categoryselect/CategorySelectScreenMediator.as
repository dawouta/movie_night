package movienight.view.categoryselect
{
	import movienight.enum.Screens;
	import movienight.model.DataModel;
	
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;
	
	public class CategorySelectScreenMediator extends StarlingMediator
	{
		[Inject]
		public var view : CategorySelectScreen;
		
		[Inject]
		public var dataModel : DataModel;
		
		////////////////////////////////////////////////////////////////
		
		override public function initialize():void
		{
			super.initialize();
			view.signalCommenceSpin.add( onCommenceSpin )
			view.signalCategorySelected.add( onCategorySelected );
			view.build( dataModel.categories, dataModel.results.length + 1 );
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onCommenceSpin() : void 
		{
			view.startSpin( dataModel.getRandomValidCategoryIndex() );
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onCategorySelected( categoryIndex : int ) : void 
		{
			dataModel.selectCategory( categoryIndex );
			view.signalChangeScreen.dispatch( Screens.GAME_SCREEN );
		}
		
		////////////////////////////////////////////////////////////////
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		////////////////////////////////////////////////////////////////
	}
}
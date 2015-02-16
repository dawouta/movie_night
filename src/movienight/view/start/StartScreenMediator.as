package movienight.view.start
{
	import movienight.enum.Screens;
	import movienight.model.DataModel;
	
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;
	
	public class StartScreenMediator extends StarlingMediator
	{
		[Inject]
		public var view : StartScreen;
		
		[Inject]
		public var dataModel : DataModel;
		
		////////////////////////////////////////////////////////////////
		
		override public function initialize():void
		{
			view.signalAvatar.add( onAvatar );
			view.signalSubmit.add( onSubmit );
			view.build( dataModel.avatarTexture, dataModel.userName );
			super.initialize();
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onSubmit( userName : String ) : void
		{
			dataModel.userName = userName;
			view.signalChangeScreen.dispatch( Screens.CATEGORY_SELECT_SCREEN );
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onAvatar( userName : String ) : void 
		{
			dataModel.userName = userName.length > 0 ? userName : "";
			view.signalChangeScreen.dispatch( Screens.CAMERA_SCREEN );
		}
		
		////////////////////////////////////////////////////////////////
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		////////////////////////////////////////////////////////////////
	}
}
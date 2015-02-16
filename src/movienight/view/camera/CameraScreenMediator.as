package movienight.view.camera
{
	import movienight.enum.Screens;
	import movienight.model.DataModel;
	
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;
	
	import starling.textures.Texture;
	
	public class CameraScreenMediator extends StarlingMediator
	{
		[Inject]
		public var view : CameraScreen;
		
		[Inject]
		public var dataModel : DataModel;
		
		////////////////////////////////////////////////////////////////
		
		override public function initialize():void
		{
			view.signalCapture.add( onCapture );
			view.build();
			super.initialize();
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onCapture( texture : Texture ) : void 
		{
			dataModel.avatarTexture = texture;
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
package movienight.view.core
{
	import avmplus.getQualifiedClassName;
	
	import feathers.controls.Screen;
	
	import movienight.util.Tracer;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.filters.BlurFilter;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	
	public class ScreenView extends Screen 
	{
		public var signalInstatiationComplete:Signal = new Signal();
		public var signalShow:Signal = new Signal();
		public var signalShowComplete:Signal = new Signal();
		public var signalHide:Signal = new Signal();
		public var signalHideComplete:Signal = new Signal();
		public var signalChangeScreen:Signal  = new Signal(String);
		
		protected var _assetManager:AssetManager;
		
		private var _assetsLoaded:Boolean = false;
		private var _shouldBeShown:Boolean = false;
		private var _lazyInstantiation:Boolean = false;
		private var _instatiated:Boolean = false;
		private var _destroyed:Boolean = false;
		
		////////////////////////////////////////////////////////////////
		
		public function ScreenView(assets:Array = null, lazyInstantiation:Boolean = false) 
		{
			_lazyInstantiation = lazyInstantiation;
			_assetManager = new AssetManager();
			
			
			if(assets) 
			{
				_assetManager.enqueue(assets);
				_assetManager.loadQueue(function(ratio:Number):void
				{
					if (ratio == 1)
						Starling.juggler.delayCall(function():void
						{
							if(!_lazyInstantiation) 
							{
								onInitCompleteHook();
							}
							_assetsLoaded = true;
						}, 0.15);
				});
			}
			else
			{
				if(!_lazyInstantiation)
				{
					onInitCompleteHook();
				}
				_assetsLoaded = true;
			}
		}
		
		////////////////////////////////////////////////////////////////
		
		public function reportReady():void
		{
			_lazyInstantiation = false;
			if(_assetsLoaded)
				onInitCompleteHook();
		}
		
		////////////////////////////////////////////////////////////////
		
		protected function onInitCompleteHook():void
		{
			Tracer.out(" ... INIT");
			
			_assetsLoaded = true;
			signalInstatiationComplete.dispatch();
			Tracer.out("_shouldBeShown: " + _shouldBeShown);
			if(_shouldBeShown)
				this.show();
		}
		
		////////////////////////////////////////////////////////////////
		
		public function blur():void{
			for (var i:int = 0; i < numChildren; i++) 
			{
				var child:DisplayObject = getChildAt(i)
				child.filter = new BlurFilter(2, 2, 0.3)
			}
		}
		
		////////////////////////////////////////////////////////////////
		
		public function unBlur():void{
			
				
			for (var i:int = 0; i < numChildren; i++) 
			{
				var child:DisplayObject = getChildAt(i)
				child.filter = null
			}
		}
		
		////////////////////////////////////////////////////////////////
		
		public function destroy():void
		{
			_destroyed = true;
			_assetManager.purge();
			this.dispose();
		}
		
		////////////////////////////////////////////////////////////////
		
		override public function dispose():void
		{
			if( !_destroyed )
			{
				destroy();
				return;
			}
			super.dispose();
		}
		
		////////////////////////////////////////////////////////////////
		
		protected function getTexture(name:String):Texture
		{
			return _assetManager.getTexture(name);
		}
		
		////////////////////////////////////////////////////////////////
		
		protected function getTextureAtlas(name:String):TextureAtlas
		{
			return _assetManager.getTextureAtlas(name);
		}

		////////////////////////////////////////////////////////////////
		
		public function show():void
		{
			_shouldBeShown = true;
			if(_assetsLoaded)
				showScreen();
		}
		////////////////////////////////////////////////////////////////
		
		private function showScreen():void
		{	
			signalShow.dispatch();
			
			var result:* = onShowHook();
			
			if (result is ISignal)
			{
				ISignal(result).addOnce(onShowComplete)
			}
			else if (result == true)
			{
				onShowComplete();
			}
			else 
			{
				throw new TypeError("Return value of onShowHook must be either a signal or a boolean value of true");
			}
		}
		
		////////////////////////////////////////////////////////////////
		
		protected function onShowHook():*
		{
			return true;
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onShowComplete():void
		{
			signalShowComplete.dispatch();
		}
		
		////////////////////////////////////////////////////////////////

		public function hide():void
		{
			_shouldBeShown = false;
			hideScreen();
		}
		
		////////////////////////////////////////////////////////////////
		
		private function hideScreen():void
		{
			signalHide.dispatch();
			
			var result:* = onHideHook();
			
			if (result is ISignal)
			{
				ISignal(result).addOnce(onHideComplete)
			}
			else if (result == true)
			{
				onHideComplete();
			}
			else 
			{
				throw new TypeError("Return value of onHideHook must be either a signal or a boolean value of true");
			}
		}
		
		////////////////////////////////////////////////////////////////
		
		protected function onHideHook():*
		{
			return true;
		}
		
		////////////////////////////////////////////////////////////////
		
		private function onHideComplete():void 
		{
			signalHideComplete.dispatch();
		}
		
		////////////////////////////////////////////////////////////////
		
		public function get assetsLoaded():Boolean
		{
			return _assetsLoaded;
		}
		
		////////////////////////////////////////////////////////////////
		
		public function set assetsLoaded(value:Boolean):void
		{
			_assetsLoaded = value;
		}
		
		////////////////////////////////////////////////////////////////
		
		
	}
	
}



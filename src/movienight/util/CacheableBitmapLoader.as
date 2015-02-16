package movienight.util
{
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.system.System;
	import flash.utils.ByteArray;
	
	import movienight.enum.Constants;
	
	import org.osflash.signals.Signal;

	public class CacheableBitmapLoader
	{
		
		public var signalComplete : Signal = new Signal( Bitmap );
		public var signalCached : Signal = new Signal();
		public var signalError : Signal = new Signal();
		
		protected var _loader : Loader;
		protected var _bitmap : Bitmap;
		
		protected var _url : String;
		protected var _disposeBitmapAfterComplete : Boolean;
		
		protected var _useCache : Boolean;
		protected var _fromCache : Boolean;
		protected var _isLoaded : Boolean;
		protected var _isLoading : Boolean;
		
		protected var _cacheDirectory : File = Constants.LOCAL_IMAGE_CACHE_DIRECTORY;
		protected var _urlLoader:URLLoader;
		
		////////////////////////////////////////////////////////////////
		
		public function get url() : String  { return _url; }
		
		////////////////////////////////////////////////////////////////
		
		public function get isLoaded() : Boolean { return _isLoaded; }
		public function get isLoading() : Boolean { return _isLoading; }
		
		////////////////////////////////////////////////////////////////
		
		public function loadExternalBitmap( url : String, useLocalCache : Boolean = true ) : void 
		{
			if( _bitmap )
			{
				_bitmap.bitmapData.dispose();
				_bitmap = null;
			}
			
			_url = url;
			_useCache = useLocalCache;
			_isLoading = true;
			_isLoaded = false;
			
			var f : File = _cacheDirectory;
			if( !f.exists ) f.createDirectory();
			
			f = _cacheDirectory.resolvePath( localName );
			if( f.exists && _useCache ) loadFromFile( f );
			else loadFromURL( url );
		}
		
		////////////////////////////////////////////////////////////////
		
		public function cacheExternalBitmap( url : String, disposeBitmapAfterComplete : Boolean = true ) : void 
		{
			if( _bitmap )
			{
				_bitmap.bitmapData.dispose();
				_bitmap = null;
			}
			
			_disposeBitmapAfterComplete = disposeBitmapAfterComplete
			
			_url = url;
			_useCache = true;
			_isLoading = true;
			_isLoaded = false;
			
			var f : File = _cacheDirectory;
			if( !f.exists ) f.createDirectory();
			
			f = _cacheDirectory.resolvePath( localName );
			if( f.exists && _useCache ) signalCached.dispatch();
			else loadFromURL( url );
		}
		
		////////////////////////////////////////////////////////////////
		
		public function dispose() : void 
		{
			signalComplete.removeAll();
			signalCached.removeAll();
			signalError.removeAll();
			
			if( _bitmap )
			{
				_bitmap.bitmapData.dispose();
				_bitmap = null;
			}
			
			try{ _loader.close(); } 
			catch( err ){}
			
			if( _loader ) cleanLoaders();
		}
		
		////////////////////////////////////////////////////////////////
		
		protected function loadFromFile( f : File ) : void 
		{
			_fromCache = true;
			
			var bytes : ByteArray = new ByteArray();
			var fs : FileStream = new FileStream();
			fs.open( f, FileMode.READ );
			fs.readBytes( bytes, 0, fs.bytesAvailable );
			fs.close();
			
			var context : LoaderContext = new LoaderContext();
			context.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener( Event.INIT, onComplete );
			_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			_loader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			_loader.loadBytes( bytes, context );
		}
		
		////////////////////////////////////////////////////////////////
		
		protected function loadFromURL( url : String ) : void 
		{
			_urlLoader = new URLLoader()
			_urlLoader.dataFormat = URLLoaderDataFormat.BINARY
			_urlLoader.addEventListener( Event.COMPLETE, onURLLoadCompleteHandler );
			_urlLoader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			_urlLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			_urlLoader.load(new URLRequest( url ));
		}
		
		//////////////////////////////////////////////////////
		
		private function onURLLoadCompleteHandler( e:Event ):void {
			cacheFile(_urlLoader.data)
		
			var context : LoaderContext = new LoaderContext();
			context.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener( Event.INIT, onComplete );
			_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			_loader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			_loader.loadBytes( _urlLoader.data, context );
		}
		
		////////////////////////////////////////////////////////////////
		
		protected function cacheFile( ba:ByteArray ) : void 
		{
			
			var f : File = _cacheDirectory;
			if( !f.exists ) f.createDirectory();
			
			f = _cacheDirectory.resolvePath( localName );
			
			var fs : FileStream = new FileStream();
			fs.openAsync( f, FileMode.WRITE );
			fs.writeBytes( ba, 0, ba.length );
			fs.close();
			
			System.gc();
			signalCached.dispatch();
		}
		////////////////////////////////////////////////////////////////
		
		protected function onComplete( event : Event ) : void 
		{
			_isLoading = false;
			_isLoaded = true;
			
			var info : LoaderInfo = event.target as LoaderInfo;
			_bitmap = info.content as Bitmap;
			
			signalComplete.dispatch( _bitmap );
			cleanLoaders();
		}
		
		////////////////////////////////////////////////////////////////
		
		protected function onIOError( event : IOErrorEvent ) : void 
		{
			var info : LoaderInfo = event.target as LoaderInfo;
			cleanLoaders();
			
			signalError.dispatch( event );
		}
		
		////////////////////////////////////////////////////////////////
		
		protected function onSecurityError( event : SecurityErrorEvent ) : void 
		{
			var info : LoaderInfo = event.target as LoaderInfo;
			cleanLoaders();
			
			signalError.dispatch( event );
		}
		
		////////////////////////////////////////////////////////////////
		
		protected function cleanLoaders() : void 
		{
			if( !_loader ) return;
			_isLoading = false;
			_loader.contentLoaderInfo.removeEventListener( Event.INIT, onComplete );
			_loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
			_loader.contentLoaderInfo.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			_loader = null;
			if( !_urlLoader ) return;
			_urlLoader.removeEventListener( Event.INIT, onComplete );
			_urlLoader.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
			_urlLoader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			_urlLoader = null;
		}
		
		////////////////////////////////////////////////////////////////
		
		protected function get localName() : String 
		{
			return _url.substring( _url.lastIndexOf( "/" ) + 1, _url.length );
		}
		
		////////////////////////////////////////////////////////////////
		
		protected function get extension() : String 
		{
			return _url.substring( _url.lastIndexOf( "." ), _url.length );
		}
		
		////////////////////////////////////////////////////////////////
		
	}
}
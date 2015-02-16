package movienight.model.service
{
	import com.codecatalyst.promise.Deferred;
	import com.codecatalyst.promise.Promise;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import movienight.util.FileLog;
	import movienight.util.Tracer;
	
	public class JSONWebService
	{
		
		protected var FILE_LOGGING : Boolean = false;
		protected var _logString : String;
		protected var _deferred : Deferred;
		protected var _url : String;
		
		////////////////////////////////////////////////////////////////
		
		public function request( url : String, payload : Object = null, method : String = "POST", contentType : String = "application/json" ) : Promise
		{
			_deferred = new Deferred();
			_url = url;
			var req : URLRequest = new URLRequest( url );
			if( payload ) req.data = JSON.stringify( payload );
			if( contentType ) req.contentType = contentType;
			if( method ) req.method = method;
			
			if(  FILE_LOGGING )
			{
				_logString = "-- request: ";
				_logString += "\n\t- url: \t\t\t" + _url;
				_logString += "\n\t- method: \t\t" + method;
				_logString += "\n\t- contentType: \t" + contentType;
				_logString += "\n\t- payload: \t\t" + JSON.stringify( payload );
			}
			
			var loader : URLLoader = new URLLoader();
			loader.addEventListener( Event.COMPLETE, onJSONLoadComplete );
			loader.addEventListener( IOErrorEvent.IO_ERROR, onJSONLoadError );
			loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onJSONLoadError );
			loader.addEventListener( HTTPStatusEvent.HTTP_STATUS, onHTTPStatus );
			loader.load( req );
			
			return _deferred.promise;	
		}
		
		////////////////////////////////////////////////////////////////
		
		protected function onJSONLoadComplete( event : Event ) : void 
		{
			var loader : URLLoader = event.target as URLLoader;
			cleanLoader( loader );
			
			var jsonStr : String = loader.data;
			if(  FILE_LOGGING )
			{
				_logString += "\n\n-- response: \n\t\t\t\t\t" + jsonStr;
				FileLog.logToFile( _logString );
				_logString = "";
			}
			
			try
			{
				_deferred.resolve( JSON.parse( jsonStr ) );
			} 
			catch ( err : Error )
			{
				_deferred.reject( err );
			}
		}
		
		////////////////////////////////////////////////////////////////
		
		protected function onJSONLoadError( event : Event ) : void 
		{
			var loader : URLLoader = event.target as URLLoader;
			cleanLoader( loader );
			
			var err : Error = new Error( event.toString() );
			
			if(  FILE_LOGGING )
			{
				_logString += "\n-- error: \t" + err.message
				FileLog.logToFile( _logString );
				_logString = "";
			}
			
			_deferred.reject( err );
		}
		
		////////////////////////////////////////////////////////////////
		
		protected function onHTTPStatus( event : HTTPStatusEvent ) : void 
		{
			Tracer.out( event.status );
			_logString += "\n\n-- onHTTPStatus: \t\t" + event.status;
			var error : Error;
			if( event.status == 0 ) error = new Error( "ConnectionError", 0 );
			if( event.status > 0 && event.status < 100 ) error = new Error( "flashError", event.status );
			if( event.status >= 100 && event.status < 200 ) return; // informational
			if( event.status >= 200 && event.status < 300 ) return; // successful	
			if( event.status >= 300 && event.status < 400 ) return; // redirection
			if( event.status >= 400 && event.status < 500 ) error = new Error( "clientError", event.status );
			if( event.status >= 500 && event.status < 600 ) error = new Error( "serverError", event.status );
			
			if( error != null )
			{
				if(  FILE_LOGGING )
				{
					_logString += "\n-- error: " +
						"\n\tmessage: \t" + error.message + 
						"\n\tid: \t\t" + error.id
					FileLog.logToFile( _logString );
					_logString = "";
				}
				_deferred.reject( error );
			}
		}
		
		////////////////////////////////////////////////////////////////
		
		protected function cleanLoader( loader : URLLoader ) : void 
		{
			loader.removeEventListener( Event.COMPLETE, onJSONLoadComplete );
			loader.removeEventListener( IOErrorEvent.IO_ERROR, onJSONLoadError );
			loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onJSONLoadError );
			loader.removeEventListener( HTTPStatusEvent.HTTP_STATUS, onHTTPStatus );
		}
		
		////////////////////////////////////////////////////////////////
	}
}
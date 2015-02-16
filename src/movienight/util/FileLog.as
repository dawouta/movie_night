package movienight.util
{
	import com.adobe.crypto.MD5;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class FileLog
	{
		
		public static var sessionId : String;
		
		////////////////////////////////////////////////////////////////
		
		public static function logToFile( str : String ) : void
		{
			
			if( !sessionId )
			{
				sessionId = MD5.hash( new Date().toUTCString() ) + ".txt";
			}
			
			var logStr : String = "\n\n--- begin log " + new Date().toUTCString();
			logStr += "\n\n";
			logStr += str;
			logStr += "\n\n--- end log\n\n";
			
			var f : File = File.applicationStorageDirectory.resolvePath( "logs/" + sessionId );
			var fs : FileStream = new FileStream();
			fs.open( f, FileMode.APPEND );
			fs.writeUTFBytes( logStr );
			fs.close();
			
			Tracer.out( logStr );
		}
		
		////////////////////////////////////////////////////////////////
	}
}
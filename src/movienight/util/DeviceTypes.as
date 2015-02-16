package movienight.util
{
	import flash.system.Capabilities;
	
	public class DeviceTypes
	{
		
		////////////////////////////////////////////////////////////////
		
		public static function isAndroid():Boolean
		{
			return ( Capabilities.version.substr(0,3) == "AND" );
		}
		
		////////////////////////////////////////////////////////////////
		
		public static function isIOS():Boolean
		{
			return ( Capabilities.version.substr(0,3) == "IOS" );
		}
		
		////////////////////////////////////////////////////////////////
		
		public static function isSimulator():Boolean
		{
			var os : String = Capabilities.os.toLowerCase();
			if  ( ( os.indexOf("mac") > -1 ) || ( os.indexOf("windows") > -1 ) )
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		////////////////////////////////////////////////////////////////
		
		public static function isIPadMini():Boolean
		{
			var filter:String = "iPad2,";
			var position:int = Capabilities.os.indexOf(filter);
			var iPad2Type:int = int(Capabilities.os.charAt(position + filter.length));
			
			if(iPad2Type >= 5)
				return true;
			
			return false;
		}
		
		////////////////////////////////////////////////////////////////
		
	}
}



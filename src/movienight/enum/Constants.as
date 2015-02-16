package movienight.enum
{
	import flash.filesystem.File;
	
	import starling.textures.TextureAtlas;

	public class Constants
	{
		public static const DEBUG : Boolean = false;
		
		public static var APP_WIDTH : int = 768;
		public static var APP_HEIGHT : int = 1024;
		public static var ASSET_SCALE : String;
		public static var CATEGORY_COLORS : Array = [ 0x3EA9F5, 0xFF921E, 0xFBED20, 0xFF7AAC, 0xFF1D24, 0x79C843, 0x9C27B0, 0x009688, 0xCDDC39, 0x795548, 0x9E9E9E, 0x000000, 0xFFFFFF ];
		
		public static const NUM_ROUNDS : int = 5;
		public static const TIME_PER_QUESTION : int = 10000;
		
		public static const DEFAULT_PADDING : int = 20;
		
		public static const LOCAL_IMAGE_CACHE_DIRECTORY : File = File.applicationStorageDirectory.resolvePath( "cache/images/" );
		public static const INIT_SCREEN:String = Screens.APPLICATION_LOADER_SCREEN;
		
		public static var COMMON_ATLAS : TextureAtlas; 
		
	}
}
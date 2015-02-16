package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import movienight.enum.Constants;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Assets
	{
		
		public static const OS_DESKTOP:int = 0;
		public static const OS_IOS:int = 1;
		public static const OS_ANDROID:int = 2;
		
		private static var sContentScaleFactor:int = 1;
		private static var sTextures:Dictionary = new Dictionary();
		private static var sBitmapData:Dictionary = new Dictionary();
		private static var sSounds:Dictionary = new Dictionary();
		private static var sTextureAtlas:Dictionary = new Dictionary();
		private static var sBitmapFontsLoaded:Boolean;
		
		public static function getTexture(name:String):Texture
		{
			trace("Assets getTexture = " + name);
			
			if (sTextures[name] == undefined)
			{
				var data:Object = create(name);
				var scaleFactor:int = sContentScaleFactor;
				
				if(null == data)
				{
					trace( "cannot create texture from 2x" )
					data = create1x(name);
					scaleFactor = 1;
				}
				trace( "scaleFactor: " + scaleFactor )
				
				if (data is Bitmap)
				{
					var bitmap:Bitmap = data as Bitmap;
					sTextures[name] = Texture.fromBitmap(bitmap, false, false, scaleFactor);
					bitmap.bitmapData.dispose();
				}
				else if (data is ByteArray)
				{
					var byteArray:ByteArray = data as ByteArray;
					sTextures[name] = Texture.fromAtfData(byteArray, scaleFactor, false);
					byteArray.clear();
				}
			}
			
			return sTextures[name];
		}
		
		public static function trashTexture(name:String):void
		{
			if (sTextures[name] == undefined)
			{
				//No asset found
				return;
			}
			
			trace("killing texture " + name);
			var tex:Texture = sTextures[name];
			delete sTextures[name];
			
			tex.dispose();	
		}
		
		public static function storeBitmapData( name : String, bmd : BitmapData ) : void  
		{
			if( !sBitmapData[ name ] )
			{
				sBitmapData[ name ] = bmd;
			} 
			else 
			{
				throw( "overwriting texture named : " + name );
			}
		}
		
		public static function getBitmapData( name : String ) : BitmapData 
		{
			function createBitmap():void
			{
				var object:Object = create( name );
				object = (null != object) ? object : create1x( name );
				var bmp : Bitmap = object as Bitmap;
				sBitmapData[ name ] = bmp.bitmapData;
			}
			
			
			if( sBitmapData[ name ] == undefined )
			{
				createBitmap();
			}
			else 
			{
				//Make sure bitmap hasn't been disposed accidentally
				try{
					BitmapData(sBitmapData[ name ]).width;
				}
				catch (err:Error)			
				{
					delete sBitmapData[ name ];
					createBitmap();
				}
			}
			
			return sBitmapData[ name ] as BitmapData;
		}
		
		public static function trashBitmapData( name : String ) : void 
		{
			if( sBitmapData[ name ] == undefined ) return;
			trace("killing bitmap " + name);
			var bmd : BitmapData = sBitmapData[ name ];
			delete sBitmapData[ name ];
			bmd.dispose();
		}
		
		public static function getSound(name:String):Sound
		{
			var sound:Sound = sSounds[name] as Sound;
			if (sound) return sound;
			else throw new ArgumentError("Sound not found: " + name);
		}
		
		public static function getTextureAtlas( textureName : String, xmlName : String ) : TextureAtlas 
		{
			if ( sTextureAtlas[ textureName ] == undefined ){
				var tex : Texture = getTexture( textureName );
				var object:Object = create( xmlName );
				//object = (null != object) ? object : create1x( xmlName );
				if( !object )
				{
					object = create1x( xmlName )
				}
				var xml : XML = XML( object );
				sTextureAtlas[ textureName ] = new TextureAtlas( tex, xml );
			}
			return sTextureAtlas[ textureName ];
		}
		
		public static function trashTextureAtlas( textureName : String ) : void 
		{
			if ( sTextureAtlas[ textureName ] == undefined ) return;
			
			trace("killing texture atlas " + textureName);
			var atlas : TextureAtlas = sTextureAtlas[ textureName ]
			delete sTextureAtlas[ textureName ]
			atlas.dispose();
			
			trashTexture(textureName);
			
		}
		
		public static function getXML( xmlName : String ) : XML 
		{
			var object:Object = create( xmlName );
			object = (null != object) ? object : create1x( xmlName );
			var xml : XML = XML( object );
			
			return xml;
		}
		
		public static function loadBitmapFonts():void
		{
			if (!sBitmapFontsLoaded)
			{
				//var texture:Texture = getTexture("DesyrelTexture");
				//var xml:XML = XML(create("DesyrelXml"));
				//TextField.registerBitmapFont(new BitmapFont(texture, xml));
				sBitmapFontsLoaded = true;
			}
		}
		
		private static function create(name:String):Object
		{
			var textureClass:Class = sContentScaleFactor == 1 ? AssetEmbeds_1x : AssetEmbeds_2x;
			try
			{
				return new textureClass[name];
			} 
			catch(te:TypeError) 
			{
				return null;
			}
			
		}
		
		private static function create1x(name:String):Object
		{
			var textureClass:Class = AssetEmbeds_1x;
			return new textureClass[name];
		}
		
		public static function getExternalAtfTextureAtlas(path:String, xmlName:String):TextureAtlas
		{
			if ( sTextureAtlas[ path ] == undefined ){
				var tex : Texture = getExternalAtfTexture( path );
				var object:Object = create( xmlName );
				object = (null != object) ? object : create1x( xmlName );
				var xml : XML = XML( object );
				sTextureAtlas[ path ] = new TextureAtlas( tex, xml );
			}
			return sTextureAtlas[ path ];
		}
		
		public static function getExternalAtfTexture(path:String):Texture
		{
			if (sTextures[path] == undefined)
			{	
				var ba:ByteArray = new ByteArray();
				var file:File = File.applicationDirectory.resolvePath("media/"+getMediaPrefix()+"/"+path+".atf" );
				trace("getExternalAtfTexture url = " + file.url);
				var fileStream:FileStream = new FileStream();
				fileStream.open(file, FileMode.READ);
				while (fileStream.bytesAvailable > 0)
					fileStream.readBytes(ba, fileStream.position, fileStream.bytesAvailable);
				fileStream.close();
				
				sTextures[path] = Texture.fromAtfData(ba, contentScaleFactor, false);
				ba.clear();
			}
			
			return sTextures[path];
		}
		
		public static function getMediaPrefix():String
		{
			var prefix:String;
			if(contentScaleFactor == 1)
				prefix = "1x";
			else if(contentScaleFactor == 2)
				prefix = "2x";
			
			if(Constants.DEBUG)
				prefix = "desktop";
			
			return prefix;
		}
		
		public static function get contentScaleFactor():Number { return sContentScaleFactor; }
		public static function set contentScaleFactor(value:Number):void 
		{
			for each (var texture:Texture in sTextures)
			texture.dispose();
			
			sTextures = new Dictionary(); 
			sContentScaleFactor = value < 1.5 ? 1 : 2; // assets are available for factor 1 and 2 
		}
		
	}
}
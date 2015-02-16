package movienight.util
{
	import flash.data.EncryptedLocalStore;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	
	import starling.display.DisplayObject;
	
	public class Utils 
	{
		
		////////////////////////////////////////////////////////////////
		
		public static function isSubclassOf(a:Class, b:Class):Boolean
		{
			if (int(!a) | int(!b)) return false;
			return (a == b || b.prototype.isPrototypeOf(a.prototype));
		}
		
		////////////////////////////////////////////////////////////////
		
		public static function clamp(x:Number, min:Number, max:Number):Number
		{
			return Math.min( Math.max( x, min), max);
		}
		
		////////////////////////////////////////////////////////////////
		
		public static function randomRangeInt(minNum:Number, maxNum:Number):Number   
		{  
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);  
		}
		
		////////////////////////////////////////////////////////////////
		
		public static function randomRange(minNum:Number, maxNum:Number):Number   
		{  
			return Math.random() * (maxNum - minNum) + minNum;  
		}
		
		////////////////////////////////////////////////////////////////
		
		public static function shuffleVector(a:Object, b:Object):int
		{
			return Math.floor( Math.random() * 3 - 1 );
		}
		
		////////////////////////////////////////////////////////////////
		
		public static function toByteArray(snd:Sound):ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			var duration:Number = snd.length / 1000 * 44100;
			snd.extract(bytes, duration, 0);
			return bytes;
		}
		
		////////////////////////////////////////////////////////////////
		
		public static function addLeadingZeros( value:uint, places:Number ):String { //Add Leading Zeros
			var result:String = value.toString();
			while ( result.length < places ) {
				result = '0' + result;
			}
			return result;
		}
		
		////////////////////////////////////////////////////////////////
		
		public static function saveEncryptedString(key:String, text:String):void
		{
			var data:ByteArray = new ByteArray();
			data.writeUTFBytes(text);
			EncryptedLocalStore.setItem(key, data); 
		}
		
		////////////////////////////////////////////////////////////////
		
		public static function loadEncryptedString(key:String):String
		{
			var data:ByteArray = EncryptedLocalStore.getItem(key);
			if(data)
				return data.readUTFBytes(data.bytesAvailable);
			else
				return null;
		}
		
		////////////////////////////////////////////////////////////////
		
		public static function removeEncryptedString(key:String):void
		{
			EncryptedLocalStore.removeItem(key);
		}
		
		////////////////////////////////////////////////////////////////
		
		public static function saveEncryptedBoolean(key:String, boolean:Boolean):void
		{
			var data:ByteArray = new ByteArray();
			data.writeBoolean(boolean);
			EncryptedLocalStore.setItem(key, data); 
		}
		
		////////////////////////////////////////////////////////////////
		
		public static function proximity( a : Point, b : Point ) : Number
		{
			return Math.sqrt( squaredProximity( a, b ) );
		}
		
		////////////////////////////////////////////////////////////////
		
		public static function squaredProximity( a : Point, b : Point ) : Number
		{
			var dx : Number = a.x - b.x;
			var dy : Number = a.y - b.y;
			return dx * dx + dy * dy;
		}
		
		////////////////////////////////////////////////////////////////
		
		public static function centerPivot( displayObject : DisplayObject ) : void 
		{
			displayObject.pivotX = displayObject.width >> 1;
			displayObject.pivotY = displayObject.height >> 1;
		}
		
		////////////////////////////////////////////////////////////////
	}

}
package app.assets 
{
	import app.AppSettings;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;


	/**
	 * ...
	 * @author metalcorehero
	 */
	public class Assets 
	{	
		public static function createBitmap(name:String):Bitmap
        {
			var textureClass:Class = AssetsEmbeds;
            var texture:Object = new textureClass[name];
				(texture as Bitmap).smoothing  = true;
				
			 return texture as Bitmap;			
		}
		
		public static function create(name:String):Sprite
        {
            var textureClass:Class = AssetsEmbeds;
            var texture:Object = new textureClass[name];
				(texture as Bitmap).smoothing  = true;
			
		    var spriteHolder:Sprite = new Sprite();			
		    spriteHolder.addChild(texture as Bitmap);			
			
            return spriteHolder;
        }
		
		public static function createBinary(name:String):ByteArray
        {
			var _class:Class = AssetsEmbeds;
            var shader:ByteArray = new _class[name];
			return shader;
		}		
	}
}
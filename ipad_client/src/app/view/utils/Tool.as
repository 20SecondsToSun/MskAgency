package app.view.utils
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class Tool
	{
		public static function randomIntBetween(min:int, max:int):int
		{
			return Math.round(Math.random() * (max - min) + min);
		}
		
		public static function rotateAroundCenter(ob:DisplayObject, angleDegrees:Number):void
		{
			var matrix:Matrix = ob.transform.matrix;
			var rect:Rectangle = ob.getBounds(ob.parent);
			matrix.translate(-(rect.left + (rect.width / 2)), -(rect.top + (rect.height / 2)));
			matrix.rotate((angleDegrees / 180) * Math.PI);
			matrix.translate(rect.left + (rect.width / 2), rect.top + (rect.height / 2));
			ob.transform.matrix = matrix;
		}
		
		public static function toArray(iterable:*):Array
		{
			var ret:Array = [];
			for each (var elem:*in iterable)
				ret.push(elem);
			return ret;
		}
		
		public static function removeAllChildren(_do:Sprite):void
		{
			while (_do.numChildren > 0)
			{
				var child:Sprite = _do.getChildAt(0) as Sprite;
				if (child)
				{
					removeAllChildren(child);
					_do.removeChild(child);
					child = null;
				}
				else
				{
					var doChild:DisplayObject = _do.getChildAt(0);
					_do.removeChild(doChild);
					doChild = null;
				}
			}
		}
		
		public static function timestapToDate(timestap:String):Date
		{
			var date:Date = new Date(int(timestap) * 1000);
			date = new Date(int(timestap) * 1000 + date.timezoneOffset * 60000);
			return date;
		}
		
		public static function changecolor(mc:DisplayObject, _color:uint):void
		{
			var color:ColorTransform = new ColorTransform();
			color.color = _color;
			mc.transform.colorTransform = color;
		}
		
		public static function createShape(_w:Number, _h:Number, _color:uint):Shape
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill(_color, 1.0);
			shape.graphics.drawRect(0, 0, _w, _h);
			shape.graphics.endFill();
			return shape;
		}
		
	
	}

}
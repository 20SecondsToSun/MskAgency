package app.view.utils
{
	import app.AppSettings;
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
		
		public static function animateFlyIn(rec:Rectangle, color:uint, screenshot:Bitmap, container:Sprite):void
		{
			var background:Shape = new Shape();
			background.graphics.beginFill(color, 0);
			background.graphics.drawRect(0, 0, rec.width, rec.height);
			background.graphics.endFill();
			container.addChild(background);
			background.x = rec.x;
			background.y = rec.y;
			
			rec = new Rectangle(background.x, background.y, background.width, background.height);
			
			/*
			   |           	|
			   1	|		2	|     3
			   |			|
			   --------------------------------
			
			   |            |
			   8	|			|     4
			   |			|
			
			   ---------------------------------
			
			   |           	|
			   7	|		6	|     5
			   |			|
			
			 */
			
			var screenshotArray:Vector.<Bitmap> = new Vector.<Bitmap>;
			var mat:Matrix = new Matrix();
			
			if (rec.x > 0 && rec.y > 0)
			{
				var bd1:BitmapData = new BitmapData(rec.x, rec.y);
				bd1.draw(screenshot.bitmapData);
				var b1:Bitmap = new Bitmap(bd1);
				b1.x = 0;
				b1.y = 0;
				screenshotArray.push(b1);
				container.addChild(b1);
			}
			else
			{
				screenshotArray.push(null);
			}
			
			if (rec.width > 0 && rec.y > 0)
			{
				mat.identity();
				mat.translate(-rec.x, 0);
				
				var bd2:BitmapData = new BitmapData(rec.width, rec.y);
				bd2.draw(screenshot, mat);
				var b2:Bitmap = new Bitmap(bd2);
				b2.x = rec.x;
				b2.y = 0;
				screenshotArray.push(b2);
				container.addChild(b2);
			}
			else
			{
				screenshotArray.push(null);
			}
			
			if (rec.width > 0 && rec.y > 0)
			{
				mat.identity();
				mat.translate(-rec.x - rec.width, 0);
				
				var bd3:BitmapData = new BitmapData(AppSettings.WIDTH - rec.width, rec.y);
				bd3.draw(screenshot, mat);
				var b3:Bitmap = new Bitmap(bd3);
				b3.x = rec.x + rec.width;
				b3.y = 0;
				screenshotArray.push(b3);
				container.addChild(b3);
			}
			else
			{
				screenshotArray.push(null);
			}
			
			if (AppSettings.WIDTH - rec.width > 0 && rec.height > 0)
			{
				mat.identity();
				mat.translate(-rec.x - rec.width, -rec.y);
				
				var bd4:BitmapData = new BitmapData(AppSettings.WIDTH - rec.width, rec.height);
				bd4.draw(screenshot, mat);
				var b4:Bitmap = new Bitmap(bd4);
				b4.x = rec.x + rec.width;
				b4.y = rec.y;
				screenshotArray.push(b4);
				container.addChild(b4);
			}
			else
			{
				screenshotArray.push(null);
			}
			if (AppSettings.WIDTH - rec.width > 0 && AppSettings.HEIGHT - rec.height > 0)
			{
				mat.identity();
				mat.translate(-rec.x - rec.width, -rec.y - rec.height);
				
				var bd5:BitmapData = new BitmapData(AppSettings.WIDTH - rec.width, AppSettings.HEIGHT - rec.height);
				bd5.draw(screenshot, mat);
				var b5:Bitmap = new Bitmap(bd5);
				b5.x = rec.x + rec.width;
				b5.y = rec.y + rec.height;
				
				container.addChild(b5);
				screenshotArray.push(b5);
			}
			else
			{
				screenshotArray.push(null);
			}
			
			if (rec.width > 0 && AppSettings.HEIGHT - rec.height > 0)
			{
				mat.identity();
				mat.translate(-rec.x, -rec.y - rec.height);
				
				var bd6:BitmapData = new BitmapData(rec.width, AppSettings.HEIGHT - rec.height);
				bd6.draw(screenshot, mat);
				var b6:Bitmap = new Bitmap(bd6);
				b6.x = rec.x;
				b6.y = rec.y + rec.height;
				screenshotArray.push(b6);
				container.addChild(b6);
			}
			else
			{
				screenshotArray.push(null);
			}
			
			if (rec.x > 0 && AppSettings.HEIGHT - rec.height > 0)
			{
				mat.identity();
				mat.translate(0, -rec.y - rec.height);
				
				var bd7:BitmapData = new BitmapData(rec.x, AppSettings.HEIGHT - rec.height);
				bd7.draw(screenshot, mat);
				var b7:Bitmap = new Bitmap(bd7);
				b7.x = 0;
				b7.y = rec.y + rec.height;
				screenshotArray.push(b7);
				container.addChild(b7);
			}
			else
			{
				screenshotArray.push(null);
			}
			
			if (rec.x > 0 && rec.height > 0)
			{
				mat.identity();
				mat.translate(0, -rec.y);
				
				var bd8:BitmapData = new BitmapData(rec.x, rec.height);
				bd8.draw(screenshot, mat);
				var b8:Bitmap = new Bitmap(bd8);
				b8.x = 0;
				b8.y = rec.y;
				screenshotArray.push(b8);
				container.addChild(b8);
			}
			else
			{
				screenshotArray.push(null);
			}
			
			var finWidth:Number;
			var finHeight:Number;
			background.width = AppSettings.WIDTH;
			background.height = AppSettings.HEIGHT;
			
			if (background.scaleX < background.scaleY)
			{
				background.height = AppSettings.HEIGHT;
				background.scaleX = background.scaleY;
			}
			else
			{
				background.width = AppSettings.WIDTH;
				background.scaleY = background.scaleX;
				
			}
			finWidth = background.width;
			finHeight = background.height;
			background.scaleX = background.scaleY = 1;
			
			//return;
			TweenLite.to(background, 1.5, {x: 0, y: 0, ease: Expo.easeInOut, width: finWidth, height: finHeight, onUpdate: function():void
				{
					
					for (var i:int = 0; i < screenshotArray.length; i++)
					{
						
						if (screenshotArray[i] == null)
							continue;
						
						screenshotArray[i].scaleX = background.scaleX;
						screenshotArray[i].scaleY = background.scaleY;
						
						var _x:Number;
						var _y:Number;
						switch (i)
						{
							case 0: 
								_y = background.y - screenshotArray[i].height;
								_x = background.x - screenshotArray[i].width;
								break;
							case 1: 
								_y = background.y - screenshotArray[i].height;
								_x = background.x;
								break;
							case 2: 
								_y = background.y - screenshotArray[i].height;
								_x = background.x + background.width;
								break;
							case 3: 
								_y = background.y;
								_x = background.x + background.width;
								break;
							case 4: 
								_y = background.y + background.height;
								_x = background.x + background.width;
								break;
							case 5: 
								_y = background.y + background.height;
								_x = background.x;
								
								break;
							case 6: 
								_y = background.y + background.height;
								_x = background.x - screenshotArray[i].width;
								break;
							case 7: 
								_y = background.y + 1;
								_x = background.x - screenshotArray[i].width;
								break;
							default: 
						}
						screenshotArray[i].x = _x;
						screenshotArray[i].y = _y;
						
					}
				}, onComplete: function():void
				{
					
					for (var i:int = 0; i < screenshotArray.length; i++)
					{
						if (screenshotArray[i] == null)
							continue;
						screenshotArray[i].bitmapData.dispose();
						container.removeChild(screenshotArray[i]);
						
					}
					container.removeChild(background);
				//addPage();
				//animationInFinished();
				
				}
				
				});
		
		}
	
	}

}
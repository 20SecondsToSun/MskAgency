package app.view.utils 
{
	import com.greensock.motionPaths.RectanglePath2D;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class ResizeUtil 
	{
		
		public function ResizeUtil() 
		{
			
		}
		
		public static function getStretch( w:Number, h:Number, stretchW:Number,stretchH:Number):Rectangle
		{
			var scale_X:Number = stretchW / w;
			var scale_Y:Number = stretchH / h;
			
			//trace("scaleResize", w, h , scale_X, scale_Y, stretchW, stretchH);
			
			var _x:Number = 0;
			var _y:Number = 0;
			
			
			if ( scale_X < scale_Y)			
			{				
				w = w * scale_Y;					
				h = stretchH;
			}
			else
			{				
				h = stretchH*scale_X;
				w = stretchW;
			}
			
			//trace("scaleResize == ", w, h , scale_X, scale_Y, stretchW, stretchH);
			
			_x =0// 0.5 * (stretchW - w);			
			_y =0// 0.5 * (stretchH - h);			
			
			return new Rectangle(_x, _y, w, h);			
		}
		
		public static function resizeBitmapToFit(bd:Bitmap, w:Number, h:Number):Bitmap
		{
			var thumb:Bitmap = new Bitmap(bd.bitmapData);
			
			thumb.smoothing = true;
			thumb.height =  h;
			thumb.width =  w;	
			
			if (thumb.scaleX < thumb.scaleY)
			{				
				thumb.height =  h;
				thumb.scaleX = thumb.scaleY;				
			}
			else
			{				
				thumb.width = w;
				thumb.scaleY = thumb.scaleX;				
			}			
			
			var bmpData:BitmapData = new BitmapData(w, h);			
			var mat:Matrix = new Matrix();
			mat.scale(thumb.scaleX, thumb.scaleY);
			mat.translate(thumb.x, thumb.y);
			
			bmpData.draw(thumb, mat);
			
			return new Bitmap(bmpData);
		}
		public static function resizeBitmapToWidth(bd:Bitmap, w:Number):Bitmap
		{
			var thumb:Bitmap = new Bitmap(bd.bitmapData);			
			
			thumb.smoothing = true;	
			thumb.width =  w;
			thumb.height = w *  bd.height / bd.width;
			
			return thumb;
			
		}
		
		
	}

}
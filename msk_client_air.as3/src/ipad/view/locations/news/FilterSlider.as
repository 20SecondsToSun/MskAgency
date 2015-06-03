package ipad.view.locations.news
{
	import app.AppSettings;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.SliderEvent;
	import app.view.baseview.io.InteractiveObject;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.easing.Back;
	import com.greensock.easing.Ease;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import ipad.controller.IpadConstants;
	
	public class FilterSlider extends InteractiveObject
	{
		public static const month:Array = ["января", "февраля", "марта", "апреля", "мая", "июня", "июля", "августа", "сентября", "октября", "ноября", "декабря"];		
		public var year:Array = ["2013", "2014", "2015"];
		
		private static var daysCount:int = 31;
		public var currentClipWidth:Number;
		
		protected var lastX:Number = 0;
		protected var lastY:Number = 0;
		
		public var acceleration:Number = 0.2;
		
		private var initX:Number = 0;
		private var initY:Number = 0;
		public var margin:int = 100;
		
		protected static const sliderEasing:Ease = Back.easeOut;		
		public static const startInteractEvent:SliderEvent = new SliderEvent(SliderEvent.START_INTERACTION);
		public static const stopInteractEvent:SliderEvent = new SliderEvent(SliderEvent.STOP_INTERACTION);
		
		private var splash:Shape = Tool.createShape(AppSettings.WIDTH, height + 20, 0xff0000);
		
		private static const SHIFT_Y:int =  37* IpadConstants.contentScaleFactor;
		private var initX1:int = 0;
		private var initX2:int = 504;
		private var initX3:Number = 252;
			
		private var holder:Sprite;
		private var holder1:Sprite;
		private var holder2:Sprite;
		
		private var holderMask:Shape;
		private var holderMask1:Shape;
		private var holderMask2:Shape;
		
		private var clipArray:Array;
		private var clipArray1:Array;
		private var clipArray2:Array;
		
		private var initY1:int    = 497 * IpadConstants.contentScaleFactor;
		private var initY2:int    = 477 * IpadConstants.contentScaleFactor;
		private var initY3:Number = 252;// IpadConstants.GameHeight * 0.5;
		
		private var textFormat:TextFormat    = new TextFormat("TornadoL", 120, 0xffffff);
		private var textFormatBig:TextFormat = new TextFormat("TornadoL", 231, 0xffffff);
		
		private var activeID:int = 0;
		public var currentID:int;
		
		private var mode:String = "day";
		
		public function FilterSlider(mode:String = "day", fonSize1:Number = 37, fonSize2:Number = 71)
		{
			initSlider(mode, fonSize1, fonSize2);
		}
		
		private function initSlider(mode:String = "day", fonSize1:Number = 37, fonSize2:Number = 71):void
		{
			this.mode = mode;
			
			textFormat.size = fonSize1;
			textFormatBig.size = fonSize2;
			
			holder = new Sprite();
			if (mode != "day") holder.x = -10;
			if (mode == "month") holder.x = -15;
			addChild(holder);
			
			holder1 = new Sprite();
			if (mode != "day") holder1.x = -10;
			if (mode == "month") holder1.x = -15;
			addChild(holder1);
			
			holder2 = new Sprite();
			holder2.x = -10;
			if (mode == "month") holder2.x = -15;
			
			addChild(holder2);
			
			clipArray  = new Array();
			clipArray1 = new Array();
			clipArray2 = new Array();			
			
			initX =  504 * 0.5;
			initY =  533 * IpadConstants.contentScaleFactor;//656 * IpadConstants.contentScaleFactor;//IpadConstants.GameHeight * 0.5;
			
			createSlider(holder, clipArray);
			
			holder.y = initY1 - getCenterByID(activeID, clipArray);
			
			holderMask = Tool.createShape(clipArray[0].width + 15, IpadConstants.GameHeight, 0xff0000);			
			holderMask.y = holder.y;
			holderMask.x =  holder.x;
			
			createSlider(holder1, clipArray1);
			holder1.y = initY2 - clipArray[activeID].height - getCenterByID(activeID, clipArray); // + SHIFT_Y;				
			holderMask1 = Tool.createShape(clipArray[0].width + 15, 188, 0xff0000);			
			holderMask1.y = 34;
			
			createMainSlider(holder2, clipArray2);
			holder2.y = initY3 - getCenterByID(activeID, clipArray2) - clipArray2[activeID].height * 0.5; /// + SHIFT_Y;				
			
			holderMask2 = Tool.createShape(clipArray2[0].width + 25, 350, 0xff0000);				
			holderMask2.x = holder2.x;
			
			holderMask.height = 1100* IpadConstants.contentScaleFactor;// holder.height;
			holderMask.y = 582 * IpadConstants.contentScaleFactor;	
			addChild(holderMask);
			Matrix_createGradientBox(holderMask, -90, 100);
			holderMask.cacheAsBitmap = true;
			holder.cacheAsBitmap = true;
			holder.mask = holderMask;
			
			holderMask1.x =  holder1.x;
			addChild(holderMask1);
			Matrix_createGradientBox(holderMask1);
			holderMask1.cacheAsBitmap = true;
			holder1.cacheAsBitmap = true;
			
			holder1.mask = holderMask1;
			
			holderMask2.height = 114 * IpadConstants.contentScaleFactor;// clipArray2[0].height + 18 * IpadConstants.contentScaleFactor;	
			holderMask2.y = 448 * IpadConstants.contentScaleFactor;	
			addChild(holderMask2);
			holder2.mask = holderMask2;	
			
			splash = Tool.createShape(clipArray2[0].width, IpadConstants.GameHeight, 0xff0000);
			splash.alpha = 0;
			addChild(splash);			
			initListeners();			
			currentID = activeID;
			
			animatetoStartX();
		}
		public static function Matrix_createGradientBox(spr:Shape, deegrees:Number = 90, ty:Number = -30):void
        {
            var myMatrix:Matrix = new Matrix();
         	var w:Number = spr.width;
			var h:Number = spr.height;
            myMatrix.createGradientBox(w, h, deegrees * Math.PI / 180, 50, ty);			
         
			var colors:Array = [0xFF0000, 0x0000FF];
            var alphas:Array = [0, 1];
            var ratios:Array = [0, 0xFF];
			 
			spr.graphics.clear();
		    spr.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, myMatrix);
            spr.graphics.drawRect(0,0, w, h);
        }
		
		public function initIncrease(startValue:int, num:int, mode:String = "day", fonSize1:Number = 120, fonSize2:Number = 231):void
		{
			if (contains(holder))
				removeChild(holder);
				
			if (contains(holder1))
				removeChild(holder1);
				
			if (contains(holder2))
				removeChild(holder2);
			
			if (contains(holderMask))
				removeChild(holderMask);
				
			if (contains(holderMask1))
				removeChild(holderMask1);
				
			if (contains(holderMask2))
				removeChild(holderMask2);
			
			if (contains(splash))
				removeChild(splash);
			
			if (mode == "year")
			{
				year = [];
				for (var i:int = 0; i < num; i++)
					year.push(startValue++);
			}
			
			initSlider(mode, fonSize1, fonSize2);
		}
		
		public function setIndex(index:int):void
		{
			activeID  = index;
			holder.y  = initY1  - getCenterByID(activeID, clipArray);
			holder1.y = initY2  - clipArray[activeID].height 		  - getCenterByID(activeID, clipArray);
			holder2.y = initY3  - getCenterByID(activeID, clipArray2) - clipArray2[activeID].height * 0.5;
			
			currentID = activeID; 
		}
		
		private function createMainSlider(holder:Sprite, clipArray:Array):void
		{
			var offset:Number = 0;
			var len:int = setArrayLength();
			
			for (var i:int = 1; i <= len; i++)
			{
				var day:Sprite = new Sprite();
				holder.addChild(day);
				
				var dayText:TextField = TextUtil.createTextField(0, 0);
				
				dayText.text = setText(i);
				
				dayText.setTextFormat(textFormatBig);
				day.addChild(dayText);
				if (mode == "day") dayText.autoSize = TextFieldAutoSize.RIGHT;
				dayText.x = 0;
				day.y = offset;
				offset += day.height + SHIFT_Y;
				clipArray.push(day);
			}
		}
		
		private function createSlider(holder:Sprite, clipArray:Array):void
		{
			var offset:Number = 0;
			var len:int = setArrayLength();
			
			for (var i:int = 1; i <= len; i++)
			{
				var day:Sprite = new Sprite();
				holder.addChild(day);
				
				var dayText:TextField = TextUtil.createTextField(0, 0);
				dayText.alpha = 0.5;
				dayText.text = setText(i);
				dayText.setTextFormat(textFormat);
				day.addChild(dayText);
				dayText.autoSize = TextFieldAutoSize.RIGHT;
				dayText.x = 0;
				day.y = offset;
				offset += day.height + SHIFT_Y;
				clipArray.push(day);
			}
		}
		
		private function setArrayLength():int
		{
			switch (mode)
			{
				case "day": 
					return daysCount;
					break;
					
				case "month": 
					return month.length;
					break;
					
				case "year": 
					return year.length;
					break;
					
				default: 
			}
			return -1;
		}
		
		private function setText(i:int):String
		{
			switch (mode)
			{
				case "day": 
						if (i.toString().length == 1) return "  " + i.toString();						
					return i.toString();
					break;
					
				case "month": 
					return month[i - 1];
					break;
					
				case "year": 
					return year[i - 1];
					break;
					
				default: 
			}
			
			return "";
		}
		
		private function getCenterByID(activeID:int, arr:Array):Number
		{
			var _height:Number = 0;
			
			for (var i:int = 0; i < arr.length; i++)
			{
				if (activeID == i)				
					return _height;				
				
				_height += (arr[i].height + SHIFT_Y);				
			}
			
			return 0;
		}
		
		public function startDragSlider(e:MouseEvent):void
		{			
			TweenLite.killTweensOf(holder);
			TweenLite.killTweensOf(holder1);
			TweenLite.killTweensOf(holder2);
			lastY = holder.globalToLocal(new Point(e.stageX, e.stageY)).y;
		}
		
		public function updateDragSlider(e:MouseEvent):void
		{
			if (e.stageY > IpadConstants.GameHeight || e.stageY < 0)
				stopDragSlider(e);
		
			var _y:Number = holder.globalToLocal(new Point(e.stageX, e.stageY)).y;			
			var mLastScrollDist:Number = (_y - lastY) * acceleration;
			
			if (holder.y + mLastScrollDist > initY + margin)
			{
				initListeners();
				animatetoStartX();
			}
			else if (holder.y + mLastScrollDist <margin - holder.height)// initY - holder.height - margin)
			{
				initListeners();
				animatetoFinishX();
			}
			else
			{
				holder.y  += mLastScrollDist;
				holder1.y += mLastScrollDist;
				holder2.y += mLastScrollDist;
			}
		}
		
		public function stopDragSlider(e:MouseEvent):void
		{
			var _y:Number = holder.globalToLocal(new Point(e.stageX, e.stageY)).y;
			var finalY:Number = holder.y + (_y - lastY)* acceleration;
			
			if (finalY > initY+ margin)
			{
				initListeners();
				animatetoStartX();
			}
			else if (finalY < margin - holder.height)
			{
				initListeners();
				animatetoFinishX();
			}
			else
			{
				var finalY1:Number = correctFinalY1(finalY) + SHIFT_Y;	
				finalY1 = initY1 - getCenterByID(currentID, clipArray);
				
				var a1:Number = clipArray[currentID].height;
				var a2:Number = getCenterByID(currentID, clipArray);
				var finalY2:Number = initY2 -  a1  - a2;
				var finalY3:Number = initY3 - clipArray2[currentID].height * 0.5 - getCenterByID(currentID, clipArray2);
				
				TweenLite.killTweensOf(holder);
				TweenLite.killTweensOf(holder1);
				TweenLite.killTweensOf(holder2);
				
				TweenLite.to(holder,  Math.abs(holder.y - finalY1) / 700, {y: finalY1, ease: sliderEasing});
				TweenLite.to(holder1, Math.abs(holder.y - finalY2) / 700, {y: finalY2, ease: sliderEasing});
				TweenLite.to(holder2, Math.abs(holder.y - finalY3) / 700, {y: finalY3, ease: sliderEasing});
			}
		}
		
		protected function animatetoFinishX():void
		{
			currentID = clipArray.length - 1;
			TweenLite.killTweensOf(holder);
			TweenLite.killTweensOf(holder1);
			TweenLite.killTweensOf(holder2);
			
			var time:Number = Math.abs(holder.y - (initY - holder.height)) / 700;
			TweenLite.to(holder, time,  {y: initY1 - holder.height  +  clipArray[clipArray.length  - 1].height, ease: sliderEasing});
			TweenLite.to(holder1, time, {y: initY2 - holder1.height -  clipArray[clipArray.length  - 1].height* 0.25, ease: sliderEasing});
			TweenLite.to(holder2, time, {y: initY3 - holder2.height + clipArray2[clipArray2.length - 1].height * 0.5, ease: sliderEasing});
		}	
		
		private function correctFinalY1(finalY:Number):Number
		{
			var _height:Number = 0;
			
			for (var i:int = 0; i < clipArray.length; i++)
			{
				_height += clipArray[i].height + SHIFT_Y;
				
				if (finalY + _height > initY1)
				{					
					if (finalY + _height - SHIFT_Y * 0.5 > initY1)
					{
						currentID = i;
						return initY1 - getCenterByID(currentID, clipArray);
					}
					else
					{
						if (i + 1 >= clipArray.length) currentID = clipArray.length - 1;
						else currentID = i + 1;
						
						return initY1 - getCenterByID(currentID, clipArray);
					}
				}
			}			
			return finalY;
		}
		
		protected function initListeners():void
		{
			dispatchEvent(startInteractEvent);
		}
		
		protected function animatetoStartX():void
		{
			currentID = 0;
			TweenLite.killTweensOf(holder);
			TweenLite.killTweensOf(holder1);
			TweenLite.killTweensOf(holder2);
			
			TweenLite.to(holder,  Math.abs(holder.y) / 700, {y: initY1 +  clipArray[0].height, ease: sliderEasing});
			TweenLite.to(holder1, Math.abs(holder.y) / 700, {y: initY2 -  clipArray[0].height, ease: sliderEasing});
			TweenLite.to(holder2, Math.abs(holder.y) / 700, {y: initY3 - clipArray2[0].height * 0.5, ease: sliderEasing});
		}
		
		public function getValue():String
		{
			switch (mode)
			{
				case "day": 
					var day:String = (currentID + 1).toString();
					return day = day.length == 1 ? "0" + day : day;						
					
				case "month": 					
					var month:String = (currentID + 1).toString();
					return month = month.length == 1? "0" + month : month;					
					
				case "year": 
					return year[currentID ];
					break;
					
				default: 
			}
			return "";		
		}	
		
	}
}
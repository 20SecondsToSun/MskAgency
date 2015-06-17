package app.view.filters
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
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FilterSlider extends InteractiveObject
	{
		public static const month:Array = ["ЯНВАРЯ", "ФЕВРАЛЯ", "МАРТА", "АПРЕЛЯ", "МАЯ", "ИЮНЯ", "ИЮЛЯ", "АВГУСТА", "СЕНТЯБРЯ", "ОКТЯБРЯ", "НОЯБРЯ", "ДЕКАБРЯ"];
		public var year:Array = ["2013", "2014", "2015"];
		
		private static var daysCount:int = 31;
		public var currentClipWidth:Number;
		
		protected var lastX:Number = 0;
		public var acceleration:Number = 0.2;
		
		private var initX:Number = 0;
		public var margin:int = 300;
		protected static const sliderEasing:Ease = Back.easeOut;
		
		public static const startInteractEvent:SliderEvent = new SliderEvent(SliderEvent.START_INTERACTION);
		public static const stopInteractEvent:SliderEvent = new SliderEvent(SliderEvent.STOP_INTERACTION);
		
		private var splash:Shape = Tool.createShape(AppSettings.WIDTH, height + 20, 0xff0000);
		
		private static const SHIFT_Y:int = 140;
		private static const HALF:int = 504 * 0.5;
		
		private var holder:Sprite;
		private var holder1:Sprite;
		private var holder2:Sprite;
		
		private var holderMask:Shape;
		private var holderMask1:Shape;
		private var holderMask2:Shape;
		
		private var clipArray:Array;
		private var clipArray1:Array;
		private var clipArray2:Array;
		
		private var initX1:int = 0;
		private var initX2:int = 504;
		private var initX3:Number = 252;
		
		private var textFormat:TextFormat = new TextFormat("TornadoL", 120, 0xffffff);
		private var textFormatBig:TextFormat = new TextFormat("TornadoL", 231, 0xffffff);
		
		private var activeID:int = 0;
		public var currentID:int;
		
		private var mode:String = "day";
		
		public function FilterSlider(mode:String = "day", fonSize1:Number = 120, fonSize2:Number = 231)
		{
			initSlider(mode, fonSize1, fonSize2);
		}
		
		private function initSlider(mode:String = "day", fonSize1:Number = 120, fonSize2:Number = 231):void
		{
			this.mode = mode;
			
			textFormat.size = fonSize1;
			textFormatBig.size = fonSize2;
			
			holder = new Sprite();
			holder.y = -20;
			addChild(holder);
			
			holder1 = new Sprite();
			holder1.y = -20;
			addChild(holder1);
			
			holder2 = new Sprite();
			holder2.y = -80;
			addChild(holder2);
			
			clipArray = new Array();
			clipArray1 = new Array();
			clipArray2 = new Array();
			
			initX = 504 * 0.5;
			
			createSlider(holder, clipArray);
			holder.x = initX1 - getCenterByID(activeID, clipArray);
			
			holderMask = Tool.createShape(AppSettings.WIDTH * 0.5 - initX, 200, 0xff0000);
			holderMask.x = -holderMask.width;
			
			createSlider(holder1, clipArray1);
			holder1.x = initX2 - clipArray[activeID].width - getCenterByID(activeID, clipArray); // + SHIFT_Y;					
			
			holderMask1 = Tool.createShape(AppSettings.WIDTH * 0.5 - initX, 200, 0xff0000);
			holderMask1.x = 504;
			
			createMainSlider(holder2, clipArray2);
			holder2.x = initX3 - getCenterByID(activeID, clipArray2) - clipArray2[activeID].width * 0.5; /// + SHIFT_Y;				
			
			holderMask2 = Tool.createShape(502 - 47 * 2 + 2, 350, 0xff0000);
			holderMask2.y = -200;
			holderMask2.x = 47;
			
			holder1.y = holder2.y + 0.5 * (holder2.height - holder1.height);
			holder.y = holder2.y + 0.5 * (holder2.height - holder.height);
			
			holderMask.height = holder.height;
			holderMask.y = holder.y;
			addChild(holderMask);
			holder.mask = holderMask;
			
			holderMask1.height = holder1.height;
			holderMask1.y = holder1.y;
			addChild(holderMask1);
			holder1.mask = holderMask1;
			
			holderMask2.height = holder2.height;
			holderMask2.y = holder2.y;
			addChild(holderMask2);
			holder2.mask = holderMask2;
			
			splash = Tool.createShape(AppSettings.WIDTH, height + 20, 0xff0000);
			splash.alpha = 0;
			splash.x = -708;
			splash.y = -100;
			addChild(splash);
			
			initListeners();
			
			currentID = activeID;		
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
			activeID = index;
			holder.x = initX1 - getCenterByID(activeID, clipArray);
			holder1.x = initX2 - clipArray[activeID].width - getCenterByID(activeID, clipArray);
			holder2.x = initX3 - getCenterByID(activeID, clipArray2) - clipArray2[activeID].width * 0.5;
			
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
				day.x = offset;
				offset += day.width + SHIFT_Y;
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
				day.x = offset;
				offset += day.width + SHIFT_Y;
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
			var _width:Number = 0;
			
			for (var i:int = 0; i < arr.length; i++)
			{
				if (activeID == i)				
					return _width;			
				
				_width += (arr[i].width + SHIFT_Y);
				
			}
			return 0;
		}
		
		public function startDragSlider(e:InteractiveEvent):void
		{
			TweenLite.killTweensOf(holder);
			lastX = holder.globalToLocal(new Point(e.stageX, e.stageY)).x;
		}
		
		public function updateDragSlider(e:InteractiveEvent):void
		{
			if (e.stageX > AppSettings.WIDTH || e.stageX < 0)
				stopDragSlider(e);
			
			var _x:Number = holder.globalToLocal(new Point(e.stageX, e.stageY)).x;
			
			var mLastScrollDist:Number = (_x - lastX) * acceleration;
			
			if (holder.x + mLastScrollDist > initX + margin)
			{
				initListeners();
				animatetoStartX();
			}
			else if (holder.x + mLastScrollDist < initX - holder.width - margin)
			{
				initListeners();
				animatetoFinishX();
			}
			else
			{
				holder.x += mLastScrollDist;
				holder1.x += mLastScrollDist;
				holder2.x += mLastScrollDist;
			}
		}
		
		public function stopDragSlider(e:InteractiveEvent):void
		{
			var _x:Number = holder.globalToLocal(new Point(e.stageX, e.stageY)).x;
			var finalX:Number = holder.x + (_x - lastX);
			
			if (finalX >= initX)
			{
				initListeners();
				animatetoStartX();
			}
			else if (finalX <= margin - holder.width)
			{
				initListeners();
				animatetoFinishX();
			}
			else
			{
				//var _activeID:int = 0;
				var finalX1:Number = correctFinalX1(finalX);
				var finalX2:Number = initX2 - clipArray[currentID].width - getCenterByID(currentID, clipArray);
				var finalX3:Number = initX3 - clipArray2[currentID].width * 0.5 - getCenterByID(currentID, clipArray2);
				
				TweenLite.killTweensOf(holder);
				TweenLite.killTweensOf(holder1);
				TweenLite.killTweensOf(holder2);
				
				TweenLite.to(holder, Math.abs(holder.x - finalX1) / 700, {x: finalX1, ease: sliderEasing});
				TweenLite.to(holder1, Math.abs(holder.x - finalX1) / 700, {x: finalX2, ease: sliderEasing});
				TweenLite.to(holder2, Math.abs(holder.x - finalX1) / 700, {x: finalX3, ease: sliderEasing});
			}
		}
		
		private function correctFinalX1(finalX:Number):Number
		{
			var _width:Number = 0;
			
			for (var i:int = 0; i < clipArray.length; i++)
			{
				_width += clipArray[i].width + SHIFT_Y;
				
				if (finalX + _width > initX1)
				{
					
					if (finalX + _width - SHIFT_Y * 0.5 > initX1)
					{
						currentID = i;
						return initX1 - getCenterByID(i, clipArray);
					}
					else
					{
						currentID = i + 1;
						return initX1 - getCenterByID(i + 1, clipArray);
					}
				}
			}
			return finalX;
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
			
			TweenLite.to(holder, Math.abs(holder.x) / 700, {x: initX1 + clipArray[0].width, ease: sliderEasing});
			TweenLite.to(holder1, Math.abs(holder.x) / 700, {x: initX2 - clipArray[0].width, ease: sliderEasing});
			TweenLite.to(holder2, Math.abs(holder.x) / 700, {x: initX3 - clipArray2[0].width * 0.5, ease: sliderEasing});
		}
		
		protected function animatetoFinishX():void
		{
			currentID = clipArray.length - 1;
			TweenLite.killTweensOf(holder);
			TweenLite.killTweensOf(holder1);
			TweenLite.killTweensOf(holder2);
			
			var time:Number = Math.abs(holder.x - (initX - holder.width)) / 700;
			TweenLite.to(holder, time, {x: initX1 - holder.width + clipArray[clipArray.length - 1].width, ease: sliderEasing});
			TweenLite.to(holder1, time, {x: initX2 - holder.width - clipArray[clipArray.length - 1].width, ease: sliderEasing});
			TweenLite.to(holder2, time, {x: initX3 - holder2.width + clipArray2[clipArray2.length - 1].width * 0.5, ease: sliderEasing});
		}	
	}
}
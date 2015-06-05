package app.view.facts
{
	import app.AppSettings;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.SliderEvent;
	import app.view.baseview.slider.Slider;
	import app.view.utils.BigCanvas;
	import app.view.utils.Tool;
	import com.greensock.easing.Ease;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FactsSlider extends Slider
	{
		private static const oneFactWidth:int = 410;
		private static const MARGIN:int = 400;
		public const shiftX:int = 410 + 690;
		private const accel:Number = 0.00142;
		
		private var initX:int;
		private var isInit:Boolean = false;
		
		private var splash:Shape;
		private var screenshot:BigCanvas;
		private var time:Number;
		
		public static const startInteractPullOutEvent:SliderEvent = new SliderEvent(SliderEvent.START_INTERACTION_PULL_OUT);
		public static const stopInteractPullOutEvent:SliderEvent = new SliderEvent(SliderEvent.STOP_INTERACTION_PULL_OUT);
		public const startDragSliderEvent:SliderEvent = new SliderEvent(SliderEvent.FACT_SLIDER_START_DRAG)
		public const stopSliderType:String = SliderEvent.FACT_SLIDER_STOP_DRAG;
		
		public var screenshotArea:Rectangle = new Rectangle(0, 0, AppSettings.WIDTH - oneFactWidth, 500);
		
		public function FactsSlider(_viewPort:Rectangle = null)
		{
			super(_viewPort);
		}
		
		public function init(factData:Vector.<FactsGraphic>):void
		{
			var offset:int = 0;
			for (var i:int = 0; i < factData.length; i++)
			{
				factData[i].x = offset;
				offset += factData[i].width;
				addElement(factData[i]);
			}
			isInit = true;
			initX = holder.x = AppSettings.WIDTH - oneFactWidth;
			if (holder.width < AppSettings.WIDTH)
			{
				var shape:Shape = Tool.createShape(AppSettings.WIDTH - holder.width, 500, 0x5ba041);
				shape.x = offset - 1;
				addElement(shape);
			}
		}
		
		override public function startInteraction():void
		{
			dispatchEvent(startInteractPullOutEvent);
		}
		
		public function startPullOutSlider(e:InteractiveEvent):void
		{
			TweenLite.killTweensOf(holder);
			lastX = holder.globalToLocal(new Point(e.stageX, e.stageY)).x;
		}
		
		public function stopDragSliderPullOutMode(e:InteractiveEvent):void
		{
			if (holder.x > maxBorder - MARGIN - oneFactWidth)
			{
				time = Math.abs(holder.x - initX) * accel;
				
				TweenLite.killTweensOf(holder);
				TweenLite.killTweensOf(screenshot);
				
				TweenLite.to(holder, time, {x: initX, ease: sliderEasing});
				TweenLite.to(screenshot, time, {x: 0, ease: sliderEasing, onComplete: clearScreenShot});
			}
		}
		
		private function clearScreenShot():void
		{
			dispatchEvent(new SliderEvent(SliderEvent.FACT_SLIDER_STOP_DRAG));
			if (contains(screenshot))
				removeChild(screenshot);
		}
		
		public function addScreenShot(shot:BigCanvas):void
		{
			screenshot = shot;
			addChild(screenshot);
		}

		public function updateDragPullOutSlider(e:InteractiveEvent):void
		{
			var _x:Number = holder.globalToLocal(new Point(e.stageX, e.stageY)).x;
			
			var mLastScrollDist:Number = (_x - lastX) * acceleration;
			holder.x += mLastScrollDist;
			screenshot.x = holder.x - screenshot.width;
			
			if (holder.x + mLastScrollDist >= maxBorder - oneFactWidth)
			{
				holder.x = initX;
				screenshot.x = 0;
			}
			
			if (holder.x + mLastScrollDist - maxBorder + oneFactWidth < -MARGIN)
			{
				dispatchEvent(stopInteractPullOutEvent);
				dispatchEvent(startInteractEvent);
				
				animatetoStartX();
				var time:Number = Math.abs(holder.x) * accel;
				
				TweenLite.killTweensOf(screenshot);
				TweenLite.to(screenshot, time, {x: -screenshot.width, ease: sliderEasing});
			}
		}
		
		override public function updateDragSlider(e:InteractiveEvent):void
		{
			if (e.stageX > AppSettings.WIDTH || e.stageX < 0)
				stopDragSlider(e);
			
			var _x:Number = holder.globalToLocal(new Point(e.stageX, e.stageY)).x;
			
			var mLastScrollDist:Number = (_x - lastX) * acceleration;
			holder.x += mLastScrollDist;
			screenshot.x = holder.x - screenshot.width;
			
			var time:Number;
			
			if (holder.x + mLastScrollDist > margin)
			{
				initListeners();
				TweenLite.killTweensOf(screenshot);
				time = Math.abs(holder.x) * accel;
				TweenLite.to(screenshot, time, {x: -screenshot.width, ease: sliderEasing});
				animatetoStartX();
			}
			if (holder.x + mLastScrollDist > MARGIN)
			{
				initFactSliderPosition();
				
			}
			else if (holder.x + mLastScrollDist + holder.width < maxBorder - margin)
			{
				initListeners();
				animatetoFinishX();
				time = Math.abs(holder.x - (maxBorder - holder.width)) * accel;
				TweenLite.to(screenshot, time, {x: holder.x - screenshot.width, ease: sliderEasing});
			}
		}
		private var completeFactSlider:Function;
		public function initFactSliderPosition(completeFactSlider:Function = null):void		
		{
			this.completeFactSlider = completeFactSlider;
			
			TweenLite.killTweensOf(holder);
			TweenLite.killTweensOf(screenshot);
			
			dispatchEvent(stopInteractEvent);
			
			time = Math.abs(holder.x - initX) * accel * 0.3;
			var eas:Ease = Linear.easeNone;
			
			TweenLite.to(holder, time, {x: initX, ease: eas, onComplete: initPullOutListeners});
			TweenLite.to(screenshot, time, {x: 0, ease: eas, onComplete: clearScreenShot});
			
			if (completeFactSlider != null)
				TweenLite.delayedCall(time, completeFactSlider);
		}
		
		override public function stopDragSlider(e:InteractiveEvent):void
		{
			var _x:Number = holder.globalToLocal(new Point(e.stageX, e.stageY)).x;
			
			lastTimeInteract = getTimer();
			isInteractive = false;
			
			if (isPause)
				return;
			
			var finalX:Number = holder.x + (_x - lastX);
			initListeners();
			if (finalX >= 0)
			{
				TweenLite.killTweensOf(screenshot);
				time = Math.abs(holder.x) * accel;
				TweenLite.to(screenshot, time, {x: -screenshot.width, ease: sliderEasing});
				animatetoStartX();
			}
			else if (finalX <= maxBorder - holder.width)
			{
				animatetoFinishX();
				TweenLite.killTweensOf(screenshot);
				time = Math.abs(holder.x - (maxBorder - holder.width)) * accel;
				TweenLite.to(screenshot, time, {x: holder.x - screenshot.width, ease: sliderEasing});
			}
			else
			{
				TweenLite.killTweensOf(holder);
				TweenLite.killTweensOf(screenshot);
				time = Math.abs(holder.x - finalX) * accel;
				TweenLite.to(screenshot, time, {x: holder.x - screenshot.width, ease: sliderEasing});
				TweenLite.to(holder, time, {x: finalX, ease: sliderEasing, onComplete: finishDraggingAnimation, onUpdate: updateFinAnimation});
			}
		}
		
		private function initPullOutListeners():void
		{
			dispatchEvent(startInteractPullOutEvent);
		}
		
		override public function kill():void
		{
			super.kill();
			
			TweenLite.killTweensOf(holder);			
			if (completeFactSlider != null )
				TweenLite.killDelayedCallsTo(completeFactSlider);
			
			if (screenshot)
			{
				TweenLite.killTweensOf(screenshot);
				screenshot.dispose();
			}	
		}		
	}
}
package app.view.videonews
{
	import app.AppSettings;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.SliderEvent;
	import app.view.baseview.slider.Slider;
	import app.view.utils.BigCanvas;
	import app.view.utils.Tool;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Ease;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.display.CapsStyle;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class VideoSlider extends Slider
	{
		private static const MARGIN:int = 200;
		
		private var initX:int;
		private var time:Number;
		private const accel:Number = 1 / 700;
		
		private var screenshot:BigCanvas;
		private var splash:Shape;
		private var matList:Vector.<OneVideoNewGraphic>;
		
		public const oneVideoWidth:int = 410;
		public const oneVideoHeight:int = 500;
		
		public static const startInteractPullOutEvent:SliderEvent = new SliderEvent(SliderEvent.START_INTERACTION_PULL_OUT);
		public static const stopInteractPullOutEvent:SliderEvent = new SliderEvent(SliderEvent.STOP_INTERACTION_PULL_OUT);
		public const startDragSliderEvent:SliderEvent = new SliderEvent(SliderEvent.VIDEO_SLIDER_START_DRAG)
		public const stopSliderType:String = SliderEvent.VIDEO_SLIDER_STOP_DRAG;
		
		public var screenshotArea:Rectangle = new Rectangle(oneVideoWidth, 0, AppSettings.WIDTH - oneVideoWidth, oneVideoHeight);
		
		public var completeVideoSlider:Function;
		
		public function VideoSlider(_viewPort:Rectangle = null)
		{
			super(_viewPort);
		}
		
		public function init(videoData:Vector.<OneVideoNewGraphic>):void
		{
			clearSlider();
			
			matList = videoData.reverse();
			
			var offset:int = 0;
			var line:Shape;
			var len:int = matList.length;
			
			for (var i:int = 0; i < len; i++)
			{
				matList[i].x = offset;
				offset += matList[i].width;
				addElement(matList[i]);
				
				if (i != len - 1)
				{
					line = addLine();
					line.x = offset;
					offset += 1;
					addElementAt(line, 0);
				}
			}
			
			holder.x = initX = -holder.width + oneVideoWidth;
			isReady = true;
		}
		
		public function update(videoData:OneVideoNewGraphic):void
		{
			addElement(videoData);
			
			matList = matList.reverse();
			holder.removeChild(matList.pop());
			matList = matList.reverse();
			
			var offset:int = 0;
			for (var i:int = 0; i < matList.length; i++)
			{
				matList[i].x = offset;
				offset += matList[i].width + 1;
			}
		}
		
		private function addLine():Shape
		{
			var line:Shape = new Shape();
			line.graphics.lineStyle(2, 0xdcd6d8, 1, false, "normal", CapsStyle.NONE);
			line.graphics.moveTo(0, 0);
			line.graphics.lineTo(0, 500);
			return line;
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
			if (holder.x - oneVideoWidth + holder.width < MARGIN)
			{
				time = Math.abs(holder.x - initX) * accel;
				
				TweenLite.killTweensOf(holder);
				TweenLite.killTweensOf(screenshot);
				
				TweenLite.to(holder, time, {x: initX, ease: sliderEasing});
				TweenLite.to(screenshot, time, {x: oneVideoWidth, ease: sliderEasing, onComplete: clearScreenShot});
			}
		}
		
		public function updateDragPullOutSlider(e:InteractiveEvent):void
		{
			var _x:Number = holder.globalToLocal(new Point(e.stageX, e.stageY)).x;
			
			var mLastScrollDist:Number = (_x - lastX) * acceleration;
			holder.x += mLastScrollDist;
			screenshot.x = holder.x + holder.width;
			
			if (holder.x + mLastScrollDist < oneVideoWidth - holder.width)
			{
				holder.x = -holder.width + oneVideoWidth;
				screenshot.x = oneVideoWidth;
			}
			
			if (holder.x + mLastScrollDist - oneVideoWidth + holder.width > MARGIN)
			{
				dispatchEvent(stopInteractPullOutEvent);
				dispatchEvent(startInteractEvent);
				
				animatetoFinishX();
				TweenLite.killTweensOf(screenshot);
				var time:Number = Math.abs(holder.x - (maxBorder - holder.width)) * accel;
				TweenLite.to(screenshot, time, {x: AppSettings.WIDTH, ease: sliderEasing});
			}
		}
		
		override public function updateDragSlider(e:InteractiveEvent):void
		{
			if (e.stageX > AppSettings.WIDTH || e.stageX < 0)
				stopDragSlider(e);
			
			var _x:Number = holder.globalToLocal(new Point(e.stageX, e.stageY)).x;
			
			var mLastScrollDist:Number = (_x - lastX) * acceleration;
			holder.x += mLastScrollDist;
			screenshot.x = holder.x + holder.width;
			
			var time:Number;
			
			if (holder.x + mLastScrollDist > margin)
			{
				initListeners();
				TweenLite.killTweensOf(screenshot);
				time = Math.abs(holder.x) * accel;
				TweenLite.to(screenshot, time, {x: holder.width, ease: sliderEasing});
				animatetoStartX();
			}
			else if (holder.x + mLastScrollDist + holder.width < maxBorder - MARGIN)
			{
				initVideSliderPosition();
			}
			else if (holder.x + mLastScrollDist + holder.width < maxBorder - margin)
			{
				initListeners();
				animatetoFinishX();
				TweenLite.killTweensOf(screenshot);
				time = Math.abs(holder.x - (maxBorder - holder.width)) * accel;
				TweenLite.to(screenshot, time, {x: AppSettings.WIDTH, ease: sliderEasing});
			}
		}
		
		public function initVideSliderPosition(completeVideoSlider:Function = null):void
		{
			TweenLite.killTweensOf(holder);
			TweenLite.killTweensOf(screenshot);
			
			dispatchEvent(stopInteractEvent);
			
			time = Math.abs(holder.x - initX) * accel * 0.3;
			var eas:Ease = Linear.easeNone;
			
			TweenLite.to(holder, time, {x: initX, ease: eas, onComplete: initPullOutListeners});
			TweenLite.to(screenshot, time, {x: oneVideoWidth, ease: eas, onComplete: clearScreenShot});
			
			if (completeVideoSlider != null)
				TweenLite.delayedCall(time, completeVideoSlider);
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
				TweenLite.to(screenshot, time, {x: holder.width, ease: sliderEasing});
				animatetoStartX();
			}
			else if (finalX <= maxBorder - holder.width)
			{
				animatetoFinishX();
				time = Math.abs(holder.x - (maxBorder - holder.width)) * accel;
				TweenLite.to(screenshot, time, {x: AppSettings.WIDTH, ease: sliderEasing});
			}
			else
			{
				TweenLite.killTweensOf(holder);
				TweenLite.killTweensOf(screenshot);
				time = Math.abs(holder.x - finalX) * accel;
				TweenLite.to(screenshot, time, {x: finalX + holder.width + oneVideoWidth, ease: sliderEasing});
				TweenLite.to(holder, time, {x: finalX, ease: sliderEasing, onComplete: finishDraggingAnimation, onUpdate: updateFinAnimation});
			}
		}
		
		private function initPullOutListeners():void
		{
			dispatchEvent(startInteractPullOutEvent);
		}
		
		private function clearScreenShot():void
		{
			if (contains(screenshot))
				removeChild(screenshot);
			
			dispatchEvent(new SliderEvent(SliderEvent.VIDEO_SLIDER_STOP_DRAG));
		}
		
		public function addScreenShot(shot:BigCanvas):void
		{
			screenshot = shot;
			screenshot.x = oneVideoWidth;
			addChild(screenshot);
		}
		
		override public function kill():void
		{
			super.kill();
			
			TweenLite.killTweensOf(holder);
			if (completeVideoSlider != null)
				TweenLite.killDelayedCallsTo(completeVideoSlider);
			
			if (screenshot)
			{
				TweenLite.killTweensOf(screenshot);
				screenshot.dispose();
			}
		}
	}
}
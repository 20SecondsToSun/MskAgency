package app.view.baseview.slider
{
	import app.AppSettings;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.SliderEvent;
	import app.view.baseview.io.InteractiveObject;
	import app.view.utils.Tool;
	import com.greensock.easing.Back;
	import com.greensock.easing.Ease;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class Slider extends InteractiveObject
	{
		public var selfActing:Boolean = false;
		private var delay:uint = 2000;
		private var repeat:uint = 0;
		private var pullTimer:Timer;
		
		protected var lastX:Number = 0;
		public var acceleration:Number = 0.2;
		
		public var margin:int = 400;
		public var startX:int = 0;
		public var maxBorder:Number = AppSettings.WIDTH;
		
		protected static const sliderEasing:Ease = Back.easeOut;
		public static const startInteractEvent:SliderEvent = new SliderEvent(SliderEvent.START_INTERACTION);
		public static const stopInteractEvent:SliderEvent = new SliderEvent(SliderEvent.STOP_INTERACTION);
		
		public var holder:InteractiveObject;
		
		private var mouseHold:Boolean = false;
		public var isPause:Boolean = false;
		
		protected var isInteractive:Boolean = false;
		private var isUpdating:Boolean = false;
		public var isSlideShow:Boolean = false;
		
		private var childList:Vector.<DisplayObject>;
		private var childListUpdate:Vector.<DisplayObject>;
		
		private var viewPort:Rectangle;
		public var fillholder:Shape;
		
		public var isReady:Boolean = false;
		
		protected var lastTimeInteract:int;
		
		protected var slideShowTime:Number = 0.05;
		protected var slideShowDirection:String = "FORWARD";
		private var slideShowTimer:Timer = new Timer(1000, 5);
		
		public function Slider(_viewPort:Rectangle = null, isMask:Boolean = true)
		{
			name = "slider";
			viewPort = _viewPort;
			childList = new Vector.<DisplayObject>();
			childListUpdate = new Vector.<DisplayObject>();
			
			holder = new InteractiveObject();
			addChild(holder);
			
			if (viewPort)
			{
				var over:Shape = Tool.createShape(viewPort.width, viewPort.height, 0x0000FF);
				over.alpha = 0;
				over.x = 0; // viewPort.x;
				over.y = 0; // viewPort.y;
				addChild(over);
				
				maxBorder = viewPort.width; // - viewPort.x;
				startX = viewPort.x;
				
				if (isMask)
				{
					var maskLayer:Shape = Tool.createShape(viewPort.width - viewPort.x, viewPort.height, 0x0000FF);
					maskLayer.x = viewPort.x;
					holder.mask = maskLayer;
					addChild(maskLayer);
				}
			}
			else
			{
				viewPort = new Rectangle(0, 0, AppSettings.WIDTH, AppSettings.HEIGHT);
				fillholder = Tool.createShape(1, 1, 0x0000FF);
				fillholder.alpha = 0;
				holder.addChild(fillholder);
			}
		}
		
		public function resetPosition():void
		{
			var offset:Number = 0;
			
			for (var i:int = 0; i < childList.length; i++)
			{
				childList[i].x = offset;
				offset += childList[i].width;
			}
		}
		
		public function clearSlider():void
		{
			isReady = false;
			Tool.removeAllChildren(holder);
			childList = new Vector.<DisplayObject>();
			
			if (fillholder)
			{
				holder.addChild(fillholder);
				fillholder.width = 1;
			}
		}
		
		public function addElement(child:DisplayObject):void
		{
			childList.push(child);
			holder.addChild(child);
			
			if (fillholder)
			{
				fillholder.height = holder.height;
				fillholder.width = holder.width;
				holder.setChildIndex(fillholder, holder.numChildren - 1);
			}
		}
		
		public function addElementAt(child:DisplayObject, index:int):void
		{
			childList.push(child);
			holder.addChildAt(child, index);
			
			if (fillholder)
			{
				fillholder.height = holder.height;
				fillholder.width = holder.width;
				holder.setChildIndex(fillholder, holder.numChildren - 1);
			}
		}
		
		public function startInteraction():void
		{
			dispatchEvent(startInteractEvent);
			setTimerSlideShow();
		}
		
		public function stopInteraction():void
		{
			dispatchEvent(stopInteractEvent);
		}
		
		public function kill():void
		{
			TweenLite.killTweensOf(this);
		}
		
		public function startDragSlider(e:InteractiveEvent):void
		{
			isInteractive = true;
			TweenLite.killTweensOf(holder);
			killTimer();
			lastX = holder.globalToLocal(new Point(e.stageX, e.stageY)).x;
		}
		
		public function updateDragSlider(e:InteractiveEvent):void
		{
			if (e.stageX > AppSettings.WIDTH || e.stageX < viewPort.x)
				stopDragSlider(e);
			
			if (isPause)
				return;
			
			var _x:Number = holder.globalToLocal(new Point(e.stageX, e.stageY)).x;
			
			var mLastScrollDist:Number = (_x - lastX) * acceleration;
			holder.x += mLastScrollDist;
			if (holder.x + mLastScrollDist > startX + margin)
			{
				initListeners();
				animatetoStartX();
			}
			
			if (holder.x + mLastScrollDist + holder.width < maxBorder - margin)
			{
				if (checkElementsToAdd())
					return;
				
				initListeners();
				animatetoFinishX();
			}
		}
		
		public function stopDragSlider(e:InteractiveEvent):void
		{
			var _x:Number = holder.globalToLocal(new Point(e.stageX, e.stageY)).x;
			
			lastTimeInteract = getTimer();
			isInteractive = false;
			
			initListeners();
			if (isPause)
				return;
			
			var finalX:Number = holder.x + (_x - lastX);
			if (finalX >= startX)
			{
				initListeners();
				animatetoStartX();
			}
			else if (finalX <= maxBorder - holder.width)
			{
				initListeners();
				animatetoFinishX();
			}
			else
			{
				TweenLite.killTweensOf(holder);
				TweenLite.to(holder, Math.abs(holder.x - finalX) / 700, {x: finalX, ease: sliderEasing, onComplete: finishDraggingAnimation, onUpdate: updateFinAnimation});
			}
		}
		
		protected function animatetoStartX():void
		{
			TweenLite.killTweensOf(holder);
			TweenLite.to(holder, Math.abs(holder.x) / 700, {x: startX, ease: sliderEasing, onComplete: finishDraggingAnimation, onUpdate: updateFinAnimation});
		}
		
		protected function animatetoFinishX():void
		{
			TweenLite.killTweensOf(holder);
			var time:Number = Math.abs(holder.x - (maxBorder - holder.width)) / 700;
			TweenLite.to(holder, time, {x: maxBorder - holder.width, ease: sliderEasing, onComplete: finishDraggingAnimation, onUpdate: updateFinAnimation});
		}
		
		public function updateFinAnimation():void
		{
		
		}
		
		protected function finishDraggingAnimation():void
		{
			//dispatchEvent(new AnimationEvent(AnimationEvent.STOP));
			//dispatchEvent(startInteractEvent);		
			//addEventListener(InteractiveEvent.HAND_DOWN, startDragSlider);
			
			setTimerSlideShow();
		}
		
		protected function initListeners():void
		{
			dispatchEvent(startInteractEvent);
			mouseHold = false;
		}
		
		private function animateToStartPosition():void
		{
			if (x != 0)
			{
				var _time:Number = Math.abs(x - 0) / width * 4;
				
				TweenLite.to(holder, _time, {x: 0, ease: sliderEasing, onComplete: startIntercativeSelfActing});
			}
			else
				startIntercativeSelfActing();
		}
		
		protected function startIntercativeSelfActing():void
		{
		
		}
		
		protected function checkElementsToAdd():Boolean
		{
			return false;
		}
		
		private function setTimerSlideShow():void
		{
			if (!isSlideShow)
				return;
			
			slideShowTimer.addEventListener(TimerEvent.TIMER_COMPLETE, startSlideShow);
			slideShowTimer.reset();
			slideShowTimer.start();
		}
		
		private function startSlideShow(e:TimerEvent = null):void
		{
			slideShowTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, startSlideShow);
			slideShowTimer.stop();
			
			if (childListUpdate.length != 0)
			{
				updateChilds();
			}
			else
			{
				TweenLite.killTweensOf(holder);
				
				var time:Number;//((holder.width + holder.x) / holder.width) * slideShowTime * holder.width;
				
				switch (slideShowDirection)
				{
				case "FORWARD": 
					time = ((holder.width + holder.x) / holder.width) * 500;
					TweenLite.to(holder, time, {x: maxBorder - holder.width, onComplete: reorganize});
					break;
				
				case "BACK": 
					time = (1 - (holder.width + holder.x) / holder.width) * 600;
					TweenLite.to(holder, time, {x: startX, onComplete: reorganize});
					break;
				}
			}
		}
		
		private function reorganize():void
		{
			switch (slideShowDirection)
			{
			case "FORWARD": 
				holder.x = startX;
				break;
			
			case "BACK": 
				holder.x = maxBorder - holder.width;
				break;
			}
			setTimerSlideShow();
		}
		
		public function killTimer():void
		{
			slideShowTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, startSlideShow);
			slideShowTimer.stop();
			TweenLite.killTweensOf(holder);
		}
		
		public function tryUpdateChilds(child:DisplayObject):void
		{
			childListUpdate.push(child);
			
			var interval:int = getTimer() - lastTimeInteract;
			
			if (!isInteractive && interval > 5000)
				updateChilds();
		}
		
		private function updateChilds():void
		{
			isUpdating = true;
			killTimer();
			TweenLite.killTweensOf(holder);
			
			dispatchEvent(stopInteractEvent);
			// TODO UPDATE	
			holder.visible = false;
			
			var offset:Number = 0;
			var updatingChilds:int = childListUpdate.length;
			
			holder.x = 0;
			while (childListUpdate.length)
			{
				var child:DisplayObject = childListUpdate.pop();
				childList.unshift(child);
				child.x = offset;
				offset += child.width;
				holder.addChild(child);
			}
			
			for (var i:int = updatingChilds; i < childList.length; i++)
			{
				childList[i].x += offset;
			}
			holder.visible = true;
			
			dispatchEvent(startInteractEvent);
			setTimerSlideShow();			
			isUpdating = false;
		}
	}
}
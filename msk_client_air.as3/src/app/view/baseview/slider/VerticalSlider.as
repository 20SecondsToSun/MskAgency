package app.view.baseview.slider
{
	import app.AppSettings;
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.InteractiveEvent;
	import app.view.baseview.io.InteractiveObject;
	import app.view.utils.Tool;
	import com.greensock.easing.Back;
	import com.greensock.easing.Ease;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class VerticalSlider extends InteractiveObject
	{
		public var dynamicLoad:Boolean = false;			
		private var isInteractiveNow:Boolean = true;
		
		private var mouseHold:Boolean = false;
		protected var lastY:Number = 0;
		public var maxBorder:Number = AppSettings.HEIGHT;
		public var acceleration:Number = 0.2;
		protected var sliderEasing:Ease = Back.easeOut;
		public var margin:int = 400;
		
		private var fonSlider:Shape = new Shape();
		
		public var container:Sprite;
		private var maskLayer:Sprite;
		public var elemensArray:Array;
		public var isPause:Boolean = false;	
		
		public var startY:int = 0;
		
		public function VerticalSlider()
		{
			fonSlider.graphics.beginFill(0xff0000, 1.0);
			fonSlider.graphics.drawRect(0, 0, 10, 10);
			fonSlider.graphics.endFill();
			addChild(fonSlider);
			fonSlider.alpha = 0;
			elemensArray = new Array();
			
			container = new Sprite();
			addChild(container);		
		}
		
		public function addElement(el:InteractiveObject):void
		{
			container.addChild(el);
			elemensArray.push(el);
		}		
		
		public function dragZoneFix(offsetY:Number = -1):void
		{
			if (offsetY == -1)						
				fonSlider.height = this.height;			
			else			
				fonSlider.height = offsetY;	
			
			fonSlider.width = this.width;		
			
		}
		
		public function focusSlider(id:int,offsetInit:Number):void
		{			
		
		}		
		
		public function startInteraction():void
		{			
			addEventListener(InteractiveEvent.HAND_DOWN, startDragSlider);
			addEventListener(Event.REMOVED_FROM_STAGE, cleanUpListeners);		
		}
		
		public function stopInteraction():void
		{			
			cleanUpListeners(null);
		}
		
		protected function cleanUpListeners(e:Event):void
		{
			TweenLite.killTweensOf(this);
			removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpListeners);
			removeEventListener(InteractiveEvent.HAND_UP, stopDragSlider);
			removeEventListener(InteractiveEvent.HAND_UPDATE, updateDragSlider);
			removeEventListener(InteractiveEvent.HAND_DOWN, startDragSlider);
		}		
		protected function startDragSlider(e:InteractiveEvent):void
		{			
			mouseHold = true;
			TweenLite.killTweensOf(this);
			lastY = globalToLocal(new Point(e.stageX, e.stageY)).y;
			
			addEventListener(InteractiveEvent.HAND_UPDATE, updateDragSlider, false, 0, true);
			addEventListener(InteractiveEvent.HAND_UP, stopDragSlider);
			removeEventListener(InteractiveEvent.HAND_DOWN, startDragSlider);
		}
		
		protected function updateDragSlider(e:InteractiveEvent):void
		{			
			if (e.stageY > AppSettings.HEIGHT || e.stageY < 0) stopDragSlider(e);			
			if (isPause) return;
			
			var _y:Number = globalToLocal(new Point(e.stageX, e.stageY)).y;
			
			var mLastScrollDist:Number = (_y - lastY) * acceleration;
			y += mLastScrollDist;
			
			if (y + mLastScrollDist > startY + margin)
			{				
				initListeners();
				animatetoStartY();
			}
			
			if (y + mLastScrollDist + height < maxBorder - margin)
			{
				if (dynamicLoad)
				{					
					var finalY:Number = loadNews("TO_PAST");								
					return;
				}
					
				initListeners();
				animatetoFinishY();
			}
		}
		
		protected function loadNews(string:String):Number 
		{
			return NaN;
		}
		
		protected function checkElementsToAdd():Boolean
		{
			return false;
		}
		
		protected function stopDragSlider(e:InteractiveEvent):void
		{
			var _y:Number = globalToLocal(new Point(e.stageX, e.stageY)).y;
			
			initListeners();
			if (isPause)
				return;
			
			var finalY:Number = y + (_y - lastY);
			if (finalY >= startY)
			{
				initListeners();
				animatetoStartY();
			}
			else if (finalY <= maxBorder - height)
			{
				initListeners();
				animatetoFinishY();
			}
			else
			{
				TweenLite.killTweensOf(this);
				TweenLite.to(this, Math.abs(y - finalY) / 500, {y: finalY, ease: sliderEasing, onComplete: finishDraggingAnimation});
			}
		}		
		
		protected function animatetoStartY():void
		{
			TweenLite.killTweensOf(this);
			TweenLite.to(this, Math.abs(y-startY) / 500, {y: startY, ease: sliderEasing, onComplete: finishDraggingAnimation});
		}
		
		public function animatetoFinishY():void
		{		
			TweenLite.killTweensOf(this);
			TweenLite.to(this, Math.abs(y - (maxBorder - height)) / 500, {y: maxBorder - height, ease: sliderEasing, onComplete: finishDraggingAnimation});
		}
		
		protected function initListeners():void
		{
			removeEventListener(InteractiveEvent.HAND_UP, stopDragSlider);
			removeEventListener(InteractiveEvent.HAND_UPDATE, updateDragSlider);
			addEventListener(InteractiveEvent.HAND_DOWN, startDragSlider);
			mouseHold = false;
		}
		
		protected function finishDraggingAnimation():void
		{
			dispatchEvent(new AnimationEvent(AnimationEvent.STOP));
			addEventListener(InteractiveEvent.HAND_DOWN, startDragSlider);			
		}		
		
		private function animateToStartPosition():void
		{
			if (y != 0)
			{
				var _time:Number = Math.abs(y - 0) / height * 4;				
				TweenLite.to(this, _time, {y: 0, ease: sliderEasing});
			}			
		}
		
		protected function correctTime(time:Number):Number
		{
			if (time > 1) time = 1;
			if (time < 0.7) time = 0.7;
			return time;
		}	
	}
}
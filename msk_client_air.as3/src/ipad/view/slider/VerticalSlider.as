package ipad.view.slider
{
	import app.AppSettings;
	import app.contoller.events.AnimationEvent;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import ipad.controller.IpadConstants;
	//import app.contoller.events.InteractiveEvent;
	//import app.view.baseview.io.InteractiveObject;
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
	public class VerticalSlider extends Sprite
	{
		public var dynamicLoad:Boolean = false;			
		private var isInteractiveNow:Boolean = true;
		
		private var mouseHold:Boolean = false;
		protected var lastY:Number = 0;
		public var maxBorder:Number = IpadConstants.GameHeight - 290 * IpadConstants.contentScaleFactor;		
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
		
		public function addElement(el:DisplayObject):void
		{
			container.addChild(el);
			elemensArray.push(el);
		}		
		
		public function dragZoneFix(offsetY:Number = -1):void
		{
			if (offsetY == -1)
			{				
				fonSlider.height = this.height;		
			}
			else
			{
				fonSlider.height = offsetY;	
			}
			fonSlider.width = this.width;		
			
		}
		public function focusSlider(id:int,offsetInit:Number):void
		{
			
			/*var offsetY:Number;
			for (var i:int = 0; i < elemensArray.length; i++) 
			{
				if (elemensArray[i].id == id)
				{					
					offsetY = elemensArray[i].y;
					break;
				}
			}	
			
			var time:Number = (this.height - ( this.y - offsetY + offsetInit)) / this.height;
			var finalY:Number =  this.y - offsetY + offsetInit ;
			if (finalY <  - this.height + AppSettings.HEIGHT) finalY =  - this.height +AppSettings.HEIGHT;			
			if (container.height < AppSettings.HEIGHT) finalY =  0;			
			
			TweenLite.to(this, time, { y:finalY} );			*/
		}		
		
		public function startInteraction():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, startDragSlider);			
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
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragSlider);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, updateDragSlider);
			removeEventListener(MouseEvent.MOUSE_DOWN, startDragSlider);
		}		
		protected function startDragSlider(e:MouseEvent):void
		{	
			mouseHold = true;
			TweenLite.killTweensOf(this);
			lastY = globalToLocal(new Point(e.stageX, e.stageY)).y;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, updateDragSlider, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragSlider);
			removeEventListener(MouseEvent.MOUSE_DOWN, startDragSlider);
		}
		
		protected function updateDragSlider(e:MouseEvent):void
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
					/*if ( isNaN(finalY)) finalY =  maxBorder - height;		
					var time:Number = correctTime(Math.abs(y - finalY) / 100);
					TweenLite.killTweensOf(this);
					TweenLite.to(this, time , { y: 0, ease: sliderEasing, onComplete: finishDraggingAnimation } );	*/				
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
		
		protected function stopDragSlider(e:MouseEvent):void
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
			/*if (elemensArray.length < 3 )
			{
				animatetoStartY();
				return;
			}*/
			
			TweenLite.killTweensOf(this);
			TweenLite.to(this, Math.abs(y - (maxBorder - height)) / 500, {y: maxBorder - height, ease: sliderEasing, onComplete: finishDraggingAnimation});
		}
		
		protected function initListeners():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragSlider);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, updateDragSlider);
			addEventListener(MouseEvent.MOUSE_DOWN, startDragSlider);
			mouseHold = false;
		}
		
		protected function finishDraggingAnimation():void
		{
			dispatchEvent(new AnimationEvent(AnimationEvent.STOP));
			addEventListener(MouseEvent.MOUSE_DOWN, startDragSlider);			
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
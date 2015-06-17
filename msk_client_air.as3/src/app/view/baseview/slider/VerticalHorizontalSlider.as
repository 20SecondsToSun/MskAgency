package app.view.baseview.slider 
{
	import app.AppSettings;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.SliderEvent;
	import app.view.baseview.io.InteractiveObject;
	import app.view.page.day.onehourslider.OneHourSlider;
	import com.greensock.easing.Back;
	import com.greensock.easing.Ease;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.security.X500DistinguishedName;
	/**
	 * ...
	 * @author castor troy
	 */
	public class VerticalHorizontalSlider extends InteractiveObject
	{
		public static const startInteractEvent:SliderEvent = new SliderEvent(SliderEvent.START_INTERACTION);
		public static const stopInteractEvent:SliderEvent = new SliderEvent(SliderEvent.STOP_INTERACTION);		
		
		public var dynamicLoad:Boolean = false;		
		public var TRY_HEIGHT:Number = -1;
		
		protected var mouseHold:Boolean = false;
		protected var lastY:Number = 0;
		protected var maxBorder:int = AppSettings.HEIGHT;
		protected var acceleration:Number = 0.2;
		protected var sliderEasing:Ease = Back.easeOut;
		protected var margin:int = 400;
		
		protected var startXY:Object = new Object;
		protected var direction:String = "NONE";		
		protected var lastX:Number;
		
		protected var sliderContainer:Sprite;
		protected var sliders:Vector.<*> ;
		
		protected static const MIN_ROW_TO_INTERACT:int = 4;
		
		protected var time:Number = 0;
		protected var initY:Number = 0;		
		
		private var isUpdated:Boolean = false;
		
		public function VerticalHorizontalSlider() 
		{
			sliderContainer = new Sprite();			
			addChild(sliderContainer);				
		}
		
		public function addElement(_do:DisplayObject, isSplash:Boolean = false):void
		{
			sliderContainer.addChild(_do);
			if (!isSplash) sliders.push(_do);
			TRY_HEIGHT += _do.height;
		}
		
		public function removeElement(_do:DisplayObject):void
		{
			sliderContainer.removeChild(_do);
			TRY_HEIGHT -= _do.height;
		}
		
		public function startInteraction():void
		{
			dispatchEvent(startInteractEvent);
		}
		
		public function startDragSlider(e:InteractiveEvent):void
		{			
			startXY.X = e.stageX;
			startXY.Y = e.stageY;
			
			mouseHold = true;
			TweenLite.killTweensOf(this);
			lastY = globalToLocal(new Point(e.stageX, e.stageY)).y;	
			
			isUpdated = false;			
			TweenLite.delayedCall(0.1, oneFrameForHandUpdate);		
		}
		
		
		private function oneFrameForHandUpdate():void 
		{
			isUpdated = true;			
		}
		
		public function updateDragSlider(e:InteractiveEvent):void
		{			
			if (direction == "HORIZONTAL" || !isUpdated) return;
			
			isUpdated = true;
			
			if (direction == "NONE")
			{
				if ( Math.abs(startXY.Y- e.stageY)<	Math.abs(startXY.X- e.stageX))
				{
					direction = "HORIZONTAL" ;
					for (var i:int = 0; i < sliders.length; i++)
							sliders[i].isPause = false;					
					return;
				}
				else
				{
					for (var k:int = 0; k < sliders.length; k++)
							sliders[k].isPause = true;			
					
					direction = "VERTICAL" ;									
				}
			}
		
			if (sliders.length < MIN_ROW_TO_INTERACT) return;			
			
			if (e.stageY > AppSettings.HEIGHT || e.stageY < 0) 
			{
				stopDragSlider(e);	
				return;
			}
			var _y:Number = globalToLocal(new Point(e.stageX, e.stageY)).y;			
			
			var mLastScrollDist:Number = (_y - lastY) * acceleration;
			y += mLastScrollDist;
			
			var finalY:Number;
			var time:Number;
			
			if (y + mLastScrollDist + initY> margin )
			{
				if (dynamicLoad)
				{					
					finalY = loadNews("TO_FUTURE");
					if ( isNaN(finalY)) finalY = y + (_y - lastY) * 2;	
					time = correctTime(Math.abs(y - finalY) / 100);
					TweenLite.killTweensOf(this);					
					TweenLite.to(this, time , {y: finalY, ease: sliderEasing, onComplete: finishDraggingAnimation});
					return;
				}
				
				initListeners();
				animatetoStartY();
			}
			
			var point:Point = localToGlobal(new Point(0, initY));			
				
			if (point.y + _height() < maxBorder - margin)			
			{
				if (dynamicLoad)
				{					
					finalY = loadNews("TO_PAST");	
					if ( isNaN(finalY)) finalY = y + (_y - lastY) * 2;		
					time = correctTime(Math.abs(y - finalY) / 100);
					TweenLite.killTweensOf(this);
					TweenLite.to(this, time , { y: finalY, ease: sliderEasing, onComplete: finishDraggingAnimation } );					
					return;
				}
				
				initListeners();
				animatetoFinishY();
			}
		}
		
		public function _height():Number 
		{
			return TRY_HEIGHT == -1?height: TRY_HEIGHT;		
		}
		
		protected function loadNews(string:String):Number 
		{
			return NaN;
		}
		
		protected function initListeners():void
		{			
			dispatchEvent(startInteractEvent);
			mouseHold = false;
		}		
		
		public function stopDragSlider(e:InteractiveEvent):void
		{	
			if (e == null) return;
			if (direction == "HORIZONTAL" )
			{
				direction = "NONE";
				initListeners();
				return;
			}
			direction = "NONE";	
			
			initListeners();
			
			if (sliders.length < MIN_ROW_TO_INTERACT) return;
			
			var _y:Number = globalToLocal(new Point(e.stageX, e.stageY)).y;
			
			
			
			var finalY:Number = y + (_y - lastY) * 2;
				
			if (finalY >= -initY)
			{
				initListeners();
				animatetoStartY();
			}
			else if (finalY <= maxBorder -  _height()-initY)
			{
				initListeners();
				animatetoFinishY();
			}
			else
			{
				time = correctTime(Math.abs(y - finalY) / 100);
				TweenLite.killTweensOf(this);
				TweenLite.to(this, time , {y: finalY, ease: sliderEasing, onComplete: finishDraggingAnimation});
			}
		}
		
		protected function animatetoStartY():void
		{					
			time = correctTime( Math.abs(initY) / 400);
			TweenLite.killTweensOf(this);
			TweenLite.to(this, time , {y: -initY, ease: sliderEasing, onComplete: finishDraggingAnimation});
		}
		
		protected function animatetoFinishY():void
		{
			time = correctTime(  Math.abs(y - (maxBorder -  _height())-initY) / 400);
			TweenLite.killTweensOf(this);
			TweenLite.to(this, time, {y: maxBorder -  _height() -initY, ease: sliderEasing, onComplete: finishDraggingAnimation});
		}
		
		protected function finishDraggingAnimation():void
		{

		}
		
		protected function correctTime(time:Number):Number
		{
			if (time > 1) time = 1;
			if (time < 0.7) time = 0.7;
			return time;
		}		
	}
}
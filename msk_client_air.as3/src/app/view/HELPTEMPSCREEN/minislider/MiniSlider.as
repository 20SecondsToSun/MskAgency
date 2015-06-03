package app.view.HELPTEMPSCREEN.minislider
{
	import app.contoller.events.AnimationEvent;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class MiniSlider extends Sprite
	{
		
		private var min:Number = 0;
		private var max:Number = 100;
		
		private var lenPixels:Number = 300;
		
		private var draggerSize:Number = 50;
		private var polosaWidth:Number = 10;
		private var lastX:Number = 0;
		private var dragger:Sprite;
		private var sh:Shape;
		
		public function init():void
		{
			sh = new Shape();
			sh.graphics.beginFill(0x213A24, 1);
			sh.graphics.drawRect(0, 0, lenPixels, polosaWidth);
			sh.graphics.endFill();
			addChild(sh);
			
			dragger = new Sprite();
			dragger.graphics.beginFill(0x3A653F, 1);
			dragger.graphics.drawRect(0, 0, draggerSize, draggerSize);
			dragger.graphics.endFill();
			addChild(dragger);
			
			dragger.y = -(draggerSize - polosaWidth) * 0.5;
			
			addEventListener(MouseEvent.MOUSE_DOWN, startDragHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
		}
		
		private function stopDragHandler(e:MouseEvent):void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, startDragHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
			
			if (percent < 0.6)
			{
				TweenLite.to(dragger, 0.5, {x: 0, onUpdate: function():void
				{
					disp(1 - (sh.width - dragger.x) / sh.width);
				}});
			}
		}
		private var percent:Number
		
		private function dragHandler(e:MouseEvent):void
		{			
			var _x:Number = globalToLocal(new Point(e.stageX, e.stageY)).x;
			
			if (_x < sh.x)
			{
				dragger.x = sh.x;
			}
			else if (_x > sh.x + sh.width)
			{
				dragger.x = sh.x + sh.width;
			}
			else
			{
				dragger.x = _x;
			}
			
			if (lastX != dragger.x)
			{
				percent = 1 - (sh.width - dragger.x) / sh.width;
				disp(1 - (sh.width - dragger.x) / sh.width);
			}
			if (percent > 0.45)
			{
				TweenLite.to(dragger, 0.5, {x: sh.x + sh.width, onUpdate: function():void
					{
						
					}});
				disp(1);
				//trace("DOOOOOOOOOONE!!!!!!");
				addEventListener(MouseEvent.MOUSE_DOWN, startDragHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragHandler);
			}
			
			lastX = dragger.x;
		}
		
		private function disp(percent:Number):void
		{
			var evt:AnimationEvent = new AnimationEvent(AnimationEvent.STRETCH);
			evt.percent = percent;
			dispatchEvent(evt);
			
		}
		
		private function startDragHandler(e:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN, startDragHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, dragHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
		
		}
	
	}

}
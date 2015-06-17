package app.view.baseview
{
	import app.contoller.constants.AnimConst;
	import app.view.baseview.io.InteractiveObject;
	import com.greensock.easing.Ease;
	import com.greensock.easing.Quint;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class BaseView extends InteractiveObject implements IView
	{
		[Inject]
		public var anim:AnimConst;
		
		public function BaseView()
		{
		
		}
		
		public function mainViewStartAnimation():void
		{
		
		}
		
		public function animateXY(_x:Number, _y:Number, time:Number = 0.4):void
		{
			TweenLite.to(this, time, {x: _x, y: _y, ease: Quint.easeOut, onComplete: animationFinished});
		}
		
		public function animateToXY(_x:Number, _y:Number, time:Number = 0.4, _ease:Ease = null):void
		{
			TweenLite.to(this, time, {x: _x, y: _y, ease: _ease, onComplete: animationInFinished});
		}
		
		public function animateScaleXY(target:DisplayObject, _scaleX:Number, _scaleY:Number, time:Number = 0.4):void
		{
			TweenLite.to(target, time, {scaleX: _scaleX, scaleY: _scaleY, ease: Quint.easeOut, onComplete: animationInFinished});
		}
		
		public function animationInFinished():void
		{
		
		}
		
		public function animateOutXY(_x:Number, _y:Number, time:Number = 0.4, _ease:Ease = null):void
		{
			TweenLite.to(this, time, {x: _x, y: _y, ease: _ease, onComplete: animationOutFinished});
		}
		
		public function animationFinished():void
		{
		
		}
		
		public function animationOutFinished():void
		{
		
		}
		
		public function setX(x:Number):void
		{
			this.x = x;
		}
		
		public function showView():void
		{
			visible = true;
		}
		
		public function hideView():void
		{
			visible = false;
		}
		
		public function isListNull(list:*):Boolean
		{
			if (!list || list.length == 0) return true;
			return false;
		}
	}
}
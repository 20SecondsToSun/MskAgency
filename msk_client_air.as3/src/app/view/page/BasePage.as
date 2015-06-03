package app.view.page
{
	import app.contoller.events.AnimationEvent;
	import app.model.types.AnimationType;
	import app.view.baseview.BaseView;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class BasePage extends BaseView
	{
		protected var background:Shape;	
		public var expand_rectangle:Rectangle;	
		
		public  function expand():void
		{			
			
		}		
		public function addPage():void 
		{
		
		}
		
		public function flip():void
		{
			
		}
		
		override public function animationInFinished():void
		{
			dispatchEvent(new AnimationEvent(AnimationEvent.PAGE_ANIMATION_FINISHED, AnimationType.IN, this));			
		}		
		
		override public function animationOutFinished():void
		{
			dispatchEvent(new AnimationEvent(AnimationEvent.PAGE_ANIMATION_FINISHED, AnimationType.OUT, this));			
		}
	}
}
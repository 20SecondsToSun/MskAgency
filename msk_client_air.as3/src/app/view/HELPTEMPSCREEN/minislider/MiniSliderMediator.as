package app.view.HELPTEMPSCREEN.minislider 
{
	import app.contoller.events.AnimationEvent;
	import flash.display.Shape;
	import flash.display.Sprite;
	import org.robotlegs.mvcs.Mediator;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class MiniSliderMediator extends Mediator
	{
		[Inject]
		public var view:MiniSlider;
	
		
		override public function onRegister():void
		{
			view.init();
			
			addViewListener(AnimationEvent.STRETCH, dispatch, AnimationEvent);
			
		}
	}

}
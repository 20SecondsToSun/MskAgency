
package app.view.facts
{
	import app.contoller.events.ScreenshotEvent;
	import flash.events.Event;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FactAnimatorMediator extends Mediator
	{
		[Inject]
		public var view:FactAnimator;	
		
		override public function onRegister():void
		{			
			addViewListener(Event.REMOVED_FROM_STAGE, removeHandler, Event);			
		}
		
		private function removeHandler(e:Event):void 
		{		
			removeViewListener(Event.REMOVED_FROM_STAGE, removeHandler, Event);
			view.kill();
		}	
	}
}
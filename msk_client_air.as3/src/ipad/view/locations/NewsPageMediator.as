package ipad.view.locations
{
	import app.contoller.events.IpadEvent;
	import flash.events.Event;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class NewsPageMediator extends Mediator
	{
		[Inject]
		public var view:NewsPage;	
		
		override public function onRegister():void
		{
			addViewListener(Event.REMOVED_FROM_STAGE, removeHandler, Event);			
		}
		
		private function removeHandler(e:Event):void 
		{
			removeViewListener(Event.REMOVED_FROM_STAGE, removeHandler);			
			view.kill();
		}		
	}
}
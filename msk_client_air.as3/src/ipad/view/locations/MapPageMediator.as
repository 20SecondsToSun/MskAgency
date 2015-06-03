package ipad.view.locations
{	
	import flash.events.Event;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class MapPageMediator extends Mediator
	{
		[Inject]
		public var view:MapPage;
		
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
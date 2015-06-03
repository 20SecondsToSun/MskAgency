package ipad.view.locations.news
{
	import flash.events.MouseEvent;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class DateChooseMediator extends Mediator
	{
		[Inject]
		public var view:DateChoose;
		
		override public function onRegister():void
		{
			addViewListener(MouseEvent.MOUSE_DOWN, makeScrenshot, MouseEvent);	
		}
		
		private function makeScrenshot(e:MouseEvent):void 
		{
			view.touch(contextView, e);
		}
	}
}
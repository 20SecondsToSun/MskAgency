package app.view.page
{
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.FilterEvent;
	import app.model.dataall.IAllNewsModel;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class OneNewPageMediator extends PageMediator
	{
		[Inject]
		public var pageView:OneNewPage;
		
		[Inject]
		public var model:IAllNewsModel;
		
		override public function onRegister():void
		{
			activeView = pageView;
			activeModel = model;
			
			super.onRegister();
			addContextListener(FilterEvent.SET_NULL, gotoDays, FilterEvent);
			addViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
		}
		
		private function removeHandler(e:Event):void
		{
			removeViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
			removeContextListener(FilterEvent.SET_NULL, gotoDays, FilterEvent);
		}
		
		private function gotoDays(e:FilterEvent):void
		{
			dispatch(new ChangeLocationEvent(ChangeLocationEvent.NEWS_PAGE_DAY));
		}
		
		override protected function stretch(e:ChangeLocationEvent):void
		{
		
		}
	}
}
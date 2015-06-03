package app.view.page.fact
{
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.FilterEvent;
	import app.model.datafact.IFactsModel;
	import app.view.page.PageMediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class OneNewFactPageMediator extends PageMediator
	{
		[Inject]
		public var view:OneNewFactPage;
		
		[Inject]
		public var model:IFactsModel;
		
		override public function onRegister():void
		{
			activeView = view;
			activeModel = model;			
			super.onRegister();			
			addContextListener(FilterEvent.SET_NULL, gotoAllFacts, FilterEvent);	
		}
		
		private function gotoAllFacts(e:FilterEvent):void 
		{
			dispatch(new ChangeLocationEvent(ChangeLocationEvent.FACT_PAGE));
		}
	}
}
package app.view.page.days
{
	import app.contoller.events.ChangeLocationEvent;
	import app.model.daysnews.IDaysNewsModel;
	import app.view.page.PageMediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class DaysNewPageMediator extends PageMediator
	{
		[Inject]
		public var view:DaysNewPage;
		
		[Inject]
		public var model:IDaysNewsModel;
		
		
		override public function onRegister():void
		{
			activeView = view;
			activeModel = model;
			super.onRegister();			
		}
		
		override protected function stretchIN(e:ChangeLocationEvent):void
		{
			view.stretchIN();
		}
		
		override protected function backFromOneNew(e:ChangeLocationEvent):void
		{
			view.backFromOneNew();
		}
	}
}
package app.view.page.fact
{
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.model.dataall.IAllNewsModel;
	import app.model.datafilters.IFilterDataModel;
	import app.view.page.PageMediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FactPageMediator extends PageMediator
	{
		[Inject]
		public var view:FactPage;		
		[Inject]
		public var model:IAllNewsModel;
		
		[Inject]
		public var filterModel:IFilterDataModel;
		
		override public function onRegister():void
		{
			activeView = view;
			activeModel = model;
			super.onRegister();			
		}	
		
		override protected function backFromOneNew(e:ChangeLocationEvent):void 
		{			
			view.backFromOneNew();
		}
		
	
	}
}
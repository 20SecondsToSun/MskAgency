package app.view.page.day
{
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.FilterEvent;
	import app.model.dataall.IAllNewsModel;
	import app.model.datafilters.IFilterDataModel;
	import app.view.page.PageMediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class OneDayNewPageMediator extends PageMediator
	{
		[Inject]
		public var pageView:OneDayNewPage;
		
		[Inject]
		public var model:IAllNewsModel;
		
		[Inject]
		public var filters:IFilterDataModel;
		
		override public function onRegister():void
		{
			activeView = pageView;
			activeModel = model;
			super.onRegister();
			
			addContextListener(DataLoadServiceEvent.LOAD_COMPLETED_ALL_NEWS, refreshData, DataLoadServiceEvent, false, 0, true);
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_DAY_DATA));// , true, false, -1, null, null, filters.oneDayFilters));	
			
			addContextListener(FilterEvent.SET_NULL, gotoDays, FilterEvent);
			addContextListener(DataLoadServiceEvent.RELOAD_DATA, reloadData, DataLoadServiceEvent);
		}
		
		private function reloadData(e:DataLoadServiceEvent):void
		{
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_DAY_DATA));
		}
		
		private function gotoDays(e:FilterEvent):void
		{
			dispatch(new ChangeLocationEvent(ChangeLocationEvent.NEWS_PAGE_DAY));
		}
		
		override public function onRemove():void
		{
			removeContextListener(DataLoadServiceEvent.LOAD_COMPLETED_ALL_NEWS, refreshData, DataLoadServiceEvent);
		}
		
		private function refreshData(e:DataLoadServiceEvent):void
		{
			pageView.refreshData(model.allNewsHourListToday, model.photoNum, model.videoNum, model.allNum, model.broadcastNum);
			addViewListener(FilterEvent.SORT_ONE_DAY_NEWS, askToSort, FilterEvent, true);
			addViewListener(ChangeLocationEvent.NEWS_PAGE_DAY, dispatch, ChangeLocationEvent, true);
		}
		
		private function askToSort(e:FilterEvent):void
		{
			addContextListener(FilterEvent.ONE_DAY_NEWS_SORTED, refreshSortedData, FilterEvent);
			dispatch(e);
		}
		
		private function refreshSortedData(e:FilterEvent):void
		{
			removeContextListener(FilterEvent.ONE_DAY_NEWS_SORTED, refreshSortedData, FilterEvent);
			pageView.refreshSortedData(model.allNewsHourListToday, model.photoNum, model.videoNum, model.allNum);
		}
		
		override protected function stretch(e:ChangeLocationEvent):void
		{
			removeContextListener(ChangeLocationEvent.STRETCH_MODE, stretch, ChangeLocationEvent);
			pageView.stretch();
		}
		
		override protected function stretchIN(e:ChangeLocationEvent):void
		{
			pageView.stretchIN();
		}
		
		override protected function backFromOneNew(e:ChangeLocationEvent):void
		{
			pageView.backFromOneNew();
		}
		
		override protected function removeAllListeners(e:ChangeLocationEvent):void
		{
			super.removeAllListeners(e);
			removeContextListener(DataLoadServiceEvent.LOAD_COMPLETED_ALL_NEWS, refreshData, DataLoadServiceEvent);
			removeContextListener(DataLoadServiceEvent.RELOAD_DATA, reloadData, DataLoadServiceEvent);
		}
	}
}
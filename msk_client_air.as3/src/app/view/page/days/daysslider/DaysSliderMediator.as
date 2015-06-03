package app.view.page.days.daysslider
{
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.FilterEvent;
	import app.contoller.events.InteractiveEvent;
	import app.model.datafilters.FilterData;
	import app.model.datafilters.IFilterDataModel;
	import app.model.daysnews.IDaysNewsModel;
	import app.services.state.INavigationService;
	import app.view.baseview.slider.VerticalHorizontalSliderMediator;
	import app.view.page.days.onedayslider.DateButton;
	import app.view.utils.TextUtil;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class DaysSliderMediator extends VerticalHorizontalSliderMediator
	{
		[Inject]
		public var view:DaysSlider;
		
		[Inject]
		public var filters:IFilterDataModel;
		
		[Inject]
		public var model:IDaysNewsModel;
		
		[Inject]
		public var nav:INavigationService;
		
		override public function onRegister():void
		{
			_view = view;
			super.onRegister();
			
			addContextListener(DataLoadServiceEvent.LOAD_COMPLETED_DAYS_NEWS, refreshData, DataLoadServiceEvent);
			addContextListener(DataLoadServiceEvent.LOAD_COMPLETED_DAYS_NEWS_FILTERED, refreshFilterData, DataLoadServiceEvent);			
			addContextListener(FilterEvent.SET_NULL, reloadData, FilterEvent);
			
			model.offsetLoad = view.offset;
			model.limitLoad = view.limit;	
			
			filters.resetDates();
			filters.resetOffsetLimit();
			
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_DAYS_DATA));
			
			addViewListener(AnimationEvent.STRETCH, stretch, AnimationEvent, true);
			addViewListener(InteractiveEvent.HAND_OVER, over, InteractiveEvent, true);
			addViewListener(InteractiveEvent.HAND_OUT, out, InteractiveEvent, true);
			addViewListener(InteractiveEvent.HAND_PUSH, push, InteractiveEvent, true);
			
			addViewListener(DataLoadServiceEvent.LOAD_DAYS_DATA, startLoadNews, DataLoadServiceEvent);	
			addContextListener(DataLoadServiceEvent.RELOAD_DATA, reloadDataDisconnect, DataLoadServiceEvent);	
		}
		
		private function reloadDataDisconnect(e:DataLoadServiceEvent):void 
		{
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_DAYS_DATA));
		}
		
		private function reloadData(e:FilterEvent):void 
		{
			if (!view.isFiltered) return;
			
			view.reload();
			model.offsetLoad = view.offset;
			model.limitLoad = view.limit;				
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_DAYS_DATA));
		}		
		
		private function startLoadNews(e:DataLoadServiceEvent):void 
		{			
			model.offsetLoad = view.offset;
			model.limitLoad = view.limit;		
			dispatch(e);
		}
		
		private function refreshData(e:DataLoadServiceEvent):void 
		{			
			view.refreshData(model.allNewsDaysList);
		}
		
		private function refreshFilterData(e:DataLoadServiceEvent):void 
		{
			view.filterData(model.allNewsDaysBlockList, filters.daysNewsFilters.offset == filters.daysNewsFilters.limit);
		}
		
		
		private function push(e:InteractiveEvent):void
		{
			if (e.target is DateButton)
				(e.target as DateButton).push();
		}
		
		private function out(e:InteractiveEvent):void
		{
			if (e.target is DateButton)
				(e.target as DateButton).out();
		}
		
		private function over(e:InteractiveEvent):void
		{
			if (e.target is DateButton)
				(e.target as DateButton).over();
		}
		
		private function stretch(e:AnimationEvent):void
		{
			if (e.view is DateButton)
			{				
				var fd:FilterData = new FilterData();
				fd.from = TextUtil.convertDateToString((e.view as DateButton).date);
				fd.to = fd.from;
				fd.rubrics = filters.getFilter(nav.getCurrentLocation).rubrics;
				
				filters.oneDayFilters = new FilterData();
				filters.oneDayFilters = fd;
				
				var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.NEWS_PAGE_HOUR);
				event.mode = "STRETCH_IN";
				dispatch(event);
				
				
			}
		}
		
		override public function onRemove():void
		{
			removeContextListener(DataLoadServiceEvent.RELOAD_DATA, reloadDataDisconnect, DataLoadServiceEvent);	
			removeContextListener(DataLoadServiceEvent.LOAD_COMPLETED_DAYS_NEWS, refreshData, DataLoadServiceEvent);
			removeViewListener(AnimationEvent.STRETCH, stretch, AnimationEvent, true);
			removeViewListener(InteractiveEvent.HAND_OVER, over, InteractiveEvent, true);
			removeViewListener(InteractiveEvent.HAND_OUT, out, InteractiveEvent, true);
			removeViewListener(InteractiveEvent.HAND_PUSH, push, InteractiveEvent, true);			
			removeViewListener(DataLoadServiceEvent.LOAD_DAYS_DATA, startLoadNews, DataLoadServiceEvent);	
			
		}
	}

}


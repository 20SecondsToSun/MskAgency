package app.view.filters
{
	import air.update.net.FileDownloader;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.FilterEvent;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.ScreenshotEvent;
	import app.model.config.IConfig;
	import app.model.datafact.IFactsModel;
	import app.model.datafilters.FilterData;
	import app.model.datafilters.IFilterDataModel;
	import app.services.state.INavigationService;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FiltersViewMediator extends Mediator
	{
		[Inject]
		public var view:FiltersView;
		
		[Inject]
		public var model:IFilterDataModel;
		
		[Inject]
		public var nav:INavigationService;
		
		[Inject]
		public var conf:IConfig;
		
		[Inject]
		public var fmodel:IFactsModel;
		
		override public function onRegister():void
		{
			addContextListener(ChangeLocationEvent.FILTERS, showFilters, ChangeLocationEvent);
			addContextListener(ChangeLocationEvent.HIDE_FILTERS, hideFilters, ChangeLocationEvent);
			addViewListener(InteractiveEvent.HAND_PUSH, push, InteractiveEvent, true);
			addViewListener(InteractiveEvent.HAND_CHARGED, charged, InteractiveEvent, true);
			
			view.init(model.rubrics);
			addContextListener(DataLoadServiceEvent.LOAD_COMPLETED_FILTERS_DATA, updateView, DataLoadServiceEvent);
			
			addViewListener(InteractiveEvent.HAND_OVER, over, InteractiveEvent,true);
			addViewListener(InteractiveEvent.HAND_OUT, out, InteractiveEvent, true);
			
			
			addContextListener(FilterEvent.SET_NULL, nullFilters, FilterEvent);
			addContextListener(DataLoadServiceEvent.NO_MATERIALS, noMaterials, DataLoadServiceEvent);
		}
		
		private function noMaterials(e:DataLoadServiceEvent):void 
		{
			if (view.lastFilter == "rubric")
				view.activeRubric = view.lastActiveRubric;
			else if (view.lastFilter == "date")	
				view.centerBtn.date = view.centerBtn.lastDate;
			else return;
			
			var fd:FilterData = new FilterData();
			fd._rubrics = view.activeRubric;
			
			model.setFilter(nav.getCurrentLocation, fd);	
			
			dispatch(new FilterEvent(FilterEvent.DISELECT));	
			
			var data:Object = new Object();
				data.id = view.activeRubric;
			
			dispatch(new FilterEvent(FilterEvent.SELECT, false, false, data));				
		}
		
		private function hideFilters(e:ChangeLocationEvent):void 
		{
			view.hide();
			dispatch(new ChangeLocationEvent(ChangeLocationEvent.FILTERS_IS_HIDDEN));
		}
		
		private function nullFilters(e:FilterEvent):void 
		{	
			view.clearFilters();
			model.setNullToAll();
			dispatch(new FilterEvent(FilterEvent.DISELECT));
		}
		
		private function charged(e:InteractiveEvent):void 
		{
			if (e.target is CloseButton)
			{
				view.hide();
				dispatch(new ChangeLocationEvent(ChangeLocationEvent.FILTERS_IS_HIDDEN));
			}
			else if (e.target is RefreshButton)
			{
				view.clearFilters();
				dispatch(new FilterEvent(FilterEvent.DISELECT));	
				
				model.setNullToAll();
				dispatch(new FilterEvent(FilterEvent.SET_NULL));	
				
				view.hide();
				dispatch(new ChangeLocationEvent(ChangeLocationEvent.FILTERS_IS_HIDDEN));				
			}			
		}
		
		private function out(e:InteractiveEvent):void
		{	
			if (e.target is CenterButton)
			{				
				(e.target as CenterButton).out();
				view.circle.startRotate();
			}
			else if (e.target.name == "close")
			{
				(e.target.parent as DateChoose).out();
			}		
		}
		
		private function over(e:InteractiveEvent):void
		{				
			if (e.target is CenterButton)
			{				
				(e.target as CenterButton).over();
				view.circle.stopRotate();
				
			}			
			else if (e.target.name == "close")
			{
				(e.target.parent as DateChoose).over();
			}			
		}
		
		private function updateView(e:DataLoadServiceEvent):void
		{
			view.init(model.rubrics);
		}
		
		private function push(e:InteractiveEvent):void
		{	
			var fd:FilterData = new FilterData();
			var event:String;			
			
			if (e.target.name == "close")
			{	
				if (view.activeRubric != -1)
					fd.rubrics = view.activeRubric;
					
				view.centerBtn.lastDate = view.centerBtn.date;
				fd.from = view.dateChoose.getFilteredDate();
				fd.to = fd.from;				
				view.lastFilter = "date";
				
				event = model.setFilter(nav.getCurrentLocation, fd);
				
				view.hide();
				dispatch(new ChangeLocationEvent(ChangeLocationEvent.FILTERS_IS_HIDDEN));
				
				if (event == DataLoadServiceEvent.LOAD_ALL_FACTS_DATA)
				{
					dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.PREPARE_TO_CLEAR_FILTERED));
					fmodel.allInit();					
				}
				
				if (event == DataLoadServiceEvent.LOAD_ALL_FACTS_DATA && nav.getCurrentLocation == ChangeLocationEvent.ONE_NEW_FACT_PAGE)
				{
					//dispatch(new ChangeLocationEvent(ChangeLocationEvent.FACT_PAGE));
					dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.CHECK_FOR_FILTER_FACTS));	
					return;
				}
				
				if (event == DataLoadServiceEvent.LOAD_ALL_MATERIAL_NEAR_NEWS)	
				{
					dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.CHECK_FOR_FILTER_NEWS));								
				}
				else	
				{					
					dispatch(new DataLoadServiceEvent(event));
				}	
				
			}
			else if (e.target is CenterButton)
			{
				view.gotoDateChoose();
			}
			else if (e.target is FilterButton)
			{	
				var fButton:FilterButton = (e.target as FilterButton);				
				if (fButton.isSelect) return;
				
				dispatch(new FilterEvent(FilterEvent.DISELECT));				
				fButton.isSelect = true;
				
				fd.rubrics = fButton.id;	
				view.lastActiveRubric = view.activeRubric;
				view.lastFilter = "rubric";
				view.activeRubric = fButton.id;					
				
				if (view.centerBtn.date)
				{					
					fd.from = view.centerBtn.date;
					fd.to = fd.from;					
				}
				
				event = model.setFilter(nav.getCurrentLocation, fd);				
				view.hide();				
				dispatch(new ChangeLocationEvent(ChangeLocationEvent.FILTERS_IS_HIDDEN));				
				//dispatch(new DataLoadServiceEvent(event));
				if (event == DataLoadServiceEvent.LOAD_ALL_FACTS_DATA)
				{
					dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.PREPARE_TO_CLEAR_FILTERED));
					fmodel.allInit();
				}
				
				if (event == DataLoadServiceEvent.LOAD_ALL_FACTS_DATA && nav.getCurrentLocation == ChangeLocationEvent.ONE_NEW_FACT_PAGE)
				{
					dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.CHECK_FOR_FILTER_FACTS));
					return;
				}
				
				if (event == DataLoadServiceEvent.LOAD_ALL_MATERIAL_NEAR_NEWS)
				{
					dispatch(new ChangeLocationEvent(ChangeLocationEvent.NEWS_PAGE_DAY));
				}
				else
				{					
					dispatch(new DataLoadServiceEvent(event));
				}
			}
		}
		
		private function showFilters(e:ChangeLocationEvent):void
		{
			if (view.isOpen)
			{				
				view.hide();
				dispatch(new ChangeLocationEvent(ChangeLocationEvent.FILTERS_IS_HIDDEN));
				return;
			}
			
			addContextListener(ScreenshotEvent.TAKE_SCREENSHOT, screenshotCapture, ScreenshotEvent);
			dispatch(new ScreenshotEvent(ScreenshotEvent.MAKE_SCREENSHOT));
		}
		
		private function screenshotCapture(e:ScreenshotEvent):void
		{
			removeContextListener(ScreenshotEvent.TAKE_SCREENSHOT, screenshotCapture, ScreenshotEvent);
			
			var location:String = nav.getCurrentLocation;
			var fd:FilterData   = model.getFilter(location);
			view.dateToSet      = conf.currentDate;
			view.currentDate    = conf.currentDate;			
			view.show(e.shot, fd , location);
		}		
	}
}
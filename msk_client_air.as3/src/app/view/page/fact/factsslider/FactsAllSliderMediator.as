package app.view.page.fact.factsslider
{
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.FilterEvent;
	import app.contoller.events.InteractiveEvent;
	import app.model.dataall.IAllNewsModel;
	import app.model.datafact.IFactsModel;
	import app.model.datafilters.IFilterDataModel;
	import app.view.baseview.slider.VerticalHorizontalSliderMediator;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	
	public class FactsAllSliderMediator extends VerticalHorizontalSliderMediator
	{
		[Inject]
		public var view:FactsAllSlider;
		
		[Inject]
		public var fmodel:IFactsModel;
		
		[Inject]
		public var model:IAllNewsModel;
		
		override public function onRegister():void
		{
			fmodel.allInit();
			_view = view;
			super.onRegister();
			
			addViewListener(DataLoadServiceEvent.LOAD_ALL_FACTS_DATA, startLoadFacts, DataLoadServiceEvent);			
			addContextListener(DataLoadServiceEvent.NO_MORE, stopLoading, DataLoadServiceEvent);			
			addContextListener(DataLoadServiceEvent.LOAD_COMPLETED_FACTS, refreshData, DataLoadServiceEvent);
			addContextListener(DataLoadServiceEvent.PREPARE_TO_CLEAR_FILTERED, prepareToClear, DataLoadServiceEvent);			
			
			addViewListener(InteractiveEvent.HAND_PUSH, push, InteractiveEvent, true);
			addViewListener(InteractiveEvent.HAND_OVER, over, InteractiveEvent, true);
			addViewListener(InteractiveEvent.HAND_OUT,  out,  InteractiveEvent, true);
			
			addContextListener(DataLoadServiceEvent.RELOAD_DATA, reloadData, DataLoadServiceEvent);
			addContextListener(FilterEvent.SET_NULL, reloadDataF, FilterEvent);
			
			addViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
			
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_FACTS_DATA));			
		}
		
		private function removeHandler(e:Event):void 
		{
			removeViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
			removeViewListener(DataLoadServiceEvent.LOAD_ALL_FACTS_DATA, startLoadFacts, DataLoadServiceEvent);			
			removeContextListener(DataLoadServiceEvent.NO_MORE, stopLoading, DataLoadServiceEvent);			
			removeContextListener(DataLoadServiceEvent.LOAD_COMPLETED_FACTS, refreshData, DataLoadServiceEvent);
			removeContextListener(DataLoadServiceEvent.RELOAD_DATA, reloadData, DataLoadServiceEvent);		
			
			removeViewListener(InteractiveEvent.HAND_PUSH, push, InteractiveEvent, true);
			removeViewListener(InteractiveEvent.HAND_OVER, over, InteractiveEvent, true);
			removeViewListener(InteractiveEvent.HAND_OUT, out, InteractiveEvent, true);	
		}
		
		private function reloadDataF(e:FilterEvent):void 
		{
			fmodel.allInit();
			view.prepareToClear(null);
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_FACTS_DATA));
		}
		
		private function prepareToClear(e:DataLoadServiceEvent):void 
		{			
			view.prepareToClear(e);
		}
		
		private function reloadData(e:DataLoadServiceEvent):void 
		{
			fmodel.allInit();
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_FACTS_DATA));
		}
	
		
		private function stopLoading(e:DataLoadServiceEvent):void 
		{		
			view.stopLoading();
		}
		
		private function refreshData(e:DataLoadServiceEvent):void 
		{
			view.refreshData(fmodel.newsList, fmodel.dateInfo); 
		}	
		
		private function out(e:InteractiveEvent):void
		{
			if (e.target is OneFactPageGraphic)
				(e.target as OneFactPageGraphic).out();
		}
		
		private function over(e:InteractiveEvent):void
		{
			if (e.target is OneFactPageGraphic)
				(e.target as OneFactPageGraphic).over();
		}
		
		private function push(e:InteractiveEvent):void
		{
			if (e.target is OneFactPageGraphic)
			{
				var btn:OneFactPageGraphic = e.target as OneFactPageGraphic;
			
				fmodel.activeMaterial = btn.fact;
				fmodel.sliderDate = btn.currentDate;				
				model.setChoosenField({rec: btn.getSelfRec()});
				
				var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.ONE_NEW_FACT_PAGE);
				event.mode = "EXPAND_MODE";
				dispatch(event);				
			}
		}	
		
		private function startLoadFacts(e:DataLoadServiceEvent):void
		{
			fmodel.direction = view.dir;
			fmodel.offsetLoad = view.offset;
			fmodel.limitLoad = view.limit;	
			fmodel.isInitLoad = false;
			
			if (view.isChangedDirection)
			{				
				fmodel.setOffset();
				view.isChangedDirection = false;
			}
			
			dispatch(e);
		}	
	}
}
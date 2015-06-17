package app.view.facts
{
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.SliderEvent;
	import app.model.config.IConfig;
	import app.model.datafact.IFactsModel;
	import app.view.baseview.MainScreenMediator;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FactsMediator extends MainScreenMediator
	{
		[Inject]
		public var view:Facts;
		
		[Inject]
		public var model:IFactsModel;
		
		[Inject]
		public var iconfig:IConfig;	
		
		override public function onRegister():void
		{
			activeView = view;
			super.onRegister();
			
			addContextListener(DataLoadServiceEvent.LOAD_COMPLETED_MAIN_FACTS, refreshData, DataLoadServiceEvent, false, 0, true);
			addViewListener(DataLoadServiceEvent.LOAD_FACTS_DATA, dispatch, DataLoadServiceEvent);
			addViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
			addViewListener(AnimationEvent.FACTS_ANIMATION_FINISHED, dispatch, AnimationEvent);
			
			addContextListener(SliderEvent.VIDEO_SLIDER_START_DRAG, hideView, SliderEvent);
			addContextListener(SliderEvent.FACT_SLIDER_START_DRAG, view.showYellowLine, SliderEvent);
			addContextListener(SliderEvent.VIDEO_SLIDER_STOP_DRAG, showView, SliderEvent);
			addContextListener(SliderEvent.FACT_SLIDER_STOP_DRAG, view.hideYellowLine, SliderEvent);			
			addContextListener(DataLoadServiceEvent.RELOAD_DATA, reloadData, DataLoadServiceEvent);
		}
		
		private function reloadData(e:DataLoadServiceEvent):void
		{
			view.stopAutoAnimation();
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_FACTS_DATA));
		}
		
		private function removeHandler(e:Event):void
		{
			view.setScreenShot();
			
			removeViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
			
			super.removeAllHandlers();
			removeContextListener(DataLoadServiceEvent.LOAD_COMPLETED_FACTS, refreshData, DataLoadServiceEvent);
			
			removeContextListener(SliderEvent.VIDEO_SLIDER_START_DRAG, hideView, SliderEvent);
			removeContextListener(SliderEvent.FACT_SLIDER_START_DRAG, view.showYellowLine, SliderEvent);
			
			removeContextListener(SliderEvent.VIDEO_SLIDER_STOP_DRAG, showView, SliderEvent);
			removeContextListener(SliderEvent.FACT_SLIDER_STOP_DRAG, view.hideYellowLine, SliderEvent);
			
			removeViewListener(DataLoadServiceEvent.LOAD_FACTS_DATA, dispatch, DataLoadServiceEvent);
			
			removeContextListener(DataLoadServiceEvent.RELOAD_DATA, reloadData, DataLoadServiceEvent);
			
			view.kill();
		}
		
		private function refreshData(e:DataLoadServiceEvent):void
		{
			view.refreshData(model.mainNewsList, model.dateInfo, iconfig.currentScreen, model.notema);
		}
	}
}
package app.view.map
{
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.ServerUpdateEvent;
	import app.contoller.events.SliderEvent;
	import app.model.dataall.IAllNewsModel;
	import app.model.datageo.IGeoModel;
	import app.model.datauser.IUser;
	import app.view.baseview.MainScreenMediator;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class MapMediator extends MainScreenMediator
	{
		[Inject]
		public var view:Map;
		
		[Inject]
		public var model:IGeoModel;
		
		[Inject]
		public var allmodel:IAllNewsModel;		
		
		override public function onRegister():void
		{
			activeView = view;
			super.onRegister();
			
			addContextListener(DataLoadServiceEvent.LOAD_COMPLETED_GEO_NEWS, refreshData, DataLoadServiceEvent);
			addViewListener(AnimationEvent.MAP_ANIMATION_FINISHED, dispatch, AnimationEvent);
			addViewListener(DataLoadServiceEvent.LOAD_MAIN_GEO_DATA, dispatch, DataLoadServiceEvent);
			
			addContextListener(SliderEvent.VIDEO_SLIDER_START_DRAG, hideView, SliderEvent);
			addContextListener(SliderEvent.FACT_SLIDER_START_DRAG, hideView, SliderEvent);
			
			addContextListener(SliderEvent.VIDEO_SLIDER_STOP_DRAG, showView, SliderEvent);
			addContextListener(SliderEvent.FACT_SLIDER_STOP_DRAG, showView, SliderEvent);
			
			addContextListener(ServerUpdateEvent.GEO_NEWS, view.updater, ServerUpdateEvent);
			
			addViewListener(Event.REMOVED_FROM_STAGE, removeHandler, Event);
			
			addContextListener(DataLoadServiceEvent.RELOAD_DATA, reloadData, DataLoadServiceEvent);
		}
		
		private function reloadData(e:DataLoadServiceEvent):void 
		{
			view.stopAutoAnimation();
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_MAIN_GEO_DATA));
		}
		
		public function removeHandler(e:Event):void
		{
			view.kill();
			view.setScreenShot();
			
			super.removeAllHandlers();
			eventMap.unmapListeners();
			removeContextListener(SliderEvent.VIDEO_SLIDER_START_DRAG, hideView, SliderEvent);
			removeContextListener(SliderEvent.FACT_SLIDER_START_DRAG, hideView, SliderEvent);
			
			removeContextListener(SliderEvent.VIDEO_SLIDER_STOP_DRAG, showView, SliderEvent);
			removeContextListener(SliderEvent.FACT_SLIDER_STOP_DRAG, showView, SliderEvent);
			
			removeContextListener(DataLoadServiceEvent.LOAD_COMPLETED_GEO_NEWS, refreshData, DataLoadServiceEvent);
			removeViewListener(AnimationEvent.MAP_ANIMATION_FINISHED, dispatch, AnimationEvent);
			removeViewListener(DataLoadServiceEvent.LOAD_MAIN_GEO_DATA, dispatch, DataLoadServiceEvent);
			
			removeViewListener(Event.REMOVED_FROM_STAGE, removeHandler, Event);
			removeViewListener(DataLoadServiceEvent.RELOAD_DATA, reloadData, DataLoadServiceEvent);
		}
		
		private function gotoMap(e:InteractiveEvent):void
		{
			removeAllHandlers();
			model.activeMaterial = view.mat;
			allmodel.setChoosenField({rec: view.getMapRec()});
			
			var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.MAP_PAGE);
			event.mode = "EXPAND_MODE";
			dispatch(event);
		}
		
		private function gotoPage(e:InteractiveEvent):void
		{
			removeAllHandlers();
			allmodel.activeMaterial = view.mat;
			allmodel.setChoosenField({rec: view.getNewRec()});
			
			var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.ONE_NEW_PAGE);
			event.mode = "EXPAND_MODE";
			dispatch(event);
		}
		
		private function refreshData(e:DataLoadServiceEvent):void
		{
			view.addPoints(model.newsList);
			
			eventMap.mapListener(view.mapButton, InteractiveEvent.HAND_OVER, view.overMap, InteractiveEvent);
			eventMap.mapListener(view.mapButton, InteractiveEvent.HAND_OUT, view.outMap, InteractiveEvent);
			eventMap.mapListener(view.mapButton, InteractiveEvent.HAND_PUSH, gotoMap, InteractiveEvent);
			
			eventMap.mapListener(view.newsButton, InteractiveEvent.HAND_OVER, view.overNews, InteractiveEvent);
			eventMap.mapListener(view.newsButton, InteractiveEvent.HAND_OUT, view.outNews, InteractiveEvent);
			eventMap.mapListener(view.newsButton, InteractiveEvent.HAND_PUSH, gotoPage, InteractiveEvent);
		}	
	}
}
package app.view.mainnew
{
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.ServerUpdateEvent;
	import app.contoller.events.SliderEvent;
	import app.model.config.ScreenShots;
	import app.model.dataall.IAllNewsModel;
	import app.model.datauser.IUser;
	import app.model.mainnews.IMainNewsModel;
	import app.view.baseview.MainScreenMediator;
	import app.view.mainnew.types.MainType;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class MainNewsMediator extends MainScreenMediator
	{
		[Inject]
		public var view:MainNews;
		
		[Inject]
		public var model:IAllNewsModel;
		
		[Inject]
		public var mainmodel:IMainNewsModel;
		
		override public function onRegister():void
		{
			activeView = view;
			
			super.onRegister();
			
			addContextListener(DataLoadServiceEvent.LOAD_COMPLETED_MAIN_NEWS, refreshData, DataLoadServiceEvent);
			addViewListener(DataLoadServiceEvent.LOAD_MAIN_NEWS, dispatch, DataLoadServiceEvent);
			
			addViewListener(InteractiveEvent.HAND_OVER, view.overState, InteractiveEvent, true);
			addViewListener(InteractiveEvent.HAND_OUT, view.outState, InteractiveEvent, true);
			addViewListener(InteractiveEvent.HAND_PUSH, pushView, InteractiveEvent, true);
			
			addViewListener(AnimationEvent.MAIN_NEWS_ANIMATION_FINISHED, dispatch, AnimationEvent);
			
			addContextListener(SliderEvent.VIDEO_SLIDER_START_DRAG, hideView, SliderEvent);
			addContextListener(SliderEvent.FACT_SLIDER_START_DRAG, hideView, SliderEvent);
			
			addContextListener(SliderEvent.VIDEO_SLIDER_STOP_DRAG, showView, SliderEvent);
			addContextListener(SliderEvent.FACT_SLIDER_STOP_DRAG, showView, SliderEvent);
			
			addContextListener(ServerUpdateEvent.MAIN_NEWS, view.updater, ServerUpdateEvent);
			
			addViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
			
			addContextListener(DataLoadServiceEvent.RELOAD_DATA, reloadData, DataLoadServiceEvent);
		}
		
		private function reloadData(e:DataLoadServiceEvent):void
		{
			view.stopAutoAnimation();
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_MAIN_NEWS));
		}
		
		private function removeHandler(e:Event):void
		{
			removeViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
			super.removeAllHandlers();
			
			view.setScreenShot();
			view.kill();
			
			removeContextListener(DataLoadServiceEvent.LOAD_COMPLETED_MAIN_NEWS, refreshData, DataLoadServiceEvent);
			removeViewListener(DataLoadServiceEvent.LOAD_MAIN_NEWS, dispatch, DataLoadServiceEvent);
			
			removeViewListener(InteractiveEvent.HAND_OVER, view.overState, InteractiveEvent);
			removeViewListener(InteractiveEvent.HAND_OUT, view.outState, InteractiveEvent);
			removeViewListener(AnimationEvent.MAIN_NEWS_ANIMATION_FINISHED, dispatch, AnimationEvent);
			removeViewListener(DataLoadServiceEvent.LOAD_MAIN_NEWS, dispatch, DataLoadServiceEvent);
			
			removeContextListener(SliderEvent.VIDEO_SLIDER_START_DRAG, hideView, SliderEvent);
			removeContextListener(SliderEvent.FACT_SLIDER_START_DRAG, hideView, SliderEvent);
			
			removeContextListener(SliderEvent.VIDEO_SLIDER_STOP_DRAG, showView, SliderEvent);
			removeContextListener(SliderEvent.FACT_SLIDER_STOP_DRAG, showView, SliderEvent);
			
			removeContextListener(ServerUpdateEvent.MAIN_NEWS, view.updater, ServerUpdateEvent);
			removeContextListener(DataLoadServiceEvent.RELOAD_DATA, reloadData, DataLoadServiceEvent);
		}
		
		private function pushView(e:InteractiveEvent):void
		{
			if (e.target)
			{
				var material:MainType = e.target as MainType;
				model.activeMaterial = material.mat;
				model.setChoosenField({rec: material.getSelfRec(), color: material.color});
				
				var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.ONE_NEW_PAGE);
				event.mode = "EXPAND_MODE";
				
				dispatch(event);
			}
		}
		
		private function refreshData(e:DataLoadServiceEvent):void
		{
			view.refreshData(mainmodel.newsList);
		}
	}
}
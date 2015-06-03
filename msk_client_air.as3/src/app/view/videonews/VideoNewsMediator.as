package app.view.videonews
{
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.ServerUpdateEvent;
	import app.contoller.events.SliderEvent;
	import app.model.datauser.IUser;
	import app.model.datavideo.IVideoNewsModel;
	import app.view.baseview.MainScreenMediator;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class VideoNewsMediator extends MainScreenMediator
	{
		[Inject]
		public var view:VideoNews;
		
		[Inject]
		public var model:IVideoNewsModel;
		
		override public function onRegister():void
		{
			activeView = view;
			super.onRegister();			
			
			addContextListener(DataLoadServiceEvent.LOAD_COMPLETED_VIDEOS_NEWS, refreshData, DataLoadServiceEvent);
			addViewListener(DataLoadServiceEvent.LOAD_VIDEO_DATA, dispatch, DataLoadServiceEvent);
			
			addContextListener(SliderEvent.VIDEO_SLIDER_START_DRAG, view.showYellowLine, SliderEvent);
			addContextListener(SliderEvent.VIDEO_SLIDER_STOP_DRAG, view.hideYellowLine, SliderEvent);
			
			addContextListener(SliderEvent.FACT_SLIDER_START_DRAG, hideView, SliderEvent);
			addContextListener(SliderEvent.FACT_SLIDER_STOP_DRAG, showView, SliderEvent);
			
			addViewListener(AnimationEvent.VIDEO_NEWS_ANIMATION_FINISHED, dispatch, AnimationEvent);
			addContextListener(ServerUpdateEvent.VIDEO_NEWS, view.updater, ServerUpdateEvent);
			
			addViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
			
			addContextListener(DataLoadServiceEvent.RELOAD_DATA, reloadData, DataLoadServiceEvent);
		}
		
		private function reloadData(e:DataLoadServiceEvent):void
		{
			view.stopAutoAnimation();
			view.setScreenShot();
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_VIDEO_DATA));
		}
		
		private function removeHandler(e:Event):void
		{
			removeContextListener(DataLoadServiceEvent.LOAD_COMPLETED_VIDEOS_NEWS, refreshData, DataLoadServiceEvent);
			removeContextListener(SliderEvent.VIDEO_SLIDER_START_DRAG, view.showYellowLine, SliderEvent);
			removeContextListener(SliderEvent.VIDEO_SLIDER_STOP_DRAG, view.hideYellowLine, SliderEvent);
			removeContextListener(SliderEvent.FACT_SLIDER_START_DRAG, hideView, SliderEvent);
			removeContextListener(SliderEvent.FACT_SLIDER_STOP_DRAG, showView, SliderEvent);
			removeViewListener(DataLoadServiceEvent.LOAD_VIDEO_DATA, dispatch, DataLoadServiceEvent);
			removeContextListener(ServerUpdateEvent.VIDEO_NEWS, view.updater, ServerUpdateEvent);
			removeContextListener(DataLoadServiceEvent.RELOAD_DATA, reloadData, DataLoadServiceEvent);
			
			view.kill();
			view.setScreenShot();
		}
		
		private function refreshDataWithoutPreview(e:DataLoadServiceEvent):void
		{
			view.refreshData(model.data);
		}
		
		private function refreshData(e:DataLoadServiceEvent):void
		{
			view.refreshData(model.newsList);
		}
	}
}
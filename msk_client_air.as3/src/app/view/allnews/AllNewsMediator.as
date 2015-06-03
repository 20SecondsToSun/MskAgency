package app.view.allnews
{
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.ChangeModelOut;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.ServerUpdateEvent;
	import app.model.dataall.IAllNewsModel;
	import app.model.datauser.IUser;
	import app.view.baseview.MainScreenMediator;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class AllNewsMediator extends MainScreenMediator
	{
		[Inject]
		public var view:AllNews;
		
		[Inject]
		public var model:IAllNewsModel;
		
			
		override public function onRegister():void
		{
			activeView = view;
			super.onRegister();
			
			addContextListener(DataLoadServiceEvent.LOAD_COMPLETED_ALL_NEWS, refreshData, DataLoadServiceEvent, false, 0, true);
			addViewListener(DataLoadServiceEvent.LOAD_ALL_DATA, dispatch, DataLoadServiceEvent);			
			addViewListener(AnimationEvent.ALL_NEWS_ANIMATION_FINISHED, allANimationFinish, AnimationEvent, false, 0, true);
			addContextListener(AnimationEvent.STRETCH, stretchPercent, AnimationEvent);			
			addViewListener(ChangeLocationEvent.NEWS_PAGE_HOUR, dispatchToAllNewsDay, ChangeLocationEvent);				
			addViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
			
			addContextListener(ServerUpdateEvent.ALL_NEWS, updater, ServerUpdateEvent);
			addContextListener(DataLoadServiceEvent.RELOAD_DATA, reloadData, DataLoadServiceEvent);
		}
		
		private function reloadData(e:DataLoadServiceEvent):void 
		{
			//trace("RELOAD DAT!!!!!!!!!!!!!!!!");
			view.stopAutoAnimation();
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_DATA));
		}
		
		private function updater(e:ServerUpdateEvent):void 
		{
			view.updater(model.allNewsHourListFilter);
		}
		
		private function removeHandler(e:Event):void 
		{
			view.setScreenShot();
			
			removeViewListener(Event.REMOVED_FROM_STAGE, removeHandler);			
			removeContextListener(DataLoadServiceEvent.LOAD_COMPLETED_ALL_NEWS, refreshData, DataLoadServiceEvent);
			removeViewListener(DataLoadServiceEvent.LOAD_ALL_DATA, dispatch, DataLoadServiceEvent);				
			removeViewListener(AnimationEvent.ALL_NEWS_ANIMATION_FINISHED, allANimationFinish, AnimationEvent);
			removeContextListener(AnimationEvent.STRETCH, stretchPercent, AnimationEvent);			
			removeViewListener(ChangeLocationEvent.NEWS_PAGE_HOUR, dispatchToAllNewsDay, ChangeLocationEvent);
			
			removeViewListener(InteractiveEvent.HAND_OVER, view.handOver,	InteractiveEvent);
			removeViewListener(InteractiveEvent.HAND_OUT, view.handOut,	InteractiveEvent);	
			removeViewListener(InteractiveEvent.STRETCH, stretch,	InteractiveEvent);	
			removeViewListener(InteractiveEvent.STRETCH_OFF, stretchOff,	InteractiveEvent);	
			removeContextListener(AnimationEvent.STRETCH, stretchPercent, AnimationEvent);
			removeContextListener(ServerUpdateEvent.ALL_NEWS, updater, ServerUpdateEvent);	
			removeContextListener(DataLoadServiceEvent.RELOAD_DATA, reloadData, DataLoadServiceEvent);
			
			view.kill();
		}
		
		private function refreshData(e:DataLoadServiceEvent):void
		{
			trace("REFRESH ALL DATA");
			setData();
		}
		
		private function setData():void
		{
			dispatch(new ChangeModelOut(ChangeModelOut.MAIN_SCREEN));				
			view.refreshData(model.allNewsHourListFilter);
			
			addViewListener(InteractiveEvent.HAND_OVER, view.handOver,	InteractiveEvent);
			addViewListener(InteractiveEvent.HAND_OUT, view.handOut,	InteractiveEvent);	
			addViewListener(InteractiveEvent.STRETCH, stretch,	InteractiveEvent);	
			addViewListener(InteractiveEvent.STRETCH_OFF, stretchOff,	InteractiveEvent);	
		}
		
		private function stretchOff(e:InteractiveEvent):void 
		{
			addViewListener(InteractiveEvent.HAND_OVER, view.handOver,	InteractiveEvent);
			addViewListener(InteractiveEvent.HAND_OUT, view.handOut,	InteractiveEvent);	
			view.stretch(0);
		}
		
		private function stretch(e:InteractiveEvent):void 
		{
			removeViewListener(InteractiveEvent.HAND_OVER, view.handOver,	InteractiveEvent);
			removeViewListener(InteractiveEvent.HAND_OUT, view.handOut,	InteractiveEvent);	
			view.stretch(e.percent);			
		}
		
		private function allANimationFinish(e:AnimationEvent):void 
		{
			dispatch(e.clone());		
		}		
		private function dispatchToAllNewsDay(e:ChangeLocationEvent):void
		{				
			var evt:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.NEWS_PAGE_HOUR);
			evt.mode = "STRETCH_MODE";
			dispatch(evt);
		}	
		
		private function stretchPercent(e:AnimationEvent):void
		{
			view.stretch(e.percent);
		}	
	}
}
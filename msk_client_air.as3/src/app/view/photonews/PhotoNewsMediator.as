package app.view.photonews
{
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.ServerUpdateEvent;
	import app.model.dataphoto.IPhotoNewsModel;
	import app.model.datauser.IUser;
	import app.view.baseview.MainScreenMediator; 
	import flash.events.Event;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class PhotoNewsMediator extends MainScreenMediator
	{
		[Inject]
		public var view:PhotoNews;
		
		[Inject]
		public var model:IPhotoNewsModel;		
		
		override public function onRegister():void
		{
			activeView = view;			
			super.onRegister();			
			
			addContextListener(DataLoadServiceEvent.LOAD_COMPLETED_PHOTO_NEWS, refreshData, DataLoadServiceEvent);
			addContextListener(DataLoadServiceEvent.RELOAD_DATA, reloadData, DataLoadServiceEvent);
			addViewListener(AnimationEvent.PHOTO_NEWS_ANIMATION_FINISHED, dispatch, AnimationEvent);
			addViewListener(DataLoadServiceEvent.LOAD_PHOTO_DATA, dispatch, DataLoadServiceEvent);	
			addViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
			addContextListener(ServerUpdateEvent.PHOTO_NEWS, view.updater, ServerUpdateEvent);					
		}	
		
		private function reloadData(e:DataLoadServiceEvent):void 
		{
			view.stopAutoAnimation();
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_PHOTO_DATA));
		}
		
		private function removeHandler(e:Event):void 
		{
			view.setScreenShot();
			
			removeViewListener(Event.REMOVED_FROM_STAGE, removeHandler);			
			removeContextListener(DataLoadServiceEvent.LOAD_COMPLETED_PHOTO_NEWS, refreshData, DataLoadServiceEvent);
			removeContextListener(DataLoadServiceEvent.RELOAD_DATA, reloadData, DataLoadServiceEvent);
			removeContextListener(DataLoadServiceEvent.LOAD_PHOTO_DATA, dispatch, DataLoadServiceEvent);	
			removeViewListener(AnimationEvent.PHOTO_NEWS_ANIMATION_FINISHED, dispatch, AnimationEvent);
			view.kill();
		}
	
		private function refreshData(e:DataLoadServiceEvent):void
		{			
			view.refreshData(model.newsList);
		}
	}
}
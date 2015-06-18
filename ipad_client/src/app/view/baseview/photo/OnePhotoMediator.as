package app.view.baseview.photo
{
	import app.contoller.events.LoadPhotoEvent;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class OnePhotoMediator extends Mediator
	{
		[Inject]
		public var view:OnePhoto;
		
		override public function onRegister():void
		{			
			addViewListener(LoadPhotoEvent.PHOTO_LOADED, setPhoto, LoadPhotoEvent);		
			addViewListener(LoadPhotoEvent.LOAD_PHOTO, dispatch, LoadPhotoEvent);
			view.loadAtOnce();
		}		
		private function setPhoto(e:LoadPhotoEvent):void 
		{
			view.setPhoto(e.photo);
		}
		override public function onRemove():void
		{
			removeViewListener(LoadPhotoEvent.PHOTO_LOADED, setPhoto, LoadPhotoEvent);		
			removeViewListener(LoadPhotoEvent.LOAD_PHOTO, dispatch, LoadPhotoEvent);
			view.kill();
		}
	}
}


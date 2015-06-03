package app.view.photonews
{
	import app.contoller.events.LoadPhotoEvent;
	import app.view.baseview.slider.SliderMediator;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class PhotoSliderMediator extends SliderMediator
	{
		[Inject]
		public var view:PhotoSlider;
		
		override public function onRegister():void
		{
			_view = view;
			super.onRegister();
			addViewListener(LoadPhotoEvent.COMPLETED, changeListener, LoadPhotoEvent);
			addViewListener(LoadPhotoEvent.PHOTO_LOADED, loadNext, LoadPhotoEvent, true);
			
			addViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
		}
		
		private function changeListener(e:LoadPhotoEvent):void 
		{
			removeViewListener(LoadPhotoEvent.PHOTO_LOADED, loadNext, LoadPhotoEvent, true);
			addViewListener(LoadPhotoEvent.PHOTO_LOADED, loadNextOne, LoadPhotoEvent, true);
		}
		
		private function loadNextOne(e:LoadPhotoEvent):void 
		{
			view.loadNextOne(e.photo);
		}
		
		private function removeHandler(e:Event):void
		{
			removeViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
			removeViewListener(LoadPhotoEvent.PHOTO_LOADED, loadNext, LoadPhotoEvent);
		}
		
		private function loadNext(e:LoadPhotoEvent):void
		{
			view.loadNext(e.photo);
		}
	}
}
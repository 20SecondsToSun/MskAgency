package app.view.page.oneNews.Body
{
	import app.contoller.events.LoadPhotoEvent;
	import app.view.baseview.slider.SliderMediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class PreviewSliderMediator extends SliderMediator
	{
		[Inject]
		public var galleryView:PreviewSlider;
		
		override public function onRegister():void
		{	
			_view = galleryView;
			super.onRegister();
			
			addViewListener(LoadPhotoEvent.PHOTO_LOADED, loadNext, LoadPhotoEvent,true);				
		}
		
		private function loadNext(e:LoadPhotoEvent):void 
		{		
			galleryView.loadNext();
		}
		override public function onRemove():void
		{				
			removeViewListener(LoadPhotoEvent.PHOTO_LOADED, loadNext, LoadPhotoEvent);				
		}	
	}
}


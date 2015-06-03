package app.view.page.oneNews.Body
{
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.GraphicInterfaceEvent;
	import app.contoller.events.LoadPhotoEvent;
	import app.view.baseview.slider.SliderMediator;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class GallerySliderMediator extends SliderMediator
	{
		[Inject]
		public var galleryView:GallerySlider;
		
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


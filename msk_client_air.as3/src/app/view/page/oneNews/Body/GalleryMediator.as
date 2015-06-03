package app.view.page.oneNews.Body
{
	import app.contoller.events.GraphicInterfaceEvent;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class GalleryMediator extends Mediator
	{
		[Inject]
		public var view:Gallery;
		
		override public function onRegister():void
		{			
			addContextListener(GraphicInterfaceEvent.FOCUS_ON_PHOTO, focusOnPhoto, GraphicInterfaceEvent);
			addViewListener(GraphicInterfaceEvent.CLOSE_PREVIEW_PHOTO, closePreviewPhoto, GraphicInterfaceEvent, true, 0, true);	
	
		}
		override public function onRemove():void
		{			
			removeContextListener(GraphicInterfaceEvent.FOCUS_ON_PHOTO, focusOnPhoto, GraphicInterfaceEvent);
			removeViewListener(GraphicInterfaceEvent.CLOSE_PREVIEW_PHOTO, closePreviewPhoto, GraphicInterfaceEvent);		
		}
		
		private function closePreviewPhoto(e:GraphicInterfaceEvent):void 
		{			
			view.closePeview();
		}
		
		private function focusOnPhoto(e:GraphicInterfaceEvent):void 
		{			
			view.focusOnPhoto(e.data);
		}	
	}

}


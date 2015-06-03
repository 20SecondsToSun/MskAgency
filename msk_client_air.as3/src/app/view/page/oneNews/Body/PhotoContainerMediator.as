package app.view.page.oneNews.Body 
{
	import app.contoller.events.InteractiveEvent;
	import org.robotlegs.mvcs.Mediator;
	/**
	 * ...
	 * @author metalcorehero
	 */

	public class PhotoContainerMediator extends Mediator
	{
		[Inject]
		public var view:PhotoContainer;		
		
		override public function onRegister():void
		{			
			eventMap.mapListener(view.photoBtn,InteractiveEvent.HAND_OVER, overView,	InteractiveEvent);
			eventMap.mapListener(view.photoBtn,InteractiveEvent.HAND_OUT, outView,	InteractiveEvent);
			eventMap.mapListener(view.photoBtn,InteractiveEvent.HAND_PUSH, pushView,	InteractiveEvent);	
		}
		
		override public function preRemove():void
		{
			eventMap.unmapListener(view.photoBtn,InteractiveEvent.HAND_OVER, overView,	InteractiveEvent);
			eventMap.unmapListener(view.photoBtn,InteractiveEvent.HAND_OUT, outView,	InteractiveEvent);
			eventMap.unmapListener(view.photoBtn,InteractiveEvent.HAND_PUSH, pushView,	InteractiveEvent);	
		}
		
		private function pushView(e:InteractiveEvent):void 
		{
			view.openPhotoBtn();			
		}	
		
		private function outView(e:InteractiveEvent):void 
		{			
			view.photoBtn.out();
		}
		
		private function overView(e:InteractiveEvent):void 
		{			
			view.photoBtn.over();
		}	
	}
}
package app.view.page.oneNews.Body 
{
	import app.contoller.events.GraphicInterfaceEvent;
	import app.contoller.events.InteractiveEvent;
	import org.robotlegs.mvcs.Mediator;
	/**
	 * ...
	 * @author metalcorehero
	 */

	public class OnePhotoPreviewMediator extends Mediator
	{
		[Inject]
		public var view:OnePhotoPreview;		
		
		override public function onRegister():void
		{	
			addViewListener(InteractiveEvent.HAND_OVER, overView,	InteractiveEvent);
			addViewListener(InteractiveEvent.HAND_OUT, outView,		InteractiveEvent);
			addViewListener(InteractiveEvent.HAND_PUSH, pushView,	InteractiveEvent);
		}	
		
		private function pushView(e:InteractiveEvent):void 
		{
			var evt:GraphicInterfaceEvent = new GraphicInterfaceEvent(GraphicInterfaceEvent.FOCUS_ON_PHOTO);
				evt.data = view.id;
			dispatch( evt);			
		}	
		
		private function outView(e:InteractiveEvent):void 
		{			
			view.outState();
		}
		
		private function overView(e:InteractiveEvent):void 
		{		
			view.overState();
		}	
		override public function onRemove():void
		{	
			removeViewListener(InteractiveEvent.HAND_OVER, overView,	InteractiveEvent);
			removeViewListener(InteractiveEvent.HAND_OUT, outView,	InteractiveEvent);
			removeViewListener(InteractiveEvent.HAND_PUSH, pushView,	InteractiveEvent);
			
			view.kill();
			
			// remove all request
		}
	}
	

}
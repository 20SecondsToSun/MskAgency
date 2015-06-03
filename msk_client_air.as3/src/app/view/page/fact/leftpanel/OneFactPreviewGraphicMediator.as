package app.view.page.fact.leftpanel 
{
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.InteractiveEvent;
	import app.model.datafact.IFactsModel;
	import org.robotlegs.mvcs.Mediator;
	/**
	 * ...
	 * @author metalcorehero
	 */

	public class OneFactPreviewGraphicMediator extends Mediator
	{
		[Inject]
		public var view:OneFactPreviewGraphic;
		
		[Inject]
		public var model:IFactsModel;
		
		override public function onRegister():void
		{			
			addViewListener(InteractiveEvent.HAND_OVER, overView,	InteractiveEvent);
			addViewListener(InteractiveEvent.HAND_OUT, outView,	InteractiveEvent);			
			addViewListener(InteractiveEvent.HAND_PUSH, pushView, InteractiveEvent);
			
			addContextListener(ChangeLocationEvent.SHOW_NEW_BY_ID, setActive, ChangeLocationEvent);		
		}		
		override public function preRemove():void
		{			
			removeViewListener(InteractiveEvent.HAND_OVER, overView,	InteractiveEvent);
			removeViewListener(InteractiveEvent.HAND_OUT, outView,	InteractiveEvent);			
			removeViewListener(InteractiveEvent.HAND_PUSH, pushView,	InteractiveEvent);					
			removeContextListener(ChangeLocationEvent.SHOW_NEW_BY_ID, setActive, ChangeLocationEvent);		
		}		
		
		private function setActive(e:ChangeLocationEvent):void 
		{
			view.setActive(e.obj.id);
		}
		
		private function pushView(e:InteractiveEvent):void 
		{
			if (view.isActive) return; 
			
			var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.SHOW_NEW_BY_ID);
			event.obj = view.fact;				
			dispatch(event);
		}	
		
		private function outView(e:InteractiveEvent):void 
		{			
			view.out();
		}
		
		private function overView(e:InteractiveEvent):void 
		{			
			view.over();
		}	
	}
	

}
package app.view.allnews
{	
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.InteractiveEvent;
	import app.model.dataall.IAllNewsModel;
	import flash.events.Event;
	import org.robotlegs.mvcs.Mediator;	

	public class OneHourGraphicMediator extends Mediator
	{
		[Inject]
		public var view:OneHourGraphic;
		
		[Inject]
		public var model:IAllNewsModel;
		
		override public function onRegister():void
		{
			addViewListener(InteractiveEvent.HAND_OVER, view.overState, InteractiveEvent);
			addViewListener(InteractiveEvent.HAND_OUT, view.outState, InteractiveEvent);
			addViewListener(InteractiveEvent.HAND_PUSH, pushView, InteractiveEvent);			
			addViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
		}
		
		private function removeHandler(e:Event):void 
		{
			removeViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
			removeViewListener(InteractiveEvent.HAND_OVER, view.overState, InteractiveEvent);
			removeViewListener(InteractiveEvent.HAND_OUT, view.outState, InteractiveEvent);
			removeViewListener(InteractiveEvent.HAND_PUSH, pushView, InteractiveEvent);				
			view.kill();			
		}		
		
		private function pushView(e:InteractiveEvent):void
		{
			model.activeMaterial = view.oneNewData;			
			model.setChoosenField({rec: view.getSelfRec()});
			
			var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.ONE_NEW_PAGE);
			event.mode = "EXPAND_MODE";
			dispatch(event);
		}	
	}
}
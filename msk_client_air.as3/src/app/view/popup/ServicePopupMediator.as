package app.view.popup
{	
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.IpadEvent;
	import app.contoller.events.ServerErrorEvent;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class ServicePopupMediator extends Mediator
	{
		[Inject]
		public var view: ServicePopup;
		
		override public function onRegister():void
		{	
			addContextListener(DataLoadServiceEvent.NO_MATERIALS, 			view.showNoMat, DataLoadServiceEvent);
			addContextListener(ServerErrorEvent.REQUEST_COMPLETE, 			view.hideError, ServerErrorEvent);
			addContextListener(ServerErrorEvent.AUTH_FAILED, 				view.showServerError, ServerErrorEvent);			
			addContextListener(DataLoadServiceEvent.SHOW_CONNECTION_SHAPES, view.showShapes, DataLoadServiceEvent);
			addContextListener(DataLoadServiceEvent.CHECK_MATCH, view.checkMatch, DataLoadServiceEvent);
			
			addViewListener(IpadEvent.SEND_SHAPES, dispatch, IpadEvent);
			addViewListener(IpadEvent.SYMBOLS_IS_OK, dispatch, IpadEvent);	
			addViewListener(IpadEvent.SYMBOLS_BAD, dispatch, IpadEvent);
			
			addViewListener(InteractiveEvent.HAND_PUSH, push, InteractiveEvent, true);
			
			addViewListener(InteractiveEvent.HAND_OVER, over, InteractiveEvent, true);
			addViewListener(InteractiveEvent.HAND_OUT, out, InteractiveEvent, true);				
		}	
		
		private function out(e:InteractiveEvent):void 
		{
			if (e.target.name != "btnNo" && e.target.name != "btnOk") return;			
			e.target.out();
		}
		
		private function over(e:InteractiveEvent):void 
		{
			if (e.target.name != "btnNo" && e.target.name != "btnOk") return;
			e.target.over();
		}
		
		private function push(e:InteractiveEvent):void 
		{			
			if (e.target.name == "btnNo")
			{
				dispatch(new IpadEvent(IpadEvent.SYMBOLS_BAD));
				view.isOpen = false;
				
			}
			else if (e.target.name == "btnOk")
			{
				dispatch(new IpadEvent(IpadEvent.SYMBOLS_IS_OK));	
				view.isOpen = false;
			}
			view.finishSymbols();
		}	
	}
}
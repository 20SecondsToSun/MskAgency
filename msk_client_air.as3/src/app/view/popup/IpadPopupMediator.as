package app.view.popup
{	
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.IpadEvent;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class IpadPopupMediator extends Mediator
	{
		[Inject]
		public var view: IpadPopup;
		
		override public function onRegister():void
		{	
			addContextListener(IpadEvent.SHOW_MATERIAL, view.show, IpadEvent);	
			addContextListener(ChangeLocationEvent.HIDE_IPAD_POPUP, view.hide, ChangeLocationEvent);
			addViewListener(InteractiveEvent.HAND_CHARGED, charged, InteractiveEvent, true);							
			addViewListener(ChangeLocationEvent.IPAD_POPUP_IS_HIDDEN, dispatch, ChangeLocationEvent);			
		}	
		
		private function charged(e:InteractiveEvent):void 
		{
			if (e.target is CloseButton)			
				view.hide();					
		}	
	}
}
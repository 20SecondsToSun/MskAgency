package app.view.menu
{	
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.InteractiveServiceEvent;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class MenuButtonMediator extends Mediator
	{
		[Inject]
		public var view:MenuButton;
			
		override public function onRegister():void
		{		
			addViewListener(InteractiveEvent.HAND_OVER, overBtn,	InteractiveEvent);
			addViewListener(InteractiveEvent.HAND_OUT,  outBtn,	InteractiveEvent);
			addViewListener(InteractiveEvent.HAND_PUSH,  handPush,	InteractiveEvent);			
		
			addViewListener(AnimationEvent.DEACTIVATE, deactiveteListeners, AnimationEvent);
			addContextListener(AnimationEvent.DEACTIVATE, deactiveteView, AnimationEvent);
			addViewListener(AnimationEvent.ACTIVATE, activateListeners, AnimationEvent);			
		}		
		
		private function deactiveteView(e:AnimationEvent):void 
		{
			view.deactive();
		}
		
		private function activateListeners(e:AnimationEvent):void 
		{
			addViewListener(InteractiveEvent.HAND_OVER, overBtn,	InteractiveEvent);
			addViewListener(InteractiveEvent.HAND_OUT,  outBtn,	InteractiveEvent);
			addViewListener(InteractiveEvent.HAND_PUSH,  handPush,	InteractiveEvent);			
		}
		
		private function handPush(e:InteractiveEvent):void 
		{
			dispatch(new AnimationEvent(AnimationEvent.DEACTIVATE));
			view.active();
			dispatch(new AnimationEvent(AnimationEvent.HIDE_MENU_AND_GO));			
		}
		
		private function deactiveteListeners(e:AnimationEvent):void 
		{
			removeViewListener(InteractiveEvent.HAND_OVER, overBtn,	InteractiveEvent);
			removeViewListener(InteractiveEvent.HAND_OUT,  outBtn,	InteractiveEvent);
			removeViewListener(InteractiveEvent.HAND_PUSH,  handPush,	InteractiveEvent);					
		}
		
		private function pushBtn(e:InteractiveEvent):void 
		{
			
		}
		
		private function outBtn(e:InteractiveEvent):void 
		{
			
			view.outState();
		}
		
		private function overBtn(e:InteractiveEvent):void 
		{				
			view.overState();
		}	
	}
}
package app.view.page.day.leftpanelhour
{
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.InteractiveEvent;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class LeftPanelMediator extends Mediator
	{
		[Inject]
		public var view:LeftPanel;	
		
		override public function onRegister():void
		{			
			addViewListener(InteractiveEvent.HAND_OVER, overPanel,	InteractiveEvent,true);
			addViewListener(InteractiveEvent.HAND_OUT, outPanel,	InteractiveEvent,true);
			addViewListener(InteractiveEvent.HAND_CHARGED, view.pushPanelBtn,	InteractiveEvent,true);
			addViewListener(AnimationEvent.LEFT_PANEL_OVER, dispatch,	AnimationEvent);			
		}		
		
		override public function onRemove():void
		{
			removeViewListener(InteractiveEvent.HAND_CHARGED, view.pushPanelBtn,	InteractiveEvent,true);
			removeViewListener(InteractiveEvent.HAND_OVER, overPanel,	InteractiveEvent,true);
			removeViewListener(InteractiveEvent.HAND_OUT, outPanel,	InteractiveEvent,true);
			removeViewListener(AnimationEvent.LEFT_PANEL_OVER, dispatch,	AnimationEvent);
		}	
		
		private function outPanel(e:InteractiveEvent):void 
		{
			dispatch(new AnimationEvent(AnimationEvent.LEFT_PANEL_OUT));
			view.outState();
		}
		
		private function overPanel(e:InteractiveEvent):void 
		{				
			view.overState();
		}	
	}
}
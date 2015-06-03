package app.view.mainscreen 
{
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.ChangeLocationEvent;
	import app.model.config.ScreenShots;
	import org.robotlegs.mvcs.Mediator;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class BaseMediator extends Mediator
	{	
		[Inject]
		public var config:ScreenShots;
		public var activeView:*;
		
		override public function onRegister():void
		{		
			addContextListener(ChangeLocationEvent.GO_TO_STORY_SCREEN_MAIN_WAY,  hideView, ChangeLocationEvent);
			addContextListener(ChangeLocationEvent.GO_TO_MAIN_SCREEN_MAIN_WAY,   hideView, ChangeLocationEvent);
			addContextListener(ChangeLocationEvent.GO_TO_CUSTOM_SCREEN_MAIN_WAY, hideView, ChangeLocationEvent);			
			
			addContextListener(ChangeLocationEvent.GO_TO_MAIN_SCREEN_ALONE, startShow, ChangeLocationEvent);
			addContextListener(ChangeLocationEvent.GO_TO_CUSTOM_SCREEN_ALONE, startShow, ChangeLocationEvent);
			addContextListener(ChangeLocationEvent.GO_TO_STORY_SCREEN_ALONE, startShow, ChangeLocationEvent);
			
			addContextListener(ChangeLocationEvent.GO_TO_MAIN_SCREEN_BACK, backShow, ChangeLocationEvent);
			addContextListener(ChangeLocationEvent.GO_TO_CUSTOM_SCREEN_BACK, backShow, ChangeLocationEvent);
			addContextListener(ChangeLocationEvent.GO_TO_STORY_SCREEN_BACK, backShow, ChangeLocationEvent);
			
			addViewListener(AnimationEvent.TO_MAIN_SCREEN_VISIBLE, dispatch, AnimationEvent);			
		}	
		
		private function hideView(e:ChangeLocationEvent):void 
		{
			activeView.prepare(e.type,config);
		}
		
		private function backShow(e:ChangeLocationEvent):void
		{
			activeView.prepareback(e.type,config);
		}
		private function startShow(e:ChangeLocationEvent):void
		{
			activeView.startShow();
		}		
	}
}
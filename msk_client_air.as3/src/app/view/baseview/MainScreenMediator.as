package app.view.baseview 
{
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.InteractiveRemoteEvent;
	import app.contoller.events.IpadEvent;
	import app.contoller.events.SliderEvent;
	import app.model.config.ScreenShots;
	import app.model.datauser.IUser;
	import app.services.ipad.IIpadService;
	import flash.events.Event;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.mvcs.Mediator;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class MainScreenMediator extends Mediator
	{
		[Inject] public var injector:IInjector;
		
		[Inject]
		public var user:IUser;
		
		[Inject]
		public var ipad:IIpadService;
		
		public var activeView:*;
		
		[Inject]
		public var config:ScreenShots;
		
		override public function onRegister():void
		{
			injector.injectInto(activeView);
			
			addContextListener(AnimationEvent.TO_MAIN_SCREEN_ANIMATION, animateView, AnimationEvent);				
			addContextListener(AnimationEvent.TO_MAIN_SCREEN_VISIBLE, visibleView, AnimationEvent);				
		
			addContextListener(InteractiveRemoteEvent.USER_LOST_FOR_ALL_SYSTEM, startRotatorIRE,InteractiveRemoteEvent);
			addContextListener(InteractiveRemoteEvent.USER_ACTIVE_FOR_ALL_SYSTEM, stopRotatorIRE, InteractiveRemoteEvent);
			
			addContextListener(IpadEvent.PAUSE, stopRotatorIPAD,IpadEvent);
			addContextListener(IpadEvent.PLAY, startRotatorIPAD, IpadEvent);
			
			activeView.isAllowAnimation = !user.is_active && !ipad.isPause;	
			
			activeView.config = config;
			activeView.setScreen();
			
		}
		
		protected function removeAllHandlers():void
		{				
			removeContextListener(AnimationEvent.TO_MAIN_SCREEN_ANIMATION, animateView, AnimationEvent);
			removeContextListener(AnimationEvent.TO_MAIN_SCREEN_VISIBLE, visibleView, AnimationEvent);
			
			removeContextListener(InteractiveRemoteEvent.USER_LOST_FOR_ALL_SYSTEM, startRotatorIRE,InteractiveRemoteEvent);
			removeContextListener(InteractiveRemoteEvent.USER_ACTIVE_FOR_ALL_SYSTEM, stopRotatorIRE, InteractiveRemoteEvent);
			
			removeContextListener(IpadEvent.PAUSE, stopRotatorIPAD,IpadEvent);
			removeContextListener(IpadEvent.PLAY, startRotatorIPAD,IpadEvent);
		}	
		
		private function startRotatorIPAD(e:IpadEvent):void 
		{
			activeView.isAllowAnimation = !user.is_active && !ipad.isPause;				
			activeView.startRotator();
		}
		
		private function startRotatorIRE(e:InteractiveRemoteEvent):void 
		{	
			activeView.isAllowAnimation = !user.is_active && !ipad.isPause;	
			//activeView.startRotator();
		}
		
		private function stopRotatorIPAD(e:IpadEvent):void 
		{
			activeView.isAllowAnimation = !user.is_active && !ipad.isPause;	
			activeView.stopRotator();
		}		
		
		private function stopRotatorIRE(e:InteractiveRemoteEvent):void 
		{
			activeView.isAllowAnimation = !user.is_active && !ipad.isPause;	
			activeView.stopRotator();
		}
		
		protected function hideView(e:SliderEvent):void 
		{
			activeView.hideView();
		}
		
		protected function showView(e:SliderEvent):void 
		{
			activeView.showView();
		}
		
		private function visibleView(e:AnimationEvent):void 
		{
			activeView.show();
		}
		private function animateView(e:AnimationEvent):void
		{
			activeView.toMainScreen();
		}	
	}
}
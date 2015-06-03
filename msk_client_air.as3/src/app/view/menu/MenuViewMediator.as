package app.view.menu
{
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.ScreenshotEvent;
	import app.view.baseview.MainScreenMediator; 
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class MenuViewMediator extends MainScreenMediator
	{
		[Inject]
		public var view:MenuView;
		
		override public function onRegister():void
		{
			addContextListener(ChangeLocationEvent.MENU, showMenu, ChangeLocationEvent);
			addContextListener(ChangeLocationEvent.HIDE_MENU, hideMenu, ChangeLocationEvent);
				
			addContextListener(AnimationEvent.HIDE_MENU_AND_GO, hideMenuAndGO, AnimationEvent);		
			addViewListener(ChangeLocationEvent.MENU_IS_HIDDEN, dispatch, ChangeLocationEvent);
			
			eventMap.mapListener(view.mainbtn, InteractiveEvent.HAND_OVER, overMainBtn, InteractiveEvent);
			eventMap.mapListener(view.mainbtn, InteractiveEvent.HAND_OUT, outMainBtn, InteractiveEvent);
			eventMap.mapListener(view.backbtn, InteractiveEvent.HAND_OVER, overBackBtn, InteractiveEvent);
			eventMap.mapListener(view.backbtn, InteractiveEvent.HAND_OUT, outBackBtn, InteractiveEvent);
			
			eventMap.mapListener(view.closeMenuBtn, InteractiveEvent.HAND_PUSH, closeMenu, InteractiveEvent);
			eventMap.mapListener(view.closeMenuBtn, InteractiveEvent.HAND_OVER, closeMenuOver, InteractiveEvent);
			eventMap.mapListener(view.closeMenuBtn, InteractiveEvent.HAND_OUT, closeMenuOut, InteractiveEvent);
		}
		
		private function hideMenu(e:ChangeLocationEvent):void 
		{
			view.closeMenu();
		}
		
		private function closeMenuOut(e:InteractiveEvent):void
		{
			view.closeMenuOut();
		}
		
		private function closeMenuOver(e:InteractiveEvent):void
		{
			view.closeMenuOver();
		}
		
		private function hideMenuAndGO(e:AnimationEvent):void
		{			
			addViewListener(AnimationEvent.MENU_ANIMATION_FINISHED, animationMenuFinished, AnimationEvent);
			view.closeMenu();
			
		}
		
		private function animationMenuFinished(e:AnimationEvent):void
		{
			removeViewListener(AnimationEvent.MENU_ANIMATION_FINISHED, animationMenuFinished, AnimationEvent);
			
			var event:ChangeLocationEvent = new ChangeLocationEvent(view.selectedItem());
			event.mode = "MENU_MODE";
			dispatch(event);
			
		}
		
		private function closeMenu(e:InteractiveEvent):void
		{
			view.closeMenu();
		}
		
		private function overBackBtn(e:InteractiveEvent):void
		{
			view.hideMainBtns();
		}
		
		private function outBackBtn(e:InteractiveEvent):void
		{
			view.clearHideMainBtns();
		}
		
		private function overMainBtn(e:InteractiveEvent):void
		{
			view.showMainBtns();
		}
		
		private function outMainBtn(e:InteractiveEvent):void
		{
			view.clearShowMainBtns();
		}
		
		private function showMenu(e:ChangeLocationEvent):void
		{
			if (view.isOpen)  return;
			view.loc = e.currentLocation;
			
			addContextListener(ScreenshotEvent.TAKE_SCREENSHOT, screenshotCapture, ScreenshotEvent);
			dispatch(new ScreenshotEvent(ScreenshotEvent.MAKE_SCREENSHOT));			
		}
		
		private function screenshotCapture(e:ScreenshotEvent):void 
		{
			removeContextListener(ScreenshotEvent.TAKE_SCREENSHOT, screenshotCapture, ScreenshotEvent);
			view.show(e.shot);			
		}	
	}
}
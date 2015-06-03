package app.view.animator
{
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.ScreenshotEvent;
	import app.model.config.ScreenShots;
	import app.model.dataall.IAllNewsModel;
	import flash.geom.Rectangle;
	import org.robotlegs.mvcs.Mediator;	
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class AnimatorMediator extends Mediator
	{		
		[Inject]
		public var view:Animator;
		
		[Inject]
		public var model:IAllNewsModel;
		[Inject]
		public var config:ScreenShots;
		
		override public function onRegister():void
		{	
			view.config = config;
			addContextListener(ChangeLocationEvent.ANIMATOR_SPLIT_SCREEN, backFromOnePage, ChangeLocationEvent);		
			addContextListener(ChangeLocationEvent.ANIMATOR_EXPAND_SCREEN, expandScreen, ChangeLocationEvent);		
			addContextListener(ChangeLocationEvent.ANIMATOR_FLIP_SCREEN, flipScreen, ChangeLocationEvent);		
			addContextListener(ChangeLocationEvent.PAGE_FROM_MAIN, fadeScreen, ChangeLocationEvent);		
			addContextListener(ChangeLocationEvent.MAIN_FROM_PAGE, flyOut, ChangeLocationEvent);		
		}
		
		private function flyOut(e:ChangeLocationEvent):void 
		{
			view.animation = "FLY";
			makeScreenshot();	
		}
		
		private function fadeScreen(e:ChangeLocationEvent):void 
		{
			view.animation = "FADE";
			makeScreenshot();	
		}
		
		private function flipScreen(e:ChangeLocationEvent):void 
		{
			view.animation = "FLIP";
			makeScreenshot();	
		}
		
		private function expandScreen(e:ChangeLocationEvent):void 
		{
			
			view.animation = "EXPAND";
			view.expand_rectangle =model.getChoosenField().rec;//  ,//new Rectangle(0, 0, 100, 100);//
			//view.expand_color = model.getChoosenField().color;//0xff0000;// 
			makeScreenshot();	
		}
		private function backFromOnePage(e:ChangeLocationEvent):void 
		{
			view.animation = "SPLIT";
			makeScreenshot();	
		}
		
		private function screenshotCapture(e:ScreenshotEvent):void 
		{
			removeContextListener(ScreenshotEvent.TAKE_SCREENSHOT, screenshotCapture, ScreenshotEvent);		
			view.setScreenshot(e.shot);
		}	
		private function makeScreenshot():void 
		{
			addContextListener(ScreenshotEvent.TAKE_SCREENSHOT, screenshotCapture, ScreenshotEvent);
			dispatch(new ScreenshotEvent(ScreenshotEvent.MAKE_SCREENSHOT));		
		}
	}
}
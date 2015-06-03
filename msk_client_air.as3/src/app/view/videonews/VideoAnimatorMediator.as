
package app.view.videonews
{
	import app.contoller.events.ScreenshotEvent;
	import flash.events.Event;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class VideoAnimatorMediator extends Mediator
	{
		[Inject]
		public var view:VideoAnimator;
		
		override public function onRegister():void
		{
			addContextListener(ScreenshotEvent.TAKE_SCREENSHOT, screenshotCapture, ScreenshotEvent);
			dispatch(new ScreenshotEvent(ScreenshotEvent.MAKE_SCREENSHOT, null, view.screenField));			
			addViewListener(Event.REMOVED_FROM_STAGE, rem, Event);			
		}
		
		private function rem(e:Event):void 
		{		
			removeContextListener(ScreenshotEvent.TAKE_SCREENSHOT, screenshotCapture, ScreenshotEvent);
			removeViewListener(Event.REMOVED_FROM_STAGE, rem, Event);
			view.kill();
		}
		
		private function screenshotCapture(e:ScreenshotEvent):void 
		{
			removeContextListener(ScreenshotEvent.TAKE_SCREENSHOT, screenshotCapture, ScreenshotEvent);
			view.init(e.shot);
		}		
	}
}
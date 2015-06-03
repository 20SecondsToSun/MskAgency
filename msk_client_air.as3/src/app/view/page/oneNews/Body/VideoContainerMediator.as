package app.view.page.oneNews.Body 
{
	import app.contoller.events.GraphicInterfaceEvent;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.ScreenshotEvent;
	import app.view.utils.video.events.VideoEvent;
	import org.robotlegs.mvcs.Mediator;
	/**
	 * ...
	 * @author metalcorehero
	 */

	public class VideoContainerMediator extends Mediator
	{
		[Inject]
		public var view:VideoContainer;		
		
		override public function onRegister():void
		{			
			eventMap.mapListener(view.fullScreen,InteractiveEvent.HAND_OVER, overView,	InteractiveEvent);
			eventMap.mapListener(view.fullScreen,InteractiveEvent.HAND_OUT, outView,	InteractiveEvent);
			eventMap.mapListener(view.fullScreen, InteractiveEvent.HAND_PUSH, pushView,	InteractiveEvent);
			
			addContextListener(VideoEvent.CHANGED_SIZE, changedSize, VideoEvent);
		}
		
		private function changedSize(e:VideoEvent):void 
		{			
			view.changedControlPosition(e.height);
		}
		
		override public function preRemove():void
		{
			eventMap.unmapListener(view.fullScreen,InteractiveEvent.HAND_OVER, overView,	InteractiveEvent);
			eventMap.unmapListener(view.fullScreen,InteractiveEvent.HAND_OUT, outView,	InteractiveEvent);
			eventMap.unmapListener(view.fullScreen, InteractiveEvent.HAND_PUSH, pushView,	InteractiveEvent);	
			removeContextListener(VideoEvent.CHANGED_SIZE, changedSize, VideoEvent);
		}
		
		private function pushView(e:InteractiveEvent):void 
		{	
			view.fullScreen.outFast();
			addContextListener(ScreenshotEvent.TAKE_SCREENSHOT, screenshotCapture, ScreenshotEvent);
			dispatch(new ScreenshotEvent(ScreenshotEvent.MAKE_SCREENSHOT));
		}	
		
		private function screenshotCapture(e:ScreenshotEvent):void 
		{
			removeContextListener(ScreenshotEvent.TAKE_SCREENSHOT, screenshotCapture, ScreenshotEvent);			
			view.fullScreenVideoON(e.shot);
			
			addContextListener(GraphicInterfaceEvent.FULL_SCREEN_VIDEO_OFF, screenShotOff, GraphicInterfaceEvent);			
		}
		
		private function screenShotOff(e:GraphicInterfaceEvent):void 
		{
			removeContextListener(GraphicInterfaceEvent.FULL_SCREEN_VIDEO_OFF, screenShotOff, GraphicInterfaceEvent);	
			view.fullScreenVideoOFF();
			
		}
		
		private function outView(e:InteractiveEvent):void 
		{			
			view.fullScreen.out();
		}
		
		private function overView(e:InteractiveEvent):void 
		{			
			view.fullScreen.over();
		}	
	}
}
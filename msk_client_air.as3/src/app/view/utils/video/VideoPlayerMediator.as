package app.view.utils.video 
{
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.GraphicInterfaceEvent;
	import app.contoller.events.InteractiveEvent;
	import app.view.utils.video.events.VideoEvent;
	import org.robotlegs.mvcs.Mediator;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class VideoPlayerMediator extends Mediator
	{		
		[Inject]
		public var view:VideoPlayer;
		
		override public function onRegister():void
		{				
			addViewListener(InteractiveEvent.HAND_DOWN, downVideo,	InteractiveEvent);
			addContextListener(ChangeLocationEvent.MENU, showMenu, ChangeLocationEvent);
			
			eventMap.mapListener(view.overButton, InteractiveEvent.HAND_PUSH, playStopVideo,	InteractiveEvent);
			eventMap.mapListener(view.overButton, InteractiveEvent.HAND_OVER, overVideo,	InteractiveEvent);
			eventMap.mapListener(view.overButton, InteractiveEvent.HAND_OUT, outVideo,	InteractiveEvent);
			
			
			eventMap.mapListener(view.fullscreenBtn,InteractiveEvent.HAND_OVER, overFullBtn,	InteractiveEvent);
			eventMap.mapListener(view.fullscreenBtn,InteractiveEvent.HAND_OUT, outFullBtn,	InteractiveEvent);
			eventMap.mapListener(view.fullscreenBtn, InteractiveEvent.HAND_PUSH, pushFullBtn,	InteractiveEvent);	
			
			addViewListener(VideoEvent.CHANGED_SIZE, dispatch, VideoEvent);
			addContextListener(VideoEvent.TOP_ALL_VIDEOS,stopVideo, VideoEvent);
		}	
		
		private function stopVideo(e:VideoEvent):void 
		{
			view.pause();
		}
		
		override public function preRemove():void
		{		
			removeViewListener(InteractiveEvent.HAND_DOWN, downVideo,	InteractiveEvent);
			removeContextListener(ChangeLocationEvent.MENU, showMenu, ChangeLocationEvent);				
			eventMap.unmapListeners();
		}
		
		private function overFullBtn(e:InteractiveEvent):void 
		{			
			view.playUP();
		}
		
		private function outFullBtn(e:InteractiveEvent):void 
		{			
			view.playDOWN();
		}
		
		private function pushFullBtn(e:InteractiveEvent):void 
		{
			dispatch(new GraphicInterfaceEvent(GraphicInterfaceEvent.FULL_SCREEN_VIDEO_OFF));
		}		
		
		private function showMenu(e:ChangeLocationEvent):void 
		{
			view.pause();
		}
		
		private function playStopVideo(e:InteractiveEvent):void 
		{
			view.playStop();
		}
		
		private function downVideo(e:InteractiveEvent):void 
		{
			if (view.videoFinish) return;
				
			addViewListener(InteractiveEvent.HAND_UPDATE, seekVideo,	InteractiveEvent);
			addViewListener(InteractiveEvent.HAND_UP, upVideo,	InteractiveEvent);
			
			eventMap.unmapListener(view.fullscreenBtn,InteractiveEvent.HAND_OVER, overFullBtn,	InteractiveEvent);
			eventMap.unmapListener(view.fullscreenBtn,InteractiveEvent.HAND_OUT, outFullBtn,	InteractiveEvent);
			eventMap.unmapListener(view.fullscreenBtn,InteractiveEvent.HAND_PUSH, pushFullBtn,	InteractiveEvent);			
		}
		
		private function upVideo(e:InteractiveEvent):void 
		{
			removeViewListener(InteractiveEvent.HAND_UP, upVideo,	InteractiveEvent);
			removeViewListener(InteractiveEvent.HAND_UPDATE, seekVideo,	InteractiveEvent);		
			
			eventMap.mapListener(view.fullscreenBtn,InteractiveEvent.HAND_OVER, overFullBtn,	InteractiveEvent);
			eventMap.mapListener(view.fullscreenBtn,InteractiveEvent.HAND_OUT, outFullBtn,	InteractiveEvent);
			eventMap.mapListener(view.fullscreenBtn, InteractiveEvent.HAND_PUSH, pushFullBtn,	InteractiveEvent);	
			
			view.resume();
		}
		
		private function seekVideo(e:InteractiveEvent):void 
		{
			view.seek(e.stageX,e.stageY);
		}
		
		private function outVideo(e:InteractiveEvent):void 
		{			
			view.outState();
		}
		
		private function overVideo(e:InteractiveEvent):void 
		{			
			view.overState();
		}			
	}
}
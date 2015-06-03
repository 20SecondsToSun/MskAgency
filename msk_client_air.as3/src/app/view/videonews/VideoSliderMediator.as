package app.view.videonews
{	
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.SliderEvent;
	import app.view.baseview.slider.SliderPullOutMediator;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class VideoSliderMediator extends SliderPullOutMediator
	{
		[Inject]
		public var videoView: VideoSlider;
		
		override public function onRegister():void
		{	
			view = videoView;
			super.onRegister();
			
			addViewListener(SliderEvent.VIDEO_SLIDER_STOP_DRAG, setDownListener, SliderEvent);			
			addViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
		}	
		
		private function removeHandler(e:Event):void 
		{
			removeViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
			removeViewListener(SliderEvent.VIDEO_SLIDER_STOP_DRAG, setDownListener, SliderEvent);
			eventMap.unmapListener(videoView, InteractiveEvent.HAND_DOWN, startDragSliderPullOutMode);
			
			videoView.kill();
		}
		
		private function setDownListener(e:SliderEvent):void 
		{
			eventMap.mapListener(videoView, InteractiveEvent.HAND_DOWN, startDragSliderPullOutMode);
		}
	}
}
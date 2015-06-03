package app.view.baseview.slider
{	
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.ScreenshotEvent;
	import app.contoller.events.SliderEvent;
	import app.view.baseview.slider.SliderMediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class SliderPullOutMediator extends SliderMediator
	{		
		public var view: *;
		
		override public function onRegister():void
		{	
			_view = view;
			super.onRegister();
			
			addViewListener(SliderEvent.START_INTERACTION_PULL_OUT, startInteractionPullOut, SliderEvent);	
			addViewListener(SliderEvent.STOP_INTERACTION_PULL_OUT, stopInteractionPullOut, SliderEvent);	
			addViewListener(_view.stopSliderType, dispatch, SliderEvent);			
		}
		
		private function stopInteractionPullOut(e:SliderEvent):void 
		{
			eventMap.unmapListener(_view, InteractiveEvent.HAND_UPDATE, _view.updateDragPullOutSlider);
			eventMap.unmapListener(_view, InteractiveEvent.HAND_DOWN, startDragSliderPullOutMode);		
			removeViewListener(InteractiveEvent.HAND_UP, stopDragSliderPullOutMode);			
		}
		
		private function startInteractionPullOut(e:SliderEvent):void 
		{
			eventMap.mapListener(_view, InteractiveEvent.HAND_DOWN, startDragSliderPullOutMode);
			eventMap.unmapListener(_view, InteractiveEvent.HAND_UPDATE, _view.updateDragPullOutSlider);			
		}
		
		public function startDragSliderPullOutMode(e:InteractiveEvent):void 
		{	
			_view.startPullOutSlider(e);
			eventMap.unmapListener(_view, InteractiveEvent.HAND_DOWN, startDragSliderPullOutMode);		
			
			addContextListener(ScreenshotEvent.TAKE_SCREENSHOT, screenshotCapture, ScreenshotEvent);
			dispatch(new ScreenshotEvent(ScreenshotEvent.MAKE_SCREENSHOT,null, _view.screenshotArea));				
		}
		
		private function screenshotCapture(e:ScreenshotEvent):void 
		{
			dispatch(_view.startDragSliderEvent);
			removeContextListener(ScreenshotEvent.TAKE_SCREENSHOT, screenshotCapture, ScreenshotEvent);
			
			_view.addScreenShot(e.shot);
			eventMap.mapListener(_view, InteractiveEvent.HAND_UPDATE, _view.updateDragPullOutSlider);
			addViewListener(InteractiveEvent.HAND_UP, stopDragSliderPullOutMode);	
		}
		
		private function stopDragSliderPullOutMode(e:InteractiveEvent):void 
		{	
			
			eventMap.unmapListener(_view, InteractiveEvent.HAND_UPDATE, _view.updateDragPullOutSlider);
			removeViewListener(InteractiveEvent.HAND_UP, stopDragSliderPullOutMode);			
			_view.stopDragSliderPullOutMode(e);
			
			//eventMap.mapListener(_view, InteractiveEvent.HAND_DOWN, startDragSliderPullOutMode);
		}		
		
		override public function onRemove():void
		{
			super.onRemove();
			removeViewListener(SliderEvent.START_INTERACTION_PULL_OUT, startInteractionPullOut, SliderEvent);	
			removeViewListener(SliderEvent.STOP_INTERACTION_PULL_OUT, stopInteractionPullOut, SliderEvent);	
			
			eventMap.unmapListener(_view, InteractiveEvent.HAND_UPDATE, _view.updateDragPullOutSlider);
			eventMap.unmapListener(_view, InteractiveEvent.HAND_DOWN, startDragSliderPullOutMode);
			eventMap.unmapListener(_view, InteractiveEvent.HAND_UPDATE, _view.updateDragSlider);
			removeViewListener(InteractiveEvent.HAND_UP, stopDragSliderPullOutMode);
			removeViewListener(_view.stopSliderType, dispatch, SliderEvent);	
			
			_view.kill();
		}	
	}
}
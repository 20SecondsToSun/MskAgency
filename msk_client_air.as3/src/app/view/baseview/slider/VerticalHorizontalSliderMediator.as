package app.view.baseview.slider
{
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.ScreenshotEvent;
	import app.contoller.events.SliderEvent;
	import app.view.baseview.slider.SliderMediator;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class VerticalHorizontalSliderMediator extends Mediator
	{
		public var _view:*;
		
		override public function onRegister():void
		{
			addViewListener(SliderEvent.START_INTERACTION, startInteraction, SliderEvent);
			addViewListener(SliderEvent.STOP_INTERACTION, stopInteraction, SliderEvent);
		}
		
		override public function onRemove():void
		{
			removeViewListener(SliderEvent.START_INTERACTION, startInteraction, SliderEvent);
			removeViewListener(SliderEvent.STOP_INTERACTION, stopInteraction, SliderEvent);
			removeViewListener(InteractiveEvent.HAND_UP, stopDragSlider);
			eventMap.unmapListeners();
		}
		
		private function stopInteraction(e:SliderEvent):void
		{	
			eventMap.unmapListener(_view, InteractiveEvent.HAND_UPDATE, _view.updateDragSlider);
			removeViewListener(InteractiveEvent.HAND_UP, stopDragSlider)
			_view.stopDragSlider(null);
		}
		
		private function startInteraction(e:SliderEvent):void
		{
			
			eventMap.mapListener(_view, InteractiveEvent.HAND_DOWN, startDragSlider);
			eventMap.unmapListener(_view, InteractiveEvent.HAND_UPDATE, _view.updateDragSlider);
			removeViewListener(InteractiveEvent.HAND_UP, stopDragSlider);
		}
		
		private function startDragSlider(e:InteractiveEvent):void
		{
			_view.startDragSlider(e);
			
			eventMap.mapListener(_view, InteractiveEvent.HAND_UPDATE, _view.updateDragSlider);
			addViewListener(InteractiveEvent.HAND_UP, stopDragSlider);
			eventMap.unmapListener(_view, InteractiveEvent.HAND_DOWN, startDragSlider);
		}
		
		private function stopDragSlider(e:InteractiveEvent):void
		{
			
			eventMap.unmapListener(_view, InteractiveEvent.HAND_UPDATE, _view.updateDragSlider);
			removeViewListener(InteractiveEvent.HAND_UP, stopDragSlider)
			
			_view.stopDragSlider(e);
		}
	}
}
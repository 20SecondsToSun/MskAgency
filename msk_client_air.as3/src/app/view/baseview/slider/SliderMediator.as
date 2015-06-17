package app.view.baseview.slider 
{
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.SliderEvent;
	import flash.display.DisplayObject;
	import org.robotlegs.mvcs.Mediator;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class SliderMediator extends Mediator
	{		
		public var _view:*;		
		
		override public function onRegister():void
		{			
			addViewListener(SliderEvent.START_INTERACTION, startInteraction, SliderEvent);		
			addViewListener(SliderEvent.STOP_INTERACTION, stopInteraction, SliderEvent);			
		}
		
		private function stopInteraction(e:SliderEvent):void 
		{
			eventMap.unmapListener(_view, InteractiveEvent.HAND_DOWN, startDragSlider);			
			eventMap.unmapListener(_view, InteractiveEvent.HAND_UPDATE,_view.updateDragSlider);
			removeViewListener(InteractiveEvent.HAND_UP, stopDragSlider);
		}
		
		override public function onRemove():void
		{
			eventMap.unmapListeners();
			removeViewListener(SliderEvent.START_INTERACTION, startInteraction, SliderEvent);			
			_view.kill();
		}
		
		private function startInteraction(e:SliderEvent):void 
		{				
			eventMap.mapListener(_view, InteractiveEvent.HAND_DOWN, startDragSlider);			
			eventMap.unmapListener(_view, InteractiveEvent.HAND_UPDATE,_view.updateDragSlider);
			removeViewListener(InteractiveEvent.HAND_UP, stopDragSlider);			
		}
		
		private function stopDragSlider(e:InteractiveEvent):void 
		{			
			eventMap.unmapListener(_view, InteractiveEvent.HAND_UPDATE, _view.updateDragSlider);
			removeViewListener(InteractiveEvent.HAND_UP, stopDragSlider)
			
			_view.stopDragSlider(e);
		}
		
		private function startDragSlider(e:InteractiveEvent):void 
		{			
			_view.startDragSlider(e);
			
			eventMap.mapListener(_view, InteractiveEvent.HAND_UPDATE, _view.updateDragSlider);
			addViewListener(InteractiveEvent.HAND_UP, stopDragSlider);			
			eventMap.unmapListener(_view, InteractiveEvent.HAND_DOWN, startDragSlider);		
		}
		
		private function updateChilds():void
		{
			_view.tryUpdateChilds(new DisplayObject());
		}
	}
}
package app.view.filters
{
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.SliderEvent;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FilterSliderMediator extends Mediator
	{
		[Inject]
		public var view:FilterSlider;		
	
		override public function onRegister():void
		{			
			addViewListener(SliderEvent.START_INTERACTION, startInteraction, SliderEvent);		
			addViewListener(SliderEvent.STOP_INTERACTION, stopInteraction, SliderEvent);
			startInteraction();
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
			stopDragSlider();
		}
		
		private function startInteraction(e:SliderEvent = null):void 
		{			
			eventMap.mapListener(view, InteractiveEvent.HAND_DOWN, startDragSlider);			
			eventMap.unmapListener(view, InteractiveEvent.HAND_UPDATE, view.updateDragSlider);
			removeViewListener(InteractiveEvent.HAND_UP, stopDragSlider);		
		}
		
		private function startDragSlider(e:InteractiveEvent):void 
		{
			view.startDragSlider(e);			
			eventMap.mapListener(view, InteractiveEvent.HAND_UPDATE, view.updateDragSlider);			
			addViewListener(InteractiveEvent.HAND_UP, stopDragSlider);				
			eventMap.unmapListener(view, InteractiveEvent.HAND_DOWN, startDragSlider);		
		}
		
		private function stopDragSlider(e:InteractiveEvent = null):void 
		{			
			eventMap.unmapListener(view, InteractiveEvent.HAND_UPDATE, view.updateDragSlider);
			removeViewListener(InteractiveEvent.HAND_UP, stopDragSlider)
			eventMap.mapListener(view, InteractiveEvent.HAND_DOWN, startDragSlider);		
			view.stopDragSlider(e);
		}		
	}	
}


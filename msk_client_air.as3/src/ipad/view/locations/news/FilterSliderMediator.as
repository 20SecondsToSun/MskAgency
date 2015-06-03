package ipad.view.locations.news
{
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.SliderEvent;
	import flash.events.MouseEvent;
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
			eventMap.unmapListener(view.stage, MouseEvent.MOUSE_UP, stopDragSlider, MouseEvent);	
			eventMap.unmapListeners();
		}
		private function stopInteraction(e:SliderEvent):void 
		{
			stopDragSlider();
		}
		
		private function startInteraction(e:SliderEvent = null):void 
		{			
			eventMap.mapListener(view, MouseEvent.MOUSE_DOWN, startDragSlider);			
			eventMap.unmapListener(view.stage, MouseEvent.MOUSE_MOVE, view.updateDragSlider);
			eventMap.unmapListener(view.stage, MouseEvent.MOUSE_UP, stopDragSlider, MouseEvent);	
		}
		
		private function startDragSlider(e:MouseEvent):void 
		{
			view.startDragSlider(e);			
			eventMap.mapListener(view.stage, MouseEvent.MOUSE_MOVE, view.updateDragSlider);			
			eventMap.mapListener(view.stage, MouseEvent.MOUSE_UP, stopDragSlider, MouseEvent);	
			eventMap.unmapListener(view, MouseEvent.MOUSE_DOWN, startDragSlider);		
		}
		
		private function stopDragSlider(e:MouseEvent = null):void 
		{			
			eventMap.unmapListener(view.stage, MouseEvent.MOUSE_MOVE, view.updateDragSlider);			
			eventMap.unmapListener(view.stage, MouseEvent.MOUSE_UP, stopDragSlider, MouseEvent);	
			eventMap.mapListener(view, MouseEvent.MOUSE_DOWN, startDragSlider);		
			view.stopDragSlider(e);
		}		
	}	
}


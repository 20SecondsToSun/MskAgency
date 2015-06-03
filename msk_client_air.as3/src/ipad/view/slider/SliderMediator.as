package ipad.view.slider 
{
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.SliderEvent;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import org.robotlegs.mvcs.Mediator;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class SliderMediator extends Mediator
	{		
		[Inject]
		public var _view:Slider;	
		
		override public function onRegister():void
		{			
			addViewListener(SliderEvent.START_INTERACTION, startInteraction, SliderEvent);		
			addViewListener(SliderEvent.STOP_INTERACTION, stopInteraction, SliderEvent);	
		}
		
		private function stopInteraction(e:SliderEvent):void 
		{
			eventMap.unmapListener(_view, MouseEvent.MOUSE_DOWN, startDragSlider,MouseEvent);			
			eventMap.unmapListener(_view.stage, MouseEvent.MOUSE_MOVE, _view.updateDragSlider,MouseEvent);
			eventMap.unmapListener(_view.stage, MouseEvent.MOUSE_UP, stopDragSlider, MouseEvent);	
		}
		override public function onRemove():void
		{
			eventMap.unmapListeners();
			removeViewListener(SliderEvent.START_INTERACTION, startInteraction, SliderEvent);			
			_view.kill();
		}
		
		private function startInteraction(e:SliderEvent):void 
		{				
			eventMap.mapListener(_view, MouseEvent.MOUSE_DOWN, startDragSlider,MouseEvent);		
			eventMap.unmapListener(_view.stage, MouseEvent.MOUSE_MOVE, _view.updateDragSlider,MouseEvent);
			eventMap.unmapListener(_view.stage, MouseEvent.MOUSE_UP, stopDragSlider, MouseEvent);		
		}
		
		private function stopDragSlider(e:MouseEvent):void 
		{				
			eventMap.unmapListener(_view.stage, MouseEvent.MOUSE_MOVE, _view.updateDragSlider,MouseEvent);
			eventMap.unmapListener(_view.stage, MouseEvent.MOUSE_UP, stopDragSlider, MouseEvent);			
			_view.stopDragSlider(e);
		}
		
		private function startDragSlider(e:MouseEvent):void 
		{				
			_view.startDragSlider(e);
			
			eventMap.mapListener(_view.stage, MouseEvent.MOUSE_MOVE, _view.updateDragSlider,MouseEvent);
			eventMap.mapListener(_view.stage, MouseEvent.MOUSE_UP, stopDragSlider, MouseEvent);
			eventMap.unmapListener(_view, MouseEvent.MOUSE_DOWN, startDragSlider,MouseEvent);		
		}	
		
		private function updateChilds():void
		{
			_view.tryUpdateChilds(new DisplayObject());
		}
	}

}
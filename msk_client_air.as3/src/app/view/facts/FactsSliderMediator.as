package app.view.facts
{
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.SliderEvent;
	import app.view.baseview.slider.SliderPullOutMediator;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FactsSliderMediator extends SliderPullOutMediator
	{
		[Inject]
		public var factsView: FactsSlider;
		
		override public function onRegister():void
		{	
			view = factsView;
			super.onRegister();
			
			addViewListener(SliderEvent.FACT_SLIDER_STOP_DRAG, setDownListener, SliderEvent);			
			addViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
		}	
		
		private function removeHandler(e:Event):void 
		{
			removeViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
			removeViewListener(SliderEvent.FACT_SLIDER_STOP_DRAG, setDownListener, SliderEvent);
			eventMap.unmapListener(factsView, InteractiveEvent.HAND_DOWN, startDragSliderPullOutMode);
			factsView.kill();
		}
		
		private function setDownListener(e:SliderEvent):void 
		{
			eventMap.mapListener(factsView, InteractiveEvent.HAND_DOWN, startDragSliderPullOutMode);
		}
	}
}


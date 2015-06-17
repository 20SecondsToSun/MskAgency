package app.view.page.days.onedayslider 
{
	import app.contoller.events.AnimationEvent;
	import app.view.baseview.slider.SliderMediator;
	import app.view.baseview.slider.Slider;
	
	public class OneDaySliderMediator extends SliderMediator
	{
		[Inject]
		public var view: OneDaySlider;
		
		override public function onRegister():void
		{	
			_view = view;
			super.onRegister();
			addViewListener(AnimationEvent.STRETCH, stretchPercent, AnimationEvent, true);		
		}
		
		private function stretchPercent(e:AnimationEvent):void
		{
			view.stretch(e.percent);
		}	
	}
}
package app.view.page.day.onehourslider 
{
	import app.view.baseview.slider.SliderMediator;
	import app.view.baseview.slider.Slider;
	
	public class OneHourSliderMediator extends SliderMediator
	{
		[Inject]
		public var view: OneHourSlider;
		
		override public function onRegister():void
		{	
			_view = view;
			super.onRegister();
		}	
	}
}
package app.view.page.fact.onedayfactslider 
{
	import app.view.baseview.slider.SliderMediator;
	import app.view.baseview.slider.Slider;
	
	public class OneDayFactSliderMediator extends SliderMediator
	{
		[Inject]
		public var view: OneDayFactSlider;
		
		override public function onRegister():void
		{	
			_view = view;
			super.onRegister();		
		}	
	}

}
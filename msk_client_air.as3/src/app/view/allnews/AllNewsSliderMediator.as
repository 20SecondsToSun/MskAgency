package app.view.allnews
{
	import app.view.baseview.slider.SliderMediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class AllNewsSliderMediator extends SliderMediator
	{
		[Inject]
		public var view:AllNewsSlider;
		
		override public function onRegister():void
		{	
			_view = view;
			super.onRegister();			
		}	
	}
}


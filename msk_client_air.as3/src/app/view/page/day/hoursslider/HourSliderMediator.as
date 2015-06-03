package app.view.page.day.hoursslider
{
	import app.contoller.events.AnimationEvent;
	import app.view.baseview.slider.VerticalHorizontalSliderMediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class HourSliderMediator extends VerticalHorizontalSliderMediator
	{
		[Inject]
		public var view:HourSlider;		
		
		
		override public function onRegister():void
		{			
			addContextListener(AnimationEvent.LEFT_PANEL_OVER, overLeftPanel, AnimationEvent);
			addContextListener(AnimationEvent.LEFT_PANEL_OUT, outLeftPanel, AnimationEvent);
			
			_view = view;
			super.onRegister();
		}
		
		private function outLeftPanel(e:AnimationEvent):void
		{
			view.outLeftPanel();
		}
		
		private function overLeftPanel(e:AnimationEvent):void
		{
			view.overLeftPanel();
		}
		
		override public function onRemove():void
		{
			removeContextListener(AnimationEvent.LEFT_PANEL_OVER, overLeftPanel, AnimationEvent);
			removeContextListener(AnimationEvent.LEFT_PANEL_OUT, outLeftPanel, AnimationEvent);
		}
	}

}


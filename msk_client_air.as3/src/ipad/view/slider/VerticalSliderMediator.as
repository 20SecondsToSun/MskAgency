package ipad.view.slider 
{
	import app.contoller.events.ChangeLocationEvent;
	import org.robotlegs.mvcs.Mediator;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class VerticalSliderMediator extends Mediator
	{
		
		[Inject]
		public var view:VerticalNewsSlider;
		
		override public function onRegister():void
		{				
			
		}		
		
		private function changeNews(e:ChangeLocationEvent):void 
		{
			
		}
		
	}

}
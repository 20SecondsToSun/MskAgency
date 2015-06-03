package app.view.filters
{
	import app.contoller.events.FilterEvent;
	import app.contoller.events.GraphicInterfaceEvent;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.SliderEvent;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FilterButtonMediator extends Mediator
	{
		[Inject]
		public var view:FilterButton;		
	
		override public function onRegister():void
		{			
			addViewListener(InteractiveEvent.HAND_OVER, view.over, InteractiveEvent);
			addViewListener(InteractiveEvent.HAND_OUT, view.out, InteractiveEvent);	
			
			addContextListener(FilterEvent.DISELECT, view.diselect, FilterEvent);
			addContextListener(FilterEvent.SELECT, view.select, FilterEvent);
		}
	}	
}


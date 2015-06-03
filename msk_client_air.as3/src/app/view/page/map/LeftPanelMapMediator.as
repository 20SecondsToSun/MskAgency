package app.view.page.map
{
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.FilterEvent;
	import app.contoller.events.InteractiveEvent;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class LeftPanelMapMediator extends Mediator
	{
		[Inject]
		public var view:LeftPanelMap;
		
		override public function onRegister():void
		{
			addViewListener(InteractiveEvent.HAND_OVER, view.over, InteractiveEvent, true);
			addViewListener(InteractiveEvent.HAND_OUT, view.out, InteractiveEvent, true);
			addViewListener(InteractiveEvent.HAND_PUSH, view.push, InteractiveEvent, true);
			addViewListener(InteractiveEvent.HAND_CHARGED, view.charged, InteractiveEvent, true);
			addViewListener(FilterEvent.SET_NULL, dispatch, FilterEvent);
			addContextListener(FilterEvent.GEO_NEWS_SORTED, view.changeButtonsSorted, FilterEvent);
			addViewListener(FilterEvent.SORT_GEO_NEWS, dispatch, FilterEvent);		
			addViewListener(DataLoadServiceEvent.LOAD_GEO_DATA, dispatch, DataLoadServiceEvent);
		}
		
		override public function onRemove():void
		{
			removeViewListener(FilterEvent.SET_NULL, dispatch, FilterEvent);
			removeViewListener(InteractiveEvent.HAND_OVER, view.over, InteractiveEvent, true);
			removeViewListener(InteractiveEvent.HAND_OUT, view.out, InteractiveEvent, true);
			removeViewListener(InteractiveEvent.HAND_PUSH, view.push, InteractiveEvent, true);
			removeViewListener(InteractiveEvent.HAND_CHARGED, view.charged, InteractiveEvent, true);
			removeViewListener(FilterEvent.SORT_GEO_NEWS, dispatch, FilterEvent);
			removeViewListener(FilterEvent.GEO_NEWS_SORTED, view.changeButtonsSorted, FilterEvent);
			removeViewListener(DataLoadServiceEvent.LOAD_GEO_DATA, dispatch, DataLoadServiceEvent);
		}	
	}
}
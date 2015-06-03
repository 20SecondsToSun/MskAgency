package app.view.page.fact.leftpanel
{
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.InteractiveEvent;
	import app.model.datafact.IFactsModel;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FactLeftPanelSliderMediator extends Mediator
	{
		[Inject]
		public var view:FactLeftPanelSlider;
		
		[Inject]
		public var fmodel:IFactsModel;
		
		override public function onRegister():void
		{
			addContextListener(AnimationEvent.PAGE_ANIMATION_FINISHED, waittoload, AnimationEvent);			
			addContextListener(DataLoadServiceEvent.RELOAD_DATA, reloadData, DataLoadServiceEvent);		
		}
		
		private function reloadData(e:DataLoadServiceEvent):void 
		{	
			var evt:DataLoadServiceEvent = new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_FACTS_DAY, true, false, -1, null, {date: fmodel.sliderDate});
			dispatch(evt);
		}
		
		private function waittoload(e:AnimationEvent):void
		{
			removeContextListener(AnimationEvent.PAGE_ANIMATION_FINISHED, waittoload, AnimationEvent);
			addContextListener(DataLoadServiceEvent.LOAD_COMPLETED_DAY_FACTS, initData, DataLoadServiceEvent, false, 0, true);
			var evt:DataLoadServiceEvent = new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_FACTS_DAY, true, false, -1, null, {date: fmodel.sliderDate});
			dispatch(evt);
		}
		
		private function initData(e:DataLoadServiceEvent):void
		{
			view.date = fmodel.sliderDate;
			view.init(fmodel.dayNewsList, fmodel.activeMaterial.id);
			
			eventMap.mapListener(view.backToDates, InteractiveEvent.HAND_OVER, overbackToDates, InteractiveEvent);
			eventMap.mapListener(view.backToDates, InteractiveEvent.HAND_OUT, outbackToDates, InteractiveEvent);
			eventMap.mapListener(view.backToDates, InteractiveEvent.HAND_CHARGED, changeLocationToHourNews, InteractiveEvent);
		}
		
		private function changeLocationToHourNews(e:InteractiveEvent):void
		{
			var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.BACK_FROM_ONE_NEW);
			dispatch(event);
		}
		
		private function outbackToDates(e:InteractiveEvent):void
		{
			view.outbackToDates();
		}
		
		private function overbackToDates(e:InteractiveEvent):void
		{
			view.overbackToDates();
		}
		
		override public function preRemove():void
		{
			removeContextListener(DataLoadServiceEvent.LOAD_COMPLETED_ALL_NEWS, initData, DataLoadServiceEvent);
			removeContextListener(DataLoadServiceEvent.RELOAD_DATA, reloadData, DataLoadServiceEvent);
			eventMap.unmapListeners();
			view.remove();
		}
	}
}
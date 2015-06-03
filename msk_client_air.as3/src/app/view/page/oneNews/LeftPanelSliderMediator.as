package app.view.page.oneNews
{
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.ChangeTimeToShowEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.InteractiveEvent;
	import app.model.dataall.IAllNewsModel;
	import flash.events.Event;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class LeftPanelSliderMediator extends Mediator
	{
		[Inject]
		public var view:LeftPanelSlider;
		
		[Inject]
		public var model:IAllNewsModel;
		
		override public function onRegister():void
		{
			//addContextListener(AnimationEvent.PAGE_ANIMATION_FINISHED, waittoload, AnimationEvent);	
			
			model.offsetLoad = 0;
			
			addContextListener(DataLoadServiceEvent.LOAD_COMPLETED_ALL_NEWS, initData, DataLoadServiceEvent, false, 0, true);
			addContextListener(DataLoadServiceEvent.NO_MATERIALS_SLIDER, view.offLoading, DataLoadServiceEvent);
			
			var evt:DataLoadServiceEvent = new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_MATERIAL_NEAR_NEWS);
			evt.mat = model.activeMaterial;
			dispatch(evt);
			
			addViewListener(DataLoadServiceEvent.LOAD_ALL_MATERIAL_NEAR_NEWS, loadAddon, DataLoadServiceEvent);
			
			addViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
			addContextListener(DataLoadServiceEvent.RELOAD_DATA, reloadData, DataLoadServiceEvent);
		}
		
		private function reloadData(e:DataLoadServiceEvent):void
		{
			var evt:DataLoadServiceEvent = new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_MATERIAL_NEAR_NEWS);
			evt.mat = model.activeMaterial;
			dispatch(evt);
		}
		
		private function removeHandler(e:Event):void
		{
			removeViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
			model.offsetLoad = 0;
		
		}
		
		private function loadAddon(e:Event):void
		{
			//if (view.isNeedToUpdate)
			//{
			model.sliderLoading = true;
			var evt:DataLoadServiceEvent = new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_MATERIAL_NEAR_NEWS);
			evt.mat = model.activeMaterial;
			dispatch(evt);
			//trace("LoadADDON", view.limit, view.offset);
			//}
		
		}
		
		private function waittoload(e:AnimationEvent):void
		{
			//removeContextListener(AnimationEvent.PAGE_ANIMATION_FINISHED, waittoload, AnimationEvent);			
		
		}
		
		private function initData(e:DataLoadServiceEvent):void
		{
			var id:int = model.activeMaterial.id;
			var date:Date = model.activeMaterial.publishedDate;
			
			view.init(model.allSortByDate(date), id);
			
			eventMap.mapListener(view.backToDates, InteractiveEvent.HAND_OVER, overbackToDates, InteractiveEvent);
			eventMap.mapListener(view.backToDates, InteractiveEvent.HAND_OUT, outbackToDates, InteractiveEvent);
			//eventMap.mapListener(view.backToDates, InteractiveEvent.HAND_PUSH, changeLocationToHourNews, InteractiveEvent);	
			eventMap.mapListener(view.backToDates, InteractiveEvent.HAND_CHARGED, changeLocationToHourNews, InteractiveEvent);
			addViewListener(ChangeTimeToShowEvent.CHANGE_TIME, changeTime, ChangeTimeToShowEvent, true, 0, false);
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
		
		private function changeTime(e:ChangeTimeToShowEvent):void
		{
			view.addHourTitle(e.hour);
		}
		
		override public function preRemove():void
		{
			removeContextListener(DataLoadServiceEvent.RELOAD_DATA, reloadData, DataLoadServiceEvent);
			removeContextListener(DataLoadServiceEvent.LOAD_COMPLETED_ALL_NEWS, initData, DataLoadServiceEvent);
			removeViewListener(ChangeTimeToShowEvent.CHANGE_TIME, changeTime, ChangeTimeToShowEvent);
			eventMap.unmapListeners();
			view.remove();
		}
	}
}
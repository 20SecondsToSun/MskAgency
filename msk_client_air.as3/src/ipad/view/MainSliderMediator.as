package ipad.view
{
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.IpadEvent;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import ipad.model.IInfo;
	import ipad.model.ipad.IIpadFactsModel;
	import ipad.model.ipad.IIpadNewsModel;
	import ipad.view.slider.Element;
	import ipad.view.slider.ElementFact;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class MainSliderMediator extends Mediator
	{
		[Inject]
		public var view:MainSlider;
		[Inject]
		public var model:IIpadNewsModel;
		[Inject]
		public var factmodel:IIpadFactsModel;
		
		override public function onRegister():void
		{
			if (view.type == "fact")
			{
				factmodel.currentDate = "";
				factmodel.nextDate = "";
			}
			
			eventMap.mapListener(view.stage, MouseEvent.MOUSE_UP, stopDragElement, MouseEvent);
			addViewListener(MouseEvent.MOUSE_DOWN, startDragElement, MouseEvent);
			addViewListener(Event.REMOVED_FROM_STAGE, removeHandler, Event);
			addViewListener(IpadEvent.LOAD_MORE, loadMore, IpadEvent);
			addContextListener(IpadEvent.FILTER_CHANGED, filterChanged, IpadEvent);
			addContextListener(IpadEvent.NO_MATERIALS, view.nomaterials, IpadEvent);
			addContextListener(IpadEvent.MATERIALS_LOADED, refreshData, IpadEvent);
		}
		
		private function refreshData(e:IpadEvent):void
		{
			switch (view.type)
			{
				case "fact": 
					factmodel.newSearch = false;
					view.setFactData(factmodel.newsList);
					break;
				
				default: 
					view.setdata(model.newsList);
			}
		}
		
		private function filterChanged(e:IpadEvent):void
		{
			view.isNeedToClear = true;
			view._filters.limit = 20;
			view._filters.offset = 0;
			view._filters.addFilter(e.data.name, e.data.filter);
			
			if (view.type == "fact")
			{
				view.oneLoadCounter = 0;
				factmodel.newSearch = true;
				
				//if (e.data.name == "to") factmodel.finishDate = e.data.filter;
				
				
				factmodel.idsArray = new Vector.<int>();
				view.clearSlider();
					//view.isNeedToClear = false;
			}
			
			if (e.data.update && e.data.update == "no")
				return;
				
			factmodel.finishDate =   view._filters.to;
			
			loadByType();
		}
		
		
		
		private function loadMore(e:IpadEvent):void
		{
			//if (view.type == "fact") return;
			view.isNeedToClear = false;
			view._filters.offset += view._filters.limit;
			loadByType();
		}
		
		private function loadByType():void
		{
			switch (view.type)
			{
				case "map": 
					dispatch(new IpadEvent(IpadEvent.LOAD_MAP_MATERIALS, true, false, view._filters));
					break;
				
				case "fact": 
					dispatch(new IpadEvent(IpadEvent.LOAD_FACTS, true, false, view._filters));
					break;
				
				default: 
					dispatch(new IpadEvent(IpadEvent.LOAD_MATERIALS, true, false, view._filters));
			}
		}
		
		private function removeHandler(e:Event):void
		{
			removeViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
			view.kill();
		}
		
		private function stopDragElement(e:MouseEvent):void
		{
			view.slider.startInteraction();
			TweenLite.killDelayedCallsTo(startDragElementDelay);
			eventMap.unmapListener(view.stage, MouseEvent.MOUSE_MOVE, view.updateDragElement, MouseEvent);
			view.removeDragElement(e.stageX, e.stageY);
		}
		
		private function startDragElement(e:MouseEvent):void
		{
			if (e.target is Element)
			{
				if ((e.target as Element).isActive)
				{
					(e.target as Element).isActive = false;
					(e.target as Element).clear();
					dispatch(new IpadEvent(IpadEvent.CLOSE_MATERIAL));
					view.showingMat = null;
					return;
				}
				
				view.setCandidate(e.target as Element);
				TweenLite.delayedCall(0.5, startDragElementDelay);
			}
			else if (e.target is ElementFact)
			{
				if ((e.target as ElementFact).isActive)
				{
					// send close
					(e.target as ElementFact).isActive = false;
					(e.target as ElementFact).clear();
					dispatch(new IpadEvent(IpadEvent.CLOSE_MATERIAL));
					view.showingMat = null;
					return;
				}
				
				view.setCandidate(e.target as ElementFact);
				TweenLite.delayedCall(0.5, startDragElementDelay);
			}
		}
		
		private function startDragElementDelay():void
		{
			if (view.checkCandidate())
			{
				view.slider.stopInteraction();
				eventMap.mapListener(view.stage, MouseEvent.MOUSE_MOVE, view.updateDragElement, MouseEvent);
			}
		}
	}
}
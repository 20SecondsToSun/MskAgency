
package app.view.facts
{
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.InteractiveEvent;
	import app.model.dataall.IAllNewsModel;
	import app.model.datafact.IFactsModel;
	import flash.events.Event;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class OneFactGraphicMediator extends Mediator
	{
		[Inject]
		public var view:OneFactGraphic;
		
		[Inject]
		public var model:IAllNewsModel;
		
		[Inject]
		public var fmodel:IFactsModel;
		
		override public function onRegister():void
		{
			addViewListener(InteractiveEvent.HAND_OVER, view.overState, InteractiveEvent);
			addViewListener(InteractiveEvent.HAND_OUT, view.outState, InteractiveEvent);
			addViewListener(InteractiveEvent.HAND_PUSH, pushFact, InteractiveEvent);
			addViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
		}
		
		private function removeHandler(e:Event):void
		{
			removeViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
			removeViewListener(InteractiveEvent.HAND_OVER, view.overState, InteractiveEvent);
			removeViewListener(InteractiveEvent.HAND_OUT, view.outState, InteractiveEvent);
			removeViewListener(InteractiveEvent.HAND_PUSH, pushFact, InteractiveEvent);
			view.kill();		
		}
		
		private function pushFact(e:InteractiveEvent):void
		{
			fmodel.activeMaterial = view.factData;
			fmodel.sliderDate = (view.parent as FactsGraphic).currentDate;
			model.setChoosenField({rec: view.getSelfRec()});
			
			var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.ONE_NEW_FACT_PAGE);
			event.mode = "EXPAND_MODE";
			dispatch(event);
		}
	}
}
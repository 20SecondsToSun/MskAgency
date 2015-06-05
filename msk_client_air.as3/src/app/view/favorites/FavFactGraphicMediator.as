package app.view.favorites
{
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.InteractiveEvent;
	import app.model.datafact.IFactsModel;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	
	public class FavFactGraphicMediator extends Mediator
	{
		[Inject]
		public var view:FavFactGraphic;
		
		[Inject]
		public var model:IFactsModel;
		
		override public function onRegister():void
		{
			addViewListener(InteractiveEvent.HAND_OVER, overView, InteractiveEvent);
			addViewListener(InteractiveEvent.HAND_OUT, outView, InteractiveEvent);
		}
		
		override public function preRemove():void
		{
			removeViewListener(InteractiveEvent.HAND_OVER, overView, InteractiveEvent);
			removeViewListener(InteractiveEvent.HAND_OUT, outView, InteractiveEvent);
		}
		
		private function pushView(e:InteractiveEvent):void
		{
			var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.SHOW_NEW_BY_ID);
			event.obj = view.fact;
			dispatch(event);
		}
		
		private function outView(e:InteractiveEvent):void
		{
			view.out();
		}
		
		private function overView(e:InteractiveEvent):void
		{
			view.over();
		}
	}
}
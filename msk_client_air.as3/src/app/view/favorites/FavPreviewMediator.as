package app.view.favorites 
{
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.InteractiveEvent;
	import app.model.dataall.IAllNewsModel;
	import app.model.materials.Material;
	import org.robotlegs.mvcs.Mediator;
	/**
	 * ...
	 * @author metalcorehero
	 */

	public class FavPreviewMediator extends Mediator
	{
		[Inject]
		public var view:FavPreview;
		
		[Inject]
		public var model:IAllNewsModel;
		
		override public function onRegister():void
		{			
			addViewListener(InteractiveEvent.HAND_OVER, view.overState,	InteractiveEvent);
			addViewListener(InteractiveEvent.HAND_OUT, view.outState,	InteractiveEvent);				
			eventMap.mapListener(view, InteractiveEvent.HAND_PUSH, pushView, InteractiveEvent);		
		}		
		
		private function charged(e:InteractiveEvent):void 
		{
			
		}
		
		override public function preRemove():void
		{			
			removeViewListener(InteractiveEvent.HAND_OVER, view.overState,	InteractiveEvent);
			removeViewListener(InteractiveEvent.HAND_OUT, view.outState,	InteractiveEvent);			
			eventMap.unmapListener(view, InteractiveEvent.HAND_PUSH, pushView, InteractiveEvent);				
		}		
	
		private function pushView(e:InteractiveEvent):void 
		{
			if (!view.isActive)
			{
				var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.SHOW_NEW_BY_ID);
				event.data= view.oneNewData;				
				dispatch(event);
			}			
		}		
	}
}
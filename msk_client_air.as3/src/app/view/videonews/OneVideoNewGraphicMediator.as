
package app.view.videonews
{
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.InteractiveEvent;
	import app.model.dataall.IAllNewsModel;
	import flash.events.Event;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class OneVideoNewGraphicMediator extends Mediator
	{
		[Inject]
		public var view:OneVideoNewGraphic;
		
		[Inject]
		public var model:IAllNewsModel;
		
		override public function onRegister():void
		{
			addViewListener(InteractiveEvent.HAND_OVER, overVideo, InteractiveEvent);
			addViewListener(InteractiveEvent.HAND_OUT, outVideo, InteractiveEvent);
			eventMap.mapListener(view, InteractiveEvent.HAND_PUSH, pushVideo, InteractiveEvent);
			
			addViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
		}
		
		private function removeHandler(e:Event):void 
		{
			removeViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
			removeListeners();
			view.kill();
		}		
		
		private function removeListeners():void
		{
			removeViewListener(InteractiveEvent.HAND_OVER, overVideo, InteractiveEvent, true);
			removeViewListener(InteractiveEvent.HAND_OUT, outVideo, InteractiveEvent, true);
			eventMap.unmapListener(view, InteractiveEvent.HAND_PUSH, pushVideo, InteractiveEvent);
		}
		
		private function pushVideo(e:InteractiveEvent):void
		{			
			model.activeMaterial = view.mat;
			model.setChoosenField({rec: view.getSelfRec()});
			
			var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.ONE_NEW_PAGE);
			event.mode = "EXPAND_MODE";
			dispatch(event);
		}
		
		private function outVideo(e:InteractiveEvent):void
		{
			view.outState();
		}
		
		private function overVideo(e:InteractiveEvent):void
		{
			view.overState();
		}
	}
}
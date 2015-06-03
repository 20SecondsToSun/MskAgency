package app.view.photonews
{	
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.InteractiveEvent;
	import app.model.dataall.IAllNewsModel;
	import app.model.dataphoto.IPhotoNewsModel;
	import flash.events.Event;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class OnePhotoGraphicMediator extends Mediator
	{
		[Inject]
		public var view:OnePhotoGraphic;
		
		[Inject]
		public var model:IAllNewsModel;
		
		[Inject]
		public var photoModel:IPhotoNewsModel;
		
		override public function onRegister():void
		{			
			addViewListener(InteractiveEvent.HAND_OVER, view.overState,	InteractiveEvent);
			addViewListener(InteractiveEvent.HAND_OUT, view.outState,	InteractiveEvent);			
			eventMap.mapListener(view, InteractiveEvent.HAND_PUSH, pushVideo, InteractiveEvent);	
			
			addViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
		}	
		
		private function removeHandler(e:Event):void 
		{
			removeViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
			removeViewListener(InteractiveEvent.HAND_OVER, view.overState,	InteractiveEvent);
			removeViewListener(InteractiveEvent.HAND_OUT, view.outState,	InteractiveEvent);			
			eventMap.unmapListener(view, InteractiveEvent.HAND_PUSH, pushVideo, InteractiveEvent);	
			view.kill();
		}
		
		private function pushVideo(e:InteractiveEvent):void 
		{	
			model.activeMaterial = photoModel.getMaterialByID(view.id);			
			model.setChoosenField({ rec:view.getSelfRec()});	
			
			var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.ONE_NEW_PAGE);
			event.mode = "EXPAND_MODE";
			dispatch(event);	
		}	
	}
}
package ipad.view.locations
{
	import app.contoller.events.IpadEvent;
	import flash.events.MouseEvent;
	import ipad.model.IInfo;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class BroadcastPageMediator extends Mediator
	{
		[Inject]
		public var view:BroadcastPage;
		
		[Inject]
		public var info:IInfo;
		
		override public function onRegister():void
		{
			view.init(info.volume);
			dispatch(new IpadEvent(IpadEvent.VOLUME, true, false, info.volume));
			
			eventMap.mapListener(view, MouseEvent.MOUSE_DOWN, startDragSlider, MouseEvent);	
			addViewListener(IpadEvent.VOLUME, changeVolume, IpadEvent );
		}
		
		private function changeVolume(e:IpadEvent):void 
		{
			info.volume = e.data;
			dispatch(e.clone());
		}
		
		private function startDragSlider(e:MouseEvent):void 
		{
			if (e.target.name == "vol")
			{
				view.startDragSlider(e.stageX);
				eventMap.mapListener(view.stage, MouseEvent.MOUSE_MOVE, view.updateDragSlider, MouseEvent);
				eventMap.mapListener(view.stage, MouseEvent.MOUSE_UP, stopDragSlider, MouseEvent);	
			}
		}
		
		private function stopDragSlider(e:MouseEvent):void 
		{
			eventMap.unmapListener(view.stage, MouseEvent.MOUSE_MOVE, view.updateDragSlider,MouseEvent);
			eventMap.unmapListener(view.stage, MouseEvent.MOUSE_UP, stopDragSlider, MouseEvent);	
		}
	}
}
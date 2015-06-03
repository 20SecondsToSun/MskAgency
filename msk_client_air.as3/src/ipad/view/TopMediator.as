package ipad.view
{
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.IpadEvent;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import ipad.model.IInfo;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class TopMediator extends Mediator
	{
		[Inject]
		public var view:Top;
		
		[Inject]
		private var _contextView:DisplayObjectContainer;
		
		[Inject]
		public var info:IInfo;
		
		override public function onRegister():void
		{
			//addViewListener(MouseEvent.CLICK, clickMenu, MouseEvent, true);
			addViewListener(DataLoadServiceEvent.LOAD_ALL_DATA_FOR_IPAD, dispatch, DataLoadServiceEvent);
			addViewListener(Event.REMOVED_FROM_STAGE, removeHandler, Event);
			addViewListener(IpadEvent.FILTER_CHANGED, filterChanged, IpadEvent);	
			addViewListener(IpadEvent.MENU_OPENED, menuOpened, IpadEvent);	
			
			addContextListener(IpadEvent.HAND_ACTIVE, txtInvisible, IpadEvent);			
			addContextListener(IpadEvent.HAND_LOST, txtVisible, IpadEvent);			
			addContextListener(IpadEvent.START_INTERACTION, txtVisible, IpadEvent);			
			addContextListener(IpadEvent.STOP_INTERACTION, txtInvisible, IpadEvent);
			
			if (info.isHandActive) view.txtInvisible();
		}		
		
		private function txtVisible(e:IpadEvent):void 
		{
			if (info.isHandActive) view.txtInvisible();
			else view.txtVisible();
		}
		
		private function txtInvisible(e:IpadEvent):void 
		{
			view.txtInvisible();
		}
		
		private function filterChanged(e:IpadEvent):void 
		{
			dispatch( new IpadEvent(IpadEvent.CLOSE_MATERIAL));
			dispatch(e.clone());
			view.changeState();
		}
	
		private function menuOpened(e:IpadEvent):void 
		{
			view.bringTargetFront(e.target);		
		}
		
		private function removeHandler(e:Event):void
		{
			removeViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
			view.kill();
		}
		
		private function clickMenu(e:MouseEvent):void
		{
			//trace("PUSH!!", e.target,e.currentTarget);
			/*if (e.target.name == "search")
			{
				trace('search', view.initText, view.myTextField.text);
				if (view.myTextField.text != view.initText)
				{
					var data:Object = {filter: view.myTextField.text};
					dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_DATA_FOR_IPAD, true, false, -1, null, data));
				}
			}*/
		}
	}
}
package ipad.view.locations
{
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.GraphicInterfaceEvent;
	import app.contoller.events.IpadEvent;
	import flash.events.MouseEvent;
	import ipad.model.IInfo;
	import ipad.view.locations.buttons.PlButton;
	import ipad.view.locations.buttons.SetButton;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	
	public class MainPageMediator extends Mediator
	{
		[Inject]
		public var view:MainPage;
		
		[Inject]
		public var info:IInfo;
		
		override public function onRegister():void
		{
			view.init(info.primaryScreen, info.isKinectUser, info.playState);			
			addViewListener(MouseEvent.MOUSE_DOWN, clickbtn, MouseEvent);
			addContextListener(IpadEvent.USER_LOST, kinectUserChanged,IpadEvent )
			addContextListener(IpadEvent.USER_ACTIVE, kinectUserChanged,IpadEvent )
			//dispatchEvent(new IpadEvent(IpadEvent.USER_LOST));	
			//addContextListener(GraphicInterfaceEvent.CHANGE_PRIMARY_SCREEN, clickedBtn, GraphicInterfaceEvent);
		}
		
		private function kinectUserChanged(e:IpadEvent):void
		{
			view.kinectUserChanged(info.isKinectUser, info.playState);	
		}
		
		private function clickbtn(e:MouseEvent):void
		{
			if (e.target is SetButton)
			{
				info.primaryScreen = view.locName;
				view.setActive();
				dispatch(new GraphicInterfaceEvent(GraphicInterfaceEvent.CHANGE_PRIMARY_SCREEN, null, ChangeLocationEvent.MAIN_SCREEN));				
			}
			else if (e.target is PlButton)
			{
				if (info.isKinectUser)	
				{
					view.playButton.kinectUserShow();
					return;
				}
				view.playButton.kinectUserHide();
				info.playState = !info.playState;
				view.setPlayPause(info.playState);
				
				if (info.playState) 
					dispatch(new IpadEvent(IpadEvent.PLAY));	
				else 
					dispatch(new IpadEvent(IpadEvent.PAUSE));			
			}
		}
	}
}
package app.view.handsview
{
	import app.AppSettings;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.InteractiveRemoteEvent;
	import app.contoller.events.IpadEvent;
	import app.model.datauser.IUser;
	import app.services.interactive.gestureDetector.GestureEvent;
	import flash.events.MouseEvent;
	import org.robotlegs.mvcs.Mediator;

	/**
	 * ...
	 * @author metalcorehero
	 */
	public class HandsViewMediator extends Mediator
	{
		[Inject]
		public var view:HandsView;
		
		[Inject]
		public var user:IUser;
	
		override public function onRegister ():void
		{
			view.init();
			
			addContextListener(InteractiveRemoteEvent.USER_LOST, userLost);
			addContextListener(InteractiveRemoteEvent.USER_ACTIVE, userActive);
			addContextListener(InteractiveRemoteEvent.ACTIVATE_HAND, handActive);
			addContextListener(InteractiveEvent.DEACTIVATE_HAND, handLost );
			
			addContextListener(InteractiveRemoteEvent.HAND_UPDATE, updateHandPosition);
			addContextListener(InteractiveRemoteEvent.HAND_DOWN, downHand);
			addContextListener(InteractiveRemoteEvent.HAND_UP,   upHand);	
			addContextListener(InteractiveEvent.HAND_PUSH, pushHand);			
			addContextListener(InteractiveEvent.HAND_TWO_FINGERS, view.fingerUpdater);			
			addContextListener(InteractiveEvent.HAND_THREE_FINGERS, view.fingerUpdater);			
			addContextListener(InteractiveEvent.HAND_ONE_FINGER, view.fingerUpdater);
			
			addViewListener(GestureEvent.HAND_ONE_FINGER, fingerDone, GestureEvent, true);			
			addViewListener(GestureEvent.HAND_TWO_FINGERS, fingerDone, GestureEvent, true);			
			addViewListener(GestureEvent.HAND_THREE_FINGERS, fingerDone, GestureEvent, true);			
			addViewListener(GestureEvent.FINGER_FAILED, fingerFailed, GestureEvent, true);				
			
			addContextListener(IpadEvent.IPAD_DISCONNECTING, disconnectIpad);
			addContextListener(IpadEvent.IPAD_CONNECTING, connectIpad);				
		}
		
		private function connectIpad(e:IpadEvent):void 
		{
			view.hideHand();
		}
		
		private function disconnectIpad(e:IpadEvent):void 
		{
			view.showHand();
		}
		
		private function fingerFailed(e:GestureEvent):void 
		{
			view.fingerDone(e);
		}
		
		private function fingerDone(e:GestureEvent):void 
		{
			view.fingerDone(e);
			
			switch (e.type)
			{
				case "HAND_ONE_FINGER": 
					dispatch( new ChangeLocationEvent(ChangeLocationEvent.MAIN_SCREEN));
					break;
					
				case "HAND_TWO_FINGERS":					
					dispatch( new ChangeLocationEvent(ChangeLocationEvent.CUSTOM_SCREEN));
					break;
					
				case "HAND_THREE_FINGERS": 
					dispatch( new ChangeLocationEvent(ChangeLocationEvent.STORY_SCREEN));
					break;
					
				default: 
			}
		}
		
		private function handActive(e:InteractiveRemoteEvent):void 
		{
			view.activateHand(e.handType);
		}
		
		private function handLost(e:InteractiveRemoteEvent):void 
		{
			view.loseHand(e.handType);
		}
		
		private function userLost(e:InteractiveRemoteEvent):void 
		{
			view.hideHand();
		}
		
		private function userActive(e:InteractiveRemoteEvent):void 
		{				
			view.showHand();
		}
		
		private function updateHandPosition(e:InteractiveRemoteEvent):void 
		{	
			if (user.is_active == false) return;
			
			//trace(e.stageX, e.stageY);
			
			view.updateHand(e.stageX, e.stageY, e.stageZ, e.handType);	
			
			if (view.checkHand())
			{				
				if (user.isHandActive)
				{
					user.isHandActive = false;				
					dispatch( new IpadEvent(IpadEvent.HAND_LOST));
				}											
			}
			else if (!user.isHandActive)
			{				
				user.isHandActive = true;
				dispatch( new IpadEvent(IpadEvent.HAND_ACTIVE));
			}
		}
		
		private function pushHand(e:InteractiveRemoteEvent):void 
		{
			view.pushHand(e.stageX, e.stageY, e.stageZ, e.handType);	
		}
		
		private function upHand(e:InteractiveRemoteEvent):void 
		{		
			view.upHand();
		}
		
		private function downHand(e:InteractiveRemoteEvent):void 
		{				
			view.downHand();
		}		
	}
}
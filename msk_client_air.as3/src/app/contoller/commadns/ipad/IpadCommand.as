package app.contoller.commadns.ipad
{
	import app.contoller.events.IpadEvent;
	import app.model.datauser.IUser;
	import app.services.dataloading.ISocketService;
	import app.services.interactive.IInteractiveControlService;
	import app.services.ipad.IIpadService;
	import ipad.model.IInfo;
	import org.robotlegs.mvcs.Command;
	import app.services.state.INavigationService
	
	public class IpadCommand extends Command
	{
		[Inject]
        public var user:IUser;
		
		[Inject]
        public var event:IpadEvent;
		
		[Inject]
        public var ipadService:IIpadService;
		
		[Inject]
		public var navigationService:INavigationService;
		
		[Inject]
		public var socketService:ISocketService;
		
		[Inject]
		public var iControlService:IInteractiveControlService;
		
		override public function execute():void
		{
			switch (event.type) 
			{
				case IpadEvent.PLAY:
					
					if (ipadService.isPause == false) return;
					
					ipadService.isPause = false;
					
					if (user.is_active) return;
					
					navigationService.returnToMainScreen(true);
					socketService.start();
					
				break;
				
				case IpadEvent.PAUSE:
				
					if (ipadService.isPause == true) return;
					
					ipadService.isPause = true;
					navigationService.returnToMainScreen(false);
					socketService.stop();	
					
				break;
				
				case IpadEvent.HAND_ACTIVE:
					ipadService.handActive();
				break;
				
				case IpadEvent.HAND_LOST:
					ipadService.handLost();
				break;
				
				case IpadEvent.IPAD_CONNECTING:
					iControlService.isIpadConnect = true;
				break;
				
				case IpadEvent.IPAD_DISCONNECTING:
					iControlService.isIpadConnect = false;
				break;
				
				
				default:
			}
		}
	}
}
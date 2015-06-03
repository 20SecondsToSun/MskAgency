package app.contoller.commadns
{
	import app.contoller.events.InteractiveRemoteEvent;
	import app.model.datauser.IUser;
	import app.services.dataloading.ISocketService;
	import app.services.ipad.IIpadService;
	import app.services.state.INavigationService;
	import org.robotlegs.mvcs.Command;
	
	public class UserLostCommand extends Command
	{
		[Inject]
		public var navigationService:INavigationService;
		
		[Inject]
		public var socketService:ISocketService;
		
		[Inject]
		public var user:IUser;
		
		[Inject]
		public var ipad:IIpadService;
		
		override public function execute():void
		{
			if (!user.is_active) 
				return;
			
			user.is_active = false;
			dispatch(new InteractiveRemoteEvent(InteractiveRemoteEvent.USER_LOST_FOR_ALL_SYSTEM));
			ipad.userLost();		
			
			navigationService.returnToMainScreen(true);
			socketService.start();			
		}
	}
}
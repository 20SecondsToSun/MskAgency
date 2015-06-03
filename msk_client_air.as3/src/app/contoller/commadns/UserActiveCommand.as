package app.contoller.commadns
{	
	import app.contoller.events.InteractiveRemoteEvent;
	import app.model.datauser.IUser;
	import app.services.dataloading.ISocketService;
	import app.services.ipad.IIpadService;
	import app.services.state.INavigationService;
	import org.robotlegs.mvcs.Command;
	
	public class UserActiveCommand extends Command
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
			if (user.is_active) return;
			
			user.is_active = true;
			dispatch(new InteractiveRemoteEvent(InteractiveRemoteEvent.USER_ACTIVE_FOR_ALL_SYSTEM));
			
			navigationService.returnToMainScreen(false);
			socketService.stop();	
			ipad.userActive();
		}
	}
}
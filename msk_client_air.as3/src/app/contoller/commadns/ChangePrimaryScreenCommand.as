package app.contoller.commadns
{
	import app.contoller.events.IpadEvent;
	import app.model.datauser.IUser;
	import ipad.model.IInfo;
	import org.robotlegs.mvcs.Command;
	import ipad.services.state.INavigationService
	
	public class ChangePrimaryScreenCommand extends Command
	{
		[Inject]
        public var user:IUser;
		
		[Inject]
        public var event:IpadEvent;
		
		override public function execute():void
		{
			user.primaryScreen = event.data;
		}
	}
}
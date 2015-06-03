package ipad.controller.commands
{
	import org.robotlegs.mvcs.Command;
	import ipad.services.state.INavigationService
	
	public class StartNavigationCommand extends Command
	{
		[Inject]
        public var nav:INavigationService;
		
		override public function execute():void
		{
			nav.start();
		}
	}
}
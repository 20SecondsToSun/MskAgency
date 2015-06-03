package app.contoller.commadns.navigation
{  

	import app.services.state.INavigationService;
	import org.robotlegs.mvcs.Command;

    public class ShowMenuNavigationCommand extends Command
    {
      
		[Inject]
        public var navigationService:INavigationService;
		
	
	
        override public function execute():void
        {			
			navigationService.showMenu();
        }
    }
}
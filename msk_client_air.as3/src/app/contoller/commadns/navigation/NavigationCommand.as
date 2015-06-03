package app.contoller.commadns.navigation
{  
	import app.contoller.events.ChangeLocationEvent;
	import app.services.state.INavigationService;
	import org.robotlegs.mvcs.Command;

    public class NavigationCommand extends Command
    {      
		[Inject]
        public var navigationService:INavigationService;
		
		[Inject]
        public var cngLocEvent:ChangeLocationEvent;
	
        override public function execute():void
        {		
			navigationService.location(cngLocEvent);
        }		
    }
}
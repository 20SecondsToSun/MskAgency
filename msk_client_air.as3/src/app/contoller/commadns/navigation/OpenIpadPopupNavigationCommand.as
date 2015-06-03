package app.contoller.commadns.navigation
{  

	import app.contoller.events.IpadEvent;
	import app.services.state.INavigationService;
	import org.robotlegs.mvcs.Command;

    public class OpenIpadPopupNavigationCommand extends Command
    {
      
		[Inject]
        public var navigationService:INavigationService;
		
		[Inject]
        public var event:IpadEvent;
	
        override public function execute():void
        {			
			navigationService.openPopup(event.data);
        }
    }
}
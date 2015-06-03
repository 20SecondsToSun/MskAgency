package app.contoller.commadns.navigation
{  

	import app.services.state.INavigationService;
	import org.robotlegs.mvcs.Command;

    public class HideIpadPopupNavigationCommand extends Command
    {
      	[Inject]
        public var navigationService:INavigationService;
		
        override public function execute():void
        {	
			navigationService.hideIpadPopup();
        }
    }
}
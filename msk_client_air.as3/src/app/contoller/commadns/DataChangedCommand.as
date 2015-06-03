package app.contoller.commadns
{   
	import app.services.interactive.IInteractiveControlService;
	import app.services.ipad.IIpadService;
	import app.services.state.INavigationService;
	import org.robotlegs.mvcs.Command;

    public class DataChangedCommand extends Command
    {
		[Inject]
        public var nav:INavigationService;
	
		
        override public function execute():void
        {	
			nav.returnToMainScreen(true);
        }
    }
}
package app.contoller.commadns
{   
	import app.services.interactive.IInteractiveControlService;
	import app.services.ipad.IIpadService;
	import org.robotlegs.mvcs.Command;

    public class StopInteractiveCommand extends Command
    {
		[Inject]
        public var interactiveControlService:IInteractiveControlService;
		
		[Inject]
		public var ipad:IIpadService;
		
        override public function execute():void
        {	
			interactiveControlService.stopInteraction();
			
			if (interactiveControlService.isInteraction == false)
				ipad.stopCommunicate(); 
        }
    }
}
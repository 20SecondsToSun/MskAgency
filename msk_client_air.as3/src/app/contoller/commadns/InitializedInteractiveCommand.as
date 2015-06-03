package app.contoller.commadns
{
   
	import app.services.interactive.IInteractiveControlService;
	import org.robotlegs.mvcs.Command;

    public class InitializedInteractiveCommand extends Command
    {
		[Inject]
        public var interactiveControlService:IInteractiveControlService;	
		

        override public function execute():void
        {	
			interactiveControlService.start();	
        }
    }
}
package app.contoller.commadns
{	
	import app.contoller.events.AnimationEvent;
	import app.services.interactive.IInteractiveControlService;
	import app.services.ipad.IIpadService;
	import org.robotlegs.mvcs.Command;
	
	public class StartInteractiveCommand extends Command
	{
		[Inject]
		public var interactiveControlService:IInteractiveControlService;
		
		[Inject]
		public var ipad:IIpadService;		
		
		override public function execute():void
		{
			interactiveControlService.startInteraction();
			
			if (interactiveControlService.isInteraction == true)
				ipad.startCommunicate();		
		}
	}
}
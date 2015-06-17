package app.contoller.commadns
{
	import app.services.interactive.IInteractiveControlService;
	import org.robotlegs.mvcs.Command;
	
	public class ShutDownCommand extends Command
	{
		[Inject]
		public var iService:IInteractiveControlService;
		
		override public function execute():void
		{
			trace("==============shutDown==============");
		}
	}
}
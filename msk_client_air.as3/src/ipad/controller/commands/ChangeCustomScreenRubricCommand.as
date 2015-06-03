package ipad.controller.commands
{
	import app.contoller.events.GraphicInterfaceEvent;
	import app.contoller.events.IpadEvent;
	import ipad.model.IInfo;
	import org.robotlegs.mvcs.Command;
	import ipad.services.state.INavigationService
	
	public class ChangeCustomScreenRubricCommand extends Command
	{
		[Inject]
        public var info:IInfo;
		
		[Inject]
        public var event:IpadEvent;
		
		override public function execute():void
		{
			info.customScreenRubric = event.data;
		}
	}
}
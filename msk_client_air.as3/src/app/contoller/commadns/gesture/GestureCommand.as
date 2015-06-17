package app.contoller.commadns.gesture
{
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.GesturePostEvent;
	import app.services.interactive.IInteractiveControlService;
	import app.services.state.INavigationService;
	import org.robotlegs.mvcs.Command;

    public class GestureCommand extends Command
    {
      
		[Inject]
       public var iService:IInteractiveControlService;		
		
		[Inject]
        public var event:GesturePostEvent;
	

        override public function execute():void
        {
			
			iService.gestureDetected(event);		
        }
    }
}
package app.contoller.commadns
{  

	import app.contoller.events.AnimationEvent;
	import app.contoller.events.ChangeLocationEvent;
	import app.services.state.INavigationService;
	import org.robotlegs.mvcs.Command;

    public class AnimationFinishedCommand extends Command
    {
      
		[Inject]
        public var navigationService:INavigationService;		
		
		[Inject]
        public var animEvent:AnimationEvent;
	

        override public function execute():void
        {					
			navigationService.animationFinished(animEvent);		  	
        }
    }
}
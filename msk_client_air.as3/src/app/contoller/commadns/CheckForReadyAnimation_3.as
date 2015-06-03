package app.contoller.commadns
{  

	import app.contoller.events.AnimationEvent;
	import app.contoller.events.ChangeLocationEvent;
	import app.services.state.INavigationService;
	import org.robotlegs.mvcs.Command;

    public class CheckForReadyAnimation_3 extends Command
    {
      
		[Inject]
        public var navigationService:INavigationService;	
		
	
	

        override public function execute():void
        {					
			navigationService.checkForReadyAnimation_3();		  	
        }
    }
}
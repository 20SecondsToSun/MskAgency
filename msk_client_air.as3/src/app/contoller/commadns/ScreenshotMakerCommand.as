package app.contoller.commadns
{  

	import app.contoller.events.ScreenshotEvent;
	import app.services.util.IUtilService;
	import org.robotlegs.mvcs.Command;

    public class ScreenshotMakerCommand extends Command
    {
      
		[Inject]
        public var utilService:IUtilService;
		
		[Inject]
        public var evt:ScreenshotEvent;
		
        override public function execute():void
        {			
			utilService.screeenshot(evt.rec);		  	
        }
    }
}
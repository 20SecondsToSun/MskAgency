package app.contoller.commadns
{  
	import app.services.ipad.IIpadService;
	import org.robotlegs.mvcs.Command;

    public class LocationIpadChangedCommand extends Command
    {      
		[Inject]
        public var ipadService:IIpadService;	

        override public function execute():void
        {	
			ipadService.changeLocation();
        }
    }
}
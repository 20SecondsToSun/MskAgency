package app.contoller.commadns
{  

	import app.contoller.events.IpadEvent;
	import app.services.ipad.IIpadService;
	import org.robotlegs.mvcs.Command;

    public class SendShapesCommand extends Command
    {
      
		[Inject]
		public var ipad:IIpadService;	
		
		[Inject]
		public var event:IpadEvent;		
	

        override public function execute():void
        {					
			ipad.sendShapes(event.data);		  	
        }
    }
}
package app.contoller.commadns
{
   
	import app.services.dataloading.ISocketService;
	import app.services.ipad.IIpadService;
	import org.robotlegs.mvcs.Command;

    public class StartIpadConnection extends Command
    {	
       [Inject]
       public var ipad:IIpadService;
		
       override public function execute():void
       {
			
			ipad.start();	
       }
    }
}
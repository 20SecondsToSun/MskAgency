package app.contoller.commadns
{
   
	import app.services.dataloading.ISocketService;
	import org.robotlegs.mvcs.Command;

    public class StartSocketServer extends Command
    {
 
		
       [Inject]
        public var socket:ISocketService;
		
        override public function execute():void
        {	
			
			socket.start();	
        }
    }
}
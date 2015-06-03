package app.contoller.commadns
{
   
	import app.services.dataloading.IDataLoadingService;
	import org.robotlegs.mvcs.Command;

    public class LoadMainNewsCommand extends Command
    {
       [Inject]
        public var dataLoadingService:IDataLoadingService;
		
        override public function execute():void
        {			
			dataLoadingService.loadMainNews();	
        }
    }
}
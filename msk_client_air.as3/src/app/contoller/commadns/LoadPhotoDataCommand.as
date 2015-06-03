package app.contoller.commadns
{
   
	import app.services.dataloading.IDataLoadingService;
	import app.services.state.INavigationService;
	import org.robotlegs.mvcs.Command;

    public class LoadPhotoDataCommand extends Command
    {
 
		
       [Inject]
        public var dataLoadingService:IDataLoadingService;
		
		
		
        override public function execute():void
        {				
			dataLoadingService.loadPhotoNews();	
        }
    }
}
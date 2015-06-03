package app.contoller.commadns.geoNews
{
   
	import app.services.dataloading.IDataLoadingService;
	import org.robotlegs.mvcs.Command;

    public class LoadGeoDataCommand extends Command
    {		
        [Inject]
        public var dataLoadingService:IDataLoadingService;	
		
        override public function execute():void
        {				
			dataLoadingService.loadGeoNews();	
        }
		
		
    }
}
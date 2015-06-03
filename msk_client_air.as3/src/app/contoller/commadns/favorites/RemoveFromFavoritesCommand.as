package app.contoller.commadns.favorites
{
   
	import app.contoller.events.DataLoadServiceEvent;
	import app.services.dataloading.IDataLoadingService;
	import org.robotlegs.mvcs.Command;

    public class RemoveFromFavoritesCommand extends Command
    {		
        [Inject]
        public var dataLoadingService:IDataLoadingService;
		
        [Inject]
        public var event:DataLoadServiceEvent;	
		
		
        override public function execute():void
        {				
			dataLoadingService.removeFromFavs(event.newsID, event.data.type);	
        }			
    }
}
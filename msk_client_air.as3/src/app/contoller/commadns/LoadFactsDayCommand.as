package app.contoller.commadns
{
   
	import app.contoller.events.DataLoadServiceEvent;
	import app.services.dataloading.IDataLoadingService;
	import org.robotlegs.mvcs.Command;

    public class LoadFactsDayCommand extends Command
    {	
       [Inject]
        public var dataLoadingService:IDataLoadingService;
		
		[Inject]
        public var event:DataLoadServiceEvent;
		
        override public function execute():void
        {			
			dataLoadingService.loadFactsDataDayNews(event.data.date);	
        }
    }
}
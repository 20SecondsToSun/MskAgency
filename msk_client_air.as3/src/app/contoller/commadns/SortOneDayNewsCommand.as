package app.contoller.commadns
{
   
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.FilterEvent;
	import app.model.dataall.IAllNewsModel;
	import app.model.datageo.IGeoModel;
	import app.services.dataloading.IDataLoadingService;
	import org.robotlegs.mvcs.Command;

    public class SortOneDayNewsCommand extends Command
    {
 
		
        [Inject]
        public var model:IAllNewsModel;
		
		[Inject]
        public var filter:FilterEvent;
		
        override public function execute():void
        {			
			model.sortedType = filter.data.type;			
			model.createNewsHourLists();	
        }
    }
}
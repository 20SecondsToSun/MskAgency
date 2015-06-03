package app.contoller.commadns
{
   
	import app.contoller.events.FilterEvent;
	import app.model.datageo.IGeoModel;
	import org.robotlegs.mvcs.Command;

    public class SortGeoNewsCommand extends Command
    {
 
		
        [Inject]
        public var model:IGeoModel;
		
		[Inject]
        public var dataService:FilterEvent;
		
        override public function execute():void
        {			
			model.sort(dataService.data.group_id, dataService.data.type_id, dataService.data.important);
        }
    }
}
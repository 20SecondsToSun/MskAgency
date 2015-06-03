package app.contoller.commadns
{
	
	import app.contoller.events.DataLoadServiceEvent;
	import app.services.dataloading.IDataLoadingService;
	import org.robotlegs.mvcs.Command;
	
	public class LoadAllDataCommand extends Command
	{
		
		[Inject]
		public var dataLoadingService:IDataLoadingService;
		
		[Inject]
		public var serviceEvent:DataLoadServiceEvent;
		
		override public function execute():void
		{			
			dataLoadingService.loadAllDataNews(serviceEvent.loadingID);
		}
	}
}
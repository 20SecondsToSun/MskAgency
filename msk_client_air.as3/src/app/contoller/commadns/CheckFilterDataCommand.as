package app.contoller.commadns
{
	
	import app.contoller.events.DataLoadServiceEvent;
	import app.services.dataloading.IDataLoadingService;
	import org.robotlegs.mvcs.Command;
	
	public class CheckFilterDataCommand extends Command
	{		
		[Inject]
		public var dataLoadingService:IDataLoadingService;
		
		override public function execute():void
		{			
			dataLoadingService.checkDataNews();
		}
	}
}
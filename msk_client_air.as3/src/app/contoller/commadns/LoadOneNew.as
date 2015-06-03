package app.contoller.commadns
{
	
	import app.contoller.events.DataLoadServiceEvent;
	import app.services.dataloading.IDataLoadingService;
	import org.robotlegs.mvcs.Command;
	
	public class LoadOneNew extends Command
	{
		
		[Inject]
		public var dataLoadingService:IDataLoadingService;
		
		[Inject]
		public var evt:DataLoadServiceEvent;
		
		override public function execute():void
		{
			dataLoadingService.loadOneNew(evt.newsID);
		}
	}
}
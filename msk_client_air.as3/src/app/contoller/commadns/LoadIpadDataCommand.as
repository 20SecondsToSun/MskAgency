package app.contoller.commadns
{
	import app.contoller.events.IpadEvent;
	import ipad.services.dataloading.IDataLoadingService;
	import org.robotlegs.mvcs.Command;
	
	public class LoadIpadDataCommand extends Command
	{
		[Inject]
		public var dataLoadingService:IDataLoadingService;
		
		[Inject]
		public var evt:IpadEvent;
		
		override public function execute():void
		{
			switch (evt.type)
			{
				case IpadEvent.LOAD_MAP_MATERIALS: 
					dataLoadingService.loadMapIpadData(evt.data);
					break;
				case IpadEvent.LOAD_FACTS: 
					dataLoadingService.loadFactIpadData(evt.data);
					break;
				default: 
					dataLoadingService.loadIpadData(evt.data);
			}
		}
	}
}
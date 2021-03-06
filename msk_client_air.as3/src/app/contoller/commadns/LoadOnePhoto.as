package app.contoller.commadns
{
	
	import app.contoller.events.LoadPhotoEvent;
	import app.services.dataloading.IDataLoadingService;
	import org.robotlegs.mvcs.Command;
	
	public class LoadOnePhoto extends Command
	{
		[Inject]
		public var loadingPhotoService:IDataLoadingService;
		
		[Inject]
		public var photoEvent:LoadPhotoEvent;
		
		override public function execute():void
		{
			loadingPhotoService.loadPhoto(photoEvent.path, photoEvent.id, photoEvent.view);			
		}
	}
}
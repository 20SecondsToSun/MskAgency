package ipad.controller.commands
{   
	import ipad.services.dataloading.IDataLoadingService;
	import org.robotlegs.mvcs.Command;

    public class LoadFavoritesFactsCommand extends Command
    {
       [Inject]
        public var dataLoadingService:IDataLoadingService;
		
        override public function execute():void
        {			
			dataLoadingService.loadFavoritesFacts();	
        }
    }
}
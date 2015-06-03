package ipad.controller.commands
{   
	import ipad.services.dataloading.IDataLoadingService;
	import org.robotlegs.mvcs.Command;

    public class LoadFavoritesMaterialsCommand extends Command
    {
       [Inject]
        public var dataLoadingService:IDataLoadingService;
		
        override public function execute():void
        {
			trace("LOAD FAVORITE MATERIALS!!!!!!!!");
			dataLoadingService.loadFavoritesMaterials();	
        }
    }
}
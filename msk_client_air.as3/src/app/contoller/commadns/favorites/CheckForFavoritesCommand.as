package app.contoller.commadns.favorites
{   
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.FavoriteEvent;
	import app.model.datafav.IFavoritesModel;
	import app.services.dataloading.IDataLoadingService;
	import org.robotlegs.mvcs.Command;

    public class CheckForFavoritesCommand extends Command
    {		
        [Inject]
        public var model:IFavoritesModel;	
		
		[Inject]
        public var event:FavoriteEvent;			
		
        override public function execute():void
        {				
			model.isFavorite(event.data.mat.id, event.data.type);				
        }		
    }
}
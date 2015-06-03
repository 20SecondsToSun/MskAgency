package ipad.bootstraps
{
	import app.contoller.commadns.InitializedInteractiveCommand;
	import app.contoller.events.LoadPhotoEvent;
	import ipad.controller.commands.LoadFavoritesFactsCommand;
	import ipad.controller.commands.LoadFavoritesMaterialsCommand;
	import app.contoller.commadns.LoadIpadDataCommand;
	import app.contoller.events.AuthenticationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.GraphicInterfaceEvent;
	import app.contoller.events.IpadEvent;
	import ipad.controller.commands.AuthenticationDataCommand;
	import ipad.controller.commands.ChangeCustomScreenRubricCommand;
	import ipad.controller.commands.ChangePrimaryScreenCommand;
	import ipad.controller.commands.favorites.AddToFavoritesCommand;
	import ipad.controller.commands.favorites.RemoveFromFavoritesCommand;
	import ipad.controller.commands.LoadOnePhoto;
	import ipad.controller.commands.StartNavigationCommand;
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.core.ICommandMap;
	
	public class BootstrapCommands
	{
		public function BootstrapCommands(commandMap:ICommandMap)
		{
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, AuthenticationDataCommand, ContextEvent);
			commandMap.mapEvent(AuthenticationEvent.AUTH_SUCCESS, StartNavigationCommand, AuthenticationEvent);
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, InitializedInteractiveCommand, ContextEvent);	
			commandMap.mapEvent(IpadEvent.LOAD_MATERIALS, LoadIpadDataCommand, IpadEvent);	
			commandMap.mapEvent(IpadEvent.LOAD_MAP_MATERIALS, LoadIpadDataCommand, IpadEvent);	
			commandMap.mapEvent(IpadEvent.LOAD_FACTS, LoadIpadDataCommand, IpadEvent);	
			
			commandMap.mapEvent(IpadEvent.CUSTOM_SCREEN_RUBRIC, ChangeCustomScreenRubricCommand, IpadEvent);	
			commandMap.mapEvent(IpadEvent.PRIMARY_SCREEN, ChangePrimaryScreenCommand, IpadEvent);	
			
			commandMap.mapEvent(DataLoadServiceEvent.ADD_TO_FAVORITES, AddToFavoritesCommand, DataLoadServiceEvent);			
			commandMap.mapEvent(DataLoadServiceEvent.REMOVE_FROM_FAVORITES, RemoveFromFavoritesCommand, DataLoadServiceEvent);	
			
			commandMap.mapEvent(DataLoadServiceEvent.LOAD_FAVORITES_MATERIALS, LoadFavoritesMaterialsCommand, DataLoadServiceEvent);	
			commandMap.mapEvent(DataLoadServiceEvent.LOAD_FAVORITES_FACTS, LoadFavoritesFactsCommand, DataLoadServiceEvent);
			
			commandMap.mapEvent(LoadPhotoEvent.LOAD_PHOTO, LoadOnePhoto, LoadPhotoEvent);
			
		}
	}
}
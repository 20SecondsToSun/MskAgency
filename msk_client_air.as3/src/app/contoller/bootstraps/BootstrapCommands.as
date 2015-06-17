package app.contoller.bootstraps
{
	import app.contoller.commadns.AnimationFinishedCommand;
	import app.contoller.commadns.AuthenticationDataCommand;
	import app.contoller.commadns.ChangeModelCommand;
	import app.contoller.commadns.ChangePrimaryScreenCommand;
	import app.contoller.commadns.CheckFilterDataCommand;
	import app.contoller.commadns.CheckFilterFactsDataCommand;
	import app.contoller.commadns.CheckForReadyAnimation_3;
	import app.contoller.commadns.DataChangedCommand;
	import app.contoller.commadns.favorites.AddToFavoritesCommand;
	import app.contoller.commadns.favorites.CheckForFavoritesCommand;
	import app.contoller.commadns.favorites.RemoveFromFavoritesCommand;
	import app.contoller.commadns.FlushLoadersCommand;
	import app.contoller.commadns.geoNews.LoadGeoDataCommand;
	import app.contoller.commadns.geoNews.LoadMainGeoDataCommand;
	import app.contoller.commadns.gesture.GestureCommand;
	import app.contoller.commadns.InitializedInteractiveCommand;
	import app.contoller.commadns.ipad.IpadCommand;
	import app.contoller.commadns.LoadAllDataCommand;
	import app.contoller.commadns.LoadAllFactsDataCommand;
	import app.contoller.commadns.LoadDayNewsCommand;
	import app.contoller.commadns.LoadDaysNewsCommand;
	import app.contoller.commadns.LoadFactsDataCommand;
	import app.contoller.commadns.LoadFactsDayCommand;
	import app.contoller.commadns.LoadFavoritesFactsCommand;
	import app.contoller.commadns.LoadFavoritesMaterialsCommand;
	import app.contoller.commadns.LoadFiltersDataCommand;
	import app.contoller.commadns.LoadMainNewsCommand;
	import app.contoller.commadns.LoadNearNews;
	import app.contoller.commadns.LoadOneNew;
	import app.contoller.commadns.LoadOnePhoto;
	import app.contoller.commadns.LoadPhotoDataCommand;
	import app.contoller.commadns.LoadVideoDataCommand;
	import app.contoller.commadns.LoadWeatherCommand;
	import app.contoller.commadns.LocationIpadChangedCommand;
	import app.contoller.commadns.navigation.HideFiltersNavigationCommand;
	import app.contoller.commadns.navigation.HideIpadPopupNavigationCommand;
	import app.contoller.commadns.navigation.HideMenuNavigationCommand;
	import app.contoller.commadns.navigation.NavigationCommand;
	import app.contoller.commadns.navigation.OpenIpadPopupNavigationCommand;
	import app.contoller.commadns.navigation.ShowFiltersNavigationCommand;
	import app.contoller.commadns.navigation.ShowMenuNavigationCommand;
	import app.contoller.commadns.navigation.StartNavigationCommand;
	import app.contoller.commadns.ScreenshotMakerCommand;
	import app.contoller.commadns.SendShapesCommand;
	import app.contoller.commadns.SettingsChangedCommand;
	import app.contoller.commadns.ShutDownCommand;
	import app.contoller.commadns.SortGeoNewsCommand;
	import app.contoller.commadns.SortOneDayNewsCommand;
	import app.contoller.commadns.StartInteractiveCommand;
	import app.contoller.commadns.StartIpadConnection;
	import app.contoller.commadns.StartSocketServer;
	import app.contoller.commadns.StopInteractiveCommand;
	import app.contoller.commadns.SymbolsBadCommand;
	import app.contoller.commadns.SymbolsIsOkCommand;
	import app.contoller.commadns.UserActiveCommand;
	import app.contoller.commadns.UserLostCommand;
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.AuthenticationEvent;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.ChangeModelOut;
	import app.contoller.events.DataChangedEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.FavoriteEvent;
	import app.contoller.events.FilterEvent;
	import app.contoller.events.GesturePostEvent;
	import app.contoller.events.InteractiveRemoteEvent;
	import app.contoller.events.InteractiveServiceEvent;
	import app.contoller.events.IpadEvent;
	import app.contoller.events.LoadPhotoEvent;
	import app.contoller.events.ScreenshotEvent;
	import app.services.interactive.gestureDetector.GestureEvent;
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.core.ICommandMap;
	
	public class BootstrapCommands
	{
		public function BootstrapCommands(commandMap:ICommandMap)
		{
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, InitializedInteractiveCommand, ContextEvent);	
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, AuthenticationDataCommand, ContextEvent);
			commandMap.mapEvent(ContextEvent.SHUTDOWN_COMPLETE, ShutDownCommand, ContextEvent);
			
			commandMap.mapEvent(AuthenticationEvent.AUTH_SUCCESS, StartNavigationCommand, AuthenticationEvent);
			commandMap.mapEvent(AuthenticationEvent.AUTH_SUCCESS, StartSocketServer, AuthenticationEvent);
			commandMap.mapEvent(AuthenticationEvent.AUTH_SUCCESS, LoadFiltersDataCommand, AuthenticationEvent);
			commandMap.mapEvent(AuthenticationEvent.AUTH_SUCCESS, StartIpadConnection, AuthenticationEvent);
			commandMap.mapEvent(AuthenticationEvent.AUTH_SUCCESS, LoadFavoritesMaterialsCommand, AuthenticationEvent);
			commandMap.mapEvent(AuthenticationEvent.AUTH_SUCCESS, LoadFavoritesFactsCommand, AuthenticationEvent);
			
			
			commandMap.mapEvent(DataLoadServiceEvent.LOAD_PHOTO_DATA, LoadPhotoDataCommand, DataLoadServiceEvent);
			commandMap.mapEvent(DataLoadServiceEvent.LOAD_ALL_DATA, LoadAllDataCommand, DataLoadServiceEvent);
			commandMap.mapEvent(DataLoadServiceEvent.LOAD_VIDEO_DATA, LoadVideoDataCommand, DataLoadServiceEvent);
			
			commandMap.mapEvent(DataLoadServiceEvent.LOAD_FACTS_DATA, LoadFactsDataCommand, DataLoadServiceEvent);
			commandMap.mapEvent(DataLoadServiceEvent.LOAD_ALL_FACTS_DATA, LoadAllFactsDataCommand, DataLoadServiceEvent);
			
			commandMap.mapEvent(DataLoadServiceEvent.LOAD_ONE_NEW, LoadOneNew, DataLoadServiceEvent);
			commandMap.mapEvent(DataLoadServiceEvent.LOAD_GEO_DATA, LoadGeoDataCommand, DataLoadServiceEvent);
			commandMap.mapEvent(DataLoadServiceEvent.LOAD_MAIN_GEO_DATA, LoadMainGeoDataCommand, DataLoadServiceEvent);
			
			
			commandMap.mapEvent(DataLoadServiceEvent.LOAD_MAIN_NEWS, LoadMainNewsCommand, DataLoadServiceEvent);
			commandMap.mapEvent(DataLoadServiceEvent.LOAD_ALL_MATERIAL_NEAR_NEWS, LoadNearNews, DataLoadServiceEvent);	
			commandMap.mapEvent(DataLoadServiceEvent.LOAD_DAYS_DATA, LoadDaysNewsCommand, DataLoadServiceEvent);						
			commandMap.mapEvent(DataLoadServiceEvent.LOAD_DAY_DATA, LoadDayNewsCommand, DataLoadServiceEvent);						
			commandMap.mapEvent(DataLoadServiceEvent.LOAD_ALL_FACTS_DAY, LoadFactsDayCommand, DataLoadServiceEvent);	
			
			commandMap.mapEvent(DataLoadServiceEvent.LOAD_WEATHER, LoadWeatherCommand, DataLoadServiceEvent);	
			
			
			
			
			commandMap.mapEvent(DataLoadServiceEvent.FLUSH_LOADERS, FlushLoadersCommand, DataLoadServiceEvent);
			
			
			commandMap.mapEvent(DataLoadServiceEvent.LOAD_FAVORITES_MATERIALS, LoadFavoritesMaterialsCommand, DataLoadServiceEvent);	
			commandMap.mapEvent(DataLoadServiceEvent.LOAD_FAVORITES_FACTS, LoadFavoritesFactsCommand, DataLoadServiceEvent);	
			
			
			commandMap.mapEvent(LoadPhotoEvent.LOAD_PHOTO, LoadOnePhoto, LoadPhotoEvent);
			
			
			commandMap.mapEvent(InteractiveServiceEvent.START_INTERACTION, StartInteractiveCommand, InteractiveServiceEvent);
			commandMap.mapEvent(InteractiveServiceEvent.STOP_INTERACTION, StopInteractiveCommand, InteractiveServiceEvent);
			
			commandMap.mapEvent(ChangeLocationEvent.MAIN_SCREEN, NavigationCommand, ChangeLocationEvent);
			commandMap.mapEvent(ChangeLocationEvent.CUSTOM_SCREEN, NavigationCommand, ChangeLocationEvent);
			commandMap.mapEvent(ChangeLocationEvent.STORY_SCREEN, NavigationCommand, ChangeLocationEvent);
			
			
			commandMap.mapEvent(ChangeLocationEvent.BROADCAST_PAGE, NavigationCommand, ChangeLocationEvent);
			commandMap.mapEvent(ChangeLocationEvent.FACT_PAGE, NavigationCommand, ChangeLocationEvent);
			commandMap.mapEvent(ChangeLocationEvent.FAVORITES_PAGE, NavigationCommand, ChangeLocationEvent);
			commandMap.mapEvent(ChangeLocationEvent.MAP_PAGE, NavigationCommand, ChangeLocationEvent);
			commandMap.mapEvent(ChangeLocationEvent.ONE_NEW_PAGE, NavigationCommand, ChangeLocationEvent);
			commandMap.mapEvent(ChangeLocationEvent.ONE_NEW_FACT_PAGE, NavigationCommand, ChangeLocationEvent);
			commandMap.mapEvent(ChangeLocationEvent.NEWS_PAGE_HOUR, NavigationCommand, ChangeLocationEvent);
			
			commandMap.mapEvent(ChangeLocationEvent.BACK_FROM_ONE_NEW, NavigationCommand, ChangeLocationEvent);
			commandMap.mapEvent(ChangeLocationEvent.NEWS_PAGE_DAY, NavigationCommand, ChangeLocationEvent);
			
			
			commandMap.mapEvent(ChangeLocationEvent.SHOW_MENU, ShowMenuNavigationCommand, ChangeLocationEvent);
			commandMap.mapEvent(ChangeLocationEvent.MENU_IS_HIDDEN, HideMenuNavigationCommand, ChangeLocationEvent);
			commandMap.mapEvent(ChangeLocationEvent.SHOW_FILTERS, ShowFiltersNavigationCommand, ChangeLocationEvent);
			commandMap.mapEvent(ChangeLocationEvent.FILTERS_IS_HIDDEN, HideFiltersNavigationCommand, ChangeLocationEvent);
			
			
			commandMap.mapEvent(ChangeLocationEvent.IPAD_POPUP_IS_HIDDEN, HideIpadPopupNavigationCommand, ChangeLocationEvent);
			commandMap.mapEvent(IpadEvent.OPEN_POPUP, OpenIpadPopupNavigationCommand, IpadEvent);	
			

			commandMap.mapEvent(AnimationEvent.ALL_NEWS_ANIMATION_FINISHED, AnimationFinishedCommand, AnimationEvent);
			commandMap.mapEvent(AnimationEvent.FACTS_ANIMATION_FINISHED, AnimationFinishedCommand, AnimationEvent);
			commandMap.mapEvent(AnimationEvent.MAIN_NEWS_ANIMATION_FINISHED, AnimationFinishedCommand, AnimationEvent);
			commandMap.mapEvent(AnimationEvent.VIDEO_NEWS_ANIMATION_FINISHED, AnimationFinishedCommand, AnimationEvent);
			commandMap.mapEvent(AnimationEvent.PHOTO_NEWS_ANIMATION_FINISHED, AnimationFinishedCommand, AnimationEvent);
			commandMap.mapEvent(AnimationEvent.MAP_ANIMATION_FINISHED, AnimationFinishedCommand, AnimationEvent);
			commandMap.mapEvent(AnimationEvent.EMPLOY_ANIMATION_FINISHED, AnimationFinishedCommand, AnimationEvent);
			commandMap.mapEvent(AnimationEvent.PAGE_ANIMATION_FINISHED, AnimationFinishedCommand, AnimationEvent);
			commandMap.mapEvent(AnimationEvent.FAVORITES_ANIMATION_FINISHED, AnimationFinishedCommand, AnimationEvent);
			
			commandMap.mapEvent(AnimationEvent.MAIN_SCREEN_FINISHED, AnimationFinishedCommand, AnimationEvent);
			commandMap.mapEvent(AnimationEvent.STORY_SCREEN_FINISHED, AnimationFinishedCommand, AnimationEvent);
			commandMap.mapEvent(AnimationEvent.CUSTOM_SCREEN_FINISHED, AnimationFinishedCommand, AnimationEvent);
			
			commandMap.mapEvent(ChangeModelOut.MAIN_SCREEN, ChangeModelCommand, ChangeModelOut);
			commandMap.mapEvent(ChangeModelOut.CUSTOM_SCREEN, ChangeModelCommand, ChangeModelOut);
			commandMap.mapEvent(ChangeModelOut.STORY_SCREEN, ChangeModelCommand, ChangeModelOut);
			
			commandMap.mapEvent(ChangeModelOut.MAIN_SCREEN_SCREENSHOT, ChangeModelCommand, ChangeModelOut);
			commandMap.mapEvent(ChangeModelOut.CUSTOM_SCREEN_SCREENSHOT, ChangeModelCommand, ChangeModelOut);
			commandMap.mapEvent(ChangeModelOut.STORY_SCREEN_SCREENSHOT, ChangeModelCommand, ChangeModelOut);
			commandMap.mapEvent(ChangeModelOut.ONE_DAY_NEWS, ChangeModelCommand, ChangeModelOut);			
			
			commandMap.mapEvent(ScreenshotEvent.MAKE_SCREENSHOT, ScreenshotMakerCommand, ScreenshotEvent);	
			commandMap.mapEvent(DataLoadServiceEvent.CHECK_FOR_FILTER_NEWS, CheckFilterDataCommand, DataLoadServiceEvent);	
			commandMap.mapEvent(DataLoadServiceEvent.CHECK_FOR_FILTER_FACTS, CheckFilterFactsDataCommand, DataLoadServiceEvent);
			
			
			commandMap.mapEvent(AnimationEvent.CUSTOM_SCREEN_SCREENSHOT_FINISHED, CheckForReadyAnimation_3, AnimationEvent);	
			commandMap.mapEvent(AnimationEvent.MAIN_SCREEN_SCREENSHOT_FINISHED, CheckForReadyAnimation_3, AnimationEvent);	
			commandMap.mapEvent(AnimationEvent.STORY_SCREEN_SCREENSHOT_FINISHED, CheckForReadyAnimation_3, AnimationEvent);			
			
			commandMap.mapEvent(FilterEvent.SORT_GEO_NEWS, SortGeoNewsCommand, FilterEvent);
			commandMap.mapEvent(FilterEvent.SORT_ONE_DAY_NEWS, SortOneDayNewsCommand, FilterEvent);			
			
			commandMap.mapEvent(InteractiveRemoteEvent.USER_LOST, UserLostCommand, InteractiveRemoteEvent);	
			commandMap.mapEvent(InteractiveRemoteEvent.USER_ACTIVE, UserActiveCommand, InteractiveRemoteEvent);	
			commandMap.mapEvent(IpadEvent.SETTINGS_CHANGED, SettingsChangedCommand, IpadEvent);	
			commandMap.mapEvent(IpadEvent.LOCATION_CHANGED, LocationIpadChangedCommand, IpadEvent);	
			commandMap.mapEvent(IpadEvent.PRIMARY_SCREEN, ChangePrimaryScreenCommand, IpadEvent);
			
			commandMap.mapEvent(IpadEvent.PLAY, IpadCommand, IpadEvent);	
			commandMap.mapEvent(IpadEvent.PAUSE, IpadCommand, IpadEvent);
			commandMap.mapEvent(IpadEvent.HAND_ACTIVE, IpadCommand, IpadEvent);
			commandMap.mapEvent(IpadEvent.HAND_LOST, IpadCommand, IpadEvent);
			
			commandMap.mapEvent(IpadEvent.IPAD_DISCONNECTING, IpadCommand, IpadEvent);
			commandMap.mapEvent(IpadEvent.IPAD_CONNECTING, IpadCommand, IpadEvent);
			
			
			
			
			
			commandMap.mapEvent(DataChangedEvent.DATA_CHANGED, DataChangedCommand, DataChangedEvent);		
			
			commandMap.mapEvent(DataLoadServiceEvent.ADD_TO_FAVORITES, AddToFavoritesCommand, DataLoadServiceEvent);			
			commandMap.mapEvent(DataLoadServiceEvent.REMOVE_FROM_FAVORITES, RemoveFromFavoritesCommand, DataLoadServiceEvent);	
			
			
			commandMap.mapEvent(FavoriteEvent.CHECK_FOR_FAVORITES, CheckForFavoritesCommand, FavoriteEvent);			
			commandMap.mapEvent(IpadEvent.SEND_SHAPES, SendShapesCommand, IpadEvent);			
			commandMap.mapEvent(IpadEvent.SYMBOLS_IS_OK, SymbolsIsOkCommand, IpadEvent);			
			commandMap.mapEvent(IpadEvent.SYMBOLS_BAD, SymbolsBadCommand, IpadEvent);		
			
			
			commandMap.mapEvent(GesturePostEvent.HAND_ONE_FINGER, GestureCommand, GesturePostEvent);		
			commandMap.mapEvent(GesturePostEvent.HAND_TWO_FINGERS, GestureCommand, GesturePostEvent);					
		}
	}
}
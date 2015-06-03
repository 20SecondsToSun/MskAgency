package ipad.bootstraps
{
	import app.model.config.Config;
	import app.model.config.IConfig;
	import app.model.config.IScreenShots;
	import app.model.config.ScreenShots;
	import app.services.auth.AuthService;
	import app.services.auth.IAuthService;
	import app.services.dataloading.DataLoadingService;
	import app.services.dataloading.IDataLoadingService;
	import app.services.dataloading.ISocketService;
	import app.services.dataloading.SocketService;
	import app.services.interactive.IInteractiveControlService;
	import app.services.interactive.InteractiveControlService;
	import app.services.ipad.IIpadService;
	import app.services.ipad.IpadService;
	import app.services.state.INavigationService;
	import app.services.state.NavigationService;
	import app.services.util.IUtilService;
	import app.services.util.UtilService;
	import org.robotlegs.core.IInjector;

    public class BootstrapServices
    {

        public function BootstrapServices(injector:IInjector)
        {
            injector.mapSingletonOf(IDataLoadingService, DataLoadingService);           
            injector.mapSingletonOf(IAuthService, AuthService);		
            injector.mapSingletonOf(IInteractiveControlService, InteractiveControlService); 			
            injector.mapSingletonOf(INavigationService, NavigationService);			
            injector.mapSingletonOf(IUtilService, UtilService); 			
            injector.mapSingletonOf(ISocketService, SocketService);
            injector.mapSingletonOf(IIpadService, IpadService);
			
			injector.mapSingletonOf(IConfig, Config);
			
			
			//injector.mapSingletonOf(IScreenShots, ScreenShots);
			
        }

    }

}
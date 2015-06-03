package app.contoller.bootstraps
{
	import app.contoller.constants.AnimConst;
	import app.model.config.ScreenShots;
	import app.model.datauser.Login;
	import app.model.datauser.Password;
	import app.model.datauser.server.Server;



    import org.robotlegs.core.IInjector;

    public class BootstrapConfigValues
    {
        public function BootstrapConfigValues(injector:IInjector)
        {
            injector.mapValue(Password, new Password("admiral"));
            injector.mapValue(Login, new Login("popov"));
            injector.mapValue(Server, new Server("http://www.mskagency.ru/api/v1"));
			
			injector.mapValue(AnimConst, new AnimConst());
			injector.mapValue(ScreenShots, new ScreenShots());
			
			
           // injector.mapValue(DefaultDesignName, new DefaultDesignName("Practice Design"));
          //  injector.mapValue(DefaultGridSize, new DefaultGridSize(15, 20));
          //  injector.mapValue(DefaultTileColor, new DefaultTileColor(0x333333));
          //  injector.mapValue(DefaultWorkspaceColor, new DefaultWorkspaceColor(0x000000));
        }
    }
}
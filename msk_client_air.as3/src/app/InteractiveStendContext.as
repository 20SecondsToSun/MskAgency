package  app
{
	import app.contoller.bootstraps.BootstrapCommands;
	import app.contoller.bootstraps.BootstrapConfigValues;
	import app.contoller.bootstraps.BootstrapModels;
	import app.contoller.bootstraps.BootstrapServices;
	import app.contoller.bootstraps.BootstrapViewMediators;
	import app.view.MainView;
	import flash.display.DisplayObjectContainer;
	import org.robotlegs.mvcs.Context;
	
	/**
	 * ...
	 * @author metalcorehero
	 */	
	
	public class InteractiveStendContext extends Context
    {
        public function InteractiveStendContext(contextView:DisplayObjectContainer)
        {
            super(contextView, true);
        }

        override public function startup():void
        {           
			new BootstrapServices(injector);
			new BootstrapModels(injector);
			new BootstrapConfigValues(injector);			
			new BootstrapCommands(commandMap);
            new BootstrapViewMediators(mediatorMap);

            addRootView();            
		    super.startup();
        }

        protected function addRootView():void
        {
            var mainView:MainView = new MainView(injector);
			mainView.name = "mainView";
            contextView.addChild(mainView);			
        }
    }
}
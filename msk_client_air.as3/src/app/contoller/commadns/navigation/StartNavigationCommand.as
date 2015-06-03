package app.contoller.commadns.navigation
{  

	import app.model.dataall.AllNewsModel;
	import app.model.dataall.IAllNewsModel;
	import app.model.dataall.MainAllNewsModel;
	import app.model.dataall.StoryAllNewsModel;
	import app.services.state.INavigationService;
	import org.robotlegs.mvcs.Command;

    public class StartNavigationCommand extends Command
    {
      
		[Inject]
        public var navigationService:INavigationService;
		
        override public function execute():void
		{
			
			navigationService.start();		  	
        }
    }
}
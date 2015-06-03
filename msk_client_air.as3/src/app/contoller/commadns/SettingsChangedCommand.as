package app.contoller.commadns
{  

	import app.contoller.events.AnimationEvent;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.IpadEvent;
	import app.model.config.IConfig;
	import app.model.datauser.IUser;
	import app.model.materials.IMaterialModel;
	import app.services.state.INavigationService;
	import org.robotlegs.mvcs.Command;

    public class SettingsChangedCommand extends Command
    {
      
		[Inject]
        public var user:IUser;
		
		[Inject]
        public var event:IpadEvent;
		
		[Inject]
        public var conf:IConfig;

        override public function execute():void
        {
		//	trace("CHANGED RUBRIC",event.rubric, conf.currentScreen);
			user.removeAllUserFilters();				
			user.addUserFilter("rubric", event.data.toString());			
			
			if (conf.currentScreen == ChangeLocationEvent.CUSTOM_SCREEN)
			{
				dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.RELOAD_DATA));		
			}
			else
			{
				var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.CUSTOM_SCREEN);
				event.mode = "MENU_MODE";
				dispatch(event);
			}
        }
    }
}
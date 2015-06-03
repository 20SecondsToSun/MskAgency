package app.contoller.commadns 
{
	import app.services.dataloading.IDataLoadingService;
	import org.robotlegs.mvcs.Command;
	/**
	 * ...
	 * @author metalcorehero
	 */
	
	public class LoadWeatherCommand extends Command
    {
       [Inject]
        public var dataLoadingService:IDataLoadingService;
		
        override public function execute():void
        {			
			dataLoadingService.loadWeather();	
        }
    }
	
	
	
	
	
	

}
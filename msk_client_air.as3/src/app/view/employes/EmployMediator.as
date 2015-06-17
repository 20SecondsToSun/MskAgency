package app.view.employes
{
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.model.dataemploy.IEmployModel;
	import app.view.baseview.MainScreenMediator; 
	import flash.events.Event;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class EmployMediator extends MainScreenMediator
	{
		[Inject]
		public var view:Employ;
		
		[Inject]
		public var model:IEmployModel;
		
		override public function onRegister():void
		{
			activeView = view;			
			super.onRegister();
			
			addContextListener(DataLoadServiceEvent.LOAD_COMPLETED_EMPLOY, refreshData, DataLoadServiceEvent);			
			addContextListener(DataLoadServiceEvent.LOAD_COMPLETED_WEATHER, refreshWeather, DataLoadServiceEvent);
			addContextListener(DataLoadServiceEvent.LOAD_IFORMER_COMPLETED, refreshInformer, DataLoadServiceEvent);
			
			addViewListener(AnimationEvent.EMPLOY_ANIMATION_FINISHED, dispatch, AnimationEvent);			
			addViewListener(Event.REMOVED_FROM_STAGE, removeHandler);			
			
			if (model.weather && model.weather.length)			
				view.setWeather(model.weather);			
			else			
				dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_WEATHER));
		
			if (model.informer.probki_city)			
				view.setInformer(model.informer);			
			else			
				dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_IFORMER));
		}
		
		private function refreshInformer(e:DataLoadServiceEvent):void 
		{
			view.setInformer(model.informer);
		}
		
		private function refreshWeather(e:DataLoadServiceEvent):void 
		{
			view.setWeather(model.weather);
		}
		
		private function refreshData(e:DataLoadServiceEvent):void
		{
			view.refreshData();			
		}
		
		 private function removeHandler(e:Event):void
		{
			removeViewListener(Event.REMOVED_FROM_STAGE, removeHandler);
			view.setScreenShot();
			view.kill();
			super.removeAllHandlers();
			removeContextListener(DataLoadServiceEvent.LOAD_COMPLETED_EMPLOY, refreshData, DataLoadServiceEvent);			
		}		
	}
}
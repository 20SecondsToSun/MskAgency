package app.view.mainscreen
{
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.ChangeModelOut;
	import app.model.config.IConfig;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class MainScreenMediator extends BaseMediator
	{
		[Inject]
		public var view:MainScreen;
	
		override public function onRegister():void
		{			
			activeView = view;
			super.onRegister();
			
			addViewListener(ChangeModelOut.MAIN_SCREEN, dispatch, ChangeModelOut);
			addViewListener(ChangeModelOut.CUSTOM_SCREEN_SCREENSHOT, dispatch, ChangeModelOut);
			addViewListener(AnimationEvent.MAIN_SCREEN_FINISHED, dispatch, AnimationEvent);
		}
	}
}
package app.view.mainscreen
{
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.ChangeModelOut;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class CustomScreenMediator extends BaseMediator
	{	
		[Inject]
		public var view:CustomScreen;
		
		override public function onRegister():void
		{
			activeView = view;
			super.onRegister();

			addViewListener(ChangeModelOut.CUSTOM_SCREEN, dispatch, ChangeModelOut);
			addViewListener(ChangeModelOut.CUSTOM_SCREEN_SCREENSHOT, dispatch, ChangeModelOut);
			addViewListener(AnimationEvent.CUSTOM_SCREEN_FINISHED, dispatch, AnimationEvent);	
		}				
	}
}
package app.view.mainscreen
{
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.ChangeModelOut;
	import app.contoller.events.DataLoadServiceEvent;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class StoryScreenMediator extends BaseMediator
	{	
		[Inject]
		public var view:StoryScreen;
		
		override public function onRegister():void
		{
			activeView = view;
			super.onRegister();
			
			addViewListener(ChangeModelOut.STORY_SCREEN, dispatch, ChangeModelOut);
			addViewListener(ChangeModelOut.STORY_SCREEN_SCREENSHOT, dispatch, ChangeModelOut);			
			addViewListener(AnimationEvent.STORY_SCREEN_FINISHED, dispatch, AnimationEvent);		
		}
	}
}
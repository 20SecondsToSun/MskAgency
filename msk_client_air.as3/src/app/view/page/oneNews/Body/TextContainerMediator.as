package app.view.page.oneNews.Body 
{
	import app.view.utils.video.events.VideoEvent;
	import org.robotlegs.mvcs.Mediator;
	/**
	 * ...
	 * @author metalcorehero
	 */

	public class TextContainerMediator extends Mediator
	{
		[Inject]
		public var view:TextContainer;		
		
		override public function onRegister():void
		{				
			addContextListener(VideoEvent.CHANGED_SIZE, changedSize, VideoEvent);
		}
		
		private function changedSize(e:VideoEvent):void 
		{		
			view.changedTitlePosition(e.height, e.id);
		}
		
	}
}
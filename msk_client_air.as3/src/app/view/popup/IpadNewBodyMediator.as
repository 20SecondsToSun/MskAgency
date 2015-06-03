package app.view.popup
{
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.ScreenshotEvent;
	import app.model.dataall.IAllNewsModel;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class IpadNewBodyMediator extends Mediator
	{
		[Inject]
		public var model:IAllNewsModel;		
		
		[Inject]
		public var view:IpadNewBody;		
		
		override public function onRegister():void
		{
			eventMap.mapListener(view.star, InteractiveEvent.HAND_OVER, overStar, InteractiveEvent);
			eventMap.mapListener(view.star, InteractiveEvent.HAND_OUT, outStar, InteractiveEvent);
			eventMap.mapListener(view.star, InteractiveEvent.HAND_DOWN, downStar, InteractiveEvent);			
		}	
		
		private function downStar(e:InteractiveEvent):void 
		{	
			view.moveRight();
			addContextListener(ScreenshotEvent.TAKE_SCREENSHOT, screenshotCapture, ScreenshotEvent);
			dispatch(new ScreenshotEvent(ScreenshotEvent.MAKE_SCREENSHOT, null, view.screenField));				
		}
		
		private function screenshotCapture(e:ScreenshotEvent):void 
		{
			view.star.visible = true;
			removeContextListener(ScreenshotEvent.TAKE_SCREENSHOT, screenshotCapture, ScreenshotEvent);
			
			view.favPanel.show();
			view.addFavShot(e.shot);
			eventMap.mapListener(view.star, InteractiveEvent.HAND_UPDATE, view.dragFavShot, InteractiveEvent);			
			eventMap.mapListener(view.star, InteractiveEvent.HAND_UP, upStar, InteractiveEvent);
		}	
		private function upStar(e:InteractiveEvent):void 
		{
			view.moveLeft();		
			removeContextListener(ScreenshotEvent.TAKE_SCREENSHOT, screenshotCapture, ScreenshotEvent);
			eventMap.unmapListener(view.star, InteractiveEvent.HAND_UPDATE, view.dragFavShot, InteractiveEvent);			
			eventMap.unmapListener(view.star, InteractiveEvent.HAND_UP, upStar, InteractiveEvent);	
			
			if (view.backPanel(e) == true)
			{
				var data:Object = new Object();
				if (view.type == "fact") data.type ="activity";
				else data.type = view.type;
				data.mat = view.mat;
				dispatch( new DataLoadServiceEvent(DataLoadServiceEvent.ADD_TO_FAVORITES, true, false, view.activeID, null, data));				
			}			
		}
		
		private function outStar(e:InteractiveEvent):void 
		{			
			view.star.out();
		}
		
		private function overStar(e:InteractiveEvent):void 
		{
			view.star.over();
		}	
	}
}
package app.view.page.oneNews.Body
{
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.FavoriteEvent;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.ScreenshotEvent;
	import app.model.dataall.IAllNewsModel;
	import app.model.materials.Material;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class NewsBodyMediator extends Mediator
	{
		[Inject]
		public var model:IAllNewsModel;		
		
		[Inject]
		public var view:NewsBody;	
		

		
		override public function onRegister():void
		{
			addContextListener(ChangeLocationEvent.SHOW_NEW_BY_ID, changeNews, ChangeLocationEvent);
			addContextListener(FavoriteEvent.UPDATE_FAVORITES_LIST, updateFavList, FavoriteEvent);
			addContextListener(FavoriteEvent.IS_FAVORITES_ANSWER, isFavorites, FavoriteEvent);
			
			eventMap.mapListener(view.star, InteractiveEvent.HAND_OVER, overStar, InteractiveEvent);
			eventMap.mapListener(view.star, InteractiveEvent.HAND_OUT, outStar, InteractiveEvent);
			eventMap.mapListener(view.star, InteractiveEvent.HAND_DOWN, downStar, InteractiveEvent);
			
			view.init(model.activeMaterial);
			check(model.activeMaterial);
		
		}		
		
		private function isFavorites(e:FavoriteEvent):void 
		{
			view.setFavState(e.data.isFavorite);
		}
		private function check(mat:Material):void 
		{
			var data:Object = new Object();
			data.mat = mat;
			data.type = "material";
			dispatch(new FavoriteEvent(FavoriteEvent.CHECK_FOR_FAVORITES,true,false, data));
		}
		
		private function updateFavList(e:FavoriteEvent):void 
		{
			check(view.mat);
		}
	
		private function changeNews(e:ChangeLocationEvent):void 
		{			
			var mat:Material = e.data as Material;
			view.refresh(mat);
			check(mat);
		}
		
		override public function preRemove():void
		{
			removeContextListener(ChangeLocationEvent.SHOW_NEW_BY_ID, changeNews, ChangeLocationEvent);
			eventMap.unmapListeners();				
			view.textNews.kill();
		}
		
		private function downStar(e:InteractiveEvent):void 
		{
			if (view.isFavorite) return;
			
			view.star.visible = false;
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
			removeContextListener(ScreenshotEvent.TAKE_SCREENSHOT, screenshotCapture, ScreenshotEvent);			
			eventMap.unmapListener(view.star, InteractiveEvent.HAND_UPDATE, view.dragFavShot, InteractiveEvent);			
			eventMap.unmapListener(view.star, InteractiveEvent.HAND_UP, upStar, InteractiveEvent);	
			
			view.star.visible = true;	
			
			if (view.backPanel(e) == true)
			{
				var data:Object = new Object();
				data.type = "material";
				data.mat = view.mat;
				dispatch( new DataLoadServiceEvent(DataLoadServiceEvent.ADD_TO_FAVORITES, true, false, view.activeID, null, data));				
			}
			else
			{
				//view.star.visible = false;	
			}			
		}
		
		private function outStar(e:InteractiveEvent):void 
		{			
			view.star.out();
		}
		
		private function overStar(e:InteractiveEvent):void 
		{
			view.starOver();
		}
	}
}
package app.view.page.fact.body
{
	import app.AppSettings;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.FavoriteEvent;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.ScreenshotEvent;
	import app.model.dataall.IAllNewsModel;
	import app.model.datafact.IFactsModel;
	import app.model.dataphoto.IPhotoNewsModel;
	import app.model.datavideo.IVideoNewsModel;
	import app.model.materials.Fact;
	import app.model.materials.Material;
	import flash.geom.Rectangle;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FactNewsBodyMediator extends Mediator
	{
		[Inject]
		public var fmodel:IFactsModel;		
		
		[Inject]
		public var view:FactNewsBody;		
		
		override public function onRegister():void
		{
			addContextListener(ChangeLocationEvent.SHOW_NEW_BY_ID, changeNews, ChangeLocationEvent);
			addContextListener(FavoriteEvent.UPDATE_FAVORITES_LIST, updateFavList, FavoriteEvent);
			addContextListener(FavoriteEvent.IS_FAVORITES_ANSWER, isFavorites, FavoriteEvent);
			
			eventMap.mapListener(view.star, InteractiveEvent.HAND_OVER, overStar, InteractiveEvent);
			eventMap.mapListener(view.star, InteractiveEvent.HAND_OUT, outStar, InteractiveEvent);
			eventMap.mapListener(view.star, InteractiveEvent.HAND_DOWN, downStar, InteractiveEvent);	
			
			view.init(fmodel.activeMaterial);
			check(fmodel.activeMaterial);
		}
		
		private function isFavorites(e:FavoriteEvent):void 
		{
			view.setFavState(e.data.isFavorite);
		}
		
		private function check(fact:Fact):void 
		{
			var data:Object = new Object();
			data.mat = fact;
			data.type = "activity";
			dispatch(new FavoriteEvent(FavoriteEvent.CHECK_FOR_FAVORITES, true, false, data));			
		}
		
		private function updateFavList(e:FavoriteEvent):void 
		{
			check(view.mat);
		}
		
		private function changeNews(e:ChangeLocationEvent):void 
		{
			var fact:Fact = e.obj as Fact;
			view.refresh(fact);
			check(fact);
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
			view.star.visible = true;
			removeContextListener(ScreenshotEvent.TAKE_SCREENSHOT, screenshotCapture, ScreenshotEvent);
			eventMap.unmapListener(view.star, InteractiveEvent.HAND_UPDATE, view.dragFavShot, InteractiveEvent);			
			eventMap.unmapListener(view.star, InteractiveEvent.HAND_UP, upStar, InteractiveEvent);			
			
			if (view.backPanel(e) == true)
			{
				var data:Object = new Object();
				data.type = "activity";
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
			view.starOver();
		}	
	}
}
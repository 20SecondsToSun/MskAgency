package app.view.favorites
{
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.InteractiveEvent;
	import app.model.dataall.IAllNewsModel;
	import app.model.datafact.IFactsModel;
	import app.model.datafav.FavoritesModel;
	import app.model.datafav.IFavoritesModel;
	import app.view.baseview.MainScreenMediator; 
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	
	public class FavoritesMediator extends MainScreenMediator
	{
		[Inject]
		public var view:Favorites;		
		
		[Inject]
		public var fav:IFavoritesModel;
		
		[Inject]
		public var model:IAllNewsModel;
		
		[Inject]
		public var fmodel:IFactsModel;
		
		override public function onRegister():void
		{
			activeView = view;			
			super.onRegister();			
	
			addViewListener(AnimationEvent.FAVORITES_ANIMATION_FINISHED, waitFinishAnim, AnimationEvent);	
			
			addViewListener(InteractiveEvent.HAND_CHARGED, charged, InteractiveEvent,true);	
			addViewListener(InteractiveEvent.HAND_PUSH, push, InteractiveEvent, true);				
		}
		
		private function waitFinishAnim(e:AnimationEvent):void 
		{
			dispatch(e);
			
			addContextListener(DataLoadServiceEvent.FAVORITES_MATERIALS_LOADED, loadedMaterials, DataLoadServiceEvent);				
			addContextListener(DataLoadServiceEvent.FAVORITES_FACTS_LOADED, loadedFacts, DataLoadServiceEvent);	
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_FAVORITES_MATERIALS ));
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_FAVORITES_FACTS ));
		}
		
		private function push(e:InteractiveEvent):void 
		{
			if (e.target is FavFactGraphic)
			{				
				var btn:FavFactGraphic = e.target as FavFactGraphic;
			
				fmodel.activeMaterial = btn.fact;
				fmodel.sliderDate = btn.currentDate;				
				model.setChoosenField({rec: btn.getSelfRec()});
				
				var eventF:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.ONE_NEW_FACT_PAGE);
				eventF.mode = "EXPAND_MODE";
				dispatch(eventF);					
			}
			else if (e.target is FavPreview)
			{
				model.activeMaterial = e.target.oneNewData;			
				model.setChoosenField({rec: e.target.getSelfRec()});
			
				var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.ONE_NEW_PAGE);
				event.mode = "EXPAND_MODE";
				dispatch(event);
			}			
		}
		
		private function charged(e:InteractiveEvent):void 
		{				
			view.deleteById( e.target.parent.id, e.target.parent.parent.parent.name, e.target.parent.oneNewData.type);	
			
			var data:Object = new Object();
			switch (e.target.parent.oneNewData.type) 
			{
				case "photo":				
				case "video":
				case "text":
					data.type = "material"
				break;
				case "fact":
					data.type = "activity"
				break;
				default:
			}	
				
			dispatch( new DataLoadServiceEvent(DataLoadServiceEvent.REMOVE_FROM_FAVORITES, true, false,  e.target.parent.id, null, data));
			
		}
		
		private function loadedMaterials(e:DataLoadServiceEvent):void 
		{
			view.setTexts(fav.textList);
			view.setPhotoVideo(fav.photoVideoList, fav.photoCount, fav.videoCount);			
		}
		
		private function loadedFacts(e:DataLoadServiceEvent):void 
		{
			view.setEvents(fav.factsList);
		}		
		
		private function refreshData(e:DataLoadServiceEvent):void
		{
			view.refreshData();
		}
		
		override protected function removeAllHandlers():void
		{			
			super.removeAllHandlers();
			removeViewListener(AnimationEvent.FAVORITES_ANIMATION_FINISHED, dispatch, AnimationEvent);				
		}		
	
	}
}
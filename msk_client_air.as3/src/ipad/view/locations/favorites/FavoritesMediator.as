package ipad.view.locations.favorites
{
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.IpadEvent;
	import app.view.baseview.photo.OnePhoto;
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import ipad.model.datafav.IFavoritesModel;
	import ipad.view.slider.ElementFact;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	
	public class FavoritesMediator extends Mediator
	{
		[Inject]
		public var view:Favorites;
		
		[Inject]
		public var fav:IFavoritesModel;
		
		/*
		   [Inject]
		   public var model:IAllNewsModel;
		
		   [Inject]
		 public var fmodel:IFactsModel;*/
		
		override public function onRegister():void
		{
			//activeView = view;			
			//super.onRegister();	
			
			addViewListener(AnimationEvent.FAVORITES_ANIMATION_FINISHED, waitFinishAnim, AnimationEvent);
			view.init();
			//addViewListener(InteractiveEvent.HAND_CHARGED, charged, InteractiveEvent,true);	
			//addViewListener(InteractiveEvent.HAND_PUSH, push, InteractiveEvent, true);	
		
		}
		
		private function waitFinishAnim(e:AnimationEvent):void
		{
			addContextListener(DataLoadServiceEvent.FAVORITES_MATERIALS_LOADED, loadedMaterials, DataLoadServiceEvent);
			addContextListener(DataLoadServiceEvent.FAVORITES_FACTS_LOADED, loadedFacts, DataLoadServiceEvent);
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_FAVORITES_MATERIALS));
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_FAVORITES_FACTS));
			
			eventMap.mapListener(view.stage, MouseEvent.MOUSE_UP, stopDragElement, MouseEvent);
			addViewListener(MouseEvent.MOUSE_DOWN, startDragElement, MouseEvent);
			
			//eventMap.mapListener(view.stage, MouseEvent.DOUBLE_CLICK, tryToDeleteDragElement, MouseEvent);
			
			addViewListener(MouseEvent.DOUBLE_CLICK, tryToDeleteDragElement, MouseEvent);
			//addViewListener(TouchEvent.TOUCH_TAP, deleteElement, TouchEvent);
			//addViewListener(TransformGestureEvent.GESTURE_SWIPE, deleteElement, TransformGestureEvent);
			
			
		}
		
		private function tryToDeleteDragElement(e:MouseEvent):void 
		{
			trace("TRY DELETE", e.target);	
			if (e.target is FavPreview)
			(e.target as FavPreview).closeShow();	
			else if (e.target is OnePhoto)
			(e.target.parent as FavPreview).closeShow();
			else if (e.target is ElementFact)
			(e.target as ElementFact).closeShow();
		}
		
		private function swipehandler(evt:TransformGestureEvent):void
		{
			//myTextField.text = "I've been swiped";
			//myTextField.y = 50;
			//addChild(myTextField);
			trace("SWIPE!!!!");
		}
		
		private function deleteElement(e:TouchEvent):void
		{
			trace("TAP!!!!");
		}
		
		/*private function push(e:InteractiveEvent):void
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
		
		 }*/
		
		private function loadedMaterials(e:DataLoadServiceEvent):void
		{
			view.setTexts(fav.textList.reverse());
			view.setPhotoVideo(fav.photoVideoList.reverse(), fav.photoCount, fav.videoCount);
		}
		
		private function loadedFacts(e:DataLoadServiceEvent):void
		{
			//	trace("FACTS LOADED!!!!!!!!!!!!", fav.factsList.length);
			view.setEvents(fav.factsList.reverse());
		}
		
		private function stopDragElement(e:MouseEvent):void
		{
			view.startSlidersInteraction();
			TweenLite.killDelayedCallsTo(startDragElementDelay);
			eventMap.unmapListener(view.stage, MouseEvent.MOUSE_MOVE, view.updateDragElement, MouseEvent);
			view.removeDragElement(e.stageX, e.stageY);
		}
		
		private function startDragElement(e:MouseEvent):void
		{
			if (e.target is FavPreview)
			{
				if ((e.target as FavPreview).isActive)
				{
					(e.target as FavPreview).isActive = false;
					(e.target as FavPreview).clear();
					dispatch(new IpadEvent(IpadEvent.CLOSE_MATERIAL));
					view.showingMat = null;
					return;
				}
				
				view.setCandidate(e.target as FavPreview);
				TweenLite.delayedCall(0.5, startDragElementDelay);
			}
			else if (e.target is OnePhoto)
			{
				var clip:FavPreview = e.target.parent as FavPreview;
				if (clip.isActive)
				{
					clip.isActive = false;
					clip.clear();
					dispatch(new IpadEvent(IpadEvent.CLOSE_MATERIAL));
					view.showingMat = null;
					return;
				}
				
				view.setCandidate(clip);
				TweenLite.delayedCall(0.5, startDragElementDelay);
			}
			else if (e.target is ElementFact)
			{
				if ((e.target as ElementFact).isActive)
				{
					// send close
					(e.target as ElementFact).isActive = false;
					(e.target as ElementFact).clear();
					dispatch(new IpadEvent(IpadEvent.CLOSE_MATERIAL));
					view.showingMat = null;
					return;
				}
				
				view.setCandidate(e.target as ElementFact);
				TweenLite.delayedCall(0.5, startDragElementDelay);
			}
			
			if (e.target.name == "closeFav")
			{
				//trace("CLOSE FAV",  e.target.parent.oneHour.id);
				var __type:String ;
				if ( e.target.parent is ElementFact)
				{
					view.deleteById( e.target.parent.id, "FactFavLeftPanelSlider"/*e.target.parent.parent.parent.name*/, "fact");
					__type = "fact";
				}
				else
				{
					
					view.deleteById( e.target.parent.id, e.target.parent.parent.parent.name, e.target.parent.oneNewData.type);
					__type = e.target.parent.oneNewData.type;
					
				}
				//(e.target.parent as FavPreview).closeShow();
				
				
				  var data:Object = new Object();
				   switch (__type)
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
			
		}
		
		private function startDragElementDelay():void
		{
			if (view.checkCandidate())
			{
				view.stopSlidersInteraction();
				eventMap.mapListener(view.stage, MouseEvent.MOUSE_MOVE, view.updateDragElement, MouseEvent);
			}
			/*else if (view.checkSwipe())
			{
				
			}*/
			
		}
	
	/*
	   private function refreshData(e:DataLoadServiceEvent):void
	   {
	   view.refreshData();
	   }
	
	   override protected function removeAllHandlers():void
	   {
	   super.removeAllHandlers();
	   removeViewListener(AnimationEvent.FAVORITES_ANIMATION_FINISHED, dispatch, AnimationEvent);
	 }	*/
	
	}
}
package app.view.HELPTEMPSCREEN
{
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.InteractiveRemoteEvent;
	import app.contoller.events.IpadEvent;
	import app.contoller.events.ServerUpdateEvent;
	import app.model.dataphoto.IPhotoNewsModel;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class HelpScreenMediator extends Mediator
	{
		[Inject]
		public var view:HelpScreen;
		
		[Inject]
		public var model:IPhotoNewsModel;
		
		override public function onRegister():void
		{
			
			eventMap.mapListener(view.btn_1, MouseEvent.CLICK, btn1Clicked, MouseEvent);
			eventMap.mapListener(view.btn_2, MouseEvent.CLICK, btn2Clicked, MouseEvent);
			eventMap.mapListener(view.btn_3, MouseEvent.CLICK, btn3Clicked, MouseEvent);
			
			/*
			   eventMap.mapListener(view.menu_1, MouseEvent.CLICK, mapClicked, MouseEvent);
			   eventMap.mapListener(view.menu_2, MouseEvent.CLICK, eventsClicked, MouseEvent);
			   eventMap.mapListener(view.menu_3, MouseEvent.CLICK, newsClicked, MouseEvent);
			 eventMap.mapListener(view.menu_4, MouseEvent.CLICK, broadcastClicked, MouseEvent);*/
			
			eventMap.mapListener(view.menu_1, MouseEvent.CLICK, filtersClicked, MouseEvent);
			eventMap.mapListener(view.menu_2, MouseEvent.CLICK, menuClicked, MouseEvent);
			eventMap.mapListener(view.menu_3, MouseEvent.CLICK, btn4Clicked, MouseEvent);
			eventMap.mapListener(view.menu_4, MouseEvent.CLICK, btn5Clicked, MouseEvent);
			eventMap.mapListener(view.menu_6, MouseEvent.CLICK, videoNewUpdate, MouseEvent);
			eventMap.mapListener(view.menu_7, MouseEvent.CLICK, geoNewUpdate, MouseEvent);
			eventMap.mapListener(view.menu_8, MouseEvent.CLICK, ipadPopupNew, MouseEvent);
			eventMap.mapListener(view.menu_9, MouseEvent.CLICK, photoNewsGo, MouseEvent);
			eventMap.mapListener(view.menu_10, MouseEvent.CLICK, changeRubricInSecondScreen, MouseEvent);
			
			eventMap.mapListener(view.menu_5, MouseEvent.CLICK, pausePlayHandler, MouseEvent);
			
			addContextListener(DataLoadServiceEvent.LOAD_COMPLETED_PHOTO_NEWS, refreshData, DataLoadServiceEvent);
			
			//addViewListener(KeyboardEvent.KEY_DOWN, selectKey, KeyboardEvent);
			
			eventMap.mapListener(view.stage, KeyboardEvent.KEY_DOWN, selectKey, KeyboardEvent);
		
		}
		
		private function selectKey(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case 49:
					trace("LOAD NEW");
					dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ONE_NEW, true, false, 232879));
					break;
				case 50: 
					dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ONE_NEW, true, false, 305763));
					break;
				case 51: 
					dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ONE_NEW, true, false, 409243));
					break;
				case 81: 
					dispatch(new ChangeLocationEvent(ChangeLocationEvent.SHOW_FILTERS));
					break;
				case 73: 
					dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.SHOW_CONNECTION_SHAPES));
					break;
				case 87: 
					dispatch(new ChangeLocationEvent(ChangeLocationEvent.SHOW_MENU));
					break;
				
				case 65: 
					var event1:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.MAIN_SCREEN);
					event1.mode = "MENU_MODE";
					dispatch(event1);
					break;
				
				case 83: 
					var event2:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.CUSTOM_SCREEN);
					event2.mode = "MENU_MODE";
					dispatch(event2);
					break;
				
				case 68: 
					var event3:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.STORY_SCREEN);
					event3.mode = "MENU_MODE";
					dispatch(event3);
					break;
				
				case 187:
					dispatch(new InteractiveRemoteEvent(InteractiveRemoteEvent.USER_ACTIVE));
					break;
				
				case 189:
					dispatch(new InteractiveRemoteEvent(InteractiveRemoteEvent.USER_LOST));
					break;
					
				case 219:
					dispatch(new IpadEvent(IpadEvent.IPAD_CONNECTING));
					break;
					
				case 221:
					dispatch(new IpadEvent(IpadEvent.IPAD_DISCONNECTING));
					break;
					
				default: 
			}
			
			trace("KEY CODE:::::::::::  ", e.keyCode);
		}
		
		private var isPause:Boolean = true;
		
		private function pausePlayHandler(e:MouseEvent):void
		{
			isPause = !isPause;
			
			if (isPause)
			{
				dispatch(new IpadEvent(IpadEvent.PAUSE));
			}
			else
			{
				dispatch(new IpadEvent(IpadEvent.PLAY));
			}
		
		}
		
		private function changeRubricInSecondScreen(e:MouseEvent):void
		{
			//dispatch(new IpadEvent(IpadEvent.SETTINGS_CHANGED, true, false, "3"));		
			dispatch(new IpadEvent(IpadEvent.PRIMARY_SCREEN, true, false, "STORY_SCREEN"));
		}
		
		private function photoNewsGo(e:MouseEvent):void
		{
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ONE_NEW, true, false, 409243));
		}
		
		private function ipadPopupNew(e:MouseEvent):void
		{
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ONE_NEW, true, false, 220581));
		}
		
		private function videoNewUpdate(e:MouseEvent):void
		{
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ONE_NEW, true, false, 305763));
		}
		
		private function geoNewUpdate(e:MouseEvent):void
		{
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ONE_NEW, true, false, 232879));
		}
		
		private function btn5Clicked(e:MouseEvent):void
		{
			dispatch(new InteractiveRemoteEvent(InteractiveRemoteEvent.USER_LOST));
		}
		
		private function btn4Clicked(e:MouseEvent):void
		{
			dispatch(new InteractiveRemoteEvent(InteractiveRemoteEvent.USER_ACTIVE));
		}
		
		private function filtersClicked(e:MouseEvent):void
		{
			var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.SHOW_FILTERS);
			dispatch(event);
		}
		
		private function menuClicked(e:MouseEvent):void
		{
			var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.SHOW_MENU);
			//event.mode = "MENU_MODE";
			dispatch(event);
		}
		
		private function favClicked(e:MouseEvent):void
		{
			var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.FAVORITES_PAGE);
			event.mode = "MENU_MODE";
			dispatch(event);
		}
		
		private function broadcastClicked(e:MouseEvent):void
		{
			var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.BROADCAST_PAGE);
			event.mode = "MENU_MODE";
			dispatch(event);
		}
		
		private function newsClicked(e:MouseEvent):void
		{
			var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.ONE_NEW_PAGE);
			event.mode = "MENU_MODE";
			dispatch(event);
		}
		
		private function eventsClicked(e:MouseEvent):void
		{
			var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.FACT_PAGE);
			event.mode = "MENU_MODE";
			dispatch(event);
		}
		
		private function mapClicked(e:MouseEvent):void
		{
			var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.MAP_PAGE);
			event.mode = "MENU_MODE";
			dispatch(event);
		}
		
		private function btn1Clicked(e:MouseEvent):void
		{
			var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.MAIN_SCREEN);
			event.mode = "MENU_MODE";
			dispatch(event);
		}
		
		private function btn2Clicked(e:MouseEvent):void
		{
			var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.CUSTOM_SCREEN);
			event.mode = "MENU_MODE";
			dispatch(event);
		}
		
		private function btn3Clicked(e:MouseEvent):void
		{
			var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.STORY_SCREEN);
			event.mode = "MENU_MODE";
			dispatch(event);
		}
		
		private function refreshData(e:DataLoadServiceEvent):void
		{
			//view.refreshData(model.photoThumbnails);
		}
	}

}


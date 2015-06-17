package app.services.state
{
	import app.AppSettings;
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.FilterEvent;
	import app.contoller.events.GraphicInterfaceEvent;
	import app.contoller.events.InteractiveServiceEvent;
	import app.contoller.events.IpadEvent;
	import app.model.config.IConfig;
	import app.model.dataall.IAllNewsModel;
	import app.model.datafact.IFactsModel;
	import app.model.datafilters.IFilterDataModel;
	import app.model.dataphoto.IPhotoNewsModel;
	import app.model.datauser.IUser;
	import app.model.datavideo.IVideoNewsModel;
	import app.model.types.AnimationType;
	import app.view.MainView;
	import app.view.utils.video.events.VideoEvent;
	import com.greensock.TweenLite;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import org.robotlegs.mvcs.Actor;
	
	public class NavigationService extends Actor implements INavigationService
	{
		[Inject]
		public var contextView:DisplayObjectContainer;
		[Inject]
		public var photoNews:IPhotoNewsModel;
		[Inject]
		public var allNews:IAllNewsModel;
		[Inject]
		public var videoNews:IVideoNewsModel;
		[Inject]
		public var facts:IFactsModel;
		[Inject]
		public var config:IConfig;
		[Inject]
		public var user:IUser;
		[Inject]
		public var filters:IFilterDataModel;
		
		private static var mainScreenNames:Array = ["MAIN_SCREEN", "CUSTOM_SCREEN", "STORY_SCREEN"];
		public var LOCATIONS:Dictionary = new Dictionary();
		
		private var startLocation:String = ChangeLocationEvent.MAIN_SCREEN; //ChangeLocationEvent.ONE_NEW_PAGE;// 
		private var currentLocation:String = startLocation;
		private var nextLocation:String = startLocation;
		private var lastLocation:String = startLocation;
		private var isParallelChange:Boolean = false;
		private var view:MainView;
		private var coherentViewAnim:Boolean = false;
		private var isBlocked:Boolean = false;
		private var isMenuOpen:Boolean = false;
		private var isFiltersOpen:Boolean = false;
		private var isIpadPopupOpen:Boolean = false;
		private var count:int = 0;		
		
		private static var filterLocations:Dictionary = new Dictionary();
		{
			filterLocations[ChangeLocationEvent.NEWS_PAGE_DAY] = true;
			filterLocations[ChangeLocationEvent.ONE_NEW_PAGE] = true;
			filterLocations[ChangeLocationEvent.NEWS_PAGE_HOUR] = true;
			filterLocations[ChangeLocationEvent.FACT_PAGE] = true;
			filterLocations[ChangeLocationEvent.ONE_NEW_FACT_PAGE] = true;
			filterLocations[ChangeLocationEvent.MAP_PAGE] = true;
		}
		
		public function NavigationService():void
		{
		
		}
		
		public function get getCurrentLocation():String
		{
			return currentLocation;
		}
		
		public function start():void
		{
			dispatch(new InteractiveServiceEvent(InteractiveServiceEvent.STOP_INTERACTION));
			
			locationManagerInit();
			view = (contextView.getChildByName("mainView") as MainView);
			view.addMainScreen(startLocation);
			
			dispatch(new ChangeLocationEvent(ChangeLocationEvent.GO_TO_MAIN_SCREEN_ALONE));
			dispatch(new AnimationEvent(AnimationEvent.TO_MAIN_SCREEN_ANIMATION)); //	!!!!!!!!!!!!!!!! add		
		}
		
		public function checkForStartLocation(event:GraphicInterfaceEvent):void
		{
			var str:String = viewIsComplete(startLocation, getClassName(getQualifiedClassName(event.view)));
			
			if (checkForCompleted(startLocation))
			{
				resetLocation(startLocation);
				dispatch(new AnimationEvent(AnimationEvent.TO_MAIN_SCREEN_ANIMATION));
			}
		}
		
		public function location(event:ChangeLocationEvent):void
		{
			if (isBlocked)
				return;
			
			if (event.type == ChangeLocationEvent.BACK_FROM_ONE_NEW)
			{
				nextLocation = lastLocation;
			}
			else
				nextLocation = event.type;
			
			if (currentLocation == nextLocation)
			{
				// SHAKE SCREEN
				return;
			}
			
			closePopups();
			checkforIpadDelay();
			
			lastLocation = currentLocation;
			isBlocked = true;
			dispatch(new InteractiveServiceEvent(InteractiveServiceEvent.STOP_INTERACTION));			
			
			if (isMainScreen(nextLocation))
				config.currentScreen = nextLocation;
			
			view.animatorToFront = false;
			
			if (event.type == ChangeLocationEvent.BACK_FROM_ONE_NEW)
			{
				view.animatorToFront = true;
				dispatch(new ChangeLocationEvent(ChangeLocationEvent.ANIMATOR_SPLIT_SCREEN));
			}
			else if (event.mode == ChangeLocationEvent.EXPAND_MODE)
			{
				dispatch(new ChangeLocationEvent(ChangeLocationEvent.ANIMATOR_EXPAND_SCREEN));
			}
			else if (event.mode == ChangeLocationEvent.MENU_MODE)
			{
				if (isPage(nextLocation) && isPage(currentLocation))
				{
					if (currentLocation == "ONE_NEW_PAGE" && (nextLocation == "NEWS_PAGE_HOUR" || nextLocation == "NEWS_PAGE_DAY"))
					{
						view.animatorToFront = true;
						dispatch(new ChangeLocationEvent(ChangeLocationEvent.ANIMATOR_SPLIT_SCREEN));
					}
					else if (currentLocation == "ONE_NEW_FACT_PAGE" && nextLocation == "FACT_PAGE")
					{
						view.animatorToFront = true;
						dispatch(new ChangeLocationEvent(ChangeLocationEvent.ANIMATOR_SPLIT_SCREEN));
					}
					else
					{
						dispatch(new ChangeLocationEvent(ChangeLocationEvent.ANIMATOR_FLIP_SCREEN));
					}
				}
				else if (isPage(nextLocation) && isMainScreen(currentLocation))
				{	
					dispatch(new ChangeLocationEvent(ChangeLocationEvent.PAGE_FROM_MAIN));
				}
				else if (isPage(currentLocation) && isMainScreen(nextLocation))
				{
					//trace("HERE!!!!!!!!!!!!!!!!!!", currentLocation);
					if (currentLocation == "ONE_NEW_FACT_PAGE" || currentLocation == "ONE_NEW_PAGE")
					{
						view.animatorToFront = true;
						dispatch(new ChangeLocationEvent(ChangeLocationEvent.ANIMATOR_SPLIT_SCREEN));
					}
					else
					{
						view.animatorToFront = false;
						dispatch(new ChangeLocationEvent(ChangeLocationEvent.MAIN_FROM_PAGE));
					}
				}
			}
			
			if (isPage(nextLocation) && isPage(currentLocation))
			{
				dispatch(new ChangeLocationEvent(ChangeLocationEvent.REMOVE_PAGE));
				flush();
				view.addPageLocation(nextLocation);
				view.removeLocation(currentLocation);
				
				if (event.mode == "MENU_MODE")
				{
					if (currentLocation == "ONE_NEW_PAGE" && (nextLocation == "NEWS_PAGE_HOUR" || nextLocation == "NEWS_PAGE_DAY"))
					{
						dispatch(new ChangeLocationEvent("BACK_FROM_ONE_NEW_START"));
					}
					else if (currentLocation == "ONE_NEW_FACT_PAGE" && nextLocation == "FACT_PAGE")
					{
						dispatch(new ChangeLocationEvent("BACK_FROM_ONE_NEW_START"));
					}
					else
					{
						nullFilters();
						dispatch(new ChangeLocationEvent("FLIP_MODE"));
					}
				}
				else if (event.mode == "EXPAND_MODE")				
					dispatch(new ChangeLocationEvent("EXPAND_MODE"));				
				else if (event.mode == "STRETCH_IN")				
					dispatch(new ChangeLocationEvent("STRETCH_IN"));				
				else				
					dispatch(new ChangeLocationEvent("BACK_FROM_ONE_NEW_START"));
				
			}
			else if (isPage(nextLocation) && isMainScreen(currentLocation))
			{
				nullFilters();
				
				flush();
				view.addPageLocation(nextLocation);
				
				if (event.mode == "STRETCH_MODE")
				{					
					view.removeLocation(currentLocation);				
					dispatch(new ChangeLocationEvent("STRETCH_MODE"));
				}
				else if (event.mode == "MENU_MODE")
				{
					view.removeLocation(currentLocation);
					dispatch(new ChangeLocationEvent("FLIP_MODE"));
				}
				else if (event.mode == "EXPAND_MODE")
				{
					view.removeLocation(currentLocation);
					dispatch(new ChangeLocationEvent("EXPAND_MODE"));
				}
			}
			else if (!isMainScreen(currentLocation) && isMainScreen(nextLocation))
			{
				nullFilters();				
				flush();
				
				view.removeLocation(currentLocation);
				view.addAllScreen();
				
				dispatch(new ChangeLocationEvent(ChangeLocationEvent.REMOVE_PAGE));
				dispatch(new ChangeLocationEvent("GO_TO_" + nextLocation + "_BACK"));
				dispatch(new AnimationEvent(AnimationEvent.TO_MAIN_SCREEN_ANIMATION));				
			}
			else if (isMainScreen(currentLocation) && isMainScreen(nextLocation))
			{
				nullFilters();
				
				flush();
				view.add3Screen(currentLocation);
				dispatch(new ChangeLocationEvent("GO_TO_" + nextLocation + "_MAIN_WAY"));
			}
		}
		
		private function checkforIpadDelay():void 
		{

		}
		
		private function nullFilters():void
		{
			filters.setNullToAll();
			dispatch(new FilterEvent(FilterEvent.DISELECT));
		}
		
		private function closePopups():void
		{
			if (isMenuOpen)
				dispatch(new ChangeLocationEvent(ChangeLocationEvent.HIDE_MENU));
			if (isFiltersOpen)
				dispatch(new ChangeLocationEvent(ChangeLocationEvent.HIDE_FILTERS));
			if (isIpadPopupOpen)
				dispatch(new ChangeLocationEvent(ChangeLocationEvent.HIDE_IPAD_POPUP));		
		}
		
		private function flush():void
		{
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.FLUSH_LOADERS));
		}
		
		private function isPage(_name:String):Boolean
		{
			return (_name.indexOf("PAGE") != -1);
		}
		
		private function isMainScreen(_name:String):Boolean
		{
			for (var i:int = 0; i < mainScreenNames.length; i++)
			{
				if (_name == mainScreenNames[i])
					return true;
			}
			return false;
		}		
		
		public function checkForReadyAnimation_3():void
		{
			count++;
			
			if (count == 3)
			{
				count = 0;
				dispatch(new ChangeLocationEvent(ChangeLocationEvent.START_3_SCREEN));
			}
		}
		
		public function animationFinished(event:AnimationEvent):void
		{
			if (event.animationType == AnimationType.OUT)
			{
				viewIsComplete(currentLocation, getClassName(getQualifiedClassName(event.view)));
				event.view.remove();
				event.view.parent.removeChild(event.view);
				
				if (checkForCompleted(currentLocation))
				{
					trace("CHECK", currentLocation);
					resetLocation(currentLocation);
					eventMap.mapListener(contextView, Event.ENTER_FRAME, delayedStartNewLocation, Event);
				}
			}
			
			if (event.animationType == AnimationType.IN)
			{
				if (event.type == AnimationEvent.MAIN_SCREEN_FINISHED || event.type == AnimationEvent.STORY_SCREEN_FINISHED || event.type == AnimationEvent.CUSTOM_SCREEN_FINISHED || event.type == AnimationEvent.PAGE_ANIMATION_FINISHED)
				{
					currentLocation = nextLocation;
					config.currentLocation = currentLocation;
					dispatch(new IpadEvent(IpadEvent.LOCATION_CHANGED, true, false, currentLocation));
					
					isBlocked = false;
					dispatch(new InteractiveServiceEvent(InteractiveServiceEvent.START_INTERACTION));
					return;					
				}
				else
				{
					viewIsComplete(nextLocation, getClassName(getQualifiedClassName(event.view)));
					
					if (checkForCompleted(nextLocation))
					{
						currentLocation = nextLocation;
						config.currentLocation = currentLocation;
						dispatch(new IpadEvent(IpadEvent.LOCATION_CHANGED, true, false, currentLocation));
						
						resetLocation(nextLocation);
						isBlocked = false;
						dispatch(new InteractiveServiceEvent(InteractiveServiceEvent.START_INTERACTION));
					}
				}
			}
		}
		
		public function openPopup(data:*):void
		{
			if (data == null)
				return;
				
			if (isIpadPopupOpen == false)
				closePopups();
			
			isIpadPopupOpen = true;
			dispatch(new VideoEvent(VideoEvent.TOP_ALL_VIDEOS));
			dispatch(new IpadEvent(IpadEvent.SHOW_MATERIAL, true, false, data));
		}
		
		public function hideIpadPopup():void
		{
			isIpadPopupOpen = false;
		}
		
		public function showMenu():void
		{
			if (isFiltersOpen)
				return;
			
			var menuEvt:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.MENU);
			menuEvt.currentLocation = currentLocation;
			dispatch(menuEvt);
			
			dispatch(new VideoEvent(VideoEvent.TOP_ALL_VIDEOS));
			isMenuOpen = true;
		}
		
		public function hideMenu():void
		{
			isMenuOpen = false;
		}
		
		public function showFilters():void
		{
			if (isMenuOpen)	return;
			
			if (filterLocations[currentLocation] == undefined)
				return;
			
			dispatch(new VideoEvent(VideoEvent.TOP_ALL_VIDEOS));
			isFiltersOpen = true;
			
			var fEvt:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.FILTERS);
			dispatch(fEvt);
		}
		
		public function hideFilters():void
		{
			isFiltersOpen = false;
		}
		
		private function delayedStartNewLocation(e:Event):void
		{
			eventMap.unmapListener(contextView, Event.ENTER_FRAME, delayedStartNewLocation, Event);
			currentLocation = nextLocation;
		}
		
		public function returnToMainScreen(value:Boolean):void
		{			
			if (value)
			{
				TweenLite.killDelayedCallsTo(_returnToMainScreen);
				TweenLite.delayedCall(AppSettings.USER_LOST_TIME_AUTO_MODE, _returnToMainScreen);
			}
			else			
				TweenLite.killDelayedCallsTo(_returnToMainScreen);			
		}
		
		private function _returnToMainScreen():void
		{
			if (user.is_active) return;
			
			if (currentLocation != user.primaryScreen)
			{
				var event:ChangeLocationEvent = new ChangeLocationEvent(user.primaryScreen);
				event.mode = "MENU_MODE";
				location(event);
			}
			else if (user.is_active == false)			
				dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.RELOAD_DATA));			
		}
		
		//--------------------------------------------------------------------------
		//
		//  SERVICE FUNCTIONS
		//
		//--------------------------------------------------------------------------	
		
		public function locationManagerInit():void
		{
			LOCATIONS[ChangeLocationEvent.MAIN_SCREEN] = [{name: "AllNews", completed: false}, {name: "Employ", completed: false}, {name: "VideoNews", completed: false}, {name: "PhotoNews", completed: false}, {name: "MainNews", completed: false}, {name: "Facts", completed: false}, {name: "Map", completed: false}];
			
			LOCATIONS[ChangeLocationEvent.CUSTOM_SCREEN] = [{name: "AllNews", completed: false}, {name: "Employ", completed: false}, {name: "VideoNews", completed: false}, {name: "PhotoNews", completed: false}, {name: "MainNews", completed: false}, {name: "Facts", completed: false}, {name: "Map", completed: false}];
			
			LOCATIONS[ChangeLocationEvent.STORY_SCREEN] = [{name: "Favorites", completed: false}];
			
			LOCATIONS[ChangeLocationEvent.ONE_NEW_PAGE] = [{name: "OneNewPage", completed: false}];
			LOCATIONS[ChangeLocationEvent.ONE_NEW_FACT_PAGE] = [ { name: "OneNewFactPage", completed: false } ];
			
			LOCATIONS[ChangeLocationEvent.NEWS_PAGE_DAY] = [ { name: "OneNewPage", completed: false } ];//!!!!!!!!
			LOCATIONS[ChangeLocationEvent.NEWS_PAGE_HOUR] = [ { name: "OneNewPage", completed: false } ];//!!!!!!!!
			
			LOCATIONS[ChangeLocationEvent.FACT_PAGE] = [{name: "FactPage", completed: false}];
			LOCATIONS[ChangeLocationEvent.BROADCAST_PAGE] = [{name: "BroadcastPage", completed: false}];
			LOCATIONS[ChangeLocationEvent.FAVORITES_PAGE] = [{name: "OneNewPage", completed: false}];
			
			LOCATIONS[ChangeLocationEvent.MAP_PAGE] = [{name: "MapPage", completed: false}];
		}
		
		public function checkForCompleted(locationname:String):Boolean
		{
			for (var i:int = 0; i < LOCATIONS[locationname].length; i++)
			{
				if (LOCATIONS[locationname][i].completed == false)
					return false;
			}
			
			return true;			
		}
		
		public function viewIsComplete(locationname:String, view:String):String
		{
			for (var i:int = 0; i < LOCATIONS[locationname].length; i++)
			{
				if (LOCATIONS[locationname][i].name == view)
				{
					LOCATIONS[locationname][i].completed = true;
					return view;
				}
			}
			
			return null;
		}
		
		public function resetLocation(locationname:String):void
		{
			for (var i:int = 0; i < LOCATIONS[locationname].length; i++)			
				LOCATIONS[locationname][i].completed = false;			
		}
		
		public function getClassName(className:String):String
		{
			var nomer:int = className.indexOf("::") + 2;
			className = className.substr(nomer);
			return className;
		}
	}
}
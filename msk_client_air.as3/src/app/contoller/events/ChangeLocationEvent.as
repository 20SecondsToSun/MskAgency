package app.contoller.events
{
	
	import app.model.datafilters.FilterData;
	import flash.events.Event;
	
	public class ChangeLocationEvent extends Event
	{
		public static const PAGE:String = "PAGE";
		
		public static const FACT_PAGE:String = "FACT_PAGE";
		public static const BROADCAST_PAGE:String = "BROADCAST_PAGE";
		public static const FAVORITES_PAGE:String = "FAVORITES_PAGE";
		public static const MAP_PAGE:String = "MAP_PAGE";
		public static const ONE_NEW_PAGE:String = "ONE_NEW_PAGE";
		public static const ONE_NEW_FACT_PAGE:String = "ONE_NEW_FACT_PAGE";
		public static const NEWS_PAGE_DAY:String = "NEWS_PAGE_DAY";
		public static const NEWS_PAGE_HOUR:String = "NEWS_PAGE_HOUR";
		
		public static const MENU:String = "MENU";
		public static const SHOW_MENU:String = "SHOW_MENU";
		public static const HIDE_MENU:String = "HIDE_MENU";
		public static const MENU_IS_HIDDEN:String = "MENU_IS_HIDDEN";
		
		public static const SHOW_FILTERS:String = "SHOW_FILTERS";
		public static const HIDE_FILTERS:String = "HIDE_FILTERS";
		public static const FILTERS_IS_HIDDEN:String = "FILTERS_IS_HIDDEN";
		
		public static const HIDE_IPAD_POPUP:String = "HIDE_IPAD_POPUP";
		public static const IPAD_POPUP_IS_HIDDEN:String = "IPAD_POPUP_IS_HIDDEN";
		
		public static const FILTERS:String = "FILTERS";
		
		public static const MAIN_SCREEN:String = "MAIN_SCREEN";
		public static const CUSTOM_SCREEN:String = "CUSTOM_SCREEN";
		public static const STORY_SCREEN:String = "STORY_SCREEN";
		
		public static const GO_TO_MAIN_SCREEN_MAIN_WAY:String = "GO_TO_MAIN_SCREEN_MAIN_WAY";
		public static const GO_TO_CUSTOM_SCREEN_MAIN_WAY:String = "GO_TO_CUSTOM_SCREEN_MAIN_WAY";
		public static const GO_TO_STORY_SCREEN_MAIN_WAY:String = "GO_TO_STORY_SCREEN_MAIN_WAY";
		
		public static const GO_TO_MAIN_SCREEN_BACK_MODE:String = "GO_TO_MAIN_SCREEN_BACK_MODE";
		public static const GO_TO_CUSTOM_SCREEN_BACK_MODE:String = "GO_TO_CUSTOM_SCREEN_BACK_MODE";
		public static const GO_TO_STORY_SCREEN_BACK_MODE:String = "GO_TO_STORY_SCREEN_BACK_MODE";
		
		public static const GO_TO_CUSTOM_SCREEN_ALONE:String = "GO_TO_CUSTOM_SCREEN_ALONE";
		public static const GO_TO_STORY_SCREEN_ALONE:String = "GO_TO_STORY_SCREEN_ALONE";
		public static const GO_TO_MAIN_SCREEN_ALONE:String = "GO_TO_MAIN_SCREEN_ALONE";
		
		public static const GO_TO_CUSTOM_SCREEN_BACK:String = "GO_TO_CUSTOM_SCREEN_BACK";
		public static const GO_TO_STORY_SCREEN_BACK:String = "GO_TO_STORY_SCREEN_BACK";
		public static const GO_TO_MAIN_SCREEN_BACK:String = "GO_TO_MAIN_SCREEN_BACK";
		
		public static const GO_TO_FACT_PAGE:String = "GO_TO_FACT_PAGE";
		public static const GO_TO_VIDEO_PAGE:String = "GO_TO_VIDEO_PAGE";
		public static const GO_TO_TEXT_PAGE:String = "GO_TO_TEXT_PAGE";
		public static const GO_TO_PHOTO_PAGE:String = "GO_TO_PHOTO_PAGE";
		public static const GO_TO_MAP_PAGE:String = "GO_TO_MAP_PAGE";
		public static const GO_TO_ONE_NEW_PAGE:String = "GO_TO_ONE_NEW_PAGE";
		public static const GO_TO_NEWS_PAGE_DAY:String = "GO_TO_NEWS_PAGE_DAY";
		
		public static const SHOW_NEW_BY_ID:String = "SHOW_NEW_BY_ID";
		
		public static const BACK_FROM_ONE_NEW:String = "BACK_FROM_ONE_NEW";
		
		public static const FLIP_MODE:String = "FLIP_MODE";
		public static const EXPAND_MODE:String = "EXPAND_MODE";		
		public static const MENU_MODE:String = "MENU_MODE";
		public static const STRETCH_MODE:String = "STRETCH_MODE";
		public static const STRETCH_IN:String = "STRETCH_IN";
		public static const PAGE_FROM_MAIN:String = "PAGE_FROM_MAIN";
		public static const MAIN_FROM_PAGE:String = "MAIN_FROM_PAGE";
		
		public static const BACK_FROM_ONE_NEW_START:String = "BACK_FROM_ONE_NEW_START";
		
		
		public static const ANIMATOR_SPLIT_SCREEN:String = "ANIMATOR_SPLIT_SCREEN";
		public static const ANIMATOR_EXPAND_SCREEN:String = "ANIMATOR_EXPAND_SCREEN";
		public static const ANIMATOR_FLIP_SCREEN:String = "ANIMATOR_FLIP_SCREEN";
		
		public static const REMOVE_PAGE:String = "REMOVE_PAGE";
		public static const START_3_SCREEN:String = "START_3_SCREEN";		
		
		public static const MAIN_SCREEN_MENU_MODE:String = "MAIN_SCREEN_MENU_MODE";
		
		protected var _currentLocation:String;
		
		public function set currentLocation(value:String):void
		{
			_currentLocation = value;
		}
		
		public function get currentLocation():String
		{
			return _currentLocation;
		}
		
		protected var _id:Number;
		
		public function set id(value:Number):void
		{
			_id = value;
		}
		
		public function get id():Number
		{
			return _id;
		}
		
		protected var _obj:Object;
		
		public function set obj(value:Object):void
		{
			_obj = value;
		}
		
		public function get obj():Object
		{
			return _obj;
		}
		
		protected var _mode:String;
		
		public function set mode(value:String):void
		{
			_mode = value;
		}
		
		public function get mode():String
		{
			return _mode;
		}
		
		protected var _data:*;
		
		public function set data(value:*):void
		{
			_data = value;
		}
		
		public function get data():*
		{
			return _data;
		}
		
		/**
		 *    @constructor
		 */
		public function ChangeLocationEvent(type:String, id:Number = -1, obj:Object = null, mode:String = "", currentLocation:String = "", data:*=null)
		{
			_currentLocation = currentLocation;
			
			_id = id;
			_obj = obj;
			_mode = mode;
			_data = data;
			super(type);
		}
		
		override public function clone():Event
		{
			return new ChangeLocationEvent(type, _id, _obj, _mode,_currentLocation);
		}
	
	}
}

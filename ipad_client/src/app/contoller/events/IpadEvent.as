/**
 * @author metalcorehero
 */
package app.contoller.events
{
	
	import app.model.materials.Material;
	import flash.events.Event;
	
	public class IpadEvent extends Event
	{
		public static const PAUSE:String = "IpadEvent.PAUSE";
		public static const PLAY:String = "IpadEvent.PLAY";
		public static const SHOW_MATERIAL:String = "IpadEvent.SHOW_MATERIAL";
		public static const OPEN_POPUP:String = "IpadEvent.OPEN_POPUP";
		public static const CLOSE_MATERIAL:String = "IpadEvent.CLOSE_MATERIAL";
		public static const SETTINGS_CHANGED:String = "IpadEvent.SETTINGS_CHANGED";
		public static const LOCATION_CHANGED:String = "IpadEvent.LOCATION_CHANGED";
		
		public static const PRIMARY_SCREEN:String = "IpadEvent.PRIMARY_SCREEN";
		public static const CUSTOM_SCREEN_RUBRIC:String = "IpadEvent.CUSTOM_SCREEN_RUBRIC";
		
		public static const LOAD_MATERIALS:String = "IpadEvent.LOAD_MATERIALS";
		public static const LOAD_MAP_MATERIALS:String = "IpadEvent.LOAD_MAP_MATERIALS";
		
		public static const LOAD_FACTS:String = "IpadEvent.LOAD_FACTS";
		public static const MATERIALS_LOADED:String = "IpadEvent.MATERIALS_LOADED";
		public static const FACTS_LOADED:String = "IpadEvent.FACTS_LOADED";
		public static const NO_MATERIALS:String = "IpadEvent.NO_MATERIALS";
		public static const LOAD_MORE:String = "IpadEvent.LOAD_MORE";
		public static const FILTER_CHANGED:String = "IpadEvent.FILTER_CHANGED";
		public static const MENU_OPENED:String = "IpadEvent.MENU_OPENED";
		public static const SCREEN_SHOT:String = "IpadEvent.SCREEN_SHOT";
		public static const VOLUME:String = "IpadEvent.VOLUME";
		public static const HAND_LOST:String = "IpadEvent.HAND_LOST";
		public static const HAND_ACTIVE:String = "IpadEvent.HAND_ACTIVE";
		
		public static const USER_LOST:String = "IpadEvent.USER_LOST";
		public static const USER_ACTIVE:String = "IpadEvent.USER_ACTIVE";
		
		
		public static const STOP_INTERACTION:String = "IpadEvent.STOP_INTERACTION";
		public static const START_INTERACTION:String = "IpadEvent.START_INTERACTION";
		public static const SEND_SHAPES:String = "IpadEvent.SEND_SHAPES";
		public static const SYMBOLS_IS_OK:String = "IpadEvent.SYMBOLS_IS_OK";
		
		public static const ID_CHOOSED:String = "IpadEvent.ID_CHOOSED";
		public static const CHECK_MATCH:String = "IpadEvent.CHECK_MATCH";
		public static const SYMBOLS_CHOOSED:String = "IpadEvent.SYMBOLS_CHOOSED";
		public static const SYMBOLS_BAD:String = "IpadEvent.SYMBOLS_BAD";
		
		
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _data:*;
		protected var _rubric:String;
		
		//--------------------------------------------------------------------------
		//
		//  Initialization
		//
		//--------------------------------------------------------------------------
		
		public function IpadEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false, data:* = null)
		{
			super(type, bubbles, cancelable);
			_data = data;
			_rubric = rubric;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters and setters
		//
		//--------------------------------------------------------------------------
		
		public function get data():*
		{
			return _data;
		}
		
		public function set data(value:*):void
		{
			_data = value;
		}
		public function get rubric():String
		{
			return _rubric;
		}
		
		public function set rubric(value:String):void
		{
			_rubric = value;
		}
		
		//--------------------------------------------------------------------------
		//
		// Overridden API
		//
		//--------------------------------------------------------------------------
		
		override public function clone():Event
		{
			return new IpadEvent(type, bubbles, cancelable, data)
		}	
	}
}

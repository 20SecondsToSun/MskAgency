package app.contoller.events
{
	
	import app.view.baseview.BaseView;
	import app.view.baseview.io.InteractiveObject;
	import flash.events.Event;
	
	public class AnimationEvent extends Event
	{
		
		public static const TO_MAIN_SCREEN_ANIMATION:String = "AnimationEvent.TO_MAIN_SCREEN_ANIMATION";
		public static const STOP:String = "AnimationEvent.STOP";
		
		public static const ALL_NEWS_ANIMATION_FINISHED:String = "AnimationEvent.ALL_NEWS_ANIMATION_FINISHED";
		public static const MAIN_NEWS_ANIMATION_FINISHED:String = "AnimationEvent.MAIN_NEWS_ANIMATION_FINISHED";
		public static const PHOTO_NEWS_ANIMATION_FINISHED:String = "AnimationEvent.PHOTO_NEWS_ANIMATION_FINISHED";
		public static const VIDEO_NEWS_ANIMATION_FINISHED:String = "AnimationEvent.VIDEO_NEWS_ANIMATION_FINISHED";
		public static const FACTS_ANIMATION_FINISHED:String = "AnimationEvent.FACTS_ANIMATION_FINISHED";
		public static const MAP_ANIMATION_FINISHED:String = "AnimationEvent.MAP_ANIMATION_FINISHED";
		public static const EMPLOY_ANIMATION_FINISHED:String = "AnimationEvent.EMPLOY_ANIMATION_FINISHED";
		public static const PAGE_ANIMATION_FINISHED:String = "AnimationEvent.PAGE_ANIMATION_FINISHED";
		public static const MENU_ANIMATION_FINISHED:String = "AnimationEvent.MENU_ANIMATION_FINISHED";
		public static const FAVORITES_ANIMATION_FINISHED:String = "AnimationEvent.FAVORITES_ANIMATION_FINISHED";
		
				
		public static const CUSTOM_SCREEN_FINISHED:String = "AnimationEvent.CUSTOM_SCREEN_FINISHED";
		public static const MAIN_SCREEN_FINISHED:String = "AnimationEvent.MAIN_SCREEN_FINISHED";
		public static const STORY_SCREEN_FINISHED:String = "AnimationEvent.STORY_SCREEN_FINISHED";	
		
		
		public static const CUSTOM_SCREEN_SCREENSHOT_FINISHED:String = "AnimationEvent.CUSTOM_SCREEN_SCREENSHOT_FINISHED";
		public static const MAIN_SCREEN_SCREENSHOT_FINISHED:String = "AnimationEvent.MAIN_SCREEN_SCREENSHOT_FINISHED";
		public static const STORY_SCREEN_SCREENSHOT_FINISHED:String = "AnimationEvent.STORY_SCREEN_SCREENSHOT_FINISHED";
		
		public static const TO_MAIN_SCREEN_VISIBLE:String = "AnimationEvent.TO_MAIN_SCREEN_VISIBLE";
		public static const STRETCH:String = "AnimationEvent.STRETCH";
		
		
		public static const LEFT_PANEL_OUT:String = "AnimationEvent.LEFT_PANEL_OUT";
		public static const LEFT_PANEL_OVER:String = "AnimationEvent.LEFT_PANEL_OVER";
		
		
		public static const DEACTIVATE:String = "AnimationEvent.DEACTIVATE";
		public static const ACTIVATE:String = "AnimationEvent.ACTIVATE";
		
		public static const HIDE_MENU_AND_GO:String = "AnimationEvent.HIDE_MENU_AND_GO";		
		public static const START_3_SCREEN:String = "AnimationEvent.START_3_SCREEN";
		
		public var location:String;

		protected var _animationType:String;
		protected var _view:InteractiveObject;
		protected var _percent:Number;
		
		public function get animationType():String
		{
			return _animationType;
		}
		
		public function set view(value:InteractiveObject):void
		{
			_view = value;
		}
		
		public function get view():InteractiveObject
		{
			return _view;
		}
		public function set percent(value:Number):void
		{
			_percent = value;
		}
		
		public function get percent():Number
		{
			return _percent;
		}
		
		public function AnimationEvent(type:String, animationType:String = "", view:InteractiveObject = null, percent:Number = 0)
		{
			_animationType = animationType;
			_view = view;
			_percent = percent;			
			super(type);		
		}
		
		override public function clone():Event
		{
			return new AnimationEvent(type, _animationType, _view, _percent);			
		
		}
	
	}
}

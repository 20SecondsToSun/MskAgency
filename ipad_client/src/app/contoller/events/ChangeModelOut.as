package app.contoller.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class ChangeModelOut extends Event
	{
		public static const MAIN_SCREEN:String = "ChangeModelOut.MAIN_SCREEN";
		public static const CUSTOM_SCREEN:String = "ChangeModelOut.CUSTOM_SCREEN";
		public static const STORY_SCREEN:String = "ChangeModelOut.STORY_SCREEN";
		
		public static const MAIN_SCREEN_SCREENSHOT:String = "ChangeModelOut.MAIN_SCREEN_SCREENSHOT";
		public static const CUSTOM_SCREEN_SCREENSHOT:String = "ChangeModelOut.CUSTOM_SCREEN_SCREENSHOT";
		public static const STORY_SCREEN_SCREENSHOT:String = "ChangeModelOut.STORY_SCREEN_SCREENSHOT";
		
		
		public static const ONE_DAY_NEWS:String = "ChangeModelOut.ONE_DAY_NEWS";
		
		
		protected var _day:Date;
		
		public function get day():Date
		{
			return _day;
		}
		public function set day(value:Date):void
		{
			_day = value;
		}
		/**
		 *    @constructor
		 */
		public function ChangeModelOut(type:String,day:Date = null)
		{
			_day = day;
			
			super(type);
		
		}
		
		override public function clone():Event
		{
			return new ChangeModelOut(type,_day);
		}
	
	}

}
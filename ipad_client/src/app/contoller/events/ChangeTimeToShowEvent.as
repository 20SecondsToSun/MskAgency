package app.contoller.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class ChangeTimeToShowEvent extends Event
	{
		public static const CHANGE_TIME:String = "ChangeTimeToShowEvent.CHANGE_TIME";
	
		protected var _hour:Number;
		
		public function get hour():Number
		{
			return _hour;
		}
		
		/**
		 *    @constructor
		 */
		public function ChangeTimeToShowEvent(type:String, hour:Number = 0)
		{
			_hour = hour;
			
			super(type);
		
		}
		
		override public function clone():Event
		{
			return new ChangeTimeToShowEvent(type, _hour);
		}
	
	}

}
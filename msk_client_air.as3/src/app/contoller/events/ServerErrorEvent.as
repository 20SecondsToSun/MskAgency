package app.contoller.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class ServerErrorEvent extends Event
	{
		public static const AUTH_FAILED:String = "ServerErrorEvent.AUTH_FAILED";
		public static const REQUEST_FAILED:String = "ServerErrorEvent.REQUEST_FAILED";
		public static const REQUEST_COMPLETE:String = "ServerErrorEvent.REQUEST_COMPLETE";
		
		protected var _code:String;
		protected var _message:String;
		
		public function ServerErrorEvent(type:String, code:String = "", message:String = "")		
		{
			_code = code;
			_message = message;
			super(type);
		}
		
		public function  get code():String
		{
			return _code;
		}
		
		public function  get message():String
		{
			return _message;
		}
		
		override public function clone():Event
		{
			return new ServerErrorEvent(type, _code, _message);
		}
	}
}
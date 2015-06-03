package app.contoller.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class SocketServerEvent extends Event
	{
		
		public static const START_SOCKET_SERVER:String = "SocketServerEvent.START_SOCKET_SERVER";
		
		public function SocketServerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new SocketServerEvent(type, bubbles, cancelable);
		}
		
		public override function toString():String
		{
			return formatToString("SocketServerEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
	
	}

}
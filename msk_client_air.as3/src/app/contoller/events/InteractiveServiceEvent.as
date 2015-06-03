package app.contoller.events
{
	import flash.events.Event;
	
	public class InteractiveServiceEvent extends Event
	{		
		public static const START_INTERACTION:String = "InteractiveServiceEvent.START_INTERACTION";
		public static const STOP_INTERACTION:String = "InteractiveServiceEvent.STOP_INTERACTION";
		
		public function InteractiveServiceEvent(type:String)
		{
			super(type);
		}
		
		override public function clone():Event
		{
			return new InteractiveServiceEvent(type);
		}
	
	}
}

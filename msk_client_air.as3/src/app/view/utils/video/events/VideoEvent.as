package app.view.utils.video.events
{	
	// IMPORTS
	import flash.events.Event;
	
	public class VideoEvent extends Event
	{
		// CUSTOM EVENTS 
		public static const CHANGED_SIZE:String = "CHANGED_SIZE";
		public static const TOP_ALL_VIDEOS:String = "TOP_ALL_VIDEOS";
		
		public var height:Number;
		public var id:String;
		
		public function VideoEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, _height:Number = 0, _id:String = "")
		{
			height = _height;
			id = _id;
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new VideoEvent(type, bubbles, cancelable, height, id);
		}
		
		public override function toString():String
		{
			return formatToString("CustomEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
	}
}
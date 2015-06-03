package app.contoller.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class DataChangedEvent extends Event 
	{
		
		public static const DATA_CHANGED:String = "DataChangedEvent.DATA_CHANGED";
		
		
		
		protected var _data:Object ;
		
		public function set data(value:Object):void 
		{
			_data = value;
		}		
		public function get data():Object
		{
			return _data;
		}		
		
		
		public function DataChangedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object = null) 
		{ 
			_data = data;
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new DataChangedEvent(type, bubbles, cancelable, _data);			
		} 	
		
	}
	
}
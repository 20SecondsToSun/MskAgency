package app.contoller.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FilterEvent extends Event 
	{
		
		public static const SORT_ONE_DAY_NEWS:String = "FilterEvent.SORT_ONE_DAY_NEWS";
		public static const ONE_DAY_NEWS_SORTED:String = "FilterEvent.ONE_DAY_NEWS_SORTED";
		
		public static const GEO_NEWS_SORTED:String = "FilterEvent.GEO_NEWS_SORTED";	
		public static const SORT_GEO_NEWS:String = "FilterEvent.SORT_GEO_NEWS";
		
		public static const DISELECT:String = "FilterEvent.DISELECT";
		public static const SELECT:String = "FilterEvent.SELECT";
		public static const SET_NULL:String = "FilterEvent.SET_NULL";
		
		
		protected var _data:Object ;
		
		public function set data(value:Object):void 
		{
			_data = value;
		}		
		public function get data():Object
		{
			return _data;
		}		
		
		
		public function FilterEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object = null) 
		{ 
			_data = data;
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new FilterEvent(type, bubbles, cancelable, _data);			
		} 	
		
	}
	
}
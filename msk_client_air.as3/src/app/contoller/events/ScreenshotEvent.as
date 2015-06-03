package app.contoller.events 
{
	import app.view.utils.BigCanvas;
	import flash.events.Event;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class ScreenshotEvent  extends Event
	{
		
		public static const TAKE_SCREENSHOT:String = "ScreenshotEvent.TAKE_SCREENSHOT";		
		public static const MAKE_SCREENSHOT:String = "ScreenshotEvent.MAKE_SCREENSHOT";
		
		protected var _rec:Rectangle;
		protected var _shot:BigCanvas;
		
		public function get shot():BigCanvas
		{
			return _shot;
		}
		public function set shot(value:BigCanvas):void
		{
			_shot = value;
		}		
		
		public function get rec():Rectangle
		{
			return _rec;
		}
		public function set rec(value:Rectangle):void
		{
			_rec = value;
		}

		public function ScreenshotEvent(type:String, shot:BigCanvas = null, rec:Rectangle = null)		
		{
			_shot = shot;
			_rec = rec;			
			super(type);		
		}
		
		override public function clone():Event
		{
			return new ScreenshotEvent(type, _shot,_rec);			
		}	
		
	}

}
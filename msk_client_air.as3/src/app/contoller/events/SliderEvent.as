package app.contoller.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author castor troy
	 */
	public class SliderEvent extends Event
	{
		public static const START_INTERACTION:String = "SliderEvent.START_INTERACTION";
		public static const STOP_INTERACTION:String = "SliderEvent.STOP_INTERACTION";
		
		public static const START_INTERACTION_PULL_OUT:String = "SliderEvent.START_INTERACTION_PULL_OUT";
		public static const STOP_INTERACTION_PULL_OUT:String = "SliderEvent.STOP_INTERACTION_PULL_OUT";
		
		public static const VIDEO_SLIDER_START_DRAG:String = "SliderEvent.VIDEO_SLIDER_START_DRAG";
		public static const VIDEO_SLIDER_STOP_DRAG:String = "SliderEvent.VIDEO_SLIDER_STOP_DRAG";
		
		public static const FACT_SLIDER_START_DRAG:String = "SliderEvent.FACT_SLIDER_START_DRAG";
		public static const FACT_SLIDER_STOP_DRAG:String = "SliderEvent.FACT_SLIDER_STOP_DRAG";
		
		/**
		 *    @constructor
		 */
		
		public function SliderEvent(type:String )
		{
			
			
			super(type);
		
		}
		
		override public function clone():Event
		{
			return new SliderEvent(type);			
		
		}
		
	}

}
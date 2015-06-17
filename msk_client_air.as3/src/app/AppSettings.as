package app
{
	import flash.display.StageDisplayState;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class AppSettings
	{
		public static const WIDTH:uint = 1920;
		public static const HEIGHT:uint = 1080;
		
		public static const COLOR:uint = 0x0e0f12;
		public static const FRAMERATE:uint = 30;
		
		public static const SCALEFACTOR:Number = WIDTH / 1920;
		
		public static const FULL_SCREEN_MODE:String = StageDisplayState.NORMAL;
		
		public static const CONTROLL_BY_KINECT:Boolean = true;
		public static const CONTROLL_BY_LEAP:Boolean = false;
		
		public static const IPAD_SYNCH_TIME:int = 15;
		public static const USER_LOST_TIME_AUTO_MODE:int = 5;
	}
}
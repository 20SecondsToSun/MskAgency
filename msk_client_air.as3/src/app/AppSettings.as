package app 
{
	import flash.display.StageDisplayState;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class AppSettings 
	{			
		public static const WIDTH:uint = 1920;//; 1600;/
		public static const HEIGHT:uint = 1080;// 900;// 1080;		
		
		////public static const KINECT_HEIGHT:uint = 480;
		////public static const KINECT_WIDTH:uint  = 640;
		
		public static const COLOR:uint = 0x0e0f12;//0xffffff;//1920;
		public static const FRAMERATE:uint = 30;
		
		public static const SCALEFACTOR:Number = WIDTH / 1920;
		
		public static const FULL_SCREEN_MODE:String = StageDisplayState.NORMAL;//StageDisplayState.FULL_SCREEN_INTERACTIVE;//
		
		////public static const START_ANIMATION_TIME:Number = 1.2;
		////public static const CLOSE_ANIMATION_TIME:Number = 1.2;
		////public static const DRAG_OUT_ANIMATION_TIME:Number 	= 0.8;
		////public static const START_ANIMATION_EASING :String 	= "";
		
		public static const CONTROLL_BY_KINECT :Boolean 	=  false;		
		public static const CONTROLL_BY_LEAP :Boolean 	=  false;
		
		
		public static const IPAD_SYNCH_TIME :int 	=  15;
		public static const USER_LOST_TIME_AUTO_MODE :int =  5;		
	}
}
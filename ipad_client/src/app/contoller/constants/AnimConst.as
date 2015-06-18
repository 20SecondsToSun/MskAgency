package app.contoller.constants 
{
	import com.greensock.easing.Expo;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class AnimConst 
	{		
		public var MainScreen1:Anim;			
		public var MainScreen1Photo:Anim;			
		public var MainScreen1AllNews:Anim;			
		
		public function AnimConst() 
		{			
			MainScreen1 = new Anim(1.95, 2.0, Expo.easeInOut, Expo.easeInOut);			
			MainScreen1Photo = new Anim(1.9, 2.2, Expo.easeInOut, Expo.easeInOut);			
			MainScreen1AllNews = new Anim(2.0, 0.3, Expo.easeInOut, Expo.easeInOut);			
		}
	}
}

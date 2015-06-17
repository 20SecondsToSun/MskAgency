package app.model.datahotnews
{
	import app.contoller.events.ChangeModelOut;
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class HotNewsModel extends Actor implements IHotNewsModel
	{		
		private var _isAnimate:Boolean = true;
		
		public function get isAnimate():Boolean
		{
			return _isAnimate;
		}
		
		public function set isAnimate(value:Boolean):void
		{
			_isAnimate = value;
		}		
	
		public function setModel(value:ChangeModelOut):void
		{			
			switch (value.type)
			{
				case ChangeModelOut.MAIN_SCREEN:					
					break;
					
				case ChangeModelOut.CUSTOM_SCREEN:					
					break;
					
				case ChangeModelOut.STORY_SCREEN:					
					break;
					
				case ChangeModelOut.MAIN_SCREEN_SCREENSHOT: 
				case ChangeModelOut.STORY_SCREEN_SCREENSHOT: 
				case ChangeModelOut.CUSTOM_SCREEN_SCREENSHOT: 
					_isAnimate = false;
					break;
			}
		}	
	}
}
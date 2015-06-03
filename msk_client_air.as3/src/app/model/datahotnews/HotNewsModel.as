package app.model.datahotnews
{
	import app.AppSettings;
	import app.contoller.events.ChangeModelOut;
	import app.contoller.events.DataLoadServiceEvent;
	import app.model.materials.Fact;
	import app.model.materials.Material;
	import app.model.materials.MaterialModel;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
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
			trace("is animate:", value);
			_isAnimate = value;
		}
		
	
		public function setModel(value:ChangeModelOut):void
		{
			//trace("---------------------------------------", value);
			//if (_newsList == null || _newsList.length == 0)
			//	return;
			
			//_isAnimate = false;
			//data = _newsList;
			
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
					//data = _newsList.slice(0, 2);
					break;
				
				default: 
			}
		}
		
		
	
	}

}
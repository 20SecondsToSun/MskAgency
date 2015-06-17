package app.model.dataemploy
{
	import app.contoller.events.ChangeModelOut;
	import app.contoller.events.DataLoadServiceEvent;
	import app.model.materials.Informer;
	import app.model.materials.Weather;
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class EmployModel extends Actor implements IEmployModel
	{
		private var _isAnimate:Boolean = true;
		private var _weather:Vector.<Weather> = new Vector.<Weather>();
		private var _informer:Informer = new Informer();
		
		public function get informer():Informer
		{
			return _informer;
		}
		
		public function set informer(value:Informer):void
		{
			_informer = value;
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_IFORMER_COMPLETED));
		}
		
		public function get weather():Vector.<Weather>
		{
			return _weather;
		}
		
		public function set weather(value:Vector.<Weather>):void
		{
			_weather = value;
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_COMPLETED_WEATHER));
		}
		
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
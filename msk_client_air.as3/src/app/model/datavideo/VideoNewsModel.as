package app.model.datavideo 
{
	import app.contoller.events.ChangeModelOut;
	import app.contoller.events.DataLoadServiceEvent;
	import app.model.materials.Material;
	import app.model.materials.MaterialModel;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class VideoNewsModel extends MaterialModel implements IVideoNewsModel
	{
		private var _isAnimate:Boolean =  true;
		private var _data:Vector.<Material>;
		
		public function get isAnimate():Boolean
		{
			return _isAnimate;
		}
		
		public function set isAnimate(value:Boolean):void
		{
			_isAnimate = value;
		}	
		
		public function get data():Vector.<Material>
		{
			return _data;
		}
		
		public function set data(value:Vector.<Material>):void
		{
			_data = value;
		}
		
		override public function set newsList(value:Vector.<Material>):void
		{
			_newsList = value;
			sortBydate();			
			createDictionary();
			dispatch( new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_COMPLETED_VIDEOS_NEWS));
		}
		override public function  setModel(value:ChangeModelOut):void
		{
			if (_newsList == null || _newsList.length == 0 ) return;
			
			_isAnimate = false;
			data = _newsList;
			
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
					data = _newsList.slice(0, 1);// _videoThumbnails.slice(0, 1);
					break;
				
				default: 
			}
		}
		
	}

}
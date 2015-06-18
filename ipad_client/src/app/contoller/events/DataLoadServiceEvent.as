package app.contoller.events
{

	import app.model.datafilters.FilterData;
	import app.model.materials.Material;
	import flash.display.Bitmap;
    import flash.events.Event;

    public class DataLoadServiceEvent extends Event
    {
     	public static const LOAD_COMPLETED_EMPLOY:String = "DataLoadServiceEvent.LOAD_COMPLETED_EMPLOY";
		public static const LOAD_COMPLETED_PHOTO_NEWS:String = "DataLoadServiceEvent.LOAD_COMPLETED_PHOTO_NEWS";	
		public static const LOAD_COMPLETED_ALL_NEWS:String = "DataLoadServiceEvent.LOAD_COMPLETED_ALL_NEWS";		
		public static const LOAD_COMPLETED_VIDEOS_NEWS:String = "DataLoadServiceEvent.LOAD_COMPLETED_VIDEOS_NEWS";			
		public static const LOAD_COMPLETED_MAIN_NEWS:String = "DataLoadServiceEvent.LOAD_COMPLETED_MAIN_NEWS";
		public static const LOAD_COMPLETED_FACTS:String = "DataLoadServiceEvent.LOAD_COMPLETED_FACTS";
		public static const LOAD_COMPLETED_GEO_NEWS:String = "DataLoadServiceEvent.LOAD_COMPLETED_GEO_NEWS";
		public static const LOAD_COMPLETED_DAYS_NEWS:String = "DataLoadServiceEvent.LOAD_COMPLETED_DAYS_NEWS";
		public static const LOAD_COMPLETED_DAY_DATA:String = "DataLoadServiceEvent.LOAD_COMPLETED_DAY_DATA";
		public static const LOAD_COMPLETED_FILTERS_DATA:String = "DataLoadServiceEvent.LOAD_COMPLETED_FILTERS_DATA";
		public static const LOAD_COMPLETED_ALL_FACTS_DATA:String = "DataLoadServiceEvent.LOAD_COMPLETED_ALL_FACTS_DATA";
		public static const LOAD_COMPLETED_DAY_FACTS:String = "DataLoadServiceEvent.LOAD_COMPLETED_DAY_FACTS";
		public static const LOAD_COMPLETED_MAIN_FACTS:String = "DataLoadServiceEvent.LOAD_COMPLETED_MAIN_FACTS";
		public static const RELOAD_DATA:String = "DataLoadServiceEvent.RELOAD_DATA";
		
		
		
		public static const REFRESH_COMPLETED_EMPLOY:String = "DataLoadServiceEvent.REFRESH_COMPLETED_EMPLOY";
		public static const REFRESH_COMPLETED_PHOTO_NEWS:String = "DataLoadServiceEvent.REFRESH_COMPLETED_PHOTO_NEWS";	
		public static const REFRESH_COMPLETED_ALL_NEWS:String = "DataLoadServiceEvent.REFRESH_COMPLETED_ALL_NEWS";		
		public static const REFRESH_COMPLETED_VIDEOS_NEWS:String = "DataLoadServiceEvent.REFRESH_COMPLETED_VIDEOS_NEWS";			
		public static const REFRESH_COMPLETED_MAIN_NEWS:String = "DataLoadServiceEvent.REFRESH_COMPLETED_MAIN_NEWS";
		public static const REFRESH_COMPLETED_FACTS:String = "DataLoadServiceEvent.REFRESH_COMPLETED_FACTS";
		public static const REFRESH_COMPLETED_GEO_NEWS:String = "DataLoadServiceEvent.REFRESH_COMPLETED_GEO_NEWS";
		public static const REFRESH_COMPLETED_FAVORITES:String = "DataLoadServiceEvent.REFRESH_COMPLETED_FAVORITES";
		
		
		
		public static const NO_MORE:String = "DataLoadServiceEvent.NO_MORE";
		public static const NO_MATERIALS:String = "DataLoadServiceEvent.NO_MATERIALS";
		public static const NO_MATERIALS_SLIDER:String = "DataLoadServiceEvent.NO_MATERIALS_SLIDER";
		public static const CHECK_FOR_FILTER_NEWS:String = "DataLoadServiceEvent.CHECK_FOR_FILTER_NEWS";
		public static const CHECK_FOR_FILTER_FACTS:String = "DataLoadServiceEvent.CHECK_FOR_FILTER_FACTS";
		
		
		public static const LOAD_COMPLETED_DAYS_NEWS_FILTERED:String = "DataLoadServiceEvent.LOAD_COMPLETED_DAYS_NEWS_FILTERED";
		public static const LOAD_COMPLETED_FACTS_FILTERED:String = "DataLoadServiceEvent.LOAD_COMPLETED_FACTS_FILTERED";
		public static const PREPARE_TO_CLEAR_FILTERED:String = "DataLoadServiceEvent.PREPARE_TO_CLEAR_FILTERED";
		
		
		public static const LOAD_FAVORITES_MATERIALS:String = "DataLoadServiceEvent.LOAD_FAVORITES_MATERIALS";
		public static const LOAD_FAVORITES_FACTS:String = "DataLoadServiceEvent.LOAD_FAVORITES_FACTS";
		public static const FAVORITES_FACTS_LOADED:String = "DataLoadServiceEvent.FAVORITES_FACTS_LOADED";
		public static const FAVORITES_MATERIALS_LOADED:String = "DataLoadServiceEvent.FAVORITES_MATERIALS_LOADED";
		
		
		public static const LOAD_COMPLETED_WEATHER:String = "DataLoadServiceEvent.LOAD_COMPLETED_WEATHER";
		public static const LOAD_WEATHER:String = "DataLoadServiceEvent.LOAD_WEATHER";
		
		public static const LOAD_IFORMER_COMPLETED:String = "DataLoadServiceEvent.IFORMER_COMPLETED";
		public static const LOAD_IFORMER:String = "DataLoadServiceEvent.LOAD_IFORMER";
		
		
		
		
		
		
		
				
		public static const ONE_NEW_LOADED:String = "DataLoadServiceEvent.ONE_NEW_LOADED";		
		
		public static const LOAD_MAIN_NEWS:String = "DataLoadServiceEvent.LOAD_MAIN_NEWS";
		public static const LOAD_ONE_NEW:String = "DataLoadServiceEvent.LOAD_ONE_NEW";
		public static const LOAD_ALL_MATERIAL_NEAR_NEWS:String = "DataLoadServiceEvent.LOAD_ALL_MATERIAL_NEAR_NEWS";		
		public static const LOAD_FACTS_DATA:String = "DataLoadServiceEvent.LOAD_FACTS_DATA";		
		public static const LOAD_ALL_FACTS_DAY:String = "DataLoadServiceEvent.LOAD_ALL_FACTS_DAY";		
		public static const LOAD_ALL_FACTS_DATA:String = "DataLoadServiceEvent.LOAD_ALL_FACTS_DATA";		
		public static const LOAD_VIDEO_DATA:String = "DataLoadServiceEvent.LOAD_VIDEO_DATA";
		public static const LOAD_PHOTO_DATA:String = "DataLoadServiceEvent.LOAD_PHOTO_DATA";
		public static const LOAD_ALL_DATA:String = "DataLoadServiceEvent.LOAD_ALL_DATA";
		public static const LOAD_GEO_DATA:String = "DataLoadServiceEvent.LOAD_GEO_DATA";				
		public static const LOAD_MAIN_GEO_DATA:String = "DataLoadServiceEvent.LOAD_MAIN_GEO_DATA";				
		public static const LOAD_DAYS_DATA:String = "DataLoadServiceEvent.LOAD_DAYS_DATA";		
		public static const LOAD_DAY_DATA:String = "DataLoadServiceEvent.LOAD_DAY_DATA";		
		public static const LOAD_ALL_DATA_FOR_IPAD:String = "DataLoadServiceEvent.LOAD_ALL_DATA_FOR_IPAD";		
		public static const ALL_DATA_FOR_IPAD_LOADED:String = "DataLoadServiceEvent.ALL_DATA_FOR_IPAD_LOADED";		
		//public static const LOAD_DAYS_DATA_NOT_IMPORTANT:String = "DataLoadServiceEvent.LOAD_DAYS_DATA_NOT_IMPORTANT";		
		
		public static const FLUSH_LOADERS:String = "DataLoadServiceEvent.FLUSH_LOADERS";	
		
		public static const ADD_TO_FAVORITES:String = "DataLoadServiceEvent.ADD_TO_FAVORITES";	
		public static const REMOVE_FROM_FAVORITES:String = "DataLoadServiceEvent.REMOVE_FROM_FAVORITES";	
		public static const SHOW_CONNECTION_SHAPES:String = "DataLoadServiceEvent.SHOW_CONNECTION_SHAPES";	
		public static const CHECK_MATCH:String = "DataLoadServiceEvent.CHECK_MATCH";	
		
		
	
		
		protected var _mat:Material;
		protected var _newsID:int;
		protected var _data:Object;
		protected var _filters:FilterData;
		protected var _loadingID:String;
		
		
		public function set loadingID(value:String):void
		{
			_loadingID = value;
		}
		public function get loadingID():String
		{
			return _loadingID;
		}
	
        public function DataLoadServiceEvent(type:String , bubbles:Boolean = true, cancelable:Boolean = false, newsID:int = -1, mat:Material = null, data:Object=null,filters:FilterData = null,loadingID:String = "")		
        {
			_newsID = newsID;
			_mat = mat;
			_data = data;		
			_filters = filters;
			_loadingID = loadingID;
			
           super(type, bubbles, cancelable);
        }

        override public function clone():Event
        {
            return new DataLoadServiceEvent(type, bubbles, cancelable, _newsID, _mat, _data, _filters,_loadingID);			
			
			
        }
		
		public function set data(value:Object):void
		{
			_data = data;
		}
		
		public function get data():Object
		{
			return _data;
		}		
		
		
		
		public function set mat(value:Material):void
		{
			_mat = value;
		}
		
		public function get mat():Material
		{
			return _mat;
		}			
		
		public function set newsID(value:int):void
		{
			_newsID = value;
		}
		
		public function get newsID():int
		{
			return _newsID;
		}
		public function set filters(value:FilterData):void
		{
			_filters = value;
		}
		
		public function get filters():FilterData
		{
			return _filters;
		}

    }
}

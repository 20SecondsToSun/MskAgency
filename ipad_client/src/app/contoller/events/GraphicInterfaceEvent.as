package app.contoller.events
{

	import app.view.baseview.BaseView;
    import flash.events.Event;

    public class GraphicInterfaceEvent extends Event
    {
        public static const PHOTO_VIEW_READY:String  = "GraphicInterfaceEvent.PHOTO_VIEW_READY";
        public static const EMPLOY_VIEW_READY:String = "GraphicInterfaceEvent.EMPLOY_VIEW_READY";
        public static const ALL_NEWS_VIEW_READY:String = "GraphicInterfaceEvent.ALL_VIEW_READY";
        public static const MAIN_VIEW_READY:String = "GraphicInterfaceEvent.MAIN_VIEW_READY";
        public static const MAP_VIEW_READY:String = "GraphicInterfaceEvent.MAP_VIEW_READY";
        public static const FACTS_VIEW_READY:String = "GraphicInterfaceEvent.FACTS_VIEW_READY";
        public static const MAIN_NEW_VIEW_READY:String = "GraphicInterfaceEvent.MAIN_NEW_VIEW_READY";
        public static const VIDEO_VIEW_READY:String = "GraphicInterfaceEvent.VIDEO_VIEW_READY";
        public static const PAGE_VIEW_READY:String = "GraphicInterfaceEvent.PAGE_VIEW_READY";
		
		public static const FOCUS_ON_PHOTO:String = "GraphicInterfaceEvent.FOCUS_ON_PHOTO";
		public static const CLOSE_PREVIEW_PHOTO:String = "GraphicInterfaceEvent.CLOSE_PREVIEW_PHOTO";		
		public static const FULL_SCREEN_VIDEO_OFF:String = "GraphicInterfaceEvent.FULL_SCREEN_VIDEO_OFF";		
		
		public static const ZOOM_MAP:String = "GraphicInterfaceEvent.ZOOM_MAP";		
		public static const POPUP_MAP:String = "GraphicInterfaceEvent.POPUP_MAP";	
		
		public static const SELECT_ITEM:String = "GraphicInterfaceEvent.SELECT_ITEM";		
		public static const CHANGE_CUSTOM_SCREEN_RUBRIC:String = "GraphicInterfaceEvent.CHANGE_CUSTOM_SCREEN_RUBRIC";		
		public static const CHANGE_PRIMARY_SCREEN:String = "GraphicInterfaceEvent.CHANGE_PRIMARY_SCREEN";		
   
		protected var _data:* ;
		protected var _view:BaseView ;

		public function set data(value:*):void 
		{
			_data = value;
		}		
		public function get data():* 
		{
			return _data;
		}		
		
		public function set view(value:BaseView):void 
		{
			_view = value;
		}		
		public function get view():BaseView 
		{
			return _view;
		}		
   
        public function GraphicInterfaceEvent(type:String,view:BaseView = null,data:*=null )
        {
			_view = view;			
			_data = data;			
            super(type);			
        }
        
		override public function clone():Event
        {
            return new GraphicInterfaceEvent(type,_view,_data);
        }

    }
}

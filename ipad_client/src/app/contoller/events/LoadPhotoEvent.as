package app.contoller.events
{
	import app.model.materials.Material;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
    import flash.events.Event;

    public class LoadPhotoEvent extends Event
    {
		public static const LOAD_THUMBNAIL:String = "DataLoadServiceEvent.LOAD_THUMBNAIL";
		public static const THUMBNAIL_LOADED:String = "DataLoadServiceEvent.THUMBNAIL_LOADED";
		
		public static const LOAD_PHOTO:String = "DataLoadServiceEvent.LOAD_PHOTO";
		public static const PHOTO_LOADED:String = "DataLoadServiceEvent.PHOTO_LOADED";
		public static const COMPLETED:String = "DataLoadServiceEvent.COMPLETED";
		
		protected var _path:String;
		protected var _photo:Bitmap;
		protected var _id:int;
		protected var _view:DisplayObject;
		
		public function set path(value:String):void
		{
			_path = value;
		}
		
		public function get path():String
		{
			return _path;
		}		
		
		public function set id(value:int):void
		{
			_id = value;
		}
		
		public function get id():int
		{
			return _id;
		}	
		
		public function set view(value:DisplayObject):void
		{
			_view = value;
		}
		
		public function get view():DisplayObject
		{
			return _view;
		}
		
		public function set photo(value:Bitmap):void
		{
			_photo = value;
		}
		
		public function get photo():Bitmap
		{
			return _photo;
		}

        public function LoadPhotoEvent(type:String, path:String ="", id:int = -1, view:DisplayObject = null, photo:Bitmap = null )		
        {			
			_path = path;			
			_view = view;			
			_photo =photo;			
			_id =id;			
            super(type);
        }

        override public function clone():Event
        {
            return new LoadPhotoEvent(type, _path, _id, _view, _photo);			
			
        }
    }
}

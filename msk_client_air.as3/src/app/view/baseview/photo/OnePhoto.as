package app.view.baseview.photo 
{
	import app.contoller.events.LoadPhotoEvent;
	import app.model.materials.MaterialFile;
	import app.view.baseview.io.InteractiveButton;
	import app.view.baseview.io.InteractiveObject;
	import app.view.utils.ResizeUtil;
	import com.greensock.layout.ScaleMode;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class OnePhoto extends InteractiveObject
	{
		public var _width:Number = -1;
		public var _height:Number = -1;
		public var _path:String = "";
		public var _id:int = -1;
		public var _loadAtOnce:Boolean = true;
		public var _scaleMode:String = ScaleMode.NONE;
		public var _photo:Bitmap;
		public var _scale:Number;
		
		public function OnePhoto(path:String, id:int, loadAtOnce:Boolean = true) 
		{
			_path = path;
			_id = int(id.toString() +(Math.random() * 1000).toString());
		
			_loadAtOnce = loadAtOnce;				
		}
		
		public function loadAtOnce() :void
		{			
			if (_loadAtOnce && _id != -1)			
			dispatchEvent(new LoadPhotoEvent(LoadPhotoEvent.LOAD_PHOTO, _path, _id, this));
		
		}
		public function load() :void
		{			
			dispatchEvent(new LoadPhotoEvent(LoadPhotoEvent.LOAD_PHOTO, _path, _id, this));
		}
		
		public function setPhoto(photo:Bitmap)  :void
		{		
			_photo = photo;
			
			switch (_scaleMode) 
			{
				case ScaleMode.NONE:						
					photo = ResizeUtil.resizeBitmapToFit(photo, _height, _width);
				break;
				
				case ScaleMode.HEIGHT_ONLY:
					photo.height = _height;
					_scale = photo.scaleX = photo.scaleY;
				//	trace("WIDTH:::::::::::::::::::::::::", _scale);
					//trace("photo.scaleX =", photo.scaleX );
				break;
				
				case ScaleMode.STRETCH:
				
					if (_width == -1) _width = photo.width;
					if (_height == -1) _height = photo.height;
					
					photo = ResizeUtil.resizeBitmapToFit(photo, _width, _height);
				break;
				
				default:
			}
			
			photo.smoothing = true;	
			addChild(photo);		
		
		}
		
		public function kill()  :void
		{
			if (_photo) _photo.bitmapData.dispose();
		}
		
	}	

}
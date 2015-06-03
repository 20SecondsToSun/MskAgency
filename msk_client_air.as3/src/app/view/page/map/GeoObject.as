package app.view.page.map 
{
	import app.assets.Assets;
	import app.model.materials.GeoPoint;
	import app.model.materials.Material;
	import app.view.baseview.io.InteractiveObject;
	import com.modestmaps.geo.Location;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class GeoObject extends InteractiveObject
	{
		private var _mat:Material;
		
		public var lat:Number;
		public var long:Number;
		public var bullet:Sprite;
		
		public var location:Location;
		public var type:String;
		public var group:String;
		
		public var group_id:int;
		public var type_id:int;
		
		public function GeoObject(_mat:Material) 
		{	
			
			this._mat = _mat;				
			lat = _mat.point.lat;		
			long = _mat.point.long;			
			location = new Location(lat, long);
			type = _mat.point.type.toLowerCase();
			type_id = _mat.point.type_id;
			
			group = _mat.point.group.toLowerCase();
			group_id = _mat.point.group_id;
		}
		public function get mat():Material 
		{
			return _mat;
		}
		
	}

}
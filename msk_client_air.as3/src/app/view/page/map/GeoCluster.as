package app.view.page.map
{
	import com.modestmaps.geo.Location;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class GeoCluster
	{		
		public var location:Location;
		public var count:int = 0;
		public var name:String;
		public var cluster:Vector.<GeoObject>;
		
		public function GeoCluster()
		{			
			cluster = new Vector.<GeoObject>();		
		}	
	}
}
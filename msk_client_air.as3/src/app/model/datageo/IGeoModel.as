package app.model.datageo
{
	import app.model.materials.IMaterialModel;
	import app.model.materials.Material;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public interface IGeoModel extends IMaterialModel
	{			
		function get activeMaterial():Material;		
		function set activeMaterial(value:Material):void;
		
		function get newsListSorted():Vector.<Material>;
		function set newsListSorted(value:Vector.<Material>):void;
		function set newsListFiltered(value:Vector.<Material>):void;
		
		function sort(group_id:int, type_id:int = -1, important:int = 0, checkList:Vector.<Material> = null):Boolean;	
		
		
		
      
	}
}
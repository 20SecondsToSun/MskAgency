package ipad.model.datafav
{
	import app.model.materials.Fact;
	import app.model.materials.IMaterialModel;
	import app.model.materials.Material;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public interface IFavoritesModel extends IMaterialModel
	{			
		function get textList():Vector.<Material>;
		function set textList(value:Vector.<Material>):void;
		
		function get photoVideoList():Vector.<Material>;
		function set photoVideoList(value:Vector.<Material>):void;
		
		function get factsList():Vector.<Fact>;
		function set factsList(value:Vector.<Fact>):void;
		
		function get photoCount():int;
		function set photoCount(value:int):void;
		function get videoCount():int;
		function set videoCount(value:int):void;
		
		function isFavoritesMaterial(id:int):Boolean;		
		function isFavoritesFact(id:int):Boolean;		
		function isFavorite(id:int, type:String):void;		
		function insertMaterial(mat:Material):void;		
		function insertFact(mat:Fact):void;		
	}
}
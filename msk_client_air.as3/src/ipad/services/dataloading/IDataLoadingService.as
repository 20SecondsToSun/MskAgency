package ipad.services.dataloading
{
	import app.model.datafilters.FilterData;
	import app.model.materials.Material;
	import flash.display.DisplayObject;
    public interface IDataLoadingService
    {      
		function loadIpadData(obj:Object):void;
		function loadMapIpadData(obj:Object):void;
		function loadFactIpadData(obj:Object):void;		
		
		function loadFavoritesMaterials():void;
		function loadFavoritesFacts():void;
		
		function removeFromFavs(mat:*, type:String):void;
		function addToFavs(mat:*, type:String):void;
		function loadPhoto(path:String, id:int, view:DisplayObject):void;
    }
}


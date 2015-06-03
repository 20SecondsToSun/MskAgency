package app.services.dataloading
{
	import app.model.datafilters.FilterData;
	import app.model.materials.Material;
	import flash.display.DisplayObject;
    public interface IDataLoadingService
    {   
        function loadAllDataNews(value:String):void;
        function loadDaysDataNews(important:String = "1", limit:int = 100):void;
        function loadPhotoNews():void;
        function loadVideoNews():void;    
        function loadData():void;  
        function loadDayNews():void;  
        function loadMainNews(filtersoff:Boolean = false):void;  
		function loadFactsDataMainNews(isMain:Boolean = true,useFilters:Boolean = true):void;
		function loadFactsDataAllNews():void;
		function loadFactsDataDayNews(day:String):void;
		function loadGeoNews():void;
		function loadGeoDataMainNews():void;
		function loadOneNew(id:int):void;
		function loadNearNews():void;
		function loadFiltersData():void;
		function flush():void;
		function checkDataNews():void;
		function checkDataFacts():void;
		function loadIpadData():void;
		function loadFavoritesMaterials():void;
		function loadFavoritesFacts():void;
		function loadWeather():void;
		function loadPhoto(path:String, id:int, view:DisplayObject):void;
		
		function removeFromFavs(mat:*, type:String):void;
		function addToFavs(mat:*, type:String):void;
    }
}


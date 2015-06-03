package app.model.datafilters 
{
	import app.model.materials.IMaterialModel;
	import app.model.materials.Material;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public interface IFilterDataModel 
	{	
		function get oneDayFilters():FilterData;
		function set oneDayFilters(value:FilterData):void;
		function oneDayFiltersDate():Date;		
		
		function get status():Vector.<String>;
		function set status(value:Vector.<String>):void;
		
		function get type():Vector.<String>;
		function set type(value:Vector.<String>):void;
		
		function get rubrics():Vector.<Rubric>;
		function set rubrics(value:Vector.<Rubric>):void;
		
		function get geoNewsFilters():FilterData;
		function set geoNewsFilters(value:FilterData):void;
		
		function get daysNewsFilters():FilterData;
		function set daysNewsFilters(value:FilterData):void;
		
		function  setFilter(loc:String,value:FilterData):String;
		function  getFilter(loc:String):FilterData;
		function  setNullToAll():void;		
		function  resetDates():void;		
		function  resetOffsetLimit():void;	
		
		function get factsNewsFilters():FilterData;
		function set factsNewsFilters(value:FilterData):void;
		
	}	
}
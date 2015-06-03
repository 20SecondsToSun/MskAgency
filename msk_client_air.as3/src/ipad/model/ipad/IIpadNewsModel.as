package ipad.model.ipad
{
	import app.model.materials.IMaterialModel;
	import app.model.materials.Material;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public interface IIpadNewsModel extends IMaterialModel
	{			
		function get isAnimate():Boolean;		
		function set isAnimate(value:Boolean):void;	
		
		function allSortByDate(date:Date = null):Vector.<Material> ;		
		
		function get allNewsHourList():Vector.<Vector.<Material>>;		
		function set allNewsHourList(value:Vector.<Vector.<Material>>):void;
		
		function get allTypeNews():Vector.<Material>;		
		function set allTypeNews(value:Vector.<Material>):void;
		
		function get allNewsHourListFilter():Vector.<Vector.<Material>>;		
		function set allNewsHourListFilter(value:Vector.<Vector.<Material>>):void;
		
		function get allNewsHourListToday():Vector.<Vector.<Material>>;		
		function set allNewsHourListToday(value:Vector.<Vector.<Material>>):void;
		
		function get videoNum():int;		
		function get photoNum():int;		
		function get allNum():int;		
		function get broadcastNum():int;		
		
		
		
		function get activeMaterial():Material;		
		function set activeMaterial(value:Material):void;
		
		
		function get sortedType():String;
		function set sortedType(value:String):void;	
		
		
		function createNewsHourLists():void;
		
	}
}
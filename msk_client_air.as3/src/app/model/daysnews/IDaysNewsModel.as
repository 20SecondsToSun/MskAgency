package app.model.daysnews
{
	import app.model.materials.IMaterialModel;
	import app.model.materials.Material;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public interface IDaysNewsModel extends IMaterialModel
	{
		function get data():Vector.<Material>;
		function set data(value:Vector.<Material>):void;
		
		function get isAnimate():Boolean;
		function set isAnimate(value:Boolean):void;
		
		function get allNewsDaysList():Vector.<Material>;
		function set allNewsDaysList(value:Vector.<Material>):void;
		
		function get allNewsDaysBlockList():Vector.<Vector.<Material>>;
		function set allNewsDaysBlockList(value:Vector.<Vector.<Material>>):void;
		
		function get offsetLoad():int;
		function set offsetLoad(value:int):void;
		
		function get limitLoad():int;
		function set limitLoad(value:int):void;
		
		function set loadingDate(value:String):void;
		function get loadingDate():String;
	}
}
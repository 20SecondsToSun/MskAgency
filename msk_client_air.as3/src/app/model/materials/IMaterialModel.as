package app.model.materials 
{
	import app.contoller.events.ChangeModelOut;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public interface IMaterialModel 
	{
		function get count():String;      
        function set count(value:String):void;
      
		function get limit():String;
		function set limit(value:String):void;
		
        function get offset():String;
        function set offset(value:String):void;
		
        function get newsList():Vector.<Material>;
        function set newsList(value:Vector.<Material>):void;	
		
		function  setModel(value:ChangeModelOut):void;
		function getMaterialByID(id:Number):Material;	
		
		function setChoosenField(obj:Object):void;
		function getChoosenField():Object;		
	}	
}
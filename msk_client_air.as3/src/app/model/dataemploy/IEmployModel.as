package app.model.dataemploy 
{
	import app.contoller.events.ChangeModelOut;
	import app.model.materials.Informer;
	import app.model.materials.Weather;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public interface IEmployModel
	{	
		function get isAnimate():Boolean;		
		function set isAnimate(value:Boolean):void;	
		function  setModel(value:ChangeModelOut):void;		
		
		function get weather():Vector.<Weather>;
		function set weather(value:Vector.<Weather>):void;	
		
		function get informer():Informer;		
		function set informer(value:Informer):void
	}	
}
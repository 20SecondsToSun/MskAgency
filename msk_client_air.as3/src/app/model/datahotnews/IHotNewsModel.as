package app.model.datahotnews 
{
	import app.contoller.events.ChangeModelOut;
	import app.model.materials.Fact;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public interface IHotNewsModel 
	{
		function get isAnimate():Boolean;		
		function set isAnimate(value:Boolean):void;	
		
		function  setModel(value:ChangeModelOut):void;
	}
	
}
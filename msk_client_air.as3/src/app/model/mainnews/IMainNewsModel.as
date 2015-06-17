package app.model.mainnews 
{
	import app.model.materials.IMaterialModel;
	import app.model.materials.Material;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public interface IMainNewsModel extends IMaterialModel
	{	
		function get data():Vector.<Material>;		
		function set data(value:Vector.<Material>):void;			
		function get isAnimate():Boolean;		
		function set isAnimate(value:Boolean):void;			       
	}	
}
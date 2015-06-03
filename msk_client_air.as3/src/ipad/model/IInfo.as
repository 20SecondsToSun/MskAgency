package ipad.model
{
	import app.model.materials.IMaterialModel;
	import app.model.materials.Material;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public interface IInfo
	{		
		function get primaryScreen():String;		
		function set primaryScreen(value:String):void;
		
		function get customScreenRubric():Object;
		function set customScreenRubric(value:Object):void;		
		
		function get isKinectUser():Boolean;
		function set isKinectUser(value:Boolean):void;
		
		function get isHandActive():Boolean;
		function set isHandActive(value:Boolean):void;
		
		function get playState():Boolean;
		function set playState(value:Boolean):void;
		
		function get volume():Number;
		function set volume(value:Number):void;	
		
	
	}
}
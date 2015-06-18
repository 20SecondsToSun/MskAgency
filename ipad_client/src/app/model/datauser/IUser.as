package app.model.datauser 
{
	import app.model.materials.Filters;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public interface IUser 
	{		
		function get name():String;      
        function set name(value:String):void;
      
		function get id():String;
		function set id(value:String):void;
		
        function get login():String;
        function set login(value:String):void;
		
        function get role_id():String;
        function set role_id(value:String):void;
		
        function get permissions():Vector.<String>;
        function set permissions(value:Vector.<String>):void; 
		
		function addUserFilter(name:String, value:String):void;
		function removeUserFilter(name:String):void;
		function removeAllUserFilters():void;
		
		function addScreenFilter(name:String, value:String):void;
		function removeScreenFilter(name:String):void;
		function removeAllScreenFilters():void;
		
		function getfilters():Filters;
		function getRubric():Object;
		 
		function set primaryScreen(value:String):void;		
		function get primaryScreen():String;			
		
		function get is_active():Boolean;
        function set is_active(value:Boolean):void;
		
		function get isHandActive():Boolean;
        function set isHandActive(value:Boolean):void;
		
		function get password():String;
		function set password(value:String):void;
		
		function get stendID():String;
		function set stendID(value:String):void;
		
		function get idIpad():String;
		function set idIpad(value:String):void;		
		
		function get ipadTryingToConnect():Boolean;
		function set ipadTryingToConnect(value:Boolean):void;
	}
}
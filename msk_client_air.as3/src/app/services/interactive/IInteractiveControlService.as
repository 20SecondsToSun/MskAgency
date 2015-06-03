package app.services.interactive
{	
	public interface IInteractiveControlService
	{
		function start():void;
		
		function stopInteraction():void;
		function startInteraction():void;
		
		function get isInteraction():Boolean;
		function set isInteraction(value:Boolean):void;
		
		function set isIpadConnect(value:Boolean):void;
		function get isIpadConnect():Boolean;	
	}
}
package app.services.state
{
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.GraphicInterfaceEvent;
	import app.model.materials.Material;
	
    public interface INavigationService
    {
        function location(event:ChangeLocationEvent):void;
        function start():void;
		function animationFinished(event:AnimationEvent):void;
		function checkForStartLocation(event:GraphicInterfaceEvent):void;
		function checkForReadyAnimation_3():void;
		
		function showFilters():void;
		function showMenu():void;
		
		function hideMenu():void;
		function hideFilters():void;
		function hideIpadPopup():void;
		
		function get getCurrentLocation():String;
		
		function openPopup(data:*):void;
		function returnToMainScreen(value:Boolean):void;
    }
}


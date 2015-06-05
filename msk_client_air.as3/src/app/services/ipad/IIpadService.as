package app.services.ipad
{	
    public interface IIpadService
    {
        function start():void;
		function changeLocation():void;
		
		function startCommunicate():void;
		function stopCommunicate():void;
		
		function userLost():void;
		function userActive():void;
		
		function handLost():void;	
		function handActive():void;
		
		function set isPause(value:Boolean):void;
		function get isPause():Boolean;
		
		function  sendShapes(data:Object):void;
		function  symbolsOk():void;
		function  symbolsBad():void;
		
		function set isIpadConnect(value:Boolean):void;
		function get isIpadConnect():Boolean;		
    }
}
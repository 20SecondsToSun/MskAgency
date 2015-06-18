package app.model.config 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	public interface IConfig 
	{		
		function get currentScreen():String;			
		function set currentScreen(value:String):void;
		
		function get currentDate():String;	
		function set currentDate(value:String):void;
		
		function get previousDate():String;	
		function set previousDate(value:String):void;
		
		function get nextDate():String;	
		function set nextDate(value:String):void;
		
		function getShiftDate(value:int):String;
		
		function compareDate(value:String):String;		
		
		function get currentLocation():String;			
		function set currentLocation(value:String):void;
		
		function  getprevDate(value:Date):String;
		function  getnextDate(value:Date):String;	
		
		function init(initDate:Date):void;
	}  
}
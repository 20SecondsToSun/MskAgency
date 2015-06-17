package app.model.datafact 
{
	import app.contoller.events.ChangeModelOut;
	import app.model.materials.Fact;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public interface IFactsModel 
	{	
		function get notema():Boolean;      
        function set notema(value:Boolean):void;
		
		function get count():String;      
        function set count(value:String):void;
      
		function get limit():String;
		function set limit(value:String):void;
		
        function get offset():String;
        function set offset(value:String):void;
		
        function get newsList():Vector.<Fact>;
        function set newsList(value:Vector.<Fact>):void;	
		
		function get mainNewsList():Vector.<Fact>;
        function set mainNewsList(value:Vector.<Fact>):void;	
		
		function get data():Vector.<Fact>;		
		function set data(value:Vector.<Fact>):void;	
		
		function get isAnimate():Boolean;		
		function set isAnimate(value:Boolean):void;
		
		function set loadingDate(value:String):void;
		function get loadingDate():String;
				
		function set dateInfo(value:DateInfo):void;
		function get dateInfo():DateInfo;
		
		function get activeMaterial():Fact;		
		function set activeMaterial(value:Fact):void;
		
		function set sliderDate(value:String):void;
		function get sliderDate():String;
		
		function set dayNewsList(value:Vector.<Fact>):void;
		function get dayNewsList():Vector.<Fact>;	
		
		function get offsetLoad():int;
		function set offsetLoad(value:int):void;
		
		function get limitLoad():int;
		function set limitLoad(value:int):void;
		
		function get direction():String;
		function set direction(value:String):void;
		
		function set nextDate(value:String):void;		
		function get nextDate():String;
		
		function set prevDate(value:String):void;		
		function get prevDate():String;
		
		function set centerDate(value:String):void;
		function get centerDate():String;
		
		function set isInitLoad(value:Boolean):void;
		function get isInitLoad():Boolean;
		
		function allInit():void;			
		function setOffset():void;	
		function setModel(value:ChangeModelOut):void;
	}	
}
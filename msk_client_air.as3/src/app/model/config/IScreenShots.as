package app.model.config 
{
	import flash.display.Bitmap;
	
	public interface IScreenShots
	{			
		function  getScreenShot(value:int):Bitmap;
		function  setScreenShot(splash:Bitmap, value:int):void;
	}  
}
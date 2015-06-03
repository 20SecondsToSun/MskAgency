package app.model.config
{
	import app.AppSettings;
	import app.assets.Assets;
	import app.view.mainscreen.MainBase;
	import caurina.transitions.SpecialProperty;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class ScreenShots extends Sprite
	{
		protected var screenShotSaver:Dictionary;
		private var currentPage:int = 1;
		
		public function ScreenShots()
		{
			screenShotSaver = new Dictionary();
			
			screenShotSaver["1"] = Assets.createBitmap("screenshot1");
			screenShotSaver["2"] = Assets.createBitmap("screenshot2");
			screenShotSaver["3"] = Assets.createBitmap("screenshot3");
			screenShotSaver["MAIN_NEWS"] = Assets.createBitmap("mainscreen");
			screenShotSaver["VIDEO_NEWS"] = Assets.createBitmap("videoscreen");
			screenShotSaver["MAP_NEWS"] = Assets.createBitmap("mapscreen");
			screenShotSaver["ALL_NEWS"] = Assets.createBitmap("allscreen");
			screenShotSaver["PHOTO_NEWS"] = Assets.createBitmap("photoscreen");
			screenShotSaver["FACT_NEWS"] = Assets.createBitmap("factscreen");
			screenShotSaver["EMPLOY_NEWS"] = Assets.createBitmap("employscreen");
			
			screenShotSaver["MAIN_NEWS1"] = Assets.createBitmap("mainscreen");
			screenShotSaver["VIDEO_NEWS1"] = Assets.createBitmap("videoscreen");
			screenShotSaver["MAP_NEWS1"] = Assets.createBitmap("mapscreen");
			screenShotSaver["ALL_NEWS1"] = Assets.createBitmap("allscreen");
			screenShotSaver["PHOTO_NEWS1"] = Assets.createBitmap("photoscreen");
			screenShotSaver["FACT_NEWS1"] = Assets.createBitmap("factscreen");
			screenShotSaver["EMPLOY_NEWS1"] = Assets.createBitmap("employscreen");
			
			screenShotSaver["MAIN_NEWS2"] = Assets.createBitmap("mainscreen");
			screenShotSaver["VIDEO_NEWS2"] = Assets.createBitmap("videoscreen");
			screenShotSaver["MAP_NEWS2"] = Assets.createBitmap("mapscreen");
			screenShotSaver["ALL_NEWS2"] = Assets.createBitmap("allscreen");
			screenShotSaver["PHOTO_NEWS2"] = Assets.createBitmap("photoscreen");
			screenShotSaver["FACT_NEWS2"] = Assets.createBitmap("factscreen1");
			screenShotSaver["EMPLOY_NEWS2"] = Assets.createBitmap("employscreen");
		}
		
		public function setScreenShot(value:Bitmap, index:String):void
		{
			var bmp:BitmapData = new BitmapData(value.width, value.height);
			bmp.draw(value);
			
			if (index != "1" && index != "2" && index != "3")
			{
				if (screenShotSaver[index + MainBase.activePage.toString()] != undefined)
					screenShotSaver[index + MainBase.activePage.toString()].bitmapData.dispose();
				
				screenShotSaver[index + MainBase.activePage.toString()] = new Bitmap(bmp);
			}
			else
			{
				if (screenShotSaver[index] != undefined)
					screenShotSaver[index ].bitmapData.dispose();
				
				screenShotSaver[index] = new Bitmap(bmp);
			}
		
		}
		
		public function getShadow(value:int):Sprite
		{
			var sprite:Sprite = new Sprite();
			
			if (value == 2 || value == 1)
				sprite = Assets.create("shadow1");
			else if (value == 3)
				sprite = Assets.create("shadow1");
			
			return sprite;
		}
		
		public function getScreenShot(value:String, activePage:int = -1):Sprite
		{
			var sprite:Sprite = new Sprite();
			var bmp:BitmapData = new BitmapData(screenShotSaver[value].width, screenShotSaver[value].height);
			
			var mat:Matrix = new Matrix();
			
			switch (value)
			{
				case "1": 
				case "2": 
					bmp.draw(screenShotSaver["VIDEO_NEWS" + value]);
					mat.translate(410, 0);
					bmp.draw(screenShotSaver["MAIN_NEWS" + value], mat);
					mat.identity();
					
					mat.translate(1100, 0);
					bmp.draw(screenShotSaver["MAP_NEWS" + value], mat);
					mat.identity();
					
					mat.translate(0, AppSettings.HEIGHT - 580);
					bmp.draw(screenShotSaver["ALL_NEWS" + value], mat);
					mat.identity();
					
					mat.translate(0, AppSettings.HEIGHT - 301);
					bmp.draw(screenShotSaver["PHOTO_NEWS" + value], mat);
					mat.identity();
					
					mat.translate(AppSettings.WIDTH - 410, 0);
					bmp.draw(screenShotSaver["FACT_NEWS" + value], mat);
					mat.identity();
					
					mat.translate(0, AppSettings.HEIGHT - 69);
					bmp.draw(screenShotSaver["EMPLOY_NEWS" + value], mat);
					mat.identity();
					
					break;
				case "3": 
					if (activePage != 3)
						screenShotSaver["3"] = Assets.createBitmap("screenshot3");
					
					bmp.draw(screenShotSaver[value]);
					break;
				
				default:
					
					if (MainBase.curLoc != 3)
					{
						bmp.draw(screenShotSaver[value + MainBase.curLoc.toString()]);
					}
			}
			
			sprite.addChild(new Bitmap(bmp));
			return sprite;
		}
	}
}
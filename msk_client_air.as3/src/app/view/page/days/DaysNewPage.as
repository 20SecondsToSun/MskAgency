package app.view.page.days
{
	import app.AppSettings;
	import app.model.materials.Material;
	import app.view.page.BasePage;
	import app.view.page.days.daysslider.DaysSlider;
	import app.view.utils.Tool;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class DaysNewPage extends BasePage
	{
		private var slider:DaysSlider;
		private var splash:Shape;
		private var animateMode:String = "";
		
		public function DaysNewPage():void
		{
			splash = Tool.createShape(AppSettings.WIDTH, AppSettings.HEIGHT, 0x101114);
			addChild(splash);
			
			slider = new DaysSlider();
			slider.visible = false;
			addChild(slider);
		}
		
		public function refreshSortedData(allNewsList:Vector.<Vector.<Material>>, phn:int, vn:int, alln:int):void
		{
		
		}
		
		override public function flip():void
		{
			splash.x = 0;//AppSettings.WIDTH;	
			splash.alpha = 0;
			slider.visible = true;
			animationInFinished();
		}
		
		public function backFromOneNew():void
		{
			slider.visible = true;
			animationInFinished();
		}
		
		public function stretchIN():void
		{
			slider.visible = true;
			animationInFinished();
		}
		
		public function stretch():void
		{
		
		}
	}
}
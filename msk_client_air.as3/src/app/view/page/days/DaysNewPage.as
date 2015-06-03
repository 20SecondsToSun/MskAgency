package app.view.page.days
{
	import app.AppSettings;
	import app.model.materials.Material;
	import app.view.page.BasePage;
	import app.view.page.days.daysslider.DaysSlider;
	import app.view.page.day.hoursslider.HourSlider;
	import app.view.page.day.leftpanelhour.LeftPanel;
	import app.view.utils.Tool;
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class DaysNewPage extends BasePage
	{
		private var slider:DaysSlider;
		private var splash:Shape;	
		private var animateMode:String = "";
		//private var minHeight:int = 279;
		//private var maxHeight:int = 345;
		//private var initY:int = AppSettings.HEIGHT - (69 + 232 + 279);
		
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
			/*	if (!allNewsList || allNewsList.length == 0) return;
				
				slider.refreshData(allNewsList);	
				slider.startShowFlip();*/
		}	
		
		override public function flip():void
		{
			splash.x = 0;//AppSettings.WIDTH;	
			splash.alpha = 0;
			//TweenLite.to(splash, 0.8, { x: 0, ease: Expo.easeOut , onComplete: animationInFinished} );
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
		/*var changeHeight:Number = int(minHeight + (maxHeight - minHeight) * 0.5);
		   var _y:Number = int(initY + (changeHeight - minHeight));
		   var mat:Matrix = new Matrix();
		   mat.translate(0, -_y);
		
		   var cut_screenshot_bd:BitmapData = new BitmapData(AppSettings.WIDTH, changeHeight);
		   cut_screenshot_bd.draw(screenshot,mat);
		   var cut_screenshot:Bitmap = new Bitmap(cut_screenshot_bd);
		   cut_screenshot.y = _y;
		   cut_screenshot.smoothing = true;
		
		   changeHeight = int(minHeight + (maxHeight - minHeight) );
		   var scale:Number = changeHeight / minHeight +4;
		
		
		   mainHolder = new Sprite();
		   addChild(mainHolder);
		
		   slider = new HourSlider();
		   mainHolder.addChild(slider);
		
		   addChild(cut_screenshot);
		
		
		   TweenLite.to(cut_screenshot, 0.8, {ease:Linear.easeNone ,alpha:1, scaleX:scale, scaleY:scale , y:AppSettings.HEIGHT-250, x: -AppSettings.WIDTH * (scale-1) * 0.5, onComplete:function ():void
		   {
		   removeChild(cut_screenshot);
		   animationInFinished();
		
		   addLeftPanel();
		
		   TweenLite.to(slider, 0.5, { x:98 } );
		   TweenLite.to(leftPanel, 0.5, { x:0 } );
		   slider.startInteraction();
		
		 } } );	*/
		}
	
	}

}
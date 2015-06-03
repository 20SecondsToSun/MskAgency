package app.view.page.day
{
	import app.AppSettings;
	import app.assets.Assets;
	import app.model.materials.Material;
	import app.view.page.BasePage;
	import app.view.page.day.hoursslider.HourSlider;
	import app.view.page.day.leftpanelhour.LeftPanel;
	import app.view.utils.Tool;
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class OneDayNewPage extends BasePage
	{
		private var slider:HourSlider;
		private var splash:Shape;
		private var leftPanel:LeftPanel;
		private var animateMode:String = "";
		private var circle:Sprite;
		
		public function OneDayNewPage()
		{
			splash = Tool.createShape(AppSettings.WIDTH, AppSettings.HEIGHT, 0x1a1b1f);
			addChild(splash);
			
			slider = new HourSlider();
			slider.visible = false;
			addChild(slider);
			
			leftPanel = new LeftPanel();
			leftPanel.visible = false;
			addChild(leftPanel);
			
			
			circle = Assets.create("preloadDark1");
			circle.x = 0.5 * (AppSettings.WIDTH - circle.width);
			circle.y = 0.5 * (AppSettings.HEIGHT - circle.height);
			addChild(circle);
			addEventListener(Event.ENTER_FRAME, rotateCircle);		
		}
		
		private function rotateCircle(e:Event):void 
		{
			Tool.rotateAroundCenter(circle, 3);
		}		
		
		public function refreshData(allNewsList:Vector.<Vector.<Material>>, phn:int, vn:int, alln:int, lv:int):void
		{
			if (!allNewsList || allNewsList.length == 0)
			{
				animationInFinished();
				return;
			}
			
			leftPanel.refreshData(allNewsList, alln, phn, vn, lv);
			slider.refreshData(allNewsList);
			
			removeChild(circle);
			removeEventListener(Event.ENTER_FRAME, rotateCircle);		
				
			TweenLite.delayedCall(0.3, startAnimate);
		}
		
		public function refreshSortedData(allNewsList:Vector.<Vector.<Material>>, phn:int, vn:int, alln:int):void
		{
			if (!allNewsList || allNewsList.length == 0)
				return;
			
			slider.refreshData(allNewsList);
			slider.startShowFlip();
			slider.startInteraction();
		}
		
		override public function flip():void
		{
			splash.x = AppSettings.WIDTH;
			TweenLite.to(splash, 0.8, {x: 0, ease: Expo.easeOut});
			animateMode = "FLIP";
		}
		
		public function backFromOneNew():void
		{
			animateMode = "BACK_FROM_ONE";
		}
		
		private function startAnimate():void
		{
			switch (animateMode)
			{
				case "FLIP": 
					leftPanel.x = -leftPanel.width;
					leftPanel.visible = true;					
					slider.visible = true;		
					slider.startShowFlip();
					TweenLite.to(leftPanel, 0.5, { delay:0.5,x: 0, ease: Expo.easeOut});
					TweenLite.to(slider, 0.8, { delay:0.5, x: 98, ease: Expo.easeOut, onComplete: slider.startInteraction});
					break;
					
				case "STRETCH_IN":
				case "BACK_FROM_ONE":
					leftPanel.x = -leftPanel.width;
					leftPanel.visible = true;					
					slider.visible = true;		
					slider.startShowStretchIn();
					TweenLite.to(leftPanel, 0.5, { delay:0.5,x: 0, ease: Expo.easeOut});
					TweenLite.to(slider, 0.8, { delay:0.5, x: 98, ease: Expo.easeOut, onComplete: slider.startInteraction});
					break;
					
				default: 
			}
			
			animationInFinished();			
		}
		
		public function stretchIN():void
		{
			animateMode = "STRETCH_IN";
		}
		
		public function stretch():void
		{
			animateMode = "STRETCH_IN";
			
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
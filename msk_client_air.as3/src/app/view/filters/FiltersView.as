package app.view.filters
{
	import app.AppSettings;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.InteractiveEvent;
	import app.model.datafilters.FilterData;
	import app.model.datafilters.Rubric;
	import app.view.baseview.BaseView;
	import app.view.baseview.io.InteractiveButton;
	import app.view.utils.BigCanvas;
	import app.view.utils.Tool;
	import com.greensock.easing.Back;
	import com.greensock.easing.Quint;
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FiltersView extends BaseView
	{
		public var isOpen:Boolean = false;
		private var splash:Shape;
		private var buttonsArray:Vector.<FilterButton> = new Vector.<FilterButton>();
		private var closeBtn:InteractiveButton;
		private var layermask:Shape;
		
		public var dateChoose:DateChoose;
		public var centerBtn:CenterButton;
		private var refreshBtn:RefreshButton;
		private var clearBtn:CloseButton;
		
		public var circle:Circle;
		private var __length:int = 6;
		private var screenshot:BigCanvas;
		private var screenshotBottom:BigCanvas;
		private var screenShotHolder:Sprite;
		private var fon:Shape;
		private var overlay:Shape;
		private var mainMenu:Sprite;
		
		private var brightnessDictionary:Dictionary = new Dictionary();
		
		private var state:int = 0;
		public var dateToSet:String   = "";
		public var currentDate:String = "";
		public var activeRubric:int = -1;
		public var lastActiveRubric:int = -1;
		public var lastFilter:String = "";
		
		public function FiltersView()
		{
			pushEnabled = false;
			chargeEnabled = false;
			enabled = false;
			
			brightnessDictionary[ChangeLocationEvent.MAP_PAGE] = { color: 0x101114, alpha: 0.8 };			
			
			brightnessDictionary[ChangeLocationEvent.NEWS_PAGE_HOUR] = {color: 0x101114, alpha: 0.45};
			brightnessDictionary[ChangeLocationEvent.NEWS_PAGE_DAY] = { color: 0x101114, alpha: 0.45 };			
			brightnessDictionary[ChangeLocationEvent.FACT_PAGE] = {color: 0x101114, alpha: 0.45};
		
			brightnessDictionary[ChangeLocationEvent.ONE_NEW_PAGE] = {color: 0x101114, alpha: 0.8};
			brightnessDictionary[ChangeLocationEvent.ONE_NEW_FACT_PAGE] = { color: 0x101114, alpha: 0.8 };
			
			visible = false;
			splash = Tool.createShape(AppSettings.WIDTH, AppSettings.HEIGHT, 0x000000);
			
			screenShotHolder = new Sprite();
			addChild(screenShotHolder);
			
			addFon();
			addLayerOverlay();
			
			mainMenu = new Sprite();
			mainMenu.visible = false;
			addChild(mainMenu);
			
			//////////////////////////////////////////////////////////
			
			circle = new Circle();
			circle.x = 0.5 * (AppSettings.WIDTH - circle.width);
			circle.y = 0.5 * (AppSettings.HEIGHT - circle.height);
			addChild(circle);
			
			//////////////////////////////////////////////////////////
			
			refreshBtn = new RefreshButton();
			addChild(refreshBtn);
			
			clearBtn = new CloseButton();
			addChild(clearBtn);
			
			//////////////////////////////////////////////////////////
			
			centerBtn = new CenterButton();
			addChild(centerBtn);
			
			dateChoose = new DateChoose();
			dateChoose.x = 0.5 * (AppSettings.WIDTH  - 504);
			dateChoose.y = 0.5 * (AppSettings.HEIGHT - 504);
			addChild(dateChoose);
		}
		
		public function init(rubrics:Vector.<Rubric>):void
		{		

		}
		
		public function setOldFilters():void
		{
			
		}
		
		public function clearFilters():void
		{
			activeRubric = -1;
			centerBtn.date = "";
			lastFilter = "";
			lastActiveRubric = -1;
		}
		
		public function show(shot:BigCanvas, fd:FilterData, location:String):void
		{
			state = 0;			
			visible = true;
			isOpen = true;		
			
			Tool.changecolor(overlay, brightnessDictionary[location].color);
			overlay.alpha = brightnessDictionary[location].alpha;			
			
			if (fd && fd.from)
				dateToSet = fd.from;
			else
				dateToSet = "";				
			
			fon.alpha = 0;
			screenShotHolder.alpha = 0;
			overlay.alpha = 0;
			
			refreshBtn.visible = true;
			clearBtn.alpha = 0;
			refreshBtn.alpha = 0;
			
			var __scale:Number = 0.1;
			circle.scaleX = circle.scaleY = __scale;
			circle.x = 0.5 * (AppSettings.WIDTH - 504  * __scale);
			circle.y = 0.5 * (AppSettings.HEIGHT - 504 * __scale);
			
			makeScreenshotBottom(shot);
			makeScreenshotBlur(shot);
			
			screenShotHolder.addChild(screenshotBottom);
			screenShotHolder.addChild(fon);
			screenShotHolder.addChild(screenshot);
			
			TweenLite.to(overlay, 0.3, {alpha: 0.68, ease: Quint.easeInOut});
			TweenLite.to(screenShotHolder, 0.3, {alpha: 1, ease: Quint.easeInOut});
			TweenLite.to(fon, 0.5, {alpha: 0.98, ease: Quint.easeInOut});
			TweenLite.to(circle, 1.3, {alpha: 1, scaleX: 1, scaleY: 1, x: 0.5 * (AppSettings.WIDTH - 504), y: 0.5 * (AppSettings.HEIGHT - 504), ease: Back.easeOut});
			TweenLite.to(clearBtn, 1.5, {alpha: 1, ease: Quint.easeInOut});
			TweenLite.to(refreshBtn, 1.5, { alpha: 1, ease: Quint.easeInOut } );
			
			if (fd && fd.from)
			{				
				centerBtn.show(fd.from);
			}
			else
				centerBtn.show(); // (dateToSet);
			
			circle.show();
			
			if (location == ChangeLocationEvent.MAP_PAGE) 
			{
				gotoDateChoose();
				return;
			}	
		}
		
		public function gotoDateChoose():void
		{
			state = 1;
			
			TweenLite.to(refreshBtn, 0.5, {alpha: 0, ease: Quint.easeInOut, onComplete: function():void
				{
					refreshBtn.visible = false;
				}});
			
			circle.visible = false;
			centerBtn.visible = false;
			dateChoose.show(currentDate, dateToSet);
		}
		
		public function addFon():void
		{
			fon = Tool.createShape(AppSettings.WIDTH, AppSettings.HEIGHT, 0x1a1b1f);
		}
		
		public function addLayerOverlay():void
		{
			overlay = Tool.createShape(AppSettings.WIDTH, AppSettings.HEIGHT, 0x465568);
			addChild(overlay);
		}
		
		public function makeScreenshotBottom(shot:BigCanvas):void
		{
			screenshotBottom = new BigCanvas(AppSettings.WIDTH, AppSettings.HEIGHT);
			screenshotBottom.draw(shot);
		}
		
		public function makeScreenshotBlur(shot:BigCanvas):void
		{
			var jpgSource:BitmapData = new BitmapData(AppSettings.WIDTH, AppSettings.HEIGHT);
			jpgSource.draw(shot);
			
			var BLUR_FILTER:BlurFilter = new BlurFilter(36, 36, 4);
			jpgSource.applyFilter(jpgSource, jpgSource.rect, new Point, BLUR_FILTER);
			
			screenshot = new BigCanvas(AppSettings.WIDTH, AppSettings.HEIGHT);
			screenshot.draw(jpgSource);
		}
		
		public function hide():void
		{
			circle.hide();
			dateChoose.hide();
			centerBtn.hide();
			
			
			overlay.alpha = 0;
			screenShotHolder.alpha = 0;
			circle.alpha = 0;
			clearBtn.alpha = 0;
			refreshBtn.alpha = 0;
			/*TweenLite.to(overlay, 0.3, {alpha: 0, ease: Quint.easeInOut});
			TweenLite.to(screenShotHolder, 0.3, {alpha: 0, ease: Quint.easeInOut});
			TweenLite.to(circle, 0.3, {alpha: 0, ease: Quint.easeInOut});
			TweenLite.to(clearBtn, 0.3, {alpha: 0, ease: Quint.easeInOut});
			TweenLite.to(refreshBtn, 0.3, {alpha: 0, ease: Quint.easeInOut});*/
			
			screenshot.dispose();
				screenshotBottom.dispose();
				
				if (screenShotHolder.contains(screenshot))
					screenShotHolder.removeChild(screenshot);
				if (screenShotHolder.contains(screenshotBottom))
					screenShotHolder.removeChild(screenshotBottom);
			
			TweenLite.to(fon, 0.3, {alpha: 0, onComplete: function():void
			{
				
				
				isOpen  = false;
				visible = false;
			}});
		}
	}
}
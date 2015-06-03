package app.view.menu
{
	import app.AppSettings;
	import app.assets.Assets;
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.ChangeLocationEvent;
	import app.view.baseview.BaseView;
	import app.view.baseview.io.InteractiveButton;
	import app.view.utils.BigCanvas;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.easing.Quint;
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class MenuView extends BaseView
	{
		private var fon:Shape;
		private var overlay:Shape;
		private var layermask:Shape;
		private var screenshot:BigCanvas;
		private var screenshotBottom:BigCanvas;
		private static const menuHeight:Number = 680;
		
		public var mainbtn:InteractiveButton;
		public var backbtn:InteractiveButton;
		public var closeMenuBtn:InteractiveButton;
		public var mainbtns:Sprite;
		
		public var newsBtn:MenuButton;
		public var eventsBtn:MenuButton;
		public var mapBtn:MenuButton;
		public var broadcastBtn:MenuButton;
		public var screen1Btn:MenuButton;
		public var screen2Btn:MenuButton;
		public var screen3Btn:MenuButton;
		
		private var mainMenu:Sprite;
		private var circlesMenu:Sprite;
		
		private var screenShotHolder:Sprite;
		
		public var isOpen:Boolean = false;
		
		public function MenuView()
		{
			name = "MenuView";
			pushEnabled = false;
			chargeEnabled = false;
			
			screenShotHolder = new Sprite();
			addChild(screenShotHolder);
			
			addFon();
			addLayerMask();
			addLayerOverlay();
			
			mainMenu = new Sprite();
			mainMenu.visible = false;
			addChild(mainMenu);
			
			createButtons();
			addMainButton();
			
			mainbtns = new Sprite();
			mainMenu.addChild(mainbtns);
			
			var fonbtnmain:Shape = Tool.createShape(AppSettings.WIDTH - 58, menuHeight, 0xe6e8ed);
			mainbtns.addChild(fonbtnmain);
			mainbtns.x = -AppSettings.WIDTH;
			
			addBackButton();
			
			var textFormat:TextFormat = new TextFormat("TornadoL", 48, 0X101318);
			
			var title1:TextField = TextUtil.createTextField(145, 125);
			title1.multiline = true;
			title1.wordWrap = true;
			title1.width = 280;
			title1.text = "Возврат \nк главному экрану";
			title1.setTextFormat(textFormat);
			mainbtns.addChild(title1);
			
			textFormat.size = 18;
			var title2:TextField = TextUtil.createTextField(145, 300);
			title2.multiline = true;
			title2.wordWrap = true;
			title2.width = 200;
			title2.text = "Вы также можете переходить к одному из главных экранов, просто показывая пальцами его номер";
			title2.setTextFormat(textFormat);
			mainbtns.addChild(title2);
			
			addScreen3Buttons();
			
			closeMenuBtn = new InteractiveButton();
			addChild(closeMenuBtn);
			
			var closeMenuBtnFon:Shape = Tool.createShape(AppSettings.WIDTH, AppSettings.HEIGHT - menuHeight, 0xe6e8ed);
			closeMenuBtnFon.alpha = 0;
			closeMenuBtn.addChild(closeMenuBtnFon);
			closeMenuBtn.y = menuHeight;
			closeMenuBtn.visible = false;
			closeMenuBtn.name = "closeBtn";
		}
		
		public function showMainBtns():void
		{
			TweenLite.delayedCall(0.4, showMainMenuButtons);
		}
		
		public function clearShowMainBtns():void
		{
			TweenLite.killDelayedCallsTo(showMainMenuButtons);
		}
		
		private function showMainMenuButtons():void
		{
			TweenLite.to(mainMenu, 0.5, {x: AppSettings.WIDTH});
		}
		
		public function hideMainBtns():void
		{
			TweenLite.delayedCall(0.4, hideMainMenuButtons);
		}
		
		public function clearHideMainBtns():void
		{
			TweenLite.killDelayedCallsTo(hideMainMenuButtons);
		}
		
		public function hideMainMenuButtons():void
		{
			TweenLite.to(mainMenu, 0.5, {x: 0});
		}
		
		public function closeMenuOut():void
		{
			TweenLite.killDelayedCallsTo(closeMenuListener);
		}
		
		public function closeMenuOver():void
		{
			TweenLite.delayedCall(2, closeMenuListener);
		}
		
		private function closeMenuListener():void
		{
			closeMenu();
		}
		public var loc:String;
		
		public function show(shot:BigCanvas):void
		{
			if (isOpen)
				return;
			
			broadcastBtn.deactive();
			eventsBtn.deactive();
			mapBtn.deactive();
			newsBtn.deactive();
			
			visible = true;
			
			if (loc == "MAIN_SCREEN" || loc == "CUSTOM_SCREEN" || loc == "STORY_SCREEN")
			{
				mainbtn.visible = false;
			}
			else
			{
				mainbtn.visible = true;
				switch (loc)
				{
					case ChangeLocationEvent.BROADCAST_PAGE: 
						broadcastBtn.active();
						break;
					
					case ChangeLocationEvent.FACT_PAGE: 
						eventsBtn.active();
						break;
					
					case ChangeLocationEvent.MAP_PAGE: 
						mapBtn.active();
						break;
					
					case ChangeLocationEvent.NEWS_PAGE_DAY: 
					case ChangeLocationEvent.NEWS_PAGE_HOUR: 
						newsBtn.active();
						break;
					default: 
				}
			}
			mainMenu.y = -mainMenu.height;
			mainMenu.x = 0;
			fon.alpha = 0;
			fon.visible = true;
			
			makeScreenshotBottom(shot);
			makeScreenshotBlur(shot);
			
			screenShotHolder.addChild(screenshotBottom);
			
			screenShotHolder.addChild(fon);			
			screenShotHolder.addChild(screenshot);	
			
			layermask.visible = true;
			screenshot.mask = layermask;
			layermask.y = -layermask.height;
			
			overlay.visible = true;
			mainMenu.visible = true;
			
			isOpen = true;
			TweenLite.to(mainMenu, 0.8, {y: 0, ease: Quint.easeInOut});
			TweenLite.to(layermask, 0.8, {y: 0, ease: Quint.easeInOut});
			TweenLite.to(overlay, 0.8, {y: 0, ease: Quint.easeInOut});
			TweenLite.to(screenshotBottom, 0.8, {y: 60 , ease: Quint.easeInOut});
			TweenLite.to(fon, 0.5, {alpha: 0.98, ease: Quint.easeInOut});
			
			closeMenuBtn.visible = true;
		}
		
		public function closeMenu():void
		{
			TweenLite.to(mainMenu, 0.3, {y: -mainMenu.height});
			TweenLite.to(layermask, 0.3, {y: -layermask.height});
			
			TweenLite.to(overlay, 0.3, {y: -overlay.height});
			TweenLite.to(screenshotBottom, 0.3, {y: 0});
			
			TweenLite.to(fon, 0.3, {alpha: 0, onComplete: function():void
				{
					screenshot.dispose();
					screenshotBottom.dispose();
					
					if (screenShotHolder.contains(screenshot))screenShotHolder.removeChild(screenshot);
					if (screenShotHolder.contains(screenshotBottom))screenShotHolder.removeChild(screenshotBottom);
					if (screenShotHolder.contains((fon)))screenShotHolder.removeChild(fon);
					closeMenuBtn.visible = false;
					isOpen = false;
					this.visible = false;
					dispatchEvent(new AnimationEvent(AnimationEvent.MENU_ANIMATION_FINISHED));
					dispatchEvent( new ChangeLocationEvent( ChangeLocationEvent.MENU_IS_HIDDEN));
			}});
		}
		
		public function selectedItem():String
		{
			if (newsBtn.isSelect)
				return ChangeLocationEvent.NEWS_PAGE_DAY;
			if (mapBtn.isSelect)
				return ChangeLocationEvent.MAP_PAGE;
			if (eventsBtn.isSelect)
				return ChangeLocationEvent.FACT_PAGE;
			if (broadcastBtn.isSelect)
				return ChangeLocationEvent.BROADCAST_PAGE;
			if (screen1Btn.isSelect)
				return ChangeLocationEvent.MAIN_SCREEN;
			if (screen2Btn.isSelect)
				return ChangeLocationEvent.CUSTOM_SCREEN;
			if (screen3Btn.isSelect)
				return ChangeLocationEvent.STORY_SCREEN;
			return "";
		}
		
		public function makeScreenshotBottom(shot:BigCanvas):void
		{
			screenshotBottom = new BigCanvas( AppSettings.WIDTH, AppSettings.HEIGHT);			
			screenshotBottom.draw(shot);			
		}
		
		public function makeScreenshotBlur(shot:BigCanvas):void
		{
			var jpgSource:BitmapData = new BitmapData(AppSettings.WIDTH, menuHeight);
			
			jpgSource.draw(shot);
			
			var BLUR_FILTER:BlurFilter = new BlurFilter(36, 36, 4);
			jpgSource.applyFilter(jpgSource, jpgSource.rect, new Point, BLUR_FILTER);
			
			screenshot = new BigCanvas(AppSettings.WIDTH, menuHeight);
			screenshot.draw(jpgSource);			
		}
		
		///////////////////////////////////   MAKE UP ///////////////////////////////////////////////////////////////
		public function addFon():void
		{
			fon = Tool.createShape(AppSettings.WIDTH, AppSettings.HEIGHT, 0x1a1b1f);
			fon.alpha = 0.68;
			fon.visible = false;
		}
		
		public function addLayerMask():void
		{
			layermask = Tool.createShape(AppSettings.WIDTH, menuHeight, 0x465568);
			layermask.visible = false;
			addChild(layermask);
		}
		
		public function addLayerOverlay():void
		{
			overlay = Tool.createShape(AppSettings.WIDTH, menuHeight, 0x465568);
			overlay.alpha = 0.68;
			overlay.visible = false;
			overlay.y = -overlay.height;
			addChild(overlay);
		}
		
		public function addMainButton():void
		{
			mainbtn = new InteractiveButton();
			
			var fonbtnmain:Shape = Tool.createShape(58, menuHeight, 0xe6e8ed);
			
			var houseIcon:Sprite = Assets.create("houseIcon");
			houseIcon.x = 0.5 * (fonbtnmain.width - houseIcon.width);
			houseIcon.y = (menuHeight - houseIcon.height - 30);
			
			mainbtn.addChild(fonbtnmain);
			mainbtn.addChild(houseIcon);
			mainMenu.addChild(mainbtn);
		}
		
		public function addBackButton():void
		{
			var fonbtnback:Shape = Tool.createShape(58, menuHeight, 0xe6e8ed);
			fonbtnback.alpha = 0;
			backbtn = new InteractiveButton();
			backbtn.x = AppSettings.WIDTH - fonbtnback.width;
			
			var backIcon:Sprite = Assets.create("backIcon");
			backIcon.x = 0.5 * (fonbtnback.width - backIcon.width);
			backIcon.y = (menuHeight - backIcon.height - 30);
			
			backbtn.addChild(fonbtnback);
			backbtn.addChild(backIcon);
			mainbtns.addChild(backbtn);
		}
		
		public function addScreen3Buttons():void
		{
			screen1Btn = new MenuButton();
			screen1Btn.init("1");
			screen1Btn.x = 560;
			screen1Btn.y = 152;
			
			screen2Btn = new MenuButton();
			screen2Btn.init("2");
			screen2Btn.x = 977;
			screen2Btn.y = 152;
			
			screen3Btn = new MenuButton();
			screen3Btn.init("3");
			screen3Btn.x = 1378;
			screen3Btn.y = 152;
			
			mainbtns.addChild(screen1Btn);
			mainbtns.addChild(screen2Btn);
			mainbtns.addChild(screen3Btn);		
		}
		
		private function createButtons():void
		{
			newsBtn = new MenuButton();
			newsBtn.init("allnewsMenu");
			newsBtn.x = 215;
			newsBtn.y = 152;
			
			eventsBtn = new MenuButton();
			eventsBtn.init("eventsMenu");
			eventsBtn.x = 637;
			eventsBtn.y = 152;
			
			mapBtn = new MenuButton();
			mapBtn.init("mapMenu");
			mapBtn.x = 637 + 416;
			mapBtn.y = 152;
			
			broadcastBtn = new MenuButton();
			broadcastBtn.init("msk24");
			broadcastBtn.x = 637 + 416 + 402;
			broadcastBtn.y = 152;
			
			mainMenu.addChild(newsBtn);
			mainMenu.addChild(eventsBtn);
			mainMenu.addChild(mapBtn);
			mainMenu.addChild(broadcastBtn);
		}	
	}
}
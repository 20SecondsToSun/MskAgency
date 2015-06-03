package app.view.mainscreen
{
	import app.AppSettings;
	import app.contoller.events.AnimationEvent;
	import app.model.config.ScreenShots;
	import app.model.types.AnimationType;
	import app.view.baseview.BaseView;
	import app.view.utils.Tool;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Quart;
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class MainBase extends BaseView
	{
		protected static var lastActivePage:int = 1;
		protected static var pageNumDictionary:Dictionary = new Dictionary();
		
		public static var activePage:int = 1;
		public static var curLoc:int = 1;
		
		protected var totalPages:int = 3;
		protected var pageNum:int = 0;		
		protected var spaceBettwenPages:int = 300;
		protected var screenName:String = "";
		protected var isReady:Boolean = false;
		protected var angle:int = 45;
		protected var shiftY:int = 40;
		protected var scale:Number = 0.8;
		protected var allViews:int = 7;
		protected var splash:Sprite = new Sprite();
		protected var shadow:Sprite = new Sprite();
		protected var location:String;
		protected var outY:Number;	
		
		public var firstAnimTime:Number = 1.;
		public var secondAnimTime:Number = 1;
		
		public var firstDelay:Number = 0.2;
		public var secondDelay:Number = 1.3;		
		
		private var layerMask:Shape;
		private var completedViews:int = 0;		
		private var jpgSource:BitmapData;		
		private var config:ScreenShots;		
		
		public function MainBase()
		{
			var pp1:PerspectiveProjection = new PerspectiveProjection();
			pp1.projectionCenter = new Point(AppSettings.WIDTH * 0.5, AppSettings.HEIGHT * 0.5);
			this.transform.perspectiveProjection = pp1;
			
			pageNumDictionary["GO_TO_MAIN_SCREEN_MAIN_WAY"] = 1;
			pageNumDictionary["GO_TO_CUSTOM_SCREEN_MAIN_WAY"] = 2;
			pageNumDictionary["GO_TO_STORY_SCREEN_MAIN_WAY"] = 3;
			
			pageNumDictionary["GO_TO_MAIN_SCREEN_BACK"] = 1;
			pageNumDictionary["GO_TO_CUSTOM_SCREEN_BACK"] = 2;
			pageNumDictionary["GO_TO_STORY_SCREEN_BACK"] = 3;
		}
		
		public function prepare(location:String, config:ScreenShots):void
		{
			this.location = location;
			this.config = config;
			
			if (isReady)
			{
				screenshot();
				removeChilds();
			}
			
			splash = config.getScreenShot(pageNum.toString(), activePage);
			shadow = config.getShadow(pageNum);
			shadow.alpha = 0;
			addChild(splash);
			addChild(shadow);
			
			if (pageNumDictionary[location] == pageNum)
			{
				curLoc = pageNum;
				startOwnLocation();
			}
			else			
				startNotOwnLocation(location);						
		}
		
		public function prepareback(location:String, config:ScreenShots):void
		{
			this.location = location;
			this.config = config;
			
			if (isReady)
			{
				screenshot();
				removeChilds();
			}
			
			splash = config.getScreenShot(pageNum.toString(), activePage);
			shadow = config.getShadow(pageNum);
			shadow.alpha = 0;
			addChild(splash);
			addChild(shadow);
			
			if (pageNumDictionary[location] == pageNum)
			{
				curLoc = pageNum;
				startOwnLocation1();
			}
			else			
				startNotOwnLocation1(location);								
		}
		
		protected function screenshot():void
		{
			//if (pageNum == 3) return;
			jpgSource = new BitmapData(AppSettings.WIDTH, AppSettings.HEIGHT);
			jpgSource.draw(this);
			
			var bmp:Bitmap = new Bitmap(jpgSource);
			bmp.smoothing = true;
			splash.addChild(bmp);
			
			config.setScreenShot(bmp, pageNum.toString());
		}
		
		override public function animationInFinished():void
		{
			this.transform.matrix3D = null;
			TweenMax.killTweensOf(this);
			
			addChilds();
			addMask();
			
			activePage = pageNumDictionary["GO_TO_" + screenName + "_MAIN_WAY"];
			
			isReady = true;
			addEventListener(Event.ENTER_FRAME, activate);
		}
		
		private function activate(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, activate);
			dispatchEvent(new AnimationEvent("AnimationEvent.TO_MAIN_SCREEN_VISIBLE"));
			dispatchEvent(new AnimationEvent("AnimationEvent." + screenName + "_FINISHED", AnimationType.IN, this));
			removeSreenshot();
		}
		
		override public function animationOutFinished():void
		{
			TweenMax.killTweensOf(this);
			this.transform.matrix3D = null;
			
			dispatchEvent(new AnimationEvent("AnimationEvent." + screenName + "_FINISHED", AnimationType.OUT, this));
		}
		
		protected function removeSreenshot():void
		{
			removeChild(splash);
			removeChild(shadow);
		}
		
		protected function startOwnLocation1():void
		{
			this.y = AppSettings.HEIGHT - spaceBettwenPages * (totalPages - (pageNum + 1));			
			this.z = 1;
			finAnimBeforeStart();
			startOwnAnim();
		}
		
		protected function startOwnLocation():void
		{
			if (pageNum > activePage)			
				this.y = AppSettings.HEIGHT - spaceBettwenPages * (totalPages - (pageNum + 1));			
			else			
				this.y = -this.height + spaceBettwenPages * (totalPages - (pageNum + 1));			
			
			this.z = 1;
			finAnimBeforeStart();
			startOwnAnim();
		}
		
		protected function finAnimBeforeStart():void
		{
			TweenMax.to(this, secondAnimTime, {delay: secondDelay, alpha: 1, scaleX: 1, scaleY: 1, y: 0, x: 0, ease: Quart.easeOut, rotationX: 0, rotationY: 0, onComplete: animationInFinished})
			TweenMax.to(shadow, secondAnimTime, {delay: secondDelay, alpha: 0, ease: Quart.easeOut})
		}
		
		protected function startOwnAnim():void
		{
			TweenMax.to(this, firstAnimTime, {delay: firstDelay, alpha: 1, ease: Quart.easeOut, y: shiftY + spaceBettwenPages * (pageNum - 1), x: (1 - scale) * 0.5 * AppSettings.WIDTH, rotationX: angle, rotationY: 0, scaleX: scale, scaleY: scale});
			TweenMax.to(shadow, firstAnimTime, {delay: firstDelay, alpha: 1, ease: Quart.easeOut})
		}
		
		protected function startNotOwnLocation(location:String):void
		{
			if (pageNumDictionary[location] < pageNum)			
				outY = AppSettings.HEIGHT - spaceBettwenPages * (totalPages - (pageNum + 1)) + 100;			
			else			
				outY = -this.height - spaceBettwenPages * (totalPages - (pageNum + 1));		
			
			chooseStartYPosition();
			startNotOwnAnim();
			finAnimToOut();
			
			lastActivePage = activePage;
		}	
		
		protected function startNotOwnLocation1(location:String):void
		{
			if (pageNumDictionary[location] < pageNum)			
				outY = AppSettings.HEIGHT - spaceBettwenPages * (totalPages - (pageNum + 1)) + 100;					
			else			
				outY = -this.height - spaceBettwenPages * (totalPages - (pageNum + 1));			
			
			chooseStartYPosition1();
			startNotOwnAnim();
			finAnimToOut();
			
			lastActivePage = activePage;
		}
		
		protected function chooseStartYPosition1():void
		{
			z = 1;
			y = AppSettings.HEIGHT - spaceBettwenPages * (totalPages - (pageNum + 1));
		}
		protected function chooseStartYPosition():void
		{
			z = 1;
			if (pageNum == activePage)
			{
				// // NOTHING!!!!!!!!!
			}
			else if (pageNum > activePage)
			{
				y = AppSettings.HEIGHT - spaceBettwenPages * (totalPages - (pageNum + 1));
			}
			else
			{
				y = -this.height + spaceBettwenPages * (totalPages - (activePage + 1));
			}
		}	
		
		protected function finAnimToOut():void
		{
			TweenMax.to(this, secondAnimTime, {delay: secondDelay, y: outY, ease: Quart.easeOut, onComplete: animationOutFinished});
			TweenMax.to(shadow, secondAnimTime, {delay: secondDelay, alpha: 0, ease: Quart.easeOut})
		}
		
		protected function startNotOwnAnim():void
		{
			TweenMax.to(shadow, secondAnimTime, {delay: firstDelay, alpha: 1, ease: Quart.easeOut})
			TweenMax.to(this, firstAnimTime, {delay: firstDelay, alpha: 1, y: shiftY + spaceBettwenPages * (pageNum - 1), x: (1 - scale) * 0.5 * AppSettings.WIDTH, ease: Quart.easeOut, scaleX: scale, scaleY: scale, rotationX: angle, rotationY: 0});
		}
		
		protected function childHide():void
		{
		
		}
		
		protected function childShow():void
		{
		
		}
		
		protected function addChilds():void
		{
		
		}
		
		protected function removeChilds():void
		{
		
		}
		
		protected function addMask():void
		{
			layerMask = Tool.createShape(AppSettings.WIDTH, AppSettings.HEIGHT, 0xaa0020);
			mask = layerMask;
			addChild(layerMask);
		}
	}
}
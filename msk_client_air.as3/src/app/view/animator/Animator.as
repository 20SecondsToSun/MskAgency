package app.view.animator
{
	import app.AppSettings;
	import app.model.config.ScreenShots;
	import app.view.utils.BigCanvas;
	import app.view.utils.Tool;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class Animator extends Sprite
	{
		public var config:ScreenShots;
		
		private var screenshot:BigCanvas;
		private var _animation:String = "NONE";
		private var screen2:Bitmap;
		private var screen1:Bitmap;		
		private var _expand_rectangle:Rectangle;
		private var _expand_color:uint;
		private var background:Shape;		
		
		public function set animation(value:String):void
		{
			killAllBefore();
			_animation = value;
		}
		
		private function killAllBefore():void
		{
			TweenLite.killDelayedCallsTo(startAnimate);
			if (screenshot) TweenLite.killTweensOf(screenshot);
			if (screen1) TweenLite.killTweensOf(screen1);
			if (screen2) TweenLite.killTweensOf(screen2);
			
			if (screenshot && contains(screenshot))
				removeChild(screenshot)
			
			if (screen1 && contains(screen1))
				removeChild(screen1)
			
			if (screen2 && contains(screen2))
				removeChild(screen2)
		}
		
		public function set expand_rectangle(value:Rectangle):void
		{
			_expand_rectangle = value;
		}
		
		public function set expand_color(value:uint):void
		{
			_expand_color = value;
		}
		
		public function setScreenshot(shot:BigCanvas):void
		{
			screenshot = shot;
			
			switch (_animation)
			{
			case "SPLIT": 
				split();
				break;
			
			case "EXPAND": 
				expand(_expand_rectangle, _expand_color);
				break;
			
			case "FLIP": 
				flip();
				break;
			
			case "FADE": 
				fade();
				break;
			
			case "FLY": 
				fly();
				break;
			}
		}
		
		private function fly():void
		{
			var scr:Sprite = new Sprite();
			scr.addChild(screenshot);
			var angle:int = 30;
			var shiftY:int = 40;
			var scale:Number = 0.8;
			var spaceBettwenPages:int = 200;
			var pageNum:int = 1;
			var firstTime:Number = 0.35;			
			var timeline:TimelineLite = new TimelineLite();			
			var shadow:Sprite = new Sprite();
			
			shadow = config.getShadow(3);
			shadow.alpha = 0;
			scr.addChild(shadow);
			addChild(scr);
			
			TweenMax.to(shadow, 1.5, {alpha: 0.4});
			TweenMax.to(scr, firstTime, {alpha: 1, x: (1 - scale) * 0.5 * AppSettings.WIDTH, y: (1 - scale) * 0.5 * AppSettings.WIDTH, ease: Linear.easeIn, scaleX: scale, scaleY: scale});			
			TweenMax.to(scr, 0.8, {delay: firstTime, ease: Linear.easeIn, y: -1750, rotationX: (angle + 40), onComplete: function():void
			{
				removeChild(scr);
			}});
		}
		
		private function fade():void
		{
			var scr:Sprite = new Sprite();
			scr.addChild(screenshot);
			addChild(scr);
			
			TweenMax.to(scr, 0.8, {alpha: 0.3, onComplete: function():void
			{
				TweenMax.delayedCall(0.8, function():void
				{
					if (scr && contains(scr)) removeChild(scr);
				});
			}})
		}
		
		private function flip():void
		{
			var scr:Sprite = new Sprite();
			scr.addChild(screenshot);
			var angle:int = 30;
			var shiftY:int = 40;
			var scale:Number = 0.8;
			var spaceBettwenPages:int = 200;
			var pageNum:int = 1;
			var firstTime:Number = 0.35;			
			var timeline:TimelineLite = new TimelineLite();			
			var shadow:Sprite = new Sprite();
			
			shadow = config.getShadow(3);
			shadow.alpha = 0;
			scr.addChild(shadow);
			addChild(scr);
			
			TweenMax.to(shadow, 1.5, {alpha: 0.4});	
			TweenMax.to(scr, firstTime, {alpha: 1, x: (1 - scale) * 0.5 * AppSettings.WIDTH, y: (1 - scale) * 0.5 * AppSettings.WIDTH, ease: Linear.easeIn, scaleX: scale, scaleY: scale});			
			TweenMax.to(scr, 0.8, {delay: firstTime, ease: Linear.easeIn, y: -1750, rotationX: (angle + 10), onComplete: function():void
			{
				removeChild(scr);
			}})	
		}
		
		public function expand(rec:Rectangle, color:uint = 0xfffff):void
		{
			background = Tool.createShape(rec.width + 2, rec.height + 2, color);
			background.x = rec.x - 1;
			background.y = rec.y - 1;
			
			var finWidth:Number;
			var finHeight:Number;
			
			if (background.width > background.height)
			{
				finHeight = AppSettings.HEIGHT;
				finWidth = AppSettings.HEIGHT * (background.width / background.height);
			}
			else
			{
				finWidth = AppSettings.WIDTH;
				finHeight = AppSettings.WIDTH * (background.height / background.width);
			}
			var screenshotScale:Number = finWidth / background.width;
			
			addChild(screenshot);
			
			TweenLite.to(screenshot, 0.7, {x: -rec.x * screenshotScale, y: -rec.y * screenshotScale, scaleX: screenshotScale, scaleY: screenshotScale, ease: Cubic.easeInOut});
			TweenLite.to(background, 1.5, {x: 0, y: 0, width: finWidth, height: finHeight, ease: Expo.easeInOut, onComplete: function():void
			{
				screenshot.dispose();
				removeChild(screenshot);
			}});
			
			TweenLite.to(screenshot, 0.3, {delay: 0.1, alpha: 0, ease: Cubic.easeInOut});
		}
		
		private function split():void
		{
			var bd1:BitmapData = new BitmapData(622, AppSettings.HEIGHT);
			bd1.draw(screenshot);
			
			screen1 = new Bitmap(bd1);
			addChild(screen1);
			
			var bd2:BitmapData = new BitmapData(AppSettings.WIDTH - 622, AppSettings.HEIGHT);
			var mat:Matrix = new Matrix();
			mat.translate(-622, 0);
			bd2.draw(screenshot, mat);
			
			screen2 = new Bitmap(bd2);
			addChild(screen2);
			screen2.x = 622;
			
			TweenLite.delayedCall(0.5, startAnimate);
		}
		
		private function startAnimate():void
		{			
			TweenLite.to(screen1, 0.8, {x: -screen1.width, ease: Expo.easeOut, onComplete: function():void
			{
				screen1.bitmapData.dispose();
				removeChild(screen1);
				screenshot.dispose();
			}});
			
			TweenLite.to(screen2, 0.8, {x: AppSettings.WIDTH, ease: Expo.easeOut, onComplete: function():void
			{
				screen2.bitmapData.dispose();
				removeChild(screen2);
			}});
		}
	}
}
package app.view.allnews
{
	import app.AppSettings;
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.InteractiveEvent;
	import app.model.materials.Material;
	import app.model.types.AnimationType;
	import app.view.baseview.io.InteractiveObject;
	import app.view.baseview.MainScreenView;
	import app.view.utils.Tool;
	import com.greensock.easing.Quart;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class AllNews extends MainScreenView
	{
		private var photoBackground:Sprite;
		private var slider:AllNewsSlider;
		private var oneHourNewsList:Vector.<OneHourBlockNews>;
		private var isAnimate:Boolean = true;
		private var initY:int;
		private var sliderWidth:Number;
		private var splash:Shape;
		
		private var minHeight:int = 279;
		private var maxHeight:int = 405;
		
		private var sliderOffsetX:int = 30;
		private var holder:Sprite;
		private var loadingID:String = "ALL_DATA__" + Math.random().toString();
		private var freshUpdating:Boolean = false;
		
		private var screenshot:Bitmap;
		private var screenshotNew:Bitmap;
		private var mat:Matrix;
		
		private var __holder:InteractiveObject;
		private var step:Number = 0.5;
		private var initScreenShot:Sprite;
		private var thatsAll:Boolean = false;
		
		public function AllNews()
		{
			isStretch = true;
			visible = false;
			
			splash = Tool.createShape(AppSettings.WIDTH, minHeight, 0x000000);
			addChild(splash);
			
			holder = new Sprite();
			addChild(holder);
			
			splash = Tool.createShape(AppSettings.WIDTH, minHeight, 0x1a1b1f);
			holder.addChild(splash);
			
			initY = AppSettings.HEIGHT - (69 + 232 + minHeight);
			
			slider = new AllNewsSlider(new Rectangle(0, 0, AppSettings.WIDTH, 279));
			slider.holder.x = sliderOffsetX;
			holder.addChild(slider);
			
			splash = Tool.createShape(AppSettings.WIDTH, minHeight, 0x1a1b1f);
			splash.alpha = 0;
			addChild(splash);
		}
		
		public function setScreenShot():void
		{
			var bitmapData:BitmapData = new BitmapData(AppSettings.WIDTH, minHeight);
			bitmapData.drawWithQuality(holder, null, null, null, null, true, StageQuality.BEST);
			
			config.setScreenShot(new Bitmap(bitmapData), "ALL_NEWS");
		}		
		
		override public function setScreen():void
		{
			initScreenShot = config.getScreenShot("ALL_NEWS");
			initScreenShot.visible = true;
			addChild(initScreenShot);
			//initScreenShot.y = initY;
			visible = true;
			this.y = initY;
		}
		
		public function refreshData(allNewsHourList:Vector.<Vector.<Material>>):void
		{
			if (isListNull(allNewsHourList))
				return;
			
			slider.stopInteraction();
			slider.clearSlider();
			slider.holder.x = 30;
			
			oneHourNewsList = new Vector.<OneHourBlockNews>();
			
			for (var i:int = 0; i < allNewsHourList.length; i++)
			{
				var oneHourNews:OneHourBlockNews = new OneHourBlockNews(allNewsHourList[i]);
				oneHourNewsList.push(oneHourNews);
			}
			
			slider.init(oneHourNewsList);
			splash.width = sliderWidth = slider.width;
			
			slider.startInteraction();
			
			//trace("isAllowAnimation",isAllowAnimation);
			
			if (initScreenShot && contains(initScreenShot))
			{
				var bd:BitmapData = new BitmapData(AppSettings.WIDTH, minHeight);
				bd.draw(initScreenShot);
				screenshot = new Bitmap(bd);
				addChild(screenshot);
				removeChild(initScreenShot);
				
				makeSliderScreenshotNew();
				holder.visible = false;				
			}
			
			flip();
			waitToAnim();
			//dispatchEvent(new DataLoadServiceEvent(DataLoadServiceEvent.REFRESH_COMPLETED_ALL_NEWS, true, true));
		}
		
		public function toMainScreen():void
		{
			this.y = initY; // -this.height;
			visible = true;
			animateToXY(0, initY, anim.MainScreen1AllNews.animInSpeed, anim.MainScreen1AllNews.animInEase);
		}
		
		public function show():void
		{
			visible = true;
			this.y = initY;
			this.x = 0;
			dispatchEvent(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_DATA));
		}
		
		public function stretch(percent:Number):void
		{
			if (thatsAll) return;
			var changeHeight:Number = minHeight + (maxHeight - minHeight) * percent * 1.2;			
			var scale:Number = changeHeight / minHeight;
			
			if (percent >= 1)
			{
				thatsAll = true;
				scale = changeHeight / minHeight + 0.5 + 10;
				//slider.visible = false;
				TweenLite.to(slider, 0.4, { alpha:0 } );
				TweenLite.to(holder, 0.8, { scaleX: scale, scaleY: scale, y: -700 /*(changeHeight - minHeight) * 0.5*//* (AppSettings.HEIGHT - 840)*0.5*/, x: -AppSettings.WIDTH * (scale - 1) * 0.5, onComplete: endStretch } );
				return;
			}
			
			TweenLite.to(holder, 0.5, { scaleX: scale, scaleY: scale, y: (changeHeight - minHeight) * 0.5, x: -AppSettings.WIDTH * (scale - 1) * 0.5 } );			
		}
		
		private function endStretch():void
		{
			dispatchEvent(new ChangeLocationEvent(ChangeLocationEvent.NEWS_PAGE_HOUR));
			dispatchEvent(new AnimationEvent(AnimationEvent.ALL_NEWS_ANIMATION_FINISHED, AnimationType.OUT, this));
		}
		
		override public function animationInFinished():void
		{
			dispatchToLoadData();
			dispatchEvent(new AnimationEvent(AnimationEvent.ALL_NEWS_ANIMATION_FINISHED, AnimationType.IN, this));
		}
		
		private function dispatchToLoadData():void
		{
			var dataLoadingServiceEvent:DataLoadServiceEvent = new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_DATA);
			dataLoadingServiceEvent.loadingID = loadingID;
			dispatchEvent(dataLoadingServiceEvent);
		}
		
		override public function animationOutFinished():void
		{
			dispatchEvent(new AnimationEvent(AnimationEvent.ALL_NEWS_ANIMATION_FINISHED, AnimationType.OUT, this));
		}
		
		public function handOver(e:InteractiveEvent):void
		{
			slider.maxBorder -= 200;
			slider.startX = 190;
			slider.margin += 300;
			var scale:Number = maxHeight / minHeight;
			TweenLite.to(this, 0.3, {scaleX: scale, scaleY: scale, y: initY - (maxHeight - minHeight) * 0.5, x: -AppSettings.WIDTH * (scale - 1) * 0.5});
		}
		
		public function handOut(e:InteractiveEvent):void
		{
			slider.maxBorder = AppSettings.WIDTH;
			slider.startX = 0;
			slider.margin = 400;
			
			if (slider.holder.x > 0)
				TweenLite.to(slider.holder, 0.3, {x: sliderOffsetX});
			
			var scale:Number = minHeight / minHeight;
			TweenLite.to(this, 0.3, {scaleX: scale, scaleY: scale, y: initY + (minHeight - minHeight), x: -AppSettings.WIDTH * (scale - 1) * 0.5});
		}
		
		override public function kill():void
		{
			super.kill();
			TweenLite.killTweensOf(holder);
			TweenLite.killTweensOf(this);
			TweenLite.killDelayedCallsTo(startAutoAnimation);
			removeEventListener(Event.ENTER_FRAME, animateSlider);
		}
		
		override protected function startAutoAnimation():void
		{
			if (isListNull(oneHourNewsList) || !slider.isReady || !isAllowAnimation)
				return;
				
		  //  slider.holder.x = -6500;
			//trace("SLIDER WIDTH!!!!!!!::", slider.holder.width);
			isAutoAnimation = true;
			addEventListener(Event.ENTER_FRAME, animateSlider);
			// 
			//	var holder:InteractiveObject = slider.holder;
			//	var time:Number = ((holder.width + holder.x) / holder.width) * 500;
			//	TweenLite.to(holder, time, {x: slider.maxBorder - holder.width, onComplete: restart});
			// 
		}
		
		private function animateSlider(e:Event):void
		{
			__holder = slider.holder;
			//trace("SIZE     !!!!!!!!!!!!!!!!!!!!", holder.width, __holder.width);
			if (slider.holder.x - step > slider.maxBorder - __holder.width)
			{
				slider.holder.x -= step;
			}
			else
			{
				//
				removeEventListener(Event.ENTER_FRAME, animateSlider);
				//slider.holder.x = slider.maxBorder - holder.width; ,
				//slider.holder.x = slider.maxBorder - 10;
				restart();
				//slider.holder.x = -600;
				step = 0.5;
			}
		}
		
		private function restart():void
		{
			makeSliderScreenshot();
			slider.stopInteraction();
			slider.holder.x = 30;
			makeSliderScreenshotNew();
			holder.visible = false;
			flip();
		}
		
		override public function stopAutoAnimation():void
		{
			isAutoAnimation = false;
			//TweenLite.killTweensOf(slider.holder);
			removeEventListener(Event.ENTER_FRAME, animateSlider);
		}
		
		public function updater(allNewsHourList:Vector.<Vector.<Material>>):void
		{
			if (isListNull(allNewsHourList))
				return;
			
			if (freshUpdating == false)
			{
				TweenLite.killTweensOf(slider.holder);
				makeSliderScreenshot();
			}
			
			slider.stopInteraction();
			slider.clearSlider();
			
			oneHourNewsList = new Vector.<OneHourBlockNews>();
			for (var i:int = 0; i < allNewsHourList.length; i++)
			{
				var oneHourNews:OneHourBlockNews = new OneHourBlockNews(allNewsHourList[i]);
				oneHourNewsList.push(oneHourNews);
			}
			
			slider.holder.x = 30;
			slider.init(oneHourNewsList);
			splash.width = sliderWidth = slider.width;
			
			if (freshUpdating == false)
			{
				makeSliderScreenshotNew();
				holder.visible = false;
				flip();
			}
		}
		
		private function flip():void
		{
			freshUpdating = true;
			removeEventListener(Event.ENTER_FRAME, animateSlider);
			
			var pp:PerspectiveProjection = new PerspectiveProjection();
			pp.projectionCenter = new Point(AppSettings.WIDTH * 0.5, minHeight * 0.5);
			transform.perspectiveProjection = pp;
			
			
			var anim:Sprite = new Sprite();
			addChild(anim);
			
			var bitmapData:BitmapData = new BitmapData(AppSettings.WIDTH, minHeight);
			bitmapData.drawWithQuality(screenshotNew, null, null, null, null, true, StageQuality.BEST);
			var cur:Bitmap = new Bitmap(bitmapData);
			
			bitmapData = new BitmapData(AppSettings.WIDTH, minHeight);
			bitmapData.draw(screenshot);
			var prev:Bitmap = new Bitmap(bitmapData);
			
			anim.addChild(cur);
			anim.addChild(prev);
			
			screenshotNew.visible = false;
			screenshot.visible = false;
			
			cur.rotationX = -90;
			cur.z = minHeight;
			var swap:Boolean = false;
			
			TweenLite.to(anim, 1, {scaleX: 1, ease: Quart.easeInOut, scaleY: 1, rotationX: 90, y: minHeight, onUpdate: function():void
				{
					if (anim.rotationX > 80 && swap == false)
					{
						swap = true;
						anim.swapChildren(cur, prev);
					}
				}});
			
			TweenLite.to(prev, 0.8, {delay: 0.2, colorTransform: {tint: 0x000000, tintAmount: 0.5}, onComplete: function():void
				{
					bitmapData.dispose();
					anim.removeChild(cur);
					anim.removeChild(prev);
					removeChild(anim);
					restartSlider();
				}});
		}
		
		private function restartSlider():void
		{
			freshUpdating = false;
			holder.visible = true;
			slider.startInteraction();
			
			if (screenshotNew && contains(screenshotNew))removeChild(screenshotNew);
			if (screenshot && contains(screenshot))removeChild(screenshot);
			
			if (isAutoAnimation)
				startAutoAnimation();
		}
		
		private function makeSliderScreenshot():void
		{
			var bd:BitmapData = new BitmapData(AppSettings.WIDTH, minHeight);
			
			mat = new Matrix(1, 0, 0, 1, -slider.x);
			bd.draw(holder, mat);
			screenshot = new Bitmap(bd);
			addChild(screenshot);
		}
		
		private function makeSliderScreenshotNew():void
		{
			var bd:BitmapData = new BitmapData(AppSettings.WIDTH, minHeight);
			bd.draw(holder);
			screenshotNew = new Bitmap(bd);
			addChild(screenshotNew);
		}
	}
}
package app.view.photonews
{
	import app.AppSettings;
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.ServerUpdateEvent;
	import app.model.materials.Material;
	import app.model.types.AnimationType;
	import app.view.baseview.BaseView;
	import app.view.baseview.io.InteractiveObject;
	import app.view.baseview.MainScreenView;
	import app.view.utils.Tool;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class PhotoNews extends MainScreenView
	{
		private var slider:PhotoSlider;
		public var curLoc:String;
		private var onePhotoNewList:Vector.<OnePhotoGraphic>;
		private var isAnimate:Boolean = true;
		private var initY:Number;
		
		private var freshUpdating:Boolean = false;
		private var __holder:InteractiveObject;
		
		private static const phSliderHeight:int = 232;
		
		public function PhotoNews()
		{
			visible = false;
			
			var splash:Shape = Tool.createShape(AppSettings.WIDTH, phSliderHeight, 0x121418);
			addChild(splash);
			
			initY = AppSettings.HEIGHT - (69 + phSliderHeight);
			
			slider = new PhotoSlider(new Rectangle(0, 0, AppSettings.WIDTH, phSliderHeight));
			addChild(slider);
			
			//slider.scaleX = slider.scaleY = 0.5;		
		}
		
		public function setScreenShot():void
		{
			var bitmapData:BitmapData = new BitmapData(AppSettings.WIDTH, phSliderHeight);
			bitmapData.drawWithQuality(this, null, null, null, null, true, StageQuality.BEST);
			
			config.setScreenShot(new Bitmap(bitmapData), "PHOTO_NEWS");
		}
		private var initScreenShot:Sprite;
		
		override public function setScreen():void
		{
			initScreenShot = config.getScreenShot("PHOTO_NEWS");
			initScreenShot.visible = true;
			addChild(initScreenShot);
			visible = true;
			this.y = initY;
		}
		
		public function refreshData(photoList:Vector.<Material>):void
		{
			if (isListNull(photoList))
				return;
				
			if (slider && contains(slider))
			{
				removeChild(slider);
				
				slider = new PhotoSlider(new Rectangle(0, 0, AppSettings.WIDTH, phSliderHeight));
				addChild(slider);
			}			
			
			photoList = photoList.reverse();
			onePhotoNewList = new Vector.<OnePhotoGraphic>();
			
			trace("-------REFRSH!!!!!!!!!!!-------", curLoc);
			var folder:String = curLoc == "MAIN_SCREEN"?"maingallery/":"maingallery1/";			

			for (var i:int = 0; i < 10; i++)// photoList.length; i++)
			{
				photoList[i].files[0].thumbPath = folder + (i + 1).toString() + ".jpg";	
				//trace("--------------", photoList[i].files[0].thumbPath);
				
				var onePhotoNew:OnePhotoGraphic = new OnePhotoGraphic(photoList[i]);
				onePhotoNewList.push(onePhotoNew);
			}
			slider.callBackStart = removeInitScreen;
			slider.init(onePhotoNewList);			
			
			waitToAnim();
			//dispatchEvent(new DataLoadServiceEvent(DataLoadServiceEvent.REFRESH_COMPLETED_PHOTO_NEWS, true, true));
		}
		
		public function removeInitScreen():void
		{
			freshUpdating = false;
			slider.resetPosition();
			if (initScreenShot && contains(initScreenShot))
			{
				TweenLite.to(initScreenShot, 0.9, { x:AppSettings.WIDTH, onComplete:function ():void 
				{
					removeChild(initScreenShot);	
				} } );				
			}
		}
		
		public function toMainScreen():void
		{
			this.y = initY;//-this.height - 232;
			visible = true;
			isAnimate = true;
			animateToXY(0, initY, anim.MainScreen1Photo.animInSpeed, anim.MainScreen1Photo.animInEase);
		}
		
		public function show():void
		{
			visible = true;
			x = 0;
			y = initY;
			dispatchEvent(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_PHOTO_DATA));
		}
		
		override public function animationInFinished():void
		{
			dispatchEvent(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_PHOTO_DATA));
			dispatchEvent(new AnimationEvent(AnimationEvent.PHOTO_NEWS_ANIMATION_FINISHED, AnimationType.IN, this));
		}
		
		override public function animationOutFinished():void
		{
			dispatchEvent(new AnimationEvent(AnimationEvent.PHOTO_NEWS_ANIMATION_FINISHED, AnimationType.OUT, this));
		}
		
		override public function kill():void
		{
			TweenLite.killDelayedCallsTo(startAutoAnimation);
		}
		
		override protected function startAutoAnimation():void
		{
			if (isListNull(onePhotoNewList) || !slider.isReady || !isAllowAnimation)
				return;
			
			isAutoAnimation = true;
			sliderLoop();
		}
		
		private function restart():void
		{
			slider.resetPosition();
			
			slider.onComplete = function():void
			{
				if (isAutoAnimation)
					sliderLoop();
			}
			
			slider.animate();	
		}
		
		public function updater(e:ServerUpdateEvent):void // allNewsHourList:Vector.<Vector.<Material>>):void
		{
			//trace("HERE PHOTO UPDATER!!!!!!!",freshUpdating, e.mat);
			if (freshUpdating)
				return;
			if (isListNull(onePhotoNewList) || e.mat == null)
				return;
			
		/*	onePhotoNewList = onePhotoNewList.reverse();
			var elem:OnePhotoGraphic = onePhotoNewList.pop();
			onePhotoNewList = onePhotoNewList.reverse();
			//slider.holder.alpha = 0;
			slider.holder.removeChild(elem);
			
			//return;
			
			freshUpdating = true;
			var onePhotoNew:OnePhotoGraphic = new OnePhotoGraphic(e.mat);
			onePhotoNewList.push(onePhotoNew);*/
			
			TweenLite.killTweensOf(slider.holder);
			//refreshData(photoList);
			
			//slider.callBackStart = null;
			//slider.init(onePhotoNewList);
			//slider.callBackStart = removeInitScreen;
			
			if (slider && contains(slider))
			{
				removeChild(slider);
				//slider.clearSlider();
				//slider = null;
				
				slider = new PhotoSlider(new Rectangle(0, 0, AppSettings.WIDTH, phSliderHeight));
				addChild(slider);
				//trace("!!!!!!!!!!!! UPDATE SLIDER !!!!!!!!!!!!", slider.width);
			}
			//onePhotoNewList = onePhotoNewList.reverse();
			//slider.resetPosition();
			slider.callBackStart = removeInitScreen;
			slider.init(onePhotoNewList);
			
			/*
				slider.resetPositions();			
				slider.holder.x = -slider.holder.width;			
				slider.animate();
			*/
				
			//waitToAnim();
			
			
		//slider.addOnePhoto(onePhotoNew, onComplete);
		
		/*
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
		*/
		}
		
		private function onComplete():void
		{
			freshUpdating = false;
			if (isAutoAnimation)
				sliderLoop();
		}
		
		override public function stopAutoAnimation():void
		{
			isAutoAnimation = false;
			TweenLite.killTweensOf(slider.holder);
			removeEventListener(Event.ENTER_FRAME, animateSlider);
		}
		
		public function sliderLoop():void
		{			
			addEventListener(Event.ENTER_FRAME, animateSlider);
			//var time:Number = (1 - (holder.width + holder.x) / holder.width) * 600;
			//TweenLite.to(holder, time, {x: slider.startX, onComplete: restart});
		}
		
		private function animateSlider(e:Event):void 
		{
			__holder = slider.holder;
			var step:Number = 0.5;
			
			if (slider.holder.x + step < slider.startX)
			{
				slider.holder.x += step;
			}
			else
			{
				removeEventListener(Event.ENTER_FRAME, animateSlider);
				slider.holder.x = slider.startX;
				restart();
			}			
		}	
	}
}
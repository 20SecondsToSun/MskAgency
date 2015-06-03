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
		private static const step:Number = .5;
		private static const phSliderHeight:int = 232;
		
		private var slider:PhotoSlider;
		private var onePhotoNewList:Vector.<OnePhotoGraphic>;
		private var isAnimate:Boolean = true;
		private var initY:Number;
		
		private var freshUpdating:Boolean = false;
		private var __holder:InteractiveObject;		
		private var initScreenShot:Sprite;
				
		public function PhotoNews()
		{
			visible = false;
			
			var splash:Shape = Tool.createShape(AppSettings.WIDTH, phSliderHeight, 0x121418);
			addChild(splash);
			
			initY = AppSettings.HEIGHT - (69 + phSliderHeight);
			
			slider = new PhotoSlider(new Rectangle(0, 0, AppSettings.WIDTH, phSliderHeight));
			addChild(slider);
		}
		
		public function setScreenShot():void
		{
			var bitmapData:BitmapData = new BitmapData(AppSettings.WIDTH, phSliderHeight);
			bitmapData.drawWithQuality(this, null, null, null, null, true, StageQuality.BEST);
			
			config.setScreenShot(new Bitmap(bitmapData), "PHOTO_NEWS");
		}		
		
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
			
			for (var i:int = 0; i < photoList.length; i++)
			{
				var onePhotoNew:OnePhotoGraphic = new OnePhotoGraphic(photoList[i]);
				onePhotoNewList.push(onePhotoNew);
			}
			slider.callBackStart = removeInitScreen;
			slider.init(onePhotoNewList);			
			
			waitToAnim();
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
			slider.onComplete = function():void
			{
				if (isAutoAnimation)
					sliderLoop();
			}
			slider.resetPosition();
			slider.animate();	
		}
		
		public function updater(e:ServerUpdateEvent):void // allNewsHourList:Vector.<Vector.<Material>>):void
		{
			if (freshUpdating)
				return;
			if (isListNull(onePhotoNewList) || e.mat == null)
				return;
				
			TweenLite.killTweensOf(slider.holder);		
			
			if (slider && contains(slider))
			{
				removeChild(slider);
			
				slider = new PhotoSlider(new Rectangle(0, 0, AppSettings.WIDTH, phSliderHeight));
				addChild(slider);
			}
			
			slider.callBackStart = removeInitScreen;
			slider.init(onePhotoNewList);
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
		}	
		
		private function animateSlider(e:Event):void 
		{
			__holder = slider.holder;			
			
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
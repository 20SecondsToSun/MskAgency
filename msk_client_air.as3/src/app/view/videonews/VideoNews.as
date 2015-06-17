package app.view.videonews
{
	import app.AppSettings;
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.ServerUpdateEvent;
	import app.contoller.events.SliderEvent;
	import app.model.materials.Material;
	import app.model.types.AnimationType;
	import app.view.baseview.MainScreenView;
	import app.view.utils.Tool;
	import com.greensock.easing.Quart;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class VideoNews extends MainScreenView
	{
		private static var START_Y:int = -1011;
		
		public static const WIDTH:int = 410;
		public static const HEIGHT:int = 500;		
		
		public var slider:VideoSlider;
		
		private var videoNewsGraphicList:Vector.<OneVideoNewGraphic>;
		private var matList:Vector.<Material>;
		
		private var yellowLine:Shape;
		private var photoBackground:Sprite;
		private var splash:Shape;
		private var preview:Sprite;
		private var isInitPosition:Boolean = true;
		private var videoAnimator:VideoAnimator;		
		
		public function VideoNews()
		{
			visible = false;
			addFon();
			slider = new VideoSlider();
			addChild(slider);
			addYellowLine();
		}		
		
		override public function setScreen():void
		{
			preview = config.getScreenShot("VIDEO_NEWS");	
			preview.visible = true;
			addChild(preview);
			preview.x = 0;
			preview.y = 0;
			visible = true;			
		}
		
		public function setScreenShot():void
		{
			var bitmapData:BitmapData = new BitmapData(WIDTH, HEIGHT);
			if (videoNewsGraphicList && videoNewsGraphicList.length)
				bitmapData.drawWithQuality(videoNewsGraphicList[0], null, null, null, null, true, StageQuality.BEST);				
			else if (preview)
				bitmapData.drawWithQuality(preview, null, null, null, null, true, StageQuality.BEST);		
			if (bitmapData) config.setScreenShot(new Bitmap(bitmapData), "VIDEO_NEWS");
		}
		
		private function addFon():void
		{
			var fon:Shape = Tool.createShape(WIDTH, HEIGHT, 0x000000);
			addChild(fon);
			
			splash = Tool.createShape(WIDTH, HEIGHT, 0xffffff);
			addChild(splash);
		}
		
		private function addYellowLine():void
		{
			yellowLine = Tool.createShape(17, 500, 0xffdd1d);
			addChild(yellowLine);
			yellowLine.x = AppSettings.WIDTH - yellowLine.width;
			yellowLine.visible = false;
		}
		
		public function refreshData(videoList:Vector.<Material>):void
		{
			if (contains(preview)) removeChild(preview);
			preview = config.getScreenShot("VIDEO_NEWS");
			addChild(preview);
			
			if (isListNull(videoList))
				return;
			
			if (!isInitPosition)
				slider.initVideSliderPosition();
			slider.clearSlider();
			
			matList = videoList;
			
			videoNewsGraphicList = new Vector.<OneVideoNewGraphic>();
			
			for (var i:int = 0; i < matList.length; i++)
			{
				var oneVideoNewGraphic:OneVideoNewGraphic = new OneVideoNewGraphic(matList[i], i == 0);
				videoNewsGraphicList.push(oneVideoNewGraphic);
			}
			
			slider.init(videoNewsGraphicList);
			slider.startInteraction();
			videoNewsGraphicList = videoNewsGraphicList.reverse();
			
			if (splash && contains(splash))
				removeChild(splash);
			
			waitToAnim();			
			flipNew();
		}
		
		private function flipNew():void
		{
			slider.visible = false;
			
			var pp:PerspectiveProjection = new PerspectiveProjection();
			pp.projectionCenter = new Point(205, 250);
			transform.perspectiveProjection = pp;
			
			
			var anim:Sprite = new Sprite();
			addChild(anim);			
			
			var bitmapData:BitmapData = new BitmapData(WIDTH, HEIGHT);
			bitmapData.drawWithQuality(videoNewsGraphicList[0], null, null, null, null, true, StageQuality.BEST);			
			var cur:Bitmap = new Bitmap(bitmapData);	
			
			bitmapData = new BitmapData(WIDTH, HEIGHT);
			bitmapData.draw(preview);			
			var prev:Bitmap = new Bitmap(bitmapData);	
			
			if (contains(preview)) removeChild(preview);
		
			anim.addChild(cur);
			anim.addChild(prev);
			
			cur.y = -HEIGHT;			
			
			TweenLite.to(cur, 1, { y: 0 , ease: Quart.easeInOut} );
			TweenLite.to(prev, 1, { y: prev.height, ease: Quart.easeInOut , onComplete:function ():void 
			{				
				slider.visible = true;
				bitmapData.dispose();
				anim.removeChild(cur);
				anim.removeChild(prev);
				removeChild(anim);				
			}} );		
		}		
		
		public function hideYellowLine(e:SliderEvent):void
		{
			yellowLine.visible = false;
			isInitPosition = true;
		}
		
		public function showYellowLine(e:SliderEvent):void
		{
			yellowLine.visible = true;
			isInitPosition = false;
		}
		
		public function toMainScreen():void
		{
			y = 0;// START_Y;
			visible = true;
			animateToXY(0, 0, anim.MainScreen1.animInSpeed, anim.MainScreen1.animInEase);
		}
		
		public function show():void
		{
			visible = true;
			y = x = 0;
			dispatchEvent(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_VIDEO_DATA));
		}
		
		override protected function startAutoAnimation():void
		{
			if (isListNull(videoNewsGraphicList))
				return;
			if (videoNewsGraphicList.length < 2)
				return;
				
			if (!slider.isReady || !isAllowAnimation) return;
			
			if (!isInitPosition)
				slider.initVideSliderPosition(startVideoAutoAnimation);
			else
				startVideoAutoAnimation();
		}
		
		private function startVideoAutoAnimation():void
		{
		   if (isAutoAnimation) return;
		
		   isAutoAnimation = true;
		
		   videoAnimator = new VideoAnimator(videoNewsGraphicList);
		   addChild(videoAnimator);
		}	
		 
		override public function stopAutoAnimation():void
		{
			isAutoAnimation = false;
			
			if (videoAnimator && contains(videoAnimator))
				removeChild(videoAnimator);
		}
		
		override public function animationInFinished():void
		{
			slider.startInteraction();
			dispatchEvent(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_VIDEO_DATA));
			dispatchEvent(new AnimationEvent(AnimationEvent.VIDEO_NEWS_ANIMATION_FINISHED, AnimationType.IN, this));
		}
		
		override public function animationOutFinished():void
		{
			dispatchEvent(new AnimationEvent(AnimationEvent.VIDEO_NEWS_ANIMATION_FINISHED, AnimationType.OUT, this));
		}
		
		public function updater(e:ServerUpdateEvent):void
		{
			
			var oneVideoNewGraphic:OneVideoNewGraphic = new OneVideoNewGraphic(e.mat);
			videoNewsGraphicList = videoNewsGraphicList.reverse();
			videoNewsGraphicList.push(oneVideoNewGraphic);
			
			slider.update(oneVideoNewGraphic);
			videoNewsGraphicList = videoNewsGraphicList.reverse();
			
			if (videoAnimator && contains(videoAnimator))
				videoAnimator.freshNew();
		}
		
		override public function kill():void
		{
			stopAutoAnimation();
			TweenLite.killDelayedCallsTo(startAutoAnimation);
			super.kill();
		}	
	}
}
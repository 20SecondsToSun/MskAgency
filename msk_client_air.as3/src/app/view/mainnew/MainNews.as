package app.view.mainnew
{
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.ServerUpdateEvent;
	import app.model.materials.GeoPoint;
	import app.model.materials.Material;
	import app.model.types.AnimationType;
	import app.view.baseview.MainScreenView;
	import app.view.mainnew.types.BroadcastingNews;
	import app.view.mainnew.types.MainType;
	import app.view.mainnew.types.MapNews;
	import app.view.mainnew.types.PhotoNews;
	import app.view.mainnew.types.TextNews;
	import app.view.mainnew.types.VideoNews;
	import app.view.utils.Tool;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
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
	public class MainNews extends MainScreenView
	{
		private static const WIDTH:int = 690;
		private static const HEIGHT:int = 500;
		static public const ANIMATION_DELAY_TIME:int = 15;
		
		private var splash:Shape;
		private var matlist:Vector.<Material>;
		private var index:int = 0;
		private var currentSlide:MainType;
		private var prevSlide:Sprite;
		private var isFresh:Boolean = false;
		private var isAnimate:Boolean = false;
		private var freshUpdating:Boolean = false;		
		
		public function MainNews()
		{
			waitTimeToAnimt = 1;
			visible = false;
			x = 410;
			
			splash = Tool.createShape(WIDTH, HEIGHT, 0xf4f4f4);
			addChild(splash);
			
			currentSlide = new MainType();
			prevSlide = new Sprite();
			addChild(prevSlide);
				
			var __mask:Shape = Tool.createShape(WIDTH, HEIGHT, 0xf4f4f4);
			addChild(__mask);
			this.mask = __mask;	
		}
		
		override public function setScreen():void
		{
			prevSlide = config.getScreenShot("MAIN_NEWS");	
			prevSlide.visible = true;
			addChild(prevSlide);
			prevSlide.x = 0;
			prevSlide.y = 0;
			visible = true;			
		}
		
		public function refreshData(list:Vector.<Material>):void
		{
			if (isListNull(list))
				return;
		
			index = 0;			
			matlist = list;			
			firstShow();			
			waitToAnim();
		}
		
		private function firstShow():void
		{
			freshUpdating = true;	
			TweenLite.killDelayedCallsTo(changeSlide);
			prevSlide.visible = false;			
			Tool.changecolor(splash, 0x1a1b1f);
			
			index = 0;
			var mat:Material = matlist[index];
			setSlide(mat.type, mat.point);
			currentSlide.show(mat);			
			
			currentSlide.x = 0;
			currentSlide.y = 0;
			currentSlide.visible = false;
			
			var anim:Sprite = new Sprite();
			addChild(anim);			
			
			var bitmapData:BitmapData = new BitmapData(WIDTH, HEIGHT);
			bitmapData.drawWithQuality(currentSlide, null, null, null, null, true, StageQuality.BEST);			
			var cur:Bitmap = new Bitmap(bitmapData);	
			
			bitmapData = new BitmapData(WIDTH, HEIGHT);
			bitmapData.draw(prevSlide);
			var prev:Bitmap = new Bitmap(bitmapData);		
			
			var pp:PerspectiveProjection = new PerspectiveProjection();
			pp.projectionCenter = new Point(WIDTH * 0.5, HEIGHT * 0.5);
			transform.perspectiveProjection = pp;
	
			anim.addChild(cur);
			anim.addChild(prev);
			
			//cur.rotationX = -90;
			//cur.z = HEIGHT;
			cur.x = WIDTH;
			var swap:Boolean = false;
			
			TweenLite.to(cur, 1, { x: 0 , ease: Quart.easeInOut} );
			TweenLite.to(prev, 1, { x: -prev.width , ease: Quart.easeInOut, onComplete:function ():void 
			{				
				currentSlide.visible = true;
				bitmapData.dispose();
				anim.removeChild(cur);
				anim.removeChild(prev);
				removeChild(anim);	
				restartSlider();				
			}} );
		}		
		
		override protected function startAutoAnimation():void
		{
			if (isListNull(matlist))
				return;
			if (matlist.length < 2 || !isAllowAnimation)
				return;
			
			startMainNewsAutoAnimation();
		}
		
		private function startMainNewsAutoAnimation():void
		{
			isAutoAnimation = true;
			if (!isAnimate)
			{
				TweenLite.killDelayedCallsTo(changeSlide);
				TweenLite.delayedCall(ANIMATION_DELAY_TIME, changeSlide);
			}
		}
		
		override public function stopAutoAnimation():void
		{
			isAutoAnimation = false;
			TweenLite.killDelayedCallsTo(changeSlide);
			
			if (currentSlide)
				currentSlide.stop();
		}
		
		private function changeSlide():void
		{
			index = nextIndex();
			showBlock();
		}
		
		private function showBlock():void
		{
			var mat:Material = matlist[index];
			
			if (prevSlide.numChildren != 0)
			{
				prevSlide.visible = true;
				prevSlide.x = 0;
				TweenLite.to(prevSlide, 0.8, {x: -WIDTH, ease: Cubic.easeInOut});
			}
			
			setSlide(mat.type, mat.point);
			currentSlide.show(mat);
			isAnimate = true;
			
			TweenLite.to(currentSlide, 0.8, {x: 0, ease: Cubic.easeInOut, onComplete: function():void
				{
					clearPrevSlider();
					fillPrevSlider();
					
					isAnimate = false;
					if (isFresh)
					{
						flipNew();
						return;
					}
					if (isAutoAnimation)
					{
						TweenLite.killDelayedCallsTo(changeSlide);
						TweenLite.delayedCall(ANIMATION_DELAY_TIME, changeSlide);
					}
				}});
		}
		
		public function setSlide(type:String, geo:GeoPoint):void
		{
			if (contains(currentSlide))
				removeChild(currentSlide);			
			
			if (geo == null)
				switch (type)
				{
					case "text": 
						currentSlide = new TextNews();
						break;
					
					case "photo": 
						currentSlide = new PhotoNews();
						break;
					
					case "video": 
						currentSlide = new VideoNews();
						break;
					
					case "broadcast": 
						currentSlide = new BroadcastingNews();
						break;
					
					default: 
				}
			else 
				currentSlide = new MapNews();
			
			addChild(currentSlide);
			currentSlide.x = WIDTH;
		}
		
		private function nextIndex():int
		{
			return (index + 1) % matlist.length;
		}
		
		public function overState(e:InteractiveEvent):void
		{
			if (!currentSlide)
				return;
			currentSlide.over();
		}
		
		public function outState(e:InteractiveEvent):void
		{
			if (!currentSlide)
				return;
			currentSlide.out();
		}
		
		public function toMainScreen():void
		{
			visible = true;
			animateToXY(this.x, 0, anim.MainScreen1.animInSpeed, anim.MainScreen1.animInEase);
		}
		
		public function show():void
		{
			visible = true;
			y = 0;
			dispatchEvent(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_MAIN_NEWS));
		}
		
		override public function animationInFinished():void
		{
			dispatchEvent(new AnimationEvent(AnimationEvent.MAIN_NEWS_ANIMATION_FINISHED, AnimationType.IN, this));
			dispatchEvent(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_MAIN_NEWS));
		}
		
		override public function animationOutFinished():void
		{
			dispatchEvent(new AnimationEvent(AnimationEvent.MAIN_NEWS_ANIMATION_FINISHED, AnimationType.OUT, this));
		}
		
		override public function kill():void
		{
			TweenLite.killDelayedCallsTo(changeSlide);
			TweenLite.killTweensOf(currentSlide);
			TweenLite.killTweensOf(prevSlide);
			currentSlide.kill();
			
			super.kill();
		}
		
		public function updater(e:ServerUpdateEvent):void
		{
			if (e.mat == null)
				return;
			
			matlist.pop();
			matlist = matlist.reverse();
			matlist.push(e.mat);
			matlist = matlist.reverse();
			
			isFresh = true;
			
			if (freshUpdating)
				return;
			
			if (!isAnimate)
				flipNew();
		}
		
		private function flipNew():void
		{
			firstShow();
			return;
			freshUpdating = true;
			TweenLite.killDelayedCallsTo(changeSlide);
			
			var pp:PerspectiveProjection = new PerspectiveProjection();
			pp.projectionCenter = new Point(WIDTH * 0.5, HEIGHT * 0.5);
			transform.perspectiveProjection = pp;
			
			Tool.changecolor(splash, 0xD6D7DC);
			
			var angle:Number = 90;
			
			prevSlide.visible = true;
			prevSlide.x = 0;
			prevSlide.z = 0;
			
			index = 0;
			var mat:Material = matlist[index];
			setSlide(mat.type, mat.point);
			currentSlide.show(mat);
			
			currentSlide.z = 500 * (Math.sin(angle * Math.PI / 180));
			currentSlide.y = -HEIGHT;
			currentSlide.rotationX = -angle;
			currentSlide.x = 0;
			
			TweenLite.to(currentSlide, 1.2, {x: 0, rotationX: 0, y: 0, z: 0, ease: Expo.easeInOut});
			TweenLite.to(prevSlide, 1.2, {y: HEIGHT, rotationX: angle, z: 500 * (Math.sin(angle * Math.PI / 180)), ease: Expo.easeInOut, onComplete: restartSlider});		
		}
		
		private function restartSlider():void
		{
			Tool.changecolor(splash, 0xf4f4f4);
			
			prevSlide.visible = false;
			prevSlide.x = 0;
			prevSlide.y = 0;
			prevSlide.z = 0;
			prevSlide.rotationX = 0;
			
			currentSlide.x = 0;
			currentSlide.y = 0;
			currentSlide.z = 0;
			currentSlide.rotationX = 0;
			
			isFresh = false;
			
			clearPrevSlider();
			fillPrevSlider();
			
			if (isAutoAnimation)
			{
				TweenLite.killDelayedCallsTo(changeSlide);
				TweenLite.delayedCall(ANIMATION_DELAY_TIME, changeSlide);
			}
			freshUpdating = false;
		}
		
		public  function setScreenShot():void
		{
			var bitmapData:BitmapData = new BitmapData(WIDTH, HEIGHT);
			bitmapData.drawWithQuality(currentSlide, null, null, null, null, true, StageQuality.BEST);			
			
			config.setScreenShot(new Bitmap(bitmapData), "MAIN_NEWS");
		}
		
		private function clearPrevSlider():void
		{
			if (prevSlide.numChildren)
			{
				(prevSlide.getChildAt(0) as Bitmap).bitmapData.dispose();
				prevSlide.removeChildAt(0);
			}
		}
		
		private function fillPrevSlider():void
		{
			var screenshotBD:BitmapData = new BitmapData(WIDTH, HEIGHT);
			screenshotBD.draw(currentSlide);
			prevSlide.visible = false;
			prevSlide.addChild(new Bitmap(screenshotBD));
		}	
	}
}
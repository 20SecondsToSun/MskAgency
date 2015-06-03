package app.view.videonews
{
	import app.model.materials.MaterialFile;
	import app.view.utils.BigCanvas;
	import app.view.utils.Tool;
	import app.view.utils.video.VideoPlayer;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Quart;
	import com.greensock.layout.ScaleMode;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.geom.Matrix;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author ...
	 */
	public class VideoAnimator extends Sprite
	{
		public var screenField:Rectangle = new Rectangle(0, 0, 410, 500);
		private var screenshot:Sprite;
		private var newsHolder:Sprite;
		
		private var list:Vector.<OneVideoNewGraphic>;
		
		private var index:int = 1;
		private var len:int = 1;
		
		private var splash:Shape;
		private var screenTemp:BitmapData;
		
		private var screen1:Bitmap;
		private var screen2:Bitmap;
		
		private static const _width:int = 410;
		private static const _height:int = 500;
		private static const shiftY:int = 297;
		private static const _videoHheight:int = 297;
		
		static public const VIDEO_PLAYING_TIME:int = 15;
		static public const ANIMATION_DELAY_TIME:int = 2;
		
		private var mat:Matrix = new Matrix(1, 0, 0, 1, 0, -shiftY - 1);
		private var adapter:VideoPlayer;
		private var videomask:Shape;
		
		private var isAnimate:Boolean = false;
		private var isFresh:Boolean = false;
		
		private var freshUpdating:Boolean = false;
		
		public function VideoAnimator(_list:Vector.<OneVideoNewGraphic>)
		{
			trace("CREATE VIDEO ANIMATOR");
			list = _list; // .reverse();
			len = list.length;
			
			splash = Tool.createShape(_width, _height, 0xffffff);
			addChild(splash);
			
			newsHolder = new Sprite();
			addChild(newsHolder);
			
			screenshot = new Sprite();
			addChild(screenshot);
			
			newsHolder.visible = false;
			screenshot.visible = false;
			splash.visible = false;
			
			newsHolder.addChild(prepareOneNew(list[index]));
			
			var layerMask:Shape = Tool.createShape(_width, _height, 0x000000);
			addChild(layerMask);
			mask = layerMask;		
		}
		
		public function kill():void
		{
			if (newsHolder && contains(newsHolder))
				removeChild(newsHolder);
			
			if (screenshot && contains(screenshot))
				removeChild(screenshot);
			
			if (screen1 && contains(screen1))
				removeChild(screen1);
			if (screen2 && contains(screen2))
				removeChild(screen2);
			
			if (videomask && contains(videomask))
				removeChild(videomask);
			
			removeAdapter();
			
			TweenLite.killDelayedCallsTo(change);
			TweenLite.killDelayedCallsTo(waitVideoPlay);
			
			TweenLite.killTweensOf(screenshot);	
			TweenLite.killTweensOf(newsHolder);
			TweenLite.killTweensOf(screen1);
			TweenLite.killTweensOf(screen2);			
		}
		
		private function prepareOneNew(vid:OneVideoNewGraphic):Bitmap
		{
			screenTemp = new BitmapData(vid.width, 500);
			screenTemp.draw(vid);
			
			var bmp:Bitmap = new Bitmap(screenTemp);
			bmp.smoothing = true;
			
			return bmp;
		}
		
		public function init(shot:BigCanvas):void
		{			
			screenTemp = new BitmapData(shot.width, shot.height);
			screenTemp.draw(shot);
			
			screenshot.addChild(new Bitmap(screenTemp));
			
			screenshot.visible = true;
			newsHolder.visible = true;
			splash.visible = true;
			start();
		}
		
		private function start():void
		{
			TweenLite.delayedCall(ANIMATION_DELAY_TIME, change);
		}
	
		private function change():void
		{
			var bd1:BitmapData = new BitmapData(_width, shiftY);
			bd1.draw(screenshot);
			
			var bd2:BitmapData  = new BitmapData(_width, _height - shiftY);
			bd2.draw(screenshot, mat);
			
			screen1 = new Bitmap(bd1);
			screen1.smoothing = true;
			screen1.y = 0;
			addChild(screen1);
			
			screen2 = new Bitmap(bd2);
			screen2.smoothing = true;
			screen2.y = shiftY;
			
			addChild(screen2);
			
			(screenshot.getChildAt(0) as Bitmap).bitmapData.dispose();
			screenshot.removeChildAt(0);
			
			var _scale:Number = 0.8;
			
			newsHolder.scaleX = newsHolder.scaleY = _scale;
			newsHolder.x = (_width - newsHolder.width) * 0.5;
			newsHolder.y = (_height - newsHolder.height) * 0.5;
			
			isAnimate = true;
			
			TweenLite.to(newsHolder, 1.2, {y: 0, x: 0, scaleX: 1, scaleY: 1, ease: Expo.easeInOut}); //, onComplete:refresh } );
			TweenLite.to(screen1, 1.2, {y: -screen1.height, ease: Expo.easeInOut}); //, onComplete:refresh } );
			TweenLite.to(screen2, 1.2, {y: _height, ease: Expo.easeInOut, onComplete: refresh});
		}
		
		private function refresh():void
		{
			if (!list || list.length == 0) return;
			isAnimate = false;
			
			if (screen1 && contains(screen1))
			{
				screen1.bitmapData.dispose();
				removeChild(screen1);
			}
			
			if (screen2 && contains(screen2))
			{
				screen2.bitmapData.dispose();
				removeChild(screen2);
			}
			
			if (isFresh)
			{
				screenshot.addChild(prepareOneNew(list[nextIndex()]));
				screenshot.y = 0;
				flipNew();
				return;
			}
			
			playVideo();
			
			screenshot.addChild(prepareOneNew(list[index]));
			screenshot.y = 0;
			screenshot.x = 0;
			
			index = nextIndex();
			(newsHolder.getChildAt(0) as Bitmap).bitmapData.dispose();
			newsHolder.removeChildAt(0);
			newsHolder.addChild(prepareOneNew(list[index]));
		}
		
		public function freshNew():void
		{
			if (freshUpdating) return;
			
			isFresh = true;
			if (!isAnimate)	flipNew();
		}
		
		private function flipNew():void
		{
			if (!list || list.length == 0) return;
			
			freshUpdating = true;
			isFresh = false;
			removeAdapter();
			
			TweenLite.killDelayedCallsTo(change);
			TweenLite.killDelayedCallsTo(waitVideoPlay);
			
			index = 0;
			(newsHolder.getChildAt(0) as Bitmap).bitmapData.dispose();
			newsHolder.removeChildAt(0);
			newsHolder.addChild(prepareOneNew(list[index]));
			newsHolder.visible = false;
			var pp:PerspectiveProjection = new PerspectiveProjection();
			pp.projectionCenter = new Point(205, 250);
			transform.perspectiveProjection = pp;
			
			
			var anim:Sprite = new Sprite();
			addChild(anim);			
			
			var bitmapData:BitmapData = new BitmapData(_width, _height);
			bitmapData.drawWithQuality(newsHolder, null, null, null, null, true, StageQuality.BEST);			
			var cur:Bitmap = new Bitmap(bitmapData);	
			newsHolder.visible = false;		
			
			bitmapData = new BitmapData(_width, _height);
			bitmapData.draw(screenshot);
			var prev:Bitmap = new Bitmap(bitmapData);			
			screenshot.visible = false;
			anim.addChild(cur);
			anim.addChild(prev);
			
			cur.rotationY = 90;
			cur.z = _width;
			var swap:Boolean = false;
			
			Tool.changecolor(splash, 0x1a1b1f);
			
			TweenLite.to(anim, 1, { scaleX:1, ease: Quart.easeInOut, scaleY:1, rotationY: -90,  onComplete:function ():void 
			{				
				newsHolder.visible = true;
				screenshot.visible = true;
				bitmapData.dispose();
				anim.removeChild(cur);
				anim.removeChild(prev);
				removeChild(anim);	
				freshUpdating = false;
				showingNewVideo();
				//restartSlider();				
			},x:_width, onUpdate:function ():void 			
			{				
				if (anim.rotationY < -80 && swap == false)				
				{
					swap = true;
					anim.swapChildren(cur, prev);
					swapChildren(screenshot, newsHolder);
				}				
			} } );
			
			TweenLite.to(prev, 0.8, { delay:0.2, colorTransform: { tint:0x000000, tintAmount:0.5 }} );		
			
		}		
		
		private function removeAdapter():void
		{
			if (adapter && contains(adapter))
				removeChild(adapter);
		}
		
		private function showingNewVideo():void
		{
			if (!list || list.length == 0) return;
			
			Tool.changecolor(splash, 0xffffff);
			playVideo();
			swapChildren(screenshot, newsHolder);
			
			screenshot.y = screenshot.x = screenshot.z = 0;			
			newsHolder.y = newsHolder.x = newsHolder.z = 0;
			
			screenshot.rotationY = 0;
			newsHolder.rotationY = 0;
			
			(screenshot.getChildAt(0) as Bitmap).bitmapData.dispose();
			screenshot.removeChildAt(0);
			screenshot.addChild(prepareOneNew(list[index]));
			
			index = nextIndex();
			(newsHolder.getChildAt(0) as Bitmap).bitmapData.dispose();
			newsHolder.removeChildAt(0);
			newsHolder.addChild(prepareOneNew(list[index]));
			
			freshUpdating = false;
		}
		
		private function playVideo():void
		{
			adapter = new VideoPlayer(_width, _videoHheight, ScaleMode.STRETCH);
			adapter.control = false;
			
			addChild(adapter);
			
			videomask = Tool.createShape(_width, _videoHheight, 0x000000);
			addChild(videomask);
			
			adapter.mask = videomask;
			
			var matFile:MaterialFile = list[index].mat.files[0];
			adapter.duration = Number(matFile.duration);
			adapter.init(matFile.pathToSource, videoBegin);
			adapter.mute();
		}
		
		private function videoBegin():void
		{
			adapter.x = 0.5 * (_width - adapter.sizeX);
			TweenLite.delayedCall(VIDEO_PLAYING_TIME, waitVideoPlay);
		}
		
		private function waitVideoPlay():void
		{
			removeAdapter();
			
			if (videomask && contains(videomask))
				removeChild(videomask);
			
			start();
		}
		
		private function nextIndex():int
		{
			return (index + 1) % len;
		}
		
		private function prevIndex():int
		{
			return (index - 1) < 0 ? len - 1 : index - 1;
		}
	}
}
package app.view.utils.video
{
	import app.assets.Assets;
	import app.view.baseview.io.InteractiveButton;
	import app.view.baseview.io.InteractiveObject;
	import app.view.page.oneNews.Buttons.FullscreenButtonBig;
	import app.view.utils.ResizeUtil;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import app.view.utils.video.events.VideoEvent;
	import com.greensock.layout.ScaleMode;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author ypopov
	 */
	public class VideoPlayer extends InteractiveObject
	{
		public var va:VideoAdapt;
		private var video:Video;
		
		public var sizeX:Number = 1000;
		public var sizeY:Number = 1000;
		
		public var path:String;
		
		private var pauseBtn:Sprite;
		private var playBtn:Sprite;
		private var container:Sprite;
		private var fonSlider:Shape;
		private var vpFon:Shape;
		
		private var redSlider:Sprite;
		private var overControl:Sprite;
		private var tintFon:Shape;
		private var lineConrol:Shape;
		
		private var curTimeFormat:TextFormat = new TextFormat("TornadoL", 48, 0x02a7df);
		private var curTimeText:TextField;
		
		private var allTimeFormat:TextFormat = new TextFormat("TornadoMedium", 16, 0x8ca8c0);
		private var allTimeText:TextField;
		
		public var duration:Number;
		
		private var secToPlay:Number = -4;
		private var secOffset:Number = 0;
		
		private var minSeekInterval:Number = 200;
		private var previousSeekEvent:Number = 0;
		
		private var isLoadingFirst:Boolean = true;
		private var isInit:Boolean = false;
		public var fullscreenBtn:FullscreenButtonBig;
		public var overButton:InteractiveButton;
		
		public var _control:Boolean = true;
		private var scaleMode:String = ScaleMode.NONE;
		
		public var id:String = '';
		
		private var repeatSplash:Sprite;
		private var repeatSplashShape:Shape;
		private var repeatVideo:Sprite;
		public var videoFinish:Boolean = false;
		private var repeatTxt:TextField;
		
		private var fullScreenMode:Boolean = false;
		public var startVideoCallback:Function = null;
		
		public function set control(value:Boolean):void
		{
			_control = overButton.visible = overControl.visible = redSlider.visible = lineConrol.visible = tintFon.visible = value;
			playBtn.visible = value;
			pauseBtn.visible = value;
		}
		
		public function VideoPlayer(_w:Number, _h:Number, _scaleMode:String = ScaleMode.NONE)
		{
			scaleMode = _scaleMode;
			
			sizeX = _w;
			sizeY = _h;
			
			container = new Sprite();
			addChild(container);
			
			fonSlider = Tool.createShape(sizeX, 7, 0x1a1b1f);
			fonSlider.visible = false;
			addChild(fonSlider);
			
			var fonRedSlider:Shape = Tool.createShape(sizeX, 7, 0xaa0000);
			addChild(fonRedSlider);
			
			redSlider = new Sprite();
			redSlider.addChild(fonRedSlider);
			
			addChild(redSlider);
			redSlider.visible = false;
			
			tintFon = Tool.createShape(sizeX, sizeY, 0x1a1b1f);
			tintFon.alpha = 0;
			addChild(tintFon);
			
			overControl = new Sprite();
			overControl.alpha = 0;
			addChild(overControl);
			
			repeatSplash = new Sprite();
			repeatSplashShape = Tool.createShape(1000, 565, 0x000000);
			repeatSplashShape.alpha = 0.8;
			repeatSplash.addChild(repeatSplashShape);
			addChild(repeatSplash);
			repeatSplash.visible = false;
			videoFinish = false;
			
			repeatVideo = Assets.create("repeatVideo");
			repeatVideo.x = 0.5 * (repeatSplashShape.width - repeatVideo.width);
			repeatVideo.y = 0.5 * (repeatSplashShape.height - repeatVideo.height);
			repeatSplash.addChild(repeatVideo);
			
			var _text:String = "ПОСМОТРЕТЬ\nЕЩЕ РАЗ";
			var textFormat1:TextFormat = new TextFormat("Tornado", 18, 0x02a7df);
			textFormat1.align = TextFormatAlign.CENTER;
			repeatTxt = TextUtil.createTextField(0, 0);
			repeatTxt.text = _text;
			repeatTxt.setTextFormat(textFormat1);
			repeatTxt.x = 0.5 * (repeatSplash.width - repeatTxt.width);
			
			repeatTxt.y = repeatVideo.y + repeatVideo.height + 33;
			repeatSplash.addChild(repeatTxt);
			
			lineConrol = new Shape();
			lineConrol.graphics.lineStyle(2, 0xffffff, .75);
			lineConrol.graphics.moveTo(0, 0);
			lineConrol.graphics.lineTo(0, sizeY);
			overControl.addChild(lineConrol);
			
			curTimeText = TextUtil.createTextField(lineConrol.x + 20, 50);
			curTimeText.multiline = false;
			curTimeText.wordWrap = false;
			curTimeText.text = "00:00";
			curTimeText.setTextFormat(curTimeFormat);
			overControl.addChild(curTimeText);
			
			allTimeText = TextUtil.createTextField(lineConrol.x + 20, curTimeText.y + curTimeText.height - 7);
			allTimeText.multiline = false;
			allTimeText.wordWrap = false;
			allTimeText.text = "00:00";
			allTimeText.setTextFormat(allTimeFormat);
			overControl.addChild(allTimeText);
			
			pauseBtn = Assets.create("pauseBtn");
			//pauseBtn.visible = false;
			overControl.addChild(pauseBtn);
			
			playBtn = Assets.create("playBtn");
			playBtn.visible = false;
			overControl.addChild(playBtn);
			
			vpFon = Tool.createShape(100, 100, 0x000000);
			vpFon.visible = false;
			container.addChild(vpFon);
			
			fullscreenBtn = new FullscreenButtonBig();
			fullscreenBtn.visible = false;
			
			var btnFon:Shape = Tool.createShape(sizeX, sizeY, 0x1a1b1f);
			btnFon.alpha = 0;
			overButton = new InteractiveButton();
			addChild(overButton);
			overButton.addChild(btnFon);
			addChild(fullscreenBtn);
			
			addEventListener(Event.REMOVED_FROM_STAGE, removeAll);
		}
		
		private function removeAll(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removeAll);
			removeEventListener(Event.ENTER_FRAME, loop);
			
			if (va)
			{
				va.removeEventListener(Event.COMPLETE, loadCompleteListener);
				va.removeEventListener(AdaptVideoEvent.VIDEO_COMPLETE, videoCompleteListener);
				va.removeEventListener(AdaptVideoEvent.METADATA, metaReceive);
				va.kill();
			}
		}
		
		public function init(path:String, _startVideoCallback:Function = null):void
		{
			startVideoCallback = _startVideoCallback;
			
			va = new VideoAdapt();
			va.init(path);
			va.addEventListener(Event.COMPLETE, loadCompleteListener);
			va.addEventListener(AdaptVideoEvent.VIDEO_COMPLETE, videoCompleteListener);
			va.addEventListener(AdaptVideoEvent.METADATA, metaReceive);
			va.play();
		}
		
		public function mute():void
		{
			if (va) va.mute();
		}
		
		public function initBroadcast(path:String):void
		{
			va = new VideoAdapt();
			va.initBroadcast(path);
			///va.addEventListener(Event.COMPLETE, loadCompleteListener);
			///va.addEventListener(ProgressEvent.PROGRESS, progressListener);
			//va.addEventListener(AdaptVideoEvent.VIDEO_COMPLETE, videoCompleteListener);
			va.addEventListener(AdaptVideoEvent.METADATA, metaReceive);
		}
		
		private function metaReceive(e:AdaptVideoEvent):void
		{
			if (isLoadingFirst)
			{
				duration = va.info.duration;
				isLoadingFirst = false;
				this.alpha = 0;
				TweenLite.to(this, 0.5, {alpha: 1});
			}
			Tool.removeAllChildren(container);
			
			var rec:Rectangle;
			
			if (scaleMode == ScaleMode.STRETCH)
			{
				rec = ResizeUtil.getStretch(va.info.width, va.info.height, sizeX, sizeY);
				sizeX = rec.width;
				sizeY = rec.height;
			}
			else
				sizeY = Math.floor(sizeX * va.info.height / va.info.width);
			
			if (sizeY > 565)
			{
				sizeY = 565;
				sizeX = Math.floor(sizeY * va.info.width / va.info.height);
			}
			
			video = new Video(sizeX, sizeY);
			video.deblocking = 2;
			video.attachNetStream(va.stream);
			
			var splash:Shape = Tool.createShape(1000, 565, 0xffffff);
			
			if (rec)
			{
				video.x = rec.x;
				video.y = rec.y;
			}
			
			vpFon.width = sizeX;
			vpFon.height = sizeY;
			vpFon.visible = true;
			repeatSplashShape.width = sizeX;
			repeatSplashShape.height = sizeY;
			overButton.width = sizeX;
			overButton.height = sizeY;
			
			container.addChild(vpFon);
			container.addChild(video);
			
			vpFon.width = sizeX;
			vpFon.height = sizeY;
			repeatSplashShape.width = sizeX;
			repeatSplashShape.height = sizeY;
			overButton.width = sizeX;
			overButton.height = sizeY;
			
			if (video.width <= 1000) video.x = 0.5 * (vpFon.width - video.width);
			
			isInit = true;
			
			dispatchEvent(new VideoEvent(VideoEvent.CHANGED_SIZE, false, false, sizeY, id));
			
			if (startVideoCallback != null)
				startVideoCallback();
			
			if (!_control) return;
			
			lineConrol.visible = true;
			curTimeText.visible = true;
			allTimeText.visible = true;
			fullscreenBtn.y = sizeY - fullscreenBtn.height - 7;
			pauseBtn.x = 33;
			pauseBtn.y = sizeY - 33 - pauseBtn.height;
			playBtn.x = 33;
			playBtn.y = sizeY - 33 - playBtn.height;
			fonSlider.y = sizeY - fonSlider.height;
			redSlider.y = sizeY - redSlider.height;
			lineConrol.height = tintFon.height = sizeY;
			redSlider.width = 0;
			fonSlider.visible = true;
			redSlider.visible = true;
			addEventListener(Event.ENTER_FRAME, loop);
			isInit = true;
		}
		
		public function fullscreenMode(mode:String):void
		{
			if (mode == "ON")
			{
				fullscreenBtn.alpha = 0;
				fullscreenBtn.visible = true;
				fullScreenMode = true;
				repeatTxt.visible = false;
			}
			else if (mode == "OFF")
			{
				fullscreenBtn.visible = false;
				fullScreenMode = false;
				repeatTxt.visible = true;
			}
		}
		
		private function videoCompleteListener(e:AdaptVideoEvent):void
		{
			lineConrol.visible = false;
			curTimeText.visible = false;
			allTimeText.visible = false;
			removeEventListener(Event.ENTER_FRAME, loop);
			repeatSplash.visible = true;
			videoFinish = true;
		}
		
		private function loadCompleteListener(e:Event):void
		{
		
		}
		
		private function loop(e:Event):void
		{
			try
			{
				var percent:Number = (secOffset + va.currentSecond()) / duration;
				var fullnessRatio:Number = percent > 1 ? 1 : percent;
				setControls(fullnessRatio);
			}
			catch (err:Error)
			{
				
			}
		}
		
		public function setControls(ratio:Number):void
		{
			redSlider.width = fonSlider.width * ratio;
			lineConrol.x = redSlider.width;
			curTimeText.x = lineConrol.x + 20;
			allTimeText.x = lineConrol.x + 20;
			
			curTimeText.autoSize = TextFieldAutoSize.LEFT;
			allTimeText.autoSize = TextFieldAutoSize.LEFT;
			
			if (curTimeText.x + curTimeText.width > 900)
			{
				curTimeText.x = lineConrol.x - curTimeText.width - 20;
				allTimeText.x = lineConrol.x - allTimeText.width - 20;
				curTimeText.autoSize = TextFieldAutoSize.RIGHT;
				allTimeText.autoSize = TextFieldAutoSize.RIGHT;
			}
			
			curTimeText.text = TextUtil.calculateTimeFormat(duration * ratio);
			allTimeText.text = TextUtil.calculateTimeFormat(duration);
			
			allTimeText.setTextFormat(allTimeFormat);
			curTimeText.setTextFormat(curTimeFormat);
		}
		
		public function seek(_x:Number, _y:Number):void
		{
			if (!isInit) return;
			
			removeEventListener(Event.ENTER_FRAME, loop);
			
			var _curX:Number = globalToLocal(new Point(_x, _y)).x;
			
			if (_curX < 0)
				_curX = 0;
			if (_curX > 1000)
				_curX = 1000;
			
			var percent:Number = _curX / 1000;
			var fullnessRatio:Number = percent > 1 ? 1 : percent;
			if (fullnessRatio < 0)
				fullnessRatio = 0;
			setControls(fullnessRatio);
			if (getTimer() - previousSeekEvent > minSeekInterval)
			{
				if (secToPlay != Math.floor(percent * duration))
				{
					secToPlay = Math.floor(percent * duration);
					
					secOffset = secToPlay;
					va.pause();
					
					va.play(secToPlay);
					va.pause();
					
					previousSeekEvent = getTimer();
				}
			}
		}
		
		public function pause():void
		{
			if (videoFinish) return;
			
			pauseBtn.visible = false;
			playBtn.visible = true;
			
			TweenLite.to([redSlider, fonSlider], 0.5, {alpha: 0});
			TweenLite.to(tintFon, 0.5, {alpha: 0.7});
			TweenLite.to(overControl, 0.5, {alpha: 1});
			
			va.pause();
		}
		
		public function playUP():void
		{
			playBtn.y = sizeY - 143 - playBtn.height;
			pauseBtn.y = sizeY - 143 - pauseBtn.height;
			if (playBtn.visible)
			{
				fullscreenBtn.y = sizeY - fullscreenBtn.height;
			}
			else
			{
				fullscreenBtn.y = sizeY - fullscreenBtn.height - 7;
			}
			fullscreenBtn.over();
		}
		
		public function playDOWN():void
		{
			playBtn.y = sizeY - 33 - playBtn.height;
			pauseBtn.y = sizeY - 33 - pauseBtn.height;
			fullscreenBtn.out();
		}
		
		public function playStop():void
		{
			if (videoFinish)
			{
				secToPlay = 0;
				secOffset = 0;
				resume();
				TweenLite.to([redSlider, fonSlider], 0.5, {alpha: 0});
				TweenLite.to(tintFon, 0.5, {alpha: 0.7});
				TweenLite.to(overControl, 0.5, {alpha: 1});
				return;
			}
			if (va.isPlaying())
			{
				pause();
			}
			else
			{
				pauseBtn.visible = true;
				playBtn.visible = false;
				va.resume();
			}
		}
		
		public function resume():void
		{
			va.play(secToPlay);
			va.resume();
			repeatSplash.visible = false;
			videoFinish = false;
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		public function overState():void
		{
			if (!isInit || !va.isPlaying())
				return;
			
			if (videoFinish)
			{
				TweenLite.to(tintFon, 0.5, {alpha: 0.7});
				TweenLite.to(repeatVideo, 0.5, {colorTransform: {tint: 0x02a7df, tintAmount: 1}});
				
				return;
			}
			
			TweenLite.to([redSlider, fonSlider], 0.5, {alpha: 0});
			TweenLite.to(tintFon, 0.5, {alpha: 0.7});
			TweenLite.to(overControl, 0.5, {alpha: 1});
		}
		
		public function outState():void
		{
			if (!isInit || !va.isPlaying())
				return;
			
			if (videoFinish)
			{
				TweenLite.to(repeatVideo, 0.5, {colorTransform: {tint: 0x02a7df, tintAmount: 0}});
			}
			
			TweenLite.to([tintFon, overControl], 0.5, {alpha: 0});
			TweenLite.to([redSlider, fonSlider], 0.5, {alpha: 1});
		}
	}
}
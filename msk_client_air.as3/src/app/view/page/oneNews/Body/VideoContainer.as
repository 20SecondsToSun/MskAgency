package app.view.page.oneNews.Body 
{
	import app.AppSettings;
	import app.model.materials.Material;
	import app.view.page.oneNews.Buttons.FullscreenButton;
	import app.view.utils.BigCanvas;
	import app.view.utils.Tool;
	import app.view.utils.video.VideoPlayer;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Quart;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class VideoContainer extends Sprite
	{
		private var videoContainer:Sprite;
		private var maskLayer:Shape;
		public var fullScreen:FullscreenButton;
		public var adapter:VideoPlayer;
		
		private var isFullScreenMode:Boolean = false;
		private var initVideoContainerWidth:Number;
		private var initVideoContainerHeight:Number;
		private var screenshotHolder:Sprite;
		private var screenshot:BigCanvas;
		public var id:String = "";
		
		private var point:Point = localToGlobal(new Point(0, 0));
		
		public function VideoContainer() 
		{			
			var fon:Shape = Tool.createShape(1298, 668, 0x000000);				
			
			screenshotHolder = new Sprite();
			addChild(screenshotHolder);	
			
			videoContainer = new Sprite();			
			videoContainer.y = 0;
			videoContainer.x = 206;
			addChild(videoContainer);
			
			videoContainer.addChild(fon);
			
			fullScreen = new FullscreenButton();
			fullScreen.visible = false;
			fullScreen.x = 206 + 1000 - fullScreen.width;
			fullScreen.y = 695;		
			addChild(fullScreen);
			
			maskLayer = Tool.createShape(1298, 1, 0x000000);				
			addChild(maskLayer);
			maskLayer.visible = false;
			maskLayer.height = 0;
			videoContainer.mask = maskLayer;			
		}
		
		public function animate(cur:String, last:String, mat:Material):void
		{	
			
			
			if (cur != "video" && last != "video" )
				if( cur!="broadcast"&& last!="broadcast") return;			
			
			if (cur == "text" || cur == "photo")
			{
				fullScreen.visible = false;
			}
			else if (cur == "video" || cur == "broadcast")
			{					
				fullScreen.visible = true;						
				Tool.removeAllChildren(videoContainer);
				
				//fullScreen.visible = false;
				adapter = new VideoPlayer(1000, 670);
				adapter.id = id;			
				if (cur == "video" )				
				{
					adapter.duration = Number(mat.files[0].duration);
					adapter.init(mat.files[0].pathToSource);
				}
				else  if (cur == "broadcast"  && mat.translations.length)
				{	
					adapter.initBroadcast(mat.translations[0].media_path);// mat.files[0].pathToSource);	
				}
				else if (cur == "broadcast"  && mat.files.length)
				{
					adapter.duration = Number(mat.files[0].duration);
					adapter.init(mat.files[0].pathToSource);
				}
				
				videoContainer.addChild(adapter);					
				maskLayer.visible = true;
				TweenLite.to(maskLayer, 0.7, {height: 668, ease: Quart.easeOut});				
			}	
			
			if ((last == "video" || last == "broadcast") && cur == "photo")			
			{
				Tool.removeAllChildren(videoContainer);		
				maskLayer.visible = false;
			}			
			else if ((last == "video" || last == "broadcast") && cur!="video")
			{				
				TweenLite.to(maskLayer, 0.7, {height: 0, ease: Quart.easeOut, onComplete: function():void
					{
						Tool.removeAllChildren(videoContainer);		
						maskLayer.visible = false;
					}});
			}					
		}
		
		public function fullScreenVideoON(shot:BigCanvas):void
		{
			if (videoContainer == null || videoContainer.width < 0)
			{
				shot.dispose();
				return;			
			}
			
			var scaleXScr:Number = AppSettings.WIDTH / videoContainer.width;
			var scaleYScr:Number = AppSettings.HEIGHT / videoContainer.height;
				
			point= localToGlobal(new Point(0, 0));
			screenshot = shot;
			initVideoContainerWidth = videoContainer.width;
			initVideoContainerHeight = videoContainer.height;
			screenshotHolder.addChild(screenshot);
			screenshotHolder.x = -point.x;
			fullScreen.visible = false;
			
			adapter.fullscreenMode("ON");
			
			TweenLite.to(maskLayer, 1.5, { x: -point.x, y: 0, width: AppSettings.WIDTH, height: AppSettings.HEIGHT + 2, ease: Expo.easeInOut } );
			TweenLite.to(videoContainer, 1.5, {x: -point.x, y: 0, width: AppSettings.WIDTH, height: AppSettings.HEIGHT + 2, ease: Expo.easeInOut});
			TweenLite.to(screenshotHolder, 1.5, {x: 0 - (point.x + 206) * scaleXScr - point.x, y: 0, width: screenshotHolder.width * scaleXScr, height: screenshotHolder.height * scaleYScr, ease: Expo.easeInOut});
		}
		
		public function fullScreenVideoOFF():void
		{
			adapter.fullscreenMode("OFF");
			TweenLite.to(maskLayer, 1.5, { x: 206, y: 0, width: initVideoContainerWidth, height: initVideoContainerHeight, ease: Expo.easeInOut } );
			TweenLite.to(videoContainer, 1.5, { x: 206, y: 0, width: initVideoContainerWidth, height: initVideoContainerHeight, ease: Expo.easeInOut } );
			TweenLite.to(screenshotHolder, 1.5, {x: -point.x, y: 0, scaleX: 1, scaleY: 1, ease: Expo.easeInOut, onComplete: function():void
					{						
						screenshot.dispose();
						screenshotHolder.removeChild(screenshot);	
						fullScreen.visible = true;
					}});			
		}
		public function changedControlPosition(_height:Number):void
		{			
			fullScreen.y = _height  +117 + 25;			
		}		
	}
}
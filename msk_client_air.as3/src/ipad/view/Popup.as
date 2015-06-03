package ipad.view
{
	import app.view.utils.BigCanvas;
	import com.greensock.plugins.ShortRotationPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenMax;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import ipad.assets.Assets;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ipad.controller.IpadConstants;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class Popup extends Sprite
	{		
		private var shape:Shape;
		
		private var kinectPopup:Sprite;
		private var textFormat:TextFormat = new TextFormat("TornadoL", 72*IpadConstants.contentScaleFactor, 0xffffff);		
		private var textFormat1:TextFormat = new TextFormat("Tornado", 30*IpadConstants.contentScaleFactor, 0xa4b1c0);		
	
		private var handsIpad:Sprite;
		private var handsIpad1:Sprite;
		private var screenshotBottom:BigCanvas;
		private var screenshot:BigCanvas;
		private var overlay:Shape;
		public function Popup()
		{
			TweenPlugin.activate([ShortRotationPlugin]);
			
			shape = Tool.createShape(IpadConstants.GameWidth, IpadConstants.GameHeight, 0x000000);
			addChild(shape);
			shape.visible = false;
			shape.alpha = 0;
			
			kinectPopup = new Sprite();
			addChild(kinectPopup);
			
			var shape1:Shape = Tool.createShape(IpadConstants.GameWidth, IpadConstants.GameHeight, 0x000000);
			shape1.alpha = 0.6;
			kinectPopup.addChild(shape1);
			
			var mainTitle:TextField = TextUtil.createTextField(0, 0);
			mainTitle.text = "Кто-то управляет стендом, используя жесты";
			mainTitle.setTextFormat(textFormat);
			mainTitle.y = 264 * IpadConstants.contentScaleFactor;//; 0.5 * (IpadConstants.GameHeight - mainTitle.height);
			mainTitle.x = 0.5 * (IpadConstants.GameWidth - mainTitle.width);		
			kinectPopup.addChild(mainTitle);	
			
			var mainTitle1:TextField = TextUtil.createTextField(0, 0);
			mainTitle1.text = "В момент, когда стенд управляется жестами, Вы не можете использовать iPad приложение";
			mainTitle1.setTextFormat(textFormat1);
			mainTitle1.y = 360 * IpadConstants.contentScaleFactor;//; 0.5 * (IpadConstants.GameHeight - mainTitle.height);
			mainTitle1.x = 0.5 * (IpadConstants.GameWidth - mainTitle1.width);		
			kinectPopup.addChild(mainTitle1);	
			
			handsIpad1 = Assets.create("handsIpad");	
			handsIpad = new Sprite();
			handsIpad.addChild(handsIpad1);
			handsIpad1.x = -0.5 * handsIpad1.width;
			
			kinectPopup.addChild(handsIpad);
			handsIpad.scaleX = handsIpad.scaleY = IpadConstants.contentScaleFactor;
			handsIpad.x = 0.5 * IpadConstants.GameWidth;// - handsIpad.width);		
			handsIpad.y = 668 * IpadConstants.contentScaleFactor;
			
			
			
			//addEventListener(Event.ENTER_FRAME, animateHands);
			//addLayerOverlay();
			
			kinectPopup.visible = false;
		}
		
		private function animateHands():void 
		{
			left();			
		}
		
		private function left():void 
		{
			TweenMax.to(handsIpad,  0.7, {shortRotation:{rotation:10}, x: 0.5 * IpadConstants.GameWidth+ 150, onComplete:right});
		}
		
		private function right():void 
		{
			TweenMax.to(handsIpad,  0.7, {shortRotation:{rotation:-10}, x: 0.5 * IpadConstants.GameWidth- 150, onComplete:left});
		}
		
		
		
		public function addLayerOverlay():void
		{
			overlay = Tool.createShape(IpadConstants.GameWidth, IpadConstants.GameHeight, 0x465568);
			overlay.alpha = 0.68;
			overlay.name = "overlay";
			//overlay.visible = false;
			
			addChildAt(overlay, 1);
			//trace("addLayerOverlay!!!!!!!!!");
		}
		public function makeScreenshotBottom(shot:BigCanvas):void
		{
			screenshotBottom = new BigCanvas( IpadConstants.GameWidth, IpadConstants.GameHeight);			
			screenshotBottom.draw(shot);
			//trace("makeScreenshotBottom!!!!!!!!!");
		}
		public function makeScreenshotBlur(shot:DisplayObject):void
		{
			var jpgSource:BitmapData = new BitmapData( IpadConstants.GameWidth, IpadConstants.GameHeight);	
			
			jpgSource.draw(shot);
			
			var BLUR_FILTER:BlurFilter = new BlurFilter(36, 36, 4);
			jpgSource.applyFilter(jpgSource, jpgSource.rect, new Point, BLUR_FILTER);
			
			screenshot = new BigCanvas(IpadConstants.GameWidth, IpadConstants.GameHeight);
			screenshot.draw(jpgSource);	
			//trace("makeScreenshotBlur!!!!!!!!!");
		}
		
		
		public function hideBlockPopup():void 
		{
			TweenLite.to(shape, 0.6, { alpha:0, onComplete:function ():void 
			{
				shape.visible  = false;				
			}} );
			trace("hideBlockPopup!!!!!!!!!");
		}
		
		public function showBlockPopup(view:DisplayObject = null):void 
		{	
			visible  = true;
			shape.visible  = true;
			TweenLite.to(shape, 0.6, { alpha:0.6 } );
			trace("showBlockPopup!!!!!!!!!");
		}		
		
		public function showKinectPopup():void 
		{
			visible  = true;
			trace("showKinectPopup!!!!!!!!!");
			shape.visible = false;			
			makeScreenshotBlur(parent);
			addLayerOverlay();
			addChildAt(screenshot, 0);
			screenshot.name = "screenshot";
			kinectPopup.visible = true;	
			handsIpad.x = 0.5 * IpadConstants.GameWidth;
			handsIpad.y = 668 * IpadConstants.contentScaleFactor;
			handsIpad.rotation = 0;
			animateHands();
		}
		
		public function hideKinectPopup():void 
		{
			kinectPopup.visible = false;
			shape.visible = false;
			visible  = false;
			trace("KILL OVERLAY!!!!!!!!!");
			/*if (overlay && contains(overlay))			
			{
				removeChild(overlay);
				//removeChildAt(1);
				//trace("DONE!!!!!!!!");
			}
			if (screenshot && contains(screenshot)) removeChild(screenshot);*/
			
			removeChild(getChildByName("screenshot"));
			removeChild(getChildByName("overlay"));
			//if (screenshotBottom && contains(screenshotBottom)) removeChild(screenshotBottom);
			TweenMax.killTweensOf(handsIpad);
			//visible = false;
		}		
	}
}
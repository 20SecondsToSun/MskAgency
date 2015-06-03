package ipad.view.locations.news 
{
	import app.view.utils.BigCanvas;
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ipad.controller.IpadConstants;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FilterPopup extends Sprite 
	{
		public var button:Sprite;
		protected var screenshot:BigCanvas;
		public var callbackStageText:Function;
		public var popup:Sprite;
		public var popupfon:Shape;
		public var popupMask:Shape;
		public var popupTelo:Shape;
		
		public var isAnimate:Boolean = false;
		public var textFormat:TextFormat = new TextFormat("TornadoL", 54 * IpadConstants.contentScaleFactor, 0xffffff);
		
		protected var pFon:Sprite;
		protected var img:Sprite;
		protected var txt:TextField;		
		protected var popupHeader:Shape;	
		
		
		public function makeScreenshotBlur(shot:BigCanvas):void
		{
			var jpgSource:BitmapData = new BitmapData(shot.width, IpadConstants.GameHeight);			
			jpgSource.draw(shot);
			
			var BLUR_FILTER:BlurFilter = new BlurFilter(36, 36, 4);
			jpgSource.applyFilter(jpgSource, jpgSource.rect, new Point, BLUR_FILTER);
			
			screenshot = new BigCanvas(shot.width, IpadConstants.GameHeight);
			screenshot.draw(jpgSource);	
			
			if (popup.contains(screenshot)) popup.removeChild(screenshot);
			screenshot.x = popupTelo.x;
			popup.addChildAt(screenshot,0);
		}
		
		protected function close():void
		{
			TweenLite.to(popupfon, 0.5, {alpha: 0, ease: Expo.easeInOut});
			TweenLite.to(popupMask, 0.5, {height: 1, y: button.y + button.height*0.5, ease: Expo.easeInOut, onComplete: function():void
			{
				popup.visible = false;
				popupfon.visible = false;
				callbackStageText("on");
				isAnimate = false;
			}});
		}
		
	}

}
package app.view.page.oneNews.Body 
{
	import app.AppSettings;
	import app.assets.Assets;
	import app.view.utils.Tool;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class PreloaderNews extends Sprite 
	{
		private var circle:Sprite;
		private var _width:Number = 622;
		private var angle:Number = 3;
		private var fon:Shape;
		
		public function PreloaderNews() 
		{
			fon = Tool.createShape( _width, AppSettings.HEIGHT, 0x0e0f12);
			addChild(fon);
			x = -_width;
			
			circle = Assets.create("preloadDark1");
			circle.x = 0.5 * (_width - circle.width);
			circle.y = 0.5 * (AppSettings.HEIGHT - circle.height);
			addChild(circle);
			
			addEventListener(Event.ENTER_FRAME, rotateCircle);			
			TweenLite.delayedCall(3.2, removePreloader);
			addEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
		}
		
		private function removeHandler(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
			removeEventListener(Event.ENTER_FRAME, rotateCircle);
		}
		
		public function factcolor():void
		{
			Tool.changecolor(circle, 0x4a8734);
			Tool.changecolor(fon, 0x509338);
		}
		
		private function rotateCircle(e:Event):void 
		{
			Tool.rotateAroundCenter(circle, angle);
		}
		
		private function removePreloader():void 
		{
			removeEventListener(Event.ENTER_FRAME, rotateCircle);
			
			if (parent)
				parent.removeChild(this);
		}		
	}
}
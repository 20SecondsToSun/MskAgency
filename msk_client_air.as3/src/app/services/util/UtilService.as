package app.services.util
{
	import app.AppSettings;
	import app.contoller.events.ScreenshotEvent;
	import app.view.handsview.HandsView;
	import app.view.HELPTEMPSCREEN.HelpScreen;
	import app.view.MainView;
	import app.view.menu.MenuView;
	import app.view.utils.BigCanvas;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import org.robotlegs.mvcs.Actor;
	
	public class UtilService extends Actor implements IUtilService
	{
		[Inject]
		public var contextView:DisplayObjectContainer;
		
		private var invisibleForScr:Array = [ {_name:"HelpScreen", _class:HelpScreen },
											  {_name:"HandsView" , _class:HandsView  },
											  {_name:"MenuView"  , _class:MenuView   }]
		
		public function screeenshot(rec:Rectangle = null ):void
		{	
			
			var view:MainView = contextView.getChildByName("mainView") as MainView;			
			for (var i:int = 0; i < invisibleForScr.length; i++) 
			{
				var loc:* = view.getChildByName(invisibleForScr[i]._name) as invisibleForScr[i]._class; 
				if (loc) loc.visible = false;
			}			
			
			var mat:Matrix = new Matrix();
				mat.identity();
				
			var bmpWidth:int  = AppSettings.WIDTH;
			var bmpHeight:int = AppSettings.HEIGHT;
				
			if (rec != null)
			{
				mat.translate( -rec.x, -rec.y);
				
				bmpWidth  = rec.width;
				bmpHeight = rec.height;
			}
			
			var bigBmp:BigCanvas = new BigCanvas(bmpWidth, bmpHeight);	
			bigBmp.draw(view, mat);	
			
			dispatch(new ScreenshotEvent(ScreenshotEvent.TAKE_SCREENSHOT, bigBmp));
			
			for ( i = 0; i < invisibleForScr.length; i++) 
			{
				loc = view.getChildByName(invisibleForScr[i]._name) as invisibleForScr[i]._class; 
				if (loc) loc.visible = true;
			}				
		}
	}
}
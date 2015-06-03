package app.view.page.oneNews.Buttons 
{
	import app.AppSettings;
	import app.assets.Assets;
	import app.view.baseview.io.InteractiveButton;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FullscreenButtonBig extends InteractiveButton 
	{
		private var fullScreenTextFormat:TextFormat = new TextFormat("Tornado", 48, 0xffffff);
		
		public function FullscreenButtonBig() 
		{			
			var scale:Number = 1000 / AppSettings.WIDTH;
			var fullscreenBigImg:Shape = Tool.createShape(1000, 227 * scale, 0x5c9f42);	
			fullScreenTextFormat.size = 36;
			addChild(fullscreenBigImg);			
			
			var fullScreenDetail1:Sprite = Assets.create("fullscreen1");
			addChild(fullScreenDetail1);
			fullScreenDetail1.y = 0.5 * (height - fullScreenDetail1.height);
			fullScreenDetail1.x = 710 * scale;			
			
			var fullScreenTextBig:TextField = TextUtil.createTextField(0,0);
			fullScreenTextBig.multiline = false;
			fullScreenTextBig.wordWrap = false;			
			fullScreenTextBig.text = "СВЕРНУТЬ ВИДЕО";
			fullScreenTextBig.setTextFormat(fullScreenTextFormat);	
			
			fullScreenTextBig.x = fullScreenDetail1.x + 72;
			fullScreenTextBig.y =  fullScreenDetail1.y + 0.5*(fullScreenDetail1.height -fullScreenTextBig.height ) ;			
			
			addChild(fullScreenTextBig);			
		}
		public function over():void
		{			
			TweenLite.to(this, 0.3, { alpha:1 } );			
		}
		public function out():void
		{			
			TweenLite.to(this, 0.3, { alpha:0 } );
		}
		
	}

}
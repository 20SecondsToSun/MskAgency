package app.view.page.oneNews.Buttons 
{
	import app.assets.Assets;
	import app.view.baseview.io.InteractiveButton;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.TweenMax;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FullscreenButton extends InteractiveButton
	{
		private var fullScreenTextFormat:TextFormat = new TextFormat("Tornado", 24, 0xffffff);
		
		private var fullScreenDetail:Sprite;
		private var fullScreenImg:Sprite;
		
		public function FullscreenButton() 
		{
			fullScreenImg = Assets.create("fullScreen");
			
			var fullScreenFon:Shape = Tool.createShape(fullScreenImg.width, fullScreenImg.height, 0xf4f5f7);			
			addChild(fullScreenFon);
			addChild(fullScreenImg);
			
			fullScreenDetail = Assets.create("fullScreenDetail");
			addChild(fullScreenDetail);
			fullScreenDetail.y = 0.5 * (height - fullScreenDetail.height);
			fullScreenDetail.x = fullScreenDetail.y;
			
			var fullScreenText:TextField = TextUtil.createTextField(fullScreenDetail.y, 0);
			fullScreenText.multiline = false;
			fullScreenText.wordWrap = false;
			fullScreenText.text = "НА ВЕСЬ ЭКРАН";
			fullScreenText.width = 210;
			fullScreenText.setTextFormat(fullScreenTextFormat);
			addChild(fullScreenText);
			fullScreenText.y = 0.5 * (height - fullScreenDetail.height);
			fullScreenText.x = fullScreenDetail.x + fullScreenDetail.width + 30;
		}
		public function over():void
		{
			TweenMax.to(fullScreenImg, 0.3, {colorTransform: {tint: 0x02a7df, tintAmount: 1}});		
		}
		
		public function out():void
		{
			TweenMax.to(fullScreenImg, 0.3, {removeTint:true});
		}
		public function outFast():void
		{
			Tool.changecolor(fullScreenImg, 0x5c9f42);
		}
		
		
	}

}
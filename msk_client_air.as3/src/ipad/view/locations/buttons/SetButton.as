package ipad.view.locations.buttons
{
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ipad.controller.IpadConstants;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class SetButton extends Sprite
	{
		
		private var textFormat:TextFormat = new TextFormat("TornadoL", 36 * IpadConstants.contentScaleFactor, 0Xffffff);
		
		public function SetButton()
		{			
			graphics.beginFill(0x02a7df);
			graphics.drawRoundRect(0, 0, 753 * IpadConstants.contentScaleFactor, 138 * IpadConstants.contentScaleFactor, 10, 10);
			graphics.endFill();
			
			var mainTitle:TextField = TextUtil.createTextField(0,0);
			mainTitle.text = "СДЕЛАТЬ СТРАНИЦУ ОСНОВНОЙ";
			//mainTitle.mouseEnabled = false;
			mainTitle.setTextFormat(textFormat);
			mainTitle.y = mainTitle.y + mainTitle.height;
			mainTitle.x = 0.5 * (this.width - mainTitle.width);
			addChild(mainTitle);
			
			var splash:Shape = Tool.createShape(this.width, this.height, 0x000000);
			splash.alpha = 0;
			addChild(splash);
		}	
	}
}
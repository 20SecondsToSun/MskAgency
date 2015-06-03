package app.view.filters 
{
	import app.AppSettings;
	import app.assets.Assets;
	import app.view.baseview.io.InteractiveChargeButton;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class CloseButton extends InteractiveChargeButton 
	{			
		public function CloseButton() 
		{			
			var clearImage:Sprite = Assets.create("hideCircle");
			addChild(clearImage);
			
			x = AppSettings.WIDTH - width - 95;
			y = AppSettings.HEIGHT - height - 145;
			
			var textFormat:TextFormat = new TextFormat("Tornado", 18, 0x02a7df);
			textFormat.align = "center";
			
			var clearText:TextField = TextUtil.createTextField(0, 0);
			clearText.text = "СКРЫТЬ\nФИЛЬТРЫ";
			clearText.width = 200;
			clearText.multiline = true;
			clearText.wordWrap = true;		
			clearText.setTextFormat(textFormat);
			
			clearText.x = (width - clearText.width) * 0.5;
			clearText.y = height + 30;
			
			addChild(clearText);
			
			var shape:Shape = Tool.createShape(width, height, 0x000000);
			shape.alpha = 0;
			addChild(shape);
		}		
	}
}
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
	public class RefreshButton extends InteractiveChargeButton 
	{
		
		public function RefreshButton() 
		{			
			var refreshImage:Sprite = Assets.create("refresh");
			addChild(refreshImage);
			
			x = AppSettings.WIDTH - width - 95;
			y = 95;
			
			var textFormat:TextFormat = new TextFormat("Tornado", 18, 0x5db53a);
			textFormat.align = "center";
			//textFormat.color = 0x02a7df;
			
			var refreshText:TextField = TextUtil.createTextField(0, 0);
			refreshText.text = "СБРОСИТЬ\nФИЛЬТРЫ";
			refreshText.width = 200;
			refreshText.multiline = true;
			refreshText.wordWrap = true;	
			refreshText.setTextFormat(textFormat);
			
			refreshText.x = (width - refreshText.width) * 0.5;
			refreshText.y = height + 30;
			
			addChild(refreshText);
			
			var shape:Shape = Tool.createShape(width, height, 0x000000);
			shape.alpha = 0;
			addChild(shape);			
		}		
	}
}
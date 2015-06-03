package app.view.popup 
{
	import app.assets.Assets;
	import app.view.baseview.io.InteractiveChargeButton;
	import app.view.utils.Tool;
	import flash.display.Shape;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class CloseButton extends InteractiveChargeButton 
	{
		private var crossIpad:Sprite;
		
		public function CloseButton() 
		{			
			crossIpad = Assets.create("crossIpad");			
			addChild(crossIpad);			
			
			var shape:Shape = Tool.createShape(width, height, 0x000000);
			shape.alpha = 0;
			addChild(shape);			
		}		
	}
}
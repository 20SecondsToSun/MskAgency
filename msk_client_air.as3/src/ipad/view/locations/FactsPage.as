package ipad.view.locations 
{
	import app.view.utils.Tool;
	import flash.display.Shape;
	import flash.display.Sprite;
	import ipad.controller.IpadConstants;
	import ipad.view.MainSlider;
	import ipad.view.Top;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FactsPage extends Sprite
	{			
		private var top:Top;
		public var slider:MainSlider;
		private var shape:Shape;	
		
		public function FactsPage() 
		{
			shape = Tool.createShape(IpadConstants.GameWidth,IpadConstants.GameHeight - 290*IpadConstants.contentScaleFactor, 0x101114);	
			addChild(shape);
			
			slider = new MainSlider("fact");			
			addChild(slider);			
			
			top = new Top("fact");
			top.changeFonCallback = changeColor;
			addChild(top);	
		}
			
		private function changeColor():void 
		{
			Tool.changecolor(shape, 0x509338);
		}
		
		public function kill():void
		{
			if (shape && contains(shape)) removeChild(shape);
			if (top && contains(top)) removeChild(top);
			if (slider && contains(slider)) removeChild(slider);
		}		
	}
}
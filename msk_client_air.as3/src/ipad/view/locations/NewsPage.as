package ipad.view.locations 
{
	import app.model.materials.Filters;
	import app.model.materials.Material;
	import app.view.utils.Tool;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import ipad.controller.IpadConstants;
	import ipad.view.MainSlider;
	import ipad.view.Top;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class NewsPage extends Sprite
	{	
		private var top:Top;
		public var slider:MainSlider;
		private var shape:Shape;	
		
		public function NewsPage() 
		{
			shape = Tool.createShape(IpadConstants.GameWidth,IpadConstants.GameHeight - 290*IpadConstants.contentScaleFactor, 0x101114);	
			addChild(shape);
			
			slider = new MainSlider();			
			addChild(slider);
			
			top = new Top();
			addChild(top);	
		}
		
		public function kill():void
		{
			if (shape && contains(shape)) removeChild(shape);
			if (top && contains(top)) removeChild(top);
			if (slider && contains(slider)) removeChild(slider);
		}
		
	}
}
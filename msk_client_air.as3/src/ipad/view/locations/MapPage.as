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
	public class MapPage extends Sprite
	{
		private var top:Top;		
		private var shape:Shape;	
		public var slider:MainSlider;
		
		public function MapPage() 
		{
			shape = Tool.createShape(IpadConstants.GameWidth, IpadConstants.GameHeight - 290 * IpadConstants.contentScaleFactor, 0x101114);			
			addChild(shape);			
			
			slider = new MainSlider("map");			
			slider._filters.addFilter("has_point", "yes");
			addChild(slider);
			
			top = new Top("map");			
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
package app.view.page.oneNews
{
	import app.contoller.events.InteractiveEvent;
	import app.model.materials.Material;
	import app.view.allnews.OneHourGraphic;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class OneNewPreview extends OneHourGraphic
	{
		public var isActive:Boolean = false;
		
		public function OneNewPreview(hn:Material, _isFirstNew:Boolean, _isPreview:Boolean = false, _isShowFullTime:Boolean = false)
		{
			super(hn, _isFirstNew, _isPreview, _isShowFullTime, false, true);			
			
			var line:Shape = addLine();
			line.y = 33;
			addChild(line);
			setChildIndex(line, 0);
		}
		
		private function addLine():Shape
		{
			var lineHeight:uint = 100;
			
			var line:Shape = new Shape();
			line.graphics.lineStyle(2, 0x000000, .75);
			line.graphics.moveTo(0, 0);
			line.graphics.lineTo(348, 0);
			
			return line;
		}
		
		public function setActive(_id:Number):void
		{
			isActive = (_id == id);
			
			if (isActive)
				super.overState(null);
			else
				super.outState(null);		
		}
		
		override public function overState(e:InteractiveEvent):void
		{
			if (isActive)
				return;
			super.overState(null);
		}
		
		override public function outState(e:InteractiveEvent):void
		{
			if (isActive)
				return;
			super.outState(null);
		}	
	}
}
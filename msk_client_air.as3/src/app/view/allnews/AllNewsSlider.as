package app.view.allnews
{
	import app.view.baseview.slider.Slider;
	import com.greensock.TweenLite;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class AllNewsSlider extends Slider
	{
		private var isInit:Boolean = false;
		
		private static const shiftX:int = 150;
		private static const shiftY:int = 45;
		private static const startX:int = 35;
		private static const sliderHeight:int = 279;
		
		public function AllNewsSlider(_viewPort:Rectangle = null)
		{
			super(_viewPort);			
		}
		
		public function init(allNewsData:Vector.<OneHourBlockNews>):void
		{
			var offset:int = 0;
			
			for (var i:int = 0; i < allNewsData.length; i++)
			{
				allNewsData[i].x = offset + startX;
				allNewsData[i].y = shiftY;
				
				offset += allNewsData[i].width + shiftX + startX;
				addElement(allNewsData[i]);
			}
			
			isReady = true;			
		}		
	}
}
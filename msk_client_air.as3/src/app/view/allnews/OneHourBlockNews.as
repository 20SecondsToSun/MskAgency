package app.view.allnews
{
	import app.model.materials.Material;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class OneHourBlockNews extends Sprite 
	{
		private static const SHIFT:int = 80;
		
		public function OneHourBlockNews(hourNews:Vector.<Material>)
		{
			var offset:int = 0;
			
			for (var i:int = 0; i < hourNews.length; i++)
			{
				var oneHour:OneHourGraphic = new OneHourGraphic(hourNews[i], i == 0, false, true);				
				oneHour.x = offset;
				offset += oneHour.width + SHIFT;
				addChild(oneHour);
			}
			addLine();			
		}
		
		public function addLine():void
		{
			const offsetY:int = 33;
			
			var line:Shape = new Shape();
			line.graphics.lineStyle(2, 0x000000, .75);
			line.graphics.moveTo(0, offsetY);
			line.graphics.lineTo(this.width + 35, offsetY);
			
			addChild(line);
			setChildIndex(line, 0);
		}	
	}
}
package app.view.baseview.io 
{
	import app.AppSettings;
	import app.view.baseview.io.InteractiveObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class InteractiveButton extends InteractiveObject 
	{
		public function getSelfRec():Rectangle
		{	
			var point:Point = parent.localToGlobal(new Point(x, y));
			var finWidth:Number = width;
			
			if (point.x + width > AppSettings.WIDTH)			
				finWidth = AppSettings.WIDTH - point.x;			
			if (point.x <0)
			{
				finWidth = width + point.x;
				point.x = 0;
			}
			
			return new Rectangle(point.x,point.y, finWidth, height);
		}		
	}
}
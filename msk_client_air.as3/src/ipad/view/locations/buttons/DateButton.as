package ipad.view.locations.buttons 
{
	import ipad.assets.Assets;
	import flash.display.Shape;
	import flash.display.Sprite;
	import ipad.controller.IpadConstants;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class DateButton extends Sprite 
	{
		
		public function DateButton() 
		{
		/*	var circleMC:Shape = new Shape();
			circleMC.graphics.beginFill(0x02a7df);
			var size:Number = Math.floor(154 * IpadConstants.contentScaleFactor * 0.5);
			
			circleMC.graphics.drawCircle(size, size, size);
			addChild(circleMC);*/
			
			var arrow:Sprite = Assets.create("gogo");
			arrow.scaleX = arrow.scaleY = IpadConstants.contentScaleFactor;
			arrow.mouseEnabled  = false;
			addChild(arrow);
			
			//arrow.x = 0.5 * (circleMC.width - arrow.width);
			//arrow.y = 0.5 * (circleMC.height - arrow.height);
			
		}
		
	}

}
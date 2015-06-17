package app.view.page.fact.leftpanel
{
	import app.assets.Assets;
	import app.model.materials.Fact;
	import app.view.baseview.io.InteractiveButton;
	import app.view.page.fact.factsslider.OneFactPageGraphic;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author castor troy
	 */
	public class OneFactPreviewGraphic extends OneFactPageGraphic
	{
		public var isActive:Boolean = false;
		
		public function OneFactPreviewGraphic(fact:Fact)
		{
			super(fact, 0xffffff, "", true);			
			
			var line:Shape = addLine();
			line.y = height +20;			
			addChild(line);
			setChildIndex(line, 0);
		}
		
		private function addLine():Shape
		{
			var lineHeight:uint = 100;
			
			var line:Shape = new Shape();
			line.graphics.lineStyle(2, 0x5c9f42, .75);
			line.graphics.moveTo(0, 0);
			line.graphics.lineTo(310, 0);
			
			return line;
		}
		
		public function setActive(_id:Number):void
		{
			isActive = (_id == id);
			
			if (isActive)
				super.over();
			else
				super.out();		
		}
		
		override public function over():void
		{
			if (!isActive)				
				super.over();
		}
		
		override public function out():void
		{
			if (!isActive)			
				super.out();
		}	
	}
}
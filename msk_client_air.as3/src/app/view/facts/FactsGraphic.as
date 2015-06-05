package app.view.facts
{
	import app.assets.Assets;
	import app.model.materials.Fact;
	import app.view.utils.TextUtil;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FactsGraphic extends Sprite
	{
		private var factBackground:Sprite;
		private var live:Sprite;
		private var textFormat:TextFormat;
		public var currentDate:String;
		
		public function FactsGraphic(i:int, fact1:Fact, fact2:Fact = null, curScreen:String ="", notema:Boolean = false)
		{
			factBackground = Assets.create("eventsBckrng");
			addChild(factBackground);
			
			var lineWidth:int = 313;
			textFormat = new TextFormat();
			
			if (i == 0)
			{
				textFormat.size = 18;
				textFormat.font = "TornadoL";
				textFormat.color = 0Xffffff;
				
				var mainTitle:TextField = TextUtil.createTextField(52, 46);						
				mainTitle.text = curScreen == "MAIN_SCREEN" || notema == true ?"СЕГОДНЯ В ГОРОДЕ":"СОБЫТИЯ ПО ТЕМЕ";//
				mainTitle.setTextFormat(textFormat);
				addChild(mainTitle);
				
				var line:Shape = new Shape();
				line.graphics.lineStyle(2, 0xffffff, 1);
				line.graphics.moveTo(52, 78);
				
				line.graphics.lineTo(52 + lineWidth, 78);
				addChild(line);
			}
			
			var fact1Graphic:OneFactGraphic = new OneFactGraphic(fact1);
			fact1Graphic.x = 58;
			fact1Graphic.y = 115;
			addChild(fact1Graphic);
			
			if (fact2 == null)
				return;
			
			var fact2Graphic:OneFactGraphic = new OneFactGraphic(fact2);
			fact2Graphic.x = 58;
			fact2Graphic.y = 310;
			addChild(fact2Graphic);
			
			var lineBorder:Shape = new Shape();
			lineBorder.graphics.lineStyle(1, 0xffffff, 0.4);
			lineBorder.graphics.moveTo(this.width - 1, 106);
			lineBorder.graphics.lineTo(this.width - 1, 445);
			addChild(lineBorder);
		}	
	}
}
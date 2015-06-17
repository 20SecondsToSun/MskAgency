package app.view.page.fact.leftpanel
{
	import app.model.materials.Fact;
	import app.view.baseview.onenewpage.BaseLeftPanelSlider;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.TweenMax;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FactLeftPanelSlider extends BaseLeftPanelSlider
	{	
		public var date :String;
		
		override public function init(_all:*, id:int):void
		{
			super.init(_all, id);
			
			Tool.changecolor(fon, 0x509338);
			Tool.changecolor(backToDates, 0xede706);
			addDateTitle();			
		}		
		
		protected function addDateTitle():void
		{
			textFormat.color = 0x10271d;
			var dateArray:Array = date.split(".");
			textFormat.size = 72;
			textTitle.text = dateArray[0];
			textTitle.setTextFormat(textFormat);
			
			textFormat.size = 18;
			textHour.text = TextUtil.month[int(dateArray[1])-1];
			textHour.setTextFormat(textFormat);
			textHour.x = .5 * (textTitle.width - textHour.width) + textTitle.x;		
		}		
		
		override public function refresh(_all:*, id:int):void
		{
			all = _all;
			resetSlider();
		}	
		
		override protected function resetSlider():void
		{			
			if (!all || all.length == 0)
				return;
			
			var offset:int = 82;
			const shift:int = 20;
			newsArray = new Vector.<OneFactPreviewGraphic>;
			
			for (var i:int = 0; i < all.length; i++)
			{
				var fact:Fact = new Fact();
				fact = all[i];			
				
				var oneHour:OneFactPreviewGraphic = new OneFactPreviewGraphic(fact);
				oneHour.y = offset;
				offset += oneHour.height + shift;
				
				if (fact.id  == startFocusID)									
					oneHour.setActive(startFocusID);				
				
				newsArray.push(oneHour);
				slider.addElement(oneHour);
			}
			
			slider.isTimeChanging = false;
			slider.mask = createMaskLayer();	
			slider.focusSlider(startFocusID, 82);			
			slider.dragZoneFix();		
			if (all.length > 3)			
			slider.startInteraction();
		}
		
		override public function outbackToDates():void
		{
			TweenMax.to(backToDates, 0.3, {colorTransform: {tint: 0xede706, tintAmount: 1}});		
		}
	}
}
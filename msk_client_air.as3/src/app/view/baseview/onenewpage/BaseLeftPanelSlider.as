package app.view.baseview.onenewpage
{
	import app.AppSettings;
	import app.assets.Assets;
	import app.model.materials.Material;
	import app.view.baseview.io.InteractiveButton;
	import app.view.baseview.io.InteractiveChargeButton;
	import app.view.baseview.io.InteractiveObject;
	import app.view.page.oneNews.OneNewPreview;
	import app.view.page.oneNews.VerticalNewsSlider;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.TweenMax;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class BaseLeftPanelSlider extends InteractiveObject
	{
		protected var all:*;	
		protected var newsArray:*;		
		protected var slider:VerticalNewsSlider;
		
		public var backToDates:InteractiveChargeButton;
		protected var isPreview:Boolean = false;
		protected var isShowFullTime:Boolean = true;
		protected var textTitle:TextField;
		protected var textHour:TextField;		
		protected var textFormat:TextFormat = new TextFormat("TornadoL", 72, 0X7b8193);		
		protected var startFocusID:int;
		protected var fon:Shape;
		
		public function init(_all:*, id:int):void
		{
			all = _all;
			startFocusID = id;
			
			fon = Tool.createShape(622, AppSettings.HEIGHT, 0x1a1b1f);		
			addChild(fon);
			
			slider = new VerticalNewsSlider();
			slider.x = 210;
			addChild(slider);			
			
			textTitle = TextUtil.createTextField(66, 74);
			textTitle.multiline = false;
			textTitle.wordWrap = false;
			textTitle.width = 210;
			addChild(textTitle);
			
			textFormat.size = 18;
			
			textHour = TextUtil.createTextField(70, 152);
			textHour.multiline = false;
			textHour.wordWrap = false;
			textHour.width = 210;
			
			addChild(textHour);
			
			backToDates = new InteractiveChargeButton();
			var imgFon:Sprite = Assets.create("backToDates");
			backToDates.addChild(imgFon);
			addChild(backToDates);
			backToDates.x = 57;
			backToDates.y = AppSettings.HEIGHT - 152;
			Tool.changecolor(backToDates, 0x02a7df);			
			
			var fonBackBtn:Shape = Tool.createShape(imgFon.width, imgFon.height, 0x1a1b1f);
			fonBackBtn.alpha = 0;		
			backToDates.addChild(fonBackBtn);
			resetSlider();
		
		}		
		public function refresh(_all:*, id:int):void
		{
			all = _all;
			resetSlider();
		}	
		
		protected function resetSlider():void
		{			
			if (!all || all.length == 0)
				return;
			
			var offset:int = 82;
			const shift:int = 30;
			newsArray = new Vector.<OneNewPreview>;
			
			for (var i:int = 0; i < all.length; i++)
			{
				var hn:Material = new Material();
				hn = all[i];			
				
				var oneHour:OneNewPreview = new OneNewPreview(hn, i == 0, isPreview, isShowFullTime);
				oneHour.y = offset;
				offset += oneHour.height + shift;
				
				if (hn.id  == startFocusID)
				{
					oneHour.setActive(startFocusID);
					addHourTitle(int(all[i].publishedDate.getHours()));
				}
				
				newsArray.push(oneHour);
				slider.addElement(oneHour);
			}
			
			//addHourTitle(all[0].publishedDate.getHours());
			
			slider.mask = createMaskLayer();	
			slider.focusSlider(startFocusID, 82);
			
			slider.dragZoneFix();
		
			if (all.length > 5)			
			slider.startInteraction();
		}
		
		protected function addHourTitle(hour:int):void
		{
			textFormat.size = 72;
			textTitle.text = TextUtil.getFormatHours(hour);
			textTitle.setTextFormat(textFormat);
			
			textFormat.size = 18;
			textHour.text = TextUtil.hourInRussian(textTitle.text);
			textHour.setTextFormat(textFormat);
			textHour.x = .5 * (textTitle.width - textHour.width) + textTitle.x;		
		}
		
		protected function createMaskLayer():Sprite
		{
			var maskLayer:Sprite = new Sprite();
			var maskGraphics:Shape = Tool.createShape(slider.width, AppSettings.HEIGHT, 0xff0000);
			maskLayer.addChild(maskGraphics);
			maskLayer.x = slider.x;
			maskLayer.y = slider.y;
			
			addChild(maskLayer);
			
			return maskLayer;
		}
		
		public function overbackToDates():void
		{
			TweenMax.to(backToDates, 0.3, {colorTransform: {tint: 0xffffff, tintAmount: 1}});		
		}
		
		public function outbackToDates():void
		{
			TweenMax.to(backToDates, 0.3, {colorTransform: {tint: 0x02a7df, tintAmount: 1}});		
		}
		
	
	}

}
package app.view.page.oneNews
{
	import app.AppSettings;
	import app.assets.Assets;
	import app.contoller.events.DataLoadServiceEvent;
	import app.model.materials.Material;
	import app.view.baseview.io.InteractiveButton;
	import app.view.baseview.io.InteractiveChargeButton;
	import app.view.baseview.io.InteractiveObject;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class LeftPanelSlider extends InteractiveObject
	{
		private var all:Vector.<Material>;
		private var isPreview:Boolean = false;
		private var isShowFullTime:Boolean = true;
		private var newsArray:Vector.<OneNewPreview>;
		
		public var backToDates:InteractiveChargeButton;
		private var slider:VerticalNewsSlider;
		
		private var textTitle:TextField;
		private var textHour:TextField;		
		private var textFormat:TextFormat = new TextFormat("TornadoL", 72, 0X7b8193);
		
		private var startFocusID:int;
		
		private var allLength:int = 0;
		
		public function LeftPanelSlider():void
		{
			var fon:Shape = Tool.createShape(622, AppSettings.HEIGHT, 0x1a1b1f);		
			addChild(fon);
			
			slider = new VerticalNewsSlider();
			slider.dynamicLoad = true;
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
			
			newsArray = new Vector.<OneNewPreview>;
			all = new Vector.<Material>;			
		}		
		
		public function init(_all:Vector.<Material>, id:Number):void
		{
			allLength += _all.length;
			all = _all;
			startFocusID = id;	
			resetSlider();		
		}
		
		private const shift:int = 90;
		private var offset:int = 82;	
		private var second:Boolean = false;
		
		public function offLoading(e:DataLoadServiceEvent):void
		{
			slider.offDynamicLoad = true;
			slider.startInteraction();
			slider.animatetoFinishY();
		}
		
		private function resetSlider():void
		{			
			if (!all || all.length == 0)
			{
				//if (all.length < NEWS_BLOCK)	isNeedToUpdate = false;
				return;
			}			
			
			
			TweenLite.killTweensOf(slider);
			
			var len:int = all.length;			
			for (var i:int = 0; i < len; i++)
			{
				var hn:Material = new Material();
				hn = all[i];			
				
				var oneHour:OneNewPreview = new OneNewPreview(hn, i == 0, isPreview, isShowFullTime);				
				oneHour.y = offset;
				offset += oneHour.height + shift;
				
				/*if (hn.id  == startFocusID)
				{
					oneHour.setActive(startFocusID);
					addHourTitle(int(all[i].publishedDate.getHours()));
				}*/
				
				oneHour.showMainLive();
				
				newsArray.push(oneHour);
				slider.addElement(oneHour);
			}
			addHourTitle(all[0].publishedDate.getHours());
			
			//slider.mask = createMaskLayer();	
			//slider.focusSlider(startFocusID, 82);
			
			slider.dragZoneFix();
			//trace("all.length",all.length);
			if (allLength > 5)		
			{
				//slider.animatetoFinishY();
				//trace("STRAT INTERACTION!!!!!!!");				
			}
			
			slider.startInteraction();
		}
		
		public function addHourTitle(hour:int):void
		{
			textFormat.size = 72;
			textTitle.text = TextUtil.getFormatHours(hour);
			textTitle.setTextFormat(textFormat);
			
			textFormat.size = 18;
			textHour.text = TextUtil.hourInRussian(textTitle.text);
			textHour.setTextFormat(textFormat);
			textHour.x = .5 * (textTitle.width - textHour.width) + textTitle.x;		
		}
		
		private function createMaskLayer():Sprite
		{
			var maskLayer:Sprite = new Sprite();
			var maskGraphics:Shape = Tool.createShape(slider.width, AppSettings.HEIGHT, 0xff0000);
			maskLayer.addChild(maskGraphics);
			maskLayer.x = slider.x;
			maskLayer.y = slider.y;
			
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
		
		private function addButtonBack():void
		{
		
		}
		
		private function addCurrentDate():void
		{
		
		}			
	}
}
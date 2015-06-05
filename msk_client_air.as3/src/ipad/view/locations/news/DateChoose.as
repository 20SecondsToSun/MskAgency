package ipad.view.locations.news
{
	import app.contoller.events.IpadEvent;
	import app.view.utils.BigCanvas;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ipad.assets.Assets;
	import ipad.controller.IpadConstants;
	import ipad.view.Body;
	import ipad.view.locations.buttons.DateButton;
	import ipad.view.locations.buttons.TypeButton;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	
	public class DateChoose extends FilterPopup
	{
		private var btnsArray:Vector.<TypeButton> = new Vector.<TypeButton>();
		private var type:String;
		
		private var sliderDay1:FilterSlider;
		private var sliderDay2:FilterSlider;
		private var sliderMonth1:FilterSlider;
		private var sliderMonth2:FilterSlider;
		private var sliderYear1:FilterSlider;
		private var sliderYear2:FilterSlider;
		
		public function touch(display:DisplayObjectContainer, e:MouseEvent):void
		{
			if (isAnimate)
				return;
			
			if (e.target is DateButton)
			{
				isAnimate = true;
				close();
				
				var date1:String = sliderDay1.getValue() + "." + sliderMonth1.getValue() + "." + sliderYear1.getValue();
				var date2:String = sliderDay2.getValue() + "." + sliderMonth2.getValue() + "." + sliderYear2.getValue();
				
				var data1:Object = {name: "from", filter: date1, update: "no"};
				dispatchEvent(new IpadEvent(IpadEvent.FILTER_CHANGED, true, false, data1));
				var data2:Object = {name: "to", filter: date2};
				dispatchEvent(new IpadEvent(IpadEvent.FILTER_CHANGED, true, false, data2));
				TweenLite.delayedCall(0.6,function ():void 
				{
					dispatchEvent(new IpadEvent(IpadEvent.FILTER_CHANGED, true, false, data2));			
				});
			}
			else if (e.target.name == "popupfon")
			{
				isAnimate = true;
				close();
			}
			else if (e.target.name == "button")
			{
				isAnimate = true;
				parent.parent.setChildIndex(parent, parent.parent.numChildren - 1);
				var view:Body = display.getChildByName("body") as Body;
				
				var bigBmp:BigCanvas = new BigCanvas(Math.floor(popupTelo.width), IpadConstants.GameHeight);
				var mat:Matrix = new Matrix();
				mat.translate(-78 * IpadConstants.contentScaleFactor, 0);
				bigBmp.draw(view, mat);
				makeScreenshotBlur(bigBmp);
				
				popupfon.visible = true;
				popup.visible = true;
				popupMask.height = 1;
				popupMask.y = button.y + button.height * 0.5;
				TweenLite.to(popupMask, 0.5, {height: popup.height, y: 0, ease: Expo.easeInOut, onComplete: function():void
					{
						isAnimate = false;
					}});
				popupfon.alpha = 0;
				TweenLite.to(popupfon, 0.5, {alpha: 0.65, ease: Expo.easeInOut});
				callbackStageText("off");
				dispatchEvent(new IpadEvent(IpadEvent.MENU_OPENED));
			}
		}
		
		public function DateChoose(_type:String)
		{
			type = _type;
			
			button = new Sprite();
			button.name = "button";
			addChild(button);
			
			if (type == "fact")
				button.x = 660 * IpadConstants.contentScaleFactor;
			else
				button.x = 1381 * IpadConstants.contentScaleFactor;
			
			button.y = 680 * IpadConstants.contentScaleFactor;
			
			img = Assets.create("_dateM");
			img.mouseEnabled = false;
			img.scaleX = img.scaleY = IpadConstants.contentScaleFactor;
			img.y = -5;
			button.addChild(img);
			
			txt = TextUtil.createTextField(0, 0);
			txt.text = "Дата";
			txt.setTextFormat(textFormat);
			txt.x = img.x + img.width * 1.5;
			button.addChild(txt);
			
			var splash:Shape = Tool.createShape(button.width, button.height, 0xffffff);
			splash.alpha = 0;
			button.addChild(splash);
			
			pFon = new Sprite();
			pFon.name = "popupfon";
			addChild(pFon);
			
			popupfon = Tool.createShape(IpadConstants.GameWidth, IpadConstants.GameHeight, 0x101114);
			popupfon.visible = false;
			pFon.addChild(popupfon);
			
			popup = new Sprite();
			popup.visible = false;
			addChild(popup);
			
			popupHeader = Tool.createShape(1605 * IpadConstants.contentScaleFactor, 241 * IpadConstants.contentScaleFactor, 0x5c9f42);
			popup.addChild(popupHeader);
			
			popupTelo = Tool.createShape(1605 * IpadConstants.contentScaleFactor, IpadConstants.GameHeight - popupHeader.height, 0x465568);
			popupTelo.alpha = 0.91;
			popupTelo.y = popupHeader.height;
			popup.addChild(popupTelo);
			
			var imgHeader:Sprite = Assets.create("_dateM");
			imgHeader.mouseEnabled = false;
			imgHeader.scaleX = imgHeader.scaleY = IpadConstants.contentScaleFactor;
			imgHeader.y = (popupHeader.height - imgHeader.height) * 0.5;
			imgHeader.x = popupHeader.x + imgHeader.y;
			Tool.changecolor(imgHeader, 0x89ba77);
			popup.addChild(imgHeader);
			
			var txtHeader:TextField = TextUtil.createTextField(0, 0);
			txtHeader.text = "Дата";
			txtHeader.setTextFormat(textFormat);
			txtHeader.y = (popupHeader.height - txtHeader.height) * 0.5;
			txtHeader.x = imgHeader.x + (imgHeader.width + 80) * IpadConstants.contentScaleFactor;
			popup.addChild(txtHeader);
			
			popup.x = IpadConstants.GameWidth - popup.width;
			
			popupMask = Tool.createShape(popup.width, popup.height, 0xffffff);
			popup.mask = popupMask;
			popupMask.x = popup.x;
			addChild(popupMask);
			
			/////////////
			/////////////
			/////////////
			
			//fon.graphics.beginFill(_color);
			
			var oval1:Sprite = Assets.create("oval");
			oval1.scaleX = oval1.scaleY = IpadConstants.contentScaleFactor;
			//oval1.graphics.lineStyle(10, 0xffffff);
			//oval1.graphics.drawRoundRect(0, 0, 506 * IpadConstants.contentScaleFactor, 134 * IpadConstants.contentScaleFactor, 76, 76);
			//oval1.graphics.endFill();
			oval1.x = 160 * IpadConstants.contentScaleFactor;
			oval1.y = 610 * IpadConstants.contentScaleFactor+1;
			popup.addChild(oval1);
			
			var oval2:Sprite = Assets.create("oval");
			oval2.scaleX = oval2.scaleY = IpadConstants.contentScaleFactor;
			//oval2.graphics.lineStyle(10, 0xffffff);
			//oval2.graphics.drawRoundRect(0, 0, 506 * IpadConstants.contentScaleFactor, 134 * IpadConstants.contentScaleFactor, 76, 76);
			//oval2.graphics.endFill();
			oval2.x = 803 * IpadConstants.contentScaleFactor;
			oval2.y = 610 * IpadConstants.contentScaleFactor+1;
			popup.addChild(oval2);
			
			//trace("oval!!!!!!!!!!!!!!!!:", oval1.x, oval1.y, oval1.width, oval1.height);
			
			var _textFormat:TextFormat = new TextFormat("TornadoL", 54 * IpadConstants.contentScaleFactor, 0xffffff);
			var txt1:TextField = TextUtil.createTextField(0, 0);
			txt1.text = "C";
			txt1.setTextFormat(_textFormat);
			txt1.y = oval1.y + 0.5 * (oval1.height - 10 - txt1.height);
			txt1.x = 80 * IpadConstants.contentScaleFactor;
			popup.addChild(txt1);
			
			var txt2:TextField = TextUtil.createTextField(0, 0);
			txt2.text = "до";
			txt2.setTextFormat(_textFormat);
			txt2.y = oval1.y + 0.5 * (oval1.height - 10 - txt2.height);
			txt2.x = 700 * IpadConstants.contentScaleFactor;
			popup.addChild(txt2);
			
			var btnStart:DateButton = new DateButton();
			btnStart.x = IpadConstants.contentScaleFactor * 1385;
			btnStart.y = oval1.y + 0.5 * (oval1.height - 10 - btnStart.height);
			popup.addChild(btnStart);
			
			sliderDay1 = new FilterSlider("day", IpadConstants.contentScaleFactor * 37, IpadConstants.contentScaleFactor * 71);
			sliderDay1.x = oval1.x + 85 * IpadConstants.contentScaleFactor;
			sliderDay1.y = 180 * IpadConstants.contentScaleFactor;
			popup.addChild(sliderDay1);
			
			sliderDay2 = new FilterSlider("day", IpadConstants.contentScaleFactor * 37, IpadConstants.contentScaleFactor * 71);
			sliderDay2.x = oval2.x + 85 * IpadConstants.contentScaleFactor;
			sliderDay2.y = 180 * IpadConstants.contentScaleFactor;
			popup.addChild(sliderDay2);
			
			sliderMonth1 = new FilterSlider("month", IpadConstants.contentScaleFactor * 37, IpadConstants.contentScaleFactor * 36);
			sliderMonth1.x = sliderDay1.x + sliderDay1.width - 10 * IpadConstants.contentScaleFactor;
			sliderMonth1.y = 180 * IpadConstants.contentScaleFactor;
			popup.addChild(sliderMonth1);
			
			sliderMonth2 = new FilterSlider("month", IpadConstants.contentScaleFactor * 37, IpadConstants.contentScaleFactor * 36);
			sliderMonth2.x = sliderDay2.x + sliderDay2.width - 10 * IpadConstants.contentScaleFactor;
			sliderMonth2.y = 180 * IpadConstants.contentScaleFactor;
			popup.addChild(sliderMonth2);
			
			sliderYear1 = new FilterSlider("year", IpadConstants.contentScaleFactor * 37, IpadConstants.contentScaleFactor * 36);
			sliderYear1.x = sliderMonth1.x + sliderMonth1.width - 5 * IpadConstants.contentScaleFactor;
			sliderYear1.y = 180 * IpadConstants.contentScaleFactor;
			popup.addChild(sliderYear1);
			
			sliderYear2 = new FilterSlider("year", IpadConstants.contentScaleFactor * 37, IpadConstants.contentScaleFactor * 36);
			sliderYear2.x = sliderMonth2.x + sliderMonth2.width - 5 * IpadConstants.contentScaleFactor;
			sliderYear2.y = 180 * IpadConstants.contentScaleFactor;
			popup.addChild(sliderYear2);
		
			///////////////////
		/*isAnimate = true;
		
		
		   popupfon.visible = true;
		   popup.visible = true;
		   popupMask.height = 1;
		   popupMask.y = button.y + button.height * 0.5;
		   TweenLite.to(popupMask, 0.5, {height: popup.height,y:0, ease: Expo.easeInOut,onComplete:function ():void
		   {
		   isAnimate = false;
		   }});
		   popupfon.alpha = 0;
		   TweenLite.to(popupfon, 0.5, {alpha: 0.65, ease: Expo.easeInOut});
		
		 */
		
		/*sliderMonth = new FilterSlider("month", 45, 65);
		   sliderMonth.y = 320;
		   addChild(sliderMonth);
		
		   sliderYear = new FilterSlider("year", 76.5, 76.5);
		   sliderYear.y = 460;
		 addChild(sliderYear);*/
		
		}
		
		public function secondState():void
		{
			button.width = 148 * IpadConstants.contentScaleFactor;
			button.scaleY = button.scaleX;
			
			if (type == "fact")
				button.x = 1387 * IpadConstants.contentScaleFactor;
			else
				button.x = 1795 * IpadConstants.contentScaleFactor;
			
			button.y = 76 * IpadConstants.contentScaleFactor;
			Tool.changecolor(img, 0x828696);
			
			popup.x = IpadConstants.GameWidth - popup.width;
			popupMask.x = popup.x;
		}
	}
}
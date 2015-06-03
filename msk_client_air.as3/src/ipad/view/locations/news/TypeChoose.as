package ipad.view.locations.news
{
	import app.contoller.events.IpadEvent;
	import app.view.utils.BigCanvas;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import ipad.assets.Assets;
	import ipad.controller.IpadConstants;
	import ipad.view.Body;
	import ipad.view.locations.buttons.TypeButton;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	
	public class TypeChoose extends FilterPopup
	{
		private var btnsArray:Vector.<TypeButton> = new Vector.<TypeButton>();
		
		public function touch(display:DisplayObjectContainer, e:MouseEvent):void
		{
			if (isAnimate)
				return;
			
			if (e.target is TypeButton)
			{
				isAnimate = true;
				for (var i:int = 0; i < btnsArray.length; i++)
					btnsArray[i].click(e.target.name);
				close();
				
				var data:Object = {name: "type", filter: (e.target as TypeButton).name};
				
				TweenLite.delayedCall(0.6,function ():void 
				{
					dispatchEvent(new IpadEvent(IpadEvent.FILTER_CHANGED, true, false, data));		
				});
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
			else if (e.target.name == "popupfon")
			{
				isAnimate = true;
				close();
			}
		}
		
		public function TypeChoose()
		{
			button = new Sprite();
			button.name = "button";
			addChild(button);
			button.x = 156 * IpadConstants.contentScaleFactor;
			button.y = 680 * IpadConstants.contentScaleFactor;
			
			img = Assets.create("_typeM");
			img.mouseEnabled = false;
			img.scaleX = img.scaleY = IpadConstants.contentScaleFactor;
			button.addChild(img);
			
			txt = TextUtil.createTextField(0, 0);
			txt.text = "Тип материала";
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
			
			popupHeader = Tool.createShape(683 * IpadConstants.contentScaleFactor, 241 * IpadConstants.contentScaleFactor, 0x5c9f42);
			
			popup.addChild(popupHeader);
			
			popupTelo = Tool.createShape(683 * IpadConstants.contentScaleFactor, IpadConstants.GameHeight - popupHeader.height, 0x465568);
			popupTelo.alpha = 0.91;
			//popupTelo.x = popupHeader.x;
			popupTelo.y = popupHeader.height;
			popup.addChild(popupTelo);
			
			var imgHeader:Sprite = Assets.create("_typeM");
			imgHeader.mouseEnabled = false;
			imgHeader.scaleX = imgHeader.scaleY = IpadConstants.contentScaleFactor;
			imgHeader.y = (popupHeader.height - imgHeader.height) * 0.5;
			imgHeader.x = popupHeader.x + imgHeader.y;
			Tool.changecolor(imgHeader, 0x89ba77);
			popup.addChild(imgHeader);
			
			var txtHeader:TextField = TextUtil.createTextField(0, 0);
			txtHeader.text = "Тип материала";
			txtHeader.setTextFormat(textFormat);
			txtHeader.y = (popupHeader.height - txtHeader.height) * 0.5;
			txtHeader.x = imgHeader.x + (imgHeader.width + 80) * IpadConstants.contentScaleFactor;
			popup.addChild(txtHeader);
			
			popup.x = 78 * IpadConstants.contentScaleFactor;
			
			popupMask = Tool.createShape(popup.width, popup.height, 0xffffff);
			popup.mask = popupMask;
			popupMask.x = popup.x;
			addChild(popupMask);
			
			var typeArray:Array = [{name: "photo", text: "Фотографии", icon: "iphoto"}, {name: "video", text: "Видеоролики", icon: "ivideo"}, {name: "text", text: "Тексты", icon: "itexts"}, {name: "broadcast", text: "Трансляции", icon: "ilive"}];
			
			for (var i:int = 0; i < typeArray.length; i++)
			{
				var typeBtn:TypeButton = new TypeButton(typeArray[i], i != typeArray.length - 1);
				popup.addChild(typeBtn);
				typeBtn.x = popupTelo.x + 80 * IpadConstants.contentScaleFactor;
				typeBtn.y = 550 * IpadConstants.contentScaleFactor + 50 * i;
				typeBtn.alpha = 0;
				btnsArray.push(typeBtn);
				
				TweenLite.to(typeBtn, 0.2, {alpha: 1, delay: i * 0.05, ease: Cubic.easeInOut});
			}
		}
		
		public function secondState():void
		{
			
			button.width = 288 * IpadConstants.contentScaleFactor;
			button.scaleY = button.scaleX;
			button.x = 1092 * IpadConstants.contentScaleFactor;
			button.y = 76 * IpadConstants.contentScaleFactor;
			Tool.changecolor(img, 0x828696);
			
			popup.x = 917 * IpadConstants.contentScaleFactor;
			popupMask.x = popup.x;
		}
		
	}
}
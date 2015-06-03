package ipad.view.locations.news
{
	import app.contoller.events.IpadEvent;
	import app.model.config.Config;
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
	import ipad.view.locations.buttons.RubricButton;
	import ipad.view.locations.buttons.TypeButton;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	
	public class RubricChoose extends FilterPopup
	{
		private var btnsArray:Vector.<RubricButton> = new Vector.<RubricButton>();
		public var type:String;
		
		public function touch(display:DisplayObjectContainer, e:MouseEvent):void
		{
			if (isAnimate)
				return;
			
			if (e.target is RubricButton)
			{
				isAnimate = true;
				for (var i:int = 0; i < btnsArray.length; i++)
					btnsArray[i].click((e.target as RubricButton).rub);
				
				var data:Object;
				switch (type)
				{
					case "map": 
						data = {name: "rubric", filter: (e.target as RubricButton).rub.group_id};
						break;
					default: 
						data = {name: "rubric", filter: (e.target as RubricButton).rub.id};
				}
				TweenLite.delayedCall(0.6,function ():void 
				{
					dispatchEvent(new IpadEvent(IpadEvent.FILTER_CHANGED, true, false, data));					
				});
				
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
			else if (e.target.name == "popupfon")
			{
				isAnimate = true;
				close();
			}
		}
		
		public function RubricChoose(_type:String)
		{
			type = _type;
			
			button = new Sprite();
			button.name = "button";
			addChild(button);
			
			if (type == "fact")
				button.x = 156 * IpadConstants.contentScaleFactor;
			else
				button.x = 860 * IpadConstants.contentScaleFactor;

			button.y = 680 * IpadConstants.contentScaleFactor;
			
			img = Assets.create("_rubricM");
			img.mouseEnabled = false;
			img.scaleX = img.scaleY = IpadConstants.contentScaleFactor;
			button.addChild(img);
			img.y = -5;
			
			txt = TextUtil.createTextField(0, 0);
			txt.text = "Рубрика";
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
			
			popupHeader = Tool.createShape(566 * IpadConstants.contentScaleFactor, 241 * IpadConstants.contentScaleFactor, 0x5c9f42);
			popup.addChild(popupHeader);
			
			popupTelo = Tool.createShape(566 * IpadConstants.contentScaleFactor, IpadConstants.GameHeight - popupHeader.height, 0x465568);
			popupTelo.alpha = 0.91;
			//popupTelo.x = popupHeader.x;
			popupTelo.y = popupHeader.height;
			popup.addChild(popupTelo);
			
			var imgHeader:Sprite = Assets.create("_rubricM");
			imgHeader.mouseEnabled = false;
			imgHeader.scaleX = imgHeader.scaleY = IpadConstants.contentScaleFactor;
			imgHeader.y = (popupHeader.height - imgHeader.height) * 0.5;
			imgHeader.x = popupHeader.x + imgHeader.y;
			Tool.changecolor(imgHeader, 0x89ba77);
			popup.addChild(imgHeader);
			
			var txtHeader:TextField = TextUtil.createTextField(0, 0);
			txtHeader.text = "Рубрика";
			txtHeader.setTextFormat(textFormat);
			txtHeader.y = (popupHeader.height - txtHeader.height) * 0.5;
			txtHeader.x = imgHeader.x + (imgHeader.width + 80) * IpadConstants.contentScaleFactor;
			popup.addChild(txtHeader);
			
			
			
			if (type == "fact")
				popup.x = 78 * IpadConstants.contentScaleFactor;
			else
				popup.x = 769 * IpadConstants.contentScaleFactor;
			
			
			
			
			
			popupMask = Tool.createShape(popup.width, popup.height, 0xffffff);
			popup.mask = popupMask;
			popupMask.x = popup.x;
			addChild(popupMask);
			
			var rubrics:Array;
			if (type == "main" || type == "fact" )
				rubrics = Config.rubrics;
			else if (type == "map")
				rubrics = Config.mapRrubrics;
			
			for (var i:int = 0; i < rubrics.length; i++)
			{
				var rubBtn:RubricButton = new RubricButton(rubrics[i], null, i != rubrics.length - 1, 0x364150,i);
				//var btn:RubricButton = this["menu_" + (i + 1).toString()];
				popup.addChild(rubBtn);
				rubBtn.x = 60 * IpadConstants.contentScaleFactor;
				rubBtn.y = 470 * IpadConstants.contentScaleFactor + (rubBtn.height - 1) * i;
				rubBtn.alpha = 0;
				btnsArray.push(rubBtn);
				
				TweenLite.to(rubBtn, 0.2, {alpha: 1, delay: i * 0.05, ease: Cubic.easeInOut});
			}
			
		}
		
		public function secondState():void
		{
			
				
			button.width = 188 * IpadConstants.contentScaleFactor;
			button.scaleY = button.scaleX;
			
			
			if (type == "fact")
			{
				
				button.x = 1092 * IpadConstants.contentScaleFactor;
				popup.x = 917 * IpadConstants.contentScaleFactor;
			}
			else
			{
				
				button.x = 1497 * IpadConstants.contentScaleFactor;
				popup.x = 1317 * IpadConstants.contentScaleFactor;
			}
			
			
			
			button.y = 76 * IpadConstants.contentScaleFactor;
			Tool.changecolor(img, 0x828696);
			
			
			popupMask.x = popup.x;
		}
	}
}
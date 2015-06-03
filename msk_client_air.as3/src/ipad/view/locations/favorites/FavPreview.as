package ipad.view.locations.favorites
{
	import app.contoller.events.InteractiveEvent;
	import app.model.materials.Material;
	import app.view.baseview.io.InteractiveChargeButton;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.TweenMax;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ipad.assets.Assets;
	import ipad.controller.IpadConstants;
	import ipad.view.OneNewIpad;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FavPreview extends OneNewIpad
	{
		public var closeFav:Sprite;
		private var _width:int = 628 * IpadConstants.contentScaleFactor;
		private var _height:int = 415 * IpadConstants.contentScaleFactor;
		private var clip:Sprite;
		private var clip2:Sprite;
		private var textFormat:TextFormat = new TextFormat("Tornado", 26 * IpadConstants.contentScaleFactor, 0x02a5dc);
		public var mat:Material;
		
		public function FavPreview(hn:Material, _isFirstNew:Boolean, _isPreview:Boolean = false, _isShowFullTime:Boolean = false)
		{
			doubleClickEnabled = true;
			scaleX = 0.8;
			scaleY = 0.8;
			
			mat = hn;
			
			super(hn, _isFirstNew, _isPreview, _isShowFullTime, false, true);
			line.width = 320;
			overLine.width = 320;
			billet.width = 320;
			if (oneNewData.type == "photo" || oneNewData.type == "video")
			{
				dateTitle.y = previewContainer.y + previewContainer.height + 40;
				timeTitle.x = dateTitle.x + dateTitle.width + 8;
				timeTitle.y = dateTitle.y - 3;
				
				photoVideoSign.x = Math.floor(timeTitle.x + timeTitle.width + iconOffset);
				photoVideoSign.y = Math.floor(dateTitle.y) - 2;
				
				line.y = dateTitle.y + 33;
				overLine.y = dateTitle.y;
				bmpText.x = 0;
				bmpText.y = dateTitle.y + 56;
				billet.height = height;
				billet.width = previewContainer.width;
			}
			var HEIGHT:Number = bmpText.height + bmpText.y;
			billet.height = HEIGHT;
			
			//billet.alpha = 0.5;
			
			//closeFav.y = line.y - 1;
			//closeFav.x = line.x + line.width - 1;
			
			//billet.width += closeFav.width + 10;		
			
			if (oneNewData.type == "broadcast")
				addIsLive();
			
			if (main)
			{
				if (photoVideoSign)
					main.x = photoVideoSign.x + photoVideoSign.width + iconOffset;
				else
					main.x = timeTitle.x + timeTitle.width + iconOffset;
			}
			
			if (live)
			{
				if (main)
					live.x = main.x + main.width + iconOffset;
				else if (photoVideoSign)
					live.x = photoVideoSign.x + photoVideoSign.width + iconOffset;
				else
					live.x = timeTitle.x + timeTitle.width + iconOffset;
			}
			
			closeFav = new Sprite();
			closeFav.name = "closeFav";
			
			var image:Sprite;
			
			if (oneNewData.type == "photo" || oneNewData.type == "video")
			{
				image = Assets.create("closeFavPhoto");
			}
			else
			{
				image = Assets.create("closeFav");
			}
			image.mouseChildren = false;
			image.mouseEnabled = false;
			closeFav.addChild(image);
			
			closeFav.scaleX = 
			closeFav.scaleY = 0.8;
			if (oneNewData.type == "photo" || oneNewData.type == "video")
			{
				
			}
			else
			{
				//closeFav.scaleY = -1;				
				closeFav.y = line.y - 2 - closeFav.height;			
			}
			closeFav.x = 320 - closeFav.width;		
			addChild(closeFav);
			closeFav.visible = false;
			
			var sdvig:Number = 26;
			clip = new Sprite();
			clip.graphics.beginFill(0x2c3843);
			clip.graphics.drawRoundRect(0, 0, _width + sdvig, HEIGHT + sdvig, 10, 10);
			clip.graphics.endFill();
			clip.visible = false;
			clip.mouseEnabled = false;
			addChildAt(clip, 0);
			
			clip2 = new Sprite();
			clip2.mouseEnabled = false;
			clip2.mouseChildren = false;
			var overSplash:Sprite = new Sprite();
			overSplash.graphics.beginFill(0x000000, 0.8);
			overSplash.graphics.drawRoundRect(0, 0, _width + sdvig, HEIGHT + sdvig, 10, 10);
			overSplash.graphics.endFill();
			addChild(clip2);
			clip2.addChild(overSplash);
			
			var icon:Sprite = Assets.create("closeMat");
			icon.scaleX = icon.scaleY = IpadConstants.contentScaleFactor;
			clip2.addChild(icon);
			icon.x = (clip2.width - icon.width) * 0.5;
			icon.y = (clip2.height - icon.height) * 0.5 - IpadConstants.contentScaleFactor * 40;
			
			var mainTitle:TextField = TextUtil.createTextField(156 * IpadConstants.contentScaleFactor, 0);
			mainTitle.text = "СКРЫТЬ МАТЕРИАЛ";
			mainTitle.setTextFormat(textFormat);
			clip2.addChild(mainTitle);
			mainTitle.x = (clip2.width - mainTitle.width) * 0.5;
			mainTitle.y = icon.y + icon.height + IpadConstants.contentScaleFactor * 30;
			clip2.visible = false;
			
			clip.x = -sdvig * 0.5;
			clip2.x = -sdvig * 0.5;
			
			clip.y = -sdvig * 0.5;
			clip2.y = -sdvig * 0.5;
		
		}
		
		private function addLine():Shape
		{
			var lineHeight:uint = 100;
			
			var line:Shape = new Shape();
			line.graphics.lineStyle(2, 0x000000, .75);
			line.graphics.moveTo(0, 0);
			line.graphics.lineTo(310, 0);
			
			return line;
		}
		
		override public function overState(e:InteractiveEvent):void
		{
			TweenMax.to(bmpText, 0.4, {y: dateTitle.y + 66, colorTransform: {tint: overColor, tintAmount: 1}});
			overLine.visible = true;
			
			TweenMax.delayedCall(1, showCloseBtn);
		}
		
		private function showCloseBtn():void
		{
			TweenMax.to(closeFav, 0.5, {alpha: 1});
			//closeFav.chargeEnabled = true;
		}
		
		override public function outState(e:InteractiveEvent):void
		{
			TweenMax.to(bmpText, 0.4, {y: dateTitle.y + 56, colorTransform: {tint: overColor, tintAmount: 0}});
			overLine.visible = false;
			
			TweenMax.killDelayedCallsTo(showCloseBtn);
			TweenMax.to(closeFav, 0.5, {alpha: 0});
			//closeFav.chargeEnabled = false;
		}
		
		public function clear():void
		{
			clip.visible = false;
			clip2.visible = false;
			Tool.changecolor(line, 0x000000);
		}
		
		public function state2():void
		{
			clip.visible = false;
			clip2.visible = true;
			Tool.changecolor(line, 0x000000);
		}
		
		public function down():void
		{
			clip.visible = true;
			Tool.changecolor(line, 0x0a96c8);
		}
		
		public function closeShow():void
		{
			closeFav.visible = true;
			closeFav.alpha = 0;
			TweenMax.to(closeFav, 0.8, { alpha:1 } );
			TweenMax.delayedCall(3, delayToHide);			
		}
		
		private function delayToHide():void 
		{
			TweenMax.to(closeFav, 0.8, { alpha:0, onComplete:function ():void 
			{
				closeFav.visible = false;
			} } );
		}
		
		public function up():void
		{
			clip.visible = false;
			clip2.visible = false;
			Tool.changecolor(line, 0x000000);
		}
	
	}
}
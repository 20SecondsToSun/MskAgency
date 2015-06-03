package app.view.favorites
{
	import app.AppSettings;
	import app.assets.Assets;
	import app.contoller.events.InteractiveEvent;
	import app.model.materials.Material;
	import app.view.allnews.OneHourGraphic;
	import app.view.baseview.io.InteractiveChargeButton;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.TweenMax;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FavPreview extends OneHourGraphic
	{
		private var dateTitle:TextField;
		public var isActive:Boolean = false;
		public var closeFav:InteractiveChargeButton;
		
		public function FavPreview(hn:Material, _isFirstNew:Boolean, _isPreview:Boolean = false, _isShowFullTime:Boolean = false)
		{			
			var textFormat:TextFormat = new TextFormat("TornadoBold", 17, 0xffffff, true);
			
			dateTitle = TextUtil.createTextField(0, 0);
			dateTitle.multiline = false;
			dateTitle.wordWrap = false;
			dateTitle.text = TextUtil.formatDate(hn.publishedDate);
			dateTitle.setTextFormat(textFormat);
			addChild(dateTitle);	
			
			super(hn, _isFirstNew, _isPreview, _isShowFullTime, false, true);
			
			timeHoursTitleBmp.height = timeTitleBmp.height = dateTitle.height - 1;			
			
			
			timeHoursTitleBmp.scaleX = timeHoursTitleBmp.scaleY;
			timeTitleBmp.scaleX = timeTitleBmp.scaleY;
			
			
			timeHoursTitleBmp.x   = dateTitle.x + dateTitle.width +15;
			timeTitleBmp.x = timeHoursTitleBmp.x + timeHoursTitleBmp.width +2;
			Tool.changecolor(timeTitleBmp, 0x828696);
			Tool.changecolor(timeHoursTitleBmp, 0x828696);
			
			
			var line:Shape = addLine();
			line.y = 33;
			addChild(line);
			setChildIndex(line, 0);
			
			closeFav = new InteractiveChargeButton();
			closeFav.chargeEnabled = false;
			closeFav.name = "charge";
			addChild(closeFav);
			
			var closeFav1:Sprite = Assets.create("closeFav");			
			closeFav.addChild(closeFav1);
			
			var fonBackBtn:Shape = Tool.createShape(closeFav1.width, closeFav1.height, 0x1a1b1f);
			fonBackBtn.alpha = 0;	
			closeFav.addChild(fonBackBtn);			
			
			closeFav.y = dateTitle.y;// line.y - closeFav.height - 1;			
			closeFav.x = dateTitle.x - closeFav.width - 20;//line.x +line.width - closeFav.width - 1;
			
			closeFav.alpha = 0;
			
			var indx:int = getChildIndex(billet);
			setChildIndex(closeFav, indx );			
			
			billet.height += 50;
			billet.y -= 50;
			
			if (oneNewData.type == "photo" || oneNewData.type == "video")
			{
				dateTitle.y = previewContainer.y + previewContainer.height + 40;
				timeHoursTitleBmp.x   = dateTitle.x + dateTitle.width +15;
				timeTitleBmp.x = timeHoursTitleBmp.x + timeHoursTitleBmp.width +2;
				timeHoursTitleBmp.y = dateTitle.y;
				timeTitleBmp.y	= dateTitle.y;	
				photoVideoSign.x = timeTitleBmp.x + timeTitleBmp.width + iconOffset;
				photoVideoSign.y = timeTitleBmp.y + (timeTitleBmp.height - photoVideoSign.height) * 0.5;
				line.y = dateTitle.y + 33;				
				overLine.y = dateTitle.y;				
				bmpText.x = 0;
				bmpText.y  = dateTitle.y +56;				
				billet.height = height;
				billet.width = previewContainer.width;					
			}
			
			line.width = 352;
			overLine.width = 352;			
			
			closeFav.y = line.y - 1;
			closeFav.x = line.x + line.width - 1;
			
			billet.width += closeFav.width + 10;			
			
			showMainLive();
			if (main)
			{
				if (photoVideoSign)
					main.x = photoVideoSign.x + photoVideoSign.width + iconOffset;
				else
					main.x = timeTitleBmp.x + timeTitleBmp.width + iconOffset;
			}
			
			if (live)
			{	
				if (main)
					live.x = main.x + main.width + iconOffset;
				else if (photoVideoSign)
					live.x = photoVideoSign.x + photoVideoSign.width + iconOffset;
				else
					live.x = timeTitleBmp.x + timeTitleBmp.width + iconOffset;
			}
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
			TweenMax.to(bmpText, 0.4, {y: dateTitle.y +66, colorTransform: {tint: overColor, tintAmount: 1}});	
			overLine.visible = true;
			
			TweenMax.delayedCall(1, showCloseBtn);	
		}
		
		private function showCloseBtn():void 
		{
			TweenMax.to(closeFav, 0.5, { alpha:1 } );
			closeFav.chargeEnabled = true;
		}
		
		override public function outState(e:InteractiveEvent):void
		{
			TweenMax.to(bmpText, 0.4, {y: dateTitle.y +56, colorTransform: {tint: overColor, tintAmount: 0}});		
			overLine.visible = false;
			
			TweenMax.killDelayedCallsTo( showCloseBtn);
			TweenMax.to(closeFav, 0.5, { alpha:0 } );
			closeFav.chargeEnabled = false;
		}
		
		override public function getSelfRec():Rectangle
		{
			var scale_X:Number = 1;
			var scale_Y:Number = 1;
			
			var point:Point;			
			var finWidth:Number = width * scale_X;
			
			if (previewContainer)			
				point = localToGlobal(new Point(x, previewContainer.y));			
			else			
				point = localToGlobal(new Point(x, y));			
			
			if (point.x + width > AppSettings.WIDTH)			
				finWidth = AppSettings.WIDTH - point.x;			
			else if (point.x < 0)
			{
				finWidth = width + point.x;
				point.x = 0;
			}
			
			return new Rectangle(point.x, point.y, finWidth * scale_X, height * scale_Y);
			
		}		
	}
}
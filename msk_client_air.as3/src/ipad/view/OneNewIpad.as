package ipad.view
{
	import app.AppSettings;
	import app.assets.Assets;
	import app.contoller.events.InteractiveEvent;
	import app.model.materials.Material;
	import app.view.baseview.io.InteractiveButton;
	import app.view.baseview.photo.OnePhoto;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.layout.ScaleMode;
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ipad.controller.IpadConstants;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class OneNewIpad extends Sprite
	{
		private static const MAX_LINES:int = 7;
		
		protected var timeTitle:TextField;
		protected var timeTitleBmp:Bitmap;
		
		protected var timeHoursTitle:TextField;
		protected var timeHoursTitleBmp:Bitmap;
		
		private var textTitle:TextField;
		
		public var bmpText:Bitmap;
		public var billet:Shape;
		public var oneNewData:Material;
		
		protected var isFirstNew:Boolean;
		protected var isLast:Boolean;
		protected var isPreview:Boolean;
		protected var isShowFullTime:Boolean;
		
		public var type:String;
		public var id:int;
		public var _color:uint = 0x1a1b1f;
		
		public var previewContainer:Sprite;
		public var thumb:OnePhoto;
		public var overLine:Shape;
		public static var overColor:uint = 0xffffff;
		
		private var SCALE:Number = 345 / 279;
		public var main:Sprite;
		public var live:Sprite;
		
		public static const iconOffset:int = 20;
		public var photoVideoSign:Sprite;
		private var ownHeight:Boolean;
		public var dateTitle:TextField;
		public var isActive:Boolean = false;
		public var line:Shape;
		
		private function addLine():Shape
		{
			var lineHeight:uint = 100;
			
			var line:Shape = new Shape();
			line.graphics.lineStyle(2, 0x000000, .75);
			line.graphics.moveTo(0, 0);
			line.graphics.lineTo(310, 0);
			
			return line;
		}
		
		public function setActive(_id:Number):void
		{
			isActive = (_id == id);
			
			if (isActive)
				overState(null);
			else
				outState(null);
		}
		
		public function OneNewIpad(hn:Material, _isFirstNew:Boolean, _isPreview:Boolean = false, _isShowFullTime:Boolean = false, _isLast:Boolean = false, _ownHeight:Boolean = false)
		{
			oneNewData = hn;
			
			isFirstNew = _isFirstNew;
			isLast = _isLast;
			
			isPreview = _isPreview;
			isShowFullTime = _isShowFullTime;
			ownHeight = _ownHeight;
			
			type = hn.type;
			id = hn.id;
			
			addTimeTitle();
			addTextTitle();
			
			addBillet();
			addIcon();
			
			addOverLine();
			
			line = addLine();
			line.y = 33;
			addChild(line);
			setChildIndex(line, 0);
		}
		
		public function showMainLive():void
		{
			if (oneNewData.important == "1")
				addIsMain();
			
			if (oneNewData.type == "broadcast")
				addIsLive();
			
			setChildIndex(billet, numChildren - 1);
		}
		
		private function addIsMain():void
		{
			main = Assets.create("mainfactsIco");
			addChild(main);			
			main.y = timeTitle.y - 3;
			
			if (photoVideoSign)
				main.x = photoVideoSign.x + photoVideoSign.width + iconOffset;
			else
				main.x = timeTitle.x + timeTitle.width + iconOffset;		
		}
		
		public function addIsLive():void
		{
			live = Assets.create("live");
			addChild(live);
			live.y = timeTitle.y -3;
			
			if (main)
				live.x = main.x + main.width + iconOffset;
			else if (photoVideoSign)
				live.x = photoVideoSign.x + photoVideoSign.width + iconOffset;
			else
				live.x = timeTitle.x + timeTitle.width + iconOffset;		
		}
		
		private function addOverLine():void
		{
			const offsetY:int = 33;
			var finWidth:Number = width;
			
			finWidth = width;
			
			overLine = new Shape();
			overLine.graphics.lineStyle(2, 0x02a7df);
			overLine.graphics.moveTo(0, offsetY);
			overLine.graphics.lineTo(finWidth, offsetY);
			
			addChild(overLine);
			overLine.visible = false;
			
			if (thumb)
			{
				swapChildren(thumb, overLine);
				setChildIndex(billet, numChildren - 1);
			}
		}
		
		private function addTimeTitle():void
		{
			var textFormat:TextFormat = new TextFormat("TornadoBold", 34 * IpadConstants.contentScaleFactor, 0xffffff, true);			
			
			timeTitle = TextUtil.createTextField(0, 0);
			timeTitle.multiline = false;
			timeTitle.wordWrap = false;

			var minutes:String = TextUtil.getFormatMinutes(oneNewData.publishedDate.getMinutes());
			
			timeTitle.text = ":" + minutes;
			timeTitle.setTextFormat(textFormat);
			if (timeHoursTitle)
				timeTitle.x = timeHoursTitle.width // + 5;
			//addChild(timeTitle);
			
			timeTitleBmp = TextUtil.textFieldToBitmap(timeTitle, SCALE);
			//addChild(timeTitleBmp);
			
			
			dateTitle = TextUtil.createTextField(0, 0);
			dateTitle.multiline = false;
			dateTitle.wordWrap = false;
			
			dateTitle.text = TextUtil.formatDate(oneNewData.publishedDate);
			dateTitle.setTextFormat(textFormat);
			addChild(dateTitle);
			timeTitleBmp.x = dateTitle.x + dateTitle.width + 5;	
			
			var hours:String = TextUtil.getFormatHours(oneNewData.publishedDate.getHours());
			timeTitle.text = hours +":" + minutes;
			textFormat.color = 0x828697;
			timeTitle.setTextFormat(textFormat);
			addChild(timeTitle);
			timeTitle.x = dateTitle.x +dateTitle.width +8;
			timeTitle.y = -3;
			
		}
		
		private function addIcon():void
		{
			if (oneNewData.type == "video")
			{
				photoVideoSign = Assets.create("playImg");
			}
			else if (oneNewData.type == "photo")
			{
				photoVideoSign = Assets.create("photoImg");
			}
			
			if (photoVideoSign)
			{
				photoVideoSign.x = timeTitle.x + timeTitle.width + iconOffset;
				photoVideoSign.y = (photoVideoSign.y - timeTitle.y) * 0.5 - 2;
				addChild(photoVideoSign);
				
				if (isPreview)
				{
					previewContainer = new Sprite();
					//previewContainer.y = -84 + (345 - 273) * 0.5;
					addChild(previewContainer);
					previewContainer.alpha = 0;
					
					var fon:Shape = Tool.createShape(320, 273, 0xffffff);
					previewContainer.addChild(fon);
					
					var shiftX:Number = previewContainer.x + previewContainer.width + 30;
					///if (timeHoursTitleBmp)
					//{
					//timeHoursTitleBmp.x = shiftX;
					//timeHoursTitle.x = shiftX;
					//}
					
					//timeTitleBmp.x = timeHoursTitle.x + timeHoursTitle.width + 5;
					//photoVideoSign.x = timeTitleBmp.x + timeTitleBmp.width + 20;
					
					//bmpText.x = shiftX;
					
					thumb = new OnePhoto(oneNewData.files[0].thumbPath, oneNewData.files[0].id);
					thumb.doubleClickEnabled = true;
					thumb._height = 273;
					thumb._width = 320;
					thumb._scaleMode = ScaleMode.STRETCH;
					thumb.x = previewContainer.x;
					thumb.y = previewContainer.y;
					addChild(thumb);
					
					billet.y = previewContainer.y;
					billet.width = previewContainer.width + bmpText.width + 30;
					billet.height = previewContainer.height;
					//billet.alpha = 0.8;
					
					var _maska:Shape = Tool.createShape(previewContainer.width, previewContainer.height, 0xffffff);
					//addChild(_maska);
					//thumb.mask = _maska;
					_maska.x = thumb.x;
					_maska.y = thumb.y;
				}
			}
		}
		
		private function addTextTitle():void
		{
			var textFormat:TextFormat = new TextFormat("Tornado", 21, 0xc9e0e7);
			textFormat.leading = 0.4;
			
			textTitle = TextUtil.createTextField(0, 56);
			textTitle.multiline = true;
			textTitle.wordWrap = true;
			textTitle.width = 300;
			//textTitle.border = true;
			textTitle.text = oneNewData.title;
			
			TextUtil.truncate(textTitle, MAX_LINES, textFormat);
			
			bmpText = TextUtil.textFieldToBitmap(textTitle, SCALE);
			addChild(bmpText);
		}
		
		private function addBillet():void
		{
			var h:Number = height;// ownHeight ? height : 200;
			billet = Tool.createShape(width, h, 0x265166);
			billet.visible = true;
			billet.alpha = 0;
			addChild(billet);
		}
		
		public function overState(e:InteractiveEvent):void
		{
			if (isActive)
				return;
			TweenMax.to(bmpText, 0.4, {y: 66, colorTransform: {tint: overColor, tintAmount: 1}});
			TweenMax.to(timeTitleBmp, 0.4, {colorTransform: {tint: overColor, tintAmount: 1}});
			//if (isLast) overLine.width = this.width + 135;
			overLine.visible = true;
			
			if (isFirstNew || isShowFullTime)
				TweenMax.to(timeHoursTitleBmp, 0.4, {colorTransform: {tint: overColor, tintAmount: 1}});
			
			if (thumb)
			{
				var __scale:Number = 1.1;
				TweenMax.to(thumb, 1.8, {scaleX: __scale, scaleY: __scale, x: (thumb.width - thumb.width * __scale) * 0.5, y: -48 + (thumb.height - thumb.height * __scale) * 0.5});
			}
		}
		
		public function outState(e:InteractiveEvent):void
		{
			if (isActive)
				return;
			
			TweenMax.to(bmpText, 0.4, {y: 56, colorTransform: {tint: overColor, tintAmount: 0}});
			TweenMax.to(timeTitleBmp, 0.4, {colorTransform: {tint: overColor, tintAmount: 0}});
			overLine.visible = false;
			//	if (isLast) overLine.width = this.width - 35;
			
			if (isFirstNew || isShowFullTime)
				TweenMax.to(timeHoursTitleBmp, 0.4, {colorTransform: {tint: overColor, tintAmount: 0}});
			
			if (thumb)
				TweenMax.to(thumb, 1.8, {scaleX: 1, scaleY: 1, x: 0, y: -48});
		}
		
		public function getSelfRec():Rectangle
		{
			var scale_X:Number = 1;
			var scale_Y:Number = 1;
			
			var point:Point;
			
			if (parent.parent.parent)
			{
				scale_X = parent.parent.parent.parent.scaleX;
				scale_Y = parent.parent.parent.parent.scaleY;
			}
			
			var finWidth:Number = width * scale_X;
			
			if (previewContainer)
				point = parent.localToGlobal(new Point(x, previewContainer.y));
			else
				point = parent.localToGlobal(new Point(x, y));
			
			if (point.x + width > AppSettings.WIDTH)
				finWidth = AppSettings.WIDTH - point.x;
			else if (point.x < 0)
			{
				finWidth = width + point.x;
				point.x = 0;
			}
			
			return new Rectangle(point.x, point.y, finWidth * scale_X, height * scale_Y);
		}
		
		public function kill():void
		{
			//trace("HERE!!!!!!");
			//TweenMax.killAll();
		}
	
	}
}
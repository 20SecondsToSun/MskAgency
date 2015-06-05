package app.view.favorites
{
	import app.AppSettings;
	import app.assets.Assets;
	import app.model.materials.Fact;
	import app.view.baseview.io.InteractiveButton;
	import app.view.baseview.io.InteractiveChargeButton;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author castor troy
	 */
	public class FavFactGraphic extends InteractiveButton
	{
		private var factTitle:TextField;
		private var factTitleBmp:Bitmap;
		private var factTime:Sprite;
		
		public var fact:Fact;
		public var currentDate:String;
		private var main:Sprite;
		private var factTitleColor:uint;
		static public const MAX_LINES:int = 5;
		
		public var id:int;
		private var eventDate:String;
		private var ownHeight:Boolean;
		private var live:Sprite;
		
		private var initFT:Number;
		
		protected var billet:Shape;
		
		public var closeFav:InteractiveChargeButton;
		public var oneNewData:Object = new Object();//// это очень плохо но надо так сделать
		
		public function FavFactGraphic(_fact:Fact, _factTitleColor:uint = 0Xffffff, _eventDate:String = "", _ownHeight:Boolean = false)
		{
			oneNewData.type = "fact";
			factTitleColor = _factTitleColor;
			fact = _fact;
			eventDate = _eventDate;
			id = fact.id;
			
			ownHeight = _ownHeight;
			
			if (fact.is_main == "1")
				addIsMain();
			
			if (fact.live_broadcast != "0")
				addIsLive();
			
			addFactTime();
			addFactTitle();
			
			var line:Shape = addLine();
			line.y = height + 45;
			addChild(line);
			setChildIndex(line, 0);
			
			closeFav = new InteractiveChargeButton();
			closeFav.chargeEnabled = false;
			closeFav.name = "charge";
			addChild(closeFav);
			
			var closeFav1:Sprite = Assets.create("closeFavEvents");
			closeFav.addChild(closeFav1);
			
			var fonBackBtn:Shape = Tool.createShape(closeFav1.width, closeFav1.height, 0x1a1b1f);
			fonBackBtn.alpha = 0;
			closeFav.addChild(fonBackBtn);
			
			closeFav.y = factTitleBmp.y - 13;
			closeFav.x = line.x + line.width - 1;
			closeFav.alpha = 0;
			
			addBillet();
		}
		
		private function addLine():Shape
		{
			var lineHeight:uint = 100;
			
			var line:Shape = new Shape();
			line.graphics.lineStyle(2, 0x5c9f42, .75);
			line.graphics.moveTo(0, 0);
			line.graphics.lineTo(352, 0);
			
			return line;
		}
		
		public function setY():void
		{
			this.y = -14;
			if (!ownHeight)
			{
				if (main || live) y = -factTime.y - 14;
			}
		}
		
		private function addFactTime():void
		{
			factTime = new Sprite();
			if (main || live)
			{
				factTime.x = 0;
				if (main)
					factTime.y = main.y + main.height + 8;
				else if (live)
					factTime.y = live.y + live.height + 8;
			}
			else
			{
				factTime.x = 0;
				factTime.y = 3;
			}
			
			addChild(factTime);
			
			var textFormat:TextFormat = new TextFormat("TornadoL", 33, 0X193a2c);
			
			currentDate = TextUtil.convertDateToString(fact.start_date);
			
			var textFormatMonth:TextFormat = new TextFormat("Tornado", 21, 0X193a2c);
			
			var d1:TextField = TextUtil.createTextField(0, 0);
			d1.text = fact.start_date.getDate().toString();
			d1.setTextFormat(textFormat);
			var bmp:Bitmap = TextUtil.textFieldToBitmap(d1, 1);
			factTime.addChild(bmp);
			
			var d1Month:TextField = TextUtil.createTextField(factTime.width, 0);
			d1Month.text = TextUtil.month[fact.start_date.getMonth()];
			d1Month.setTextFormat(textFormatMonth);
			
			bmp = TextUtil.textFieldToBitmap(d1Month, 1);
			bmp.y = d1.height - d1Month.height - 3;
			bmp.x = factTime.width;
			factTime.addChild(bmp);
			
			if (TextUtil.isEqualDayDate(fact.start_date, fact.end_date)) return;
			
			var tire:TextField = TextUtil.createTextField(factTime.width, 0);
			tire.text = " — ";
			tire.setTextFormat(textFormat);
			
			bmp = TextUtil.textFieldToBitmap(tire, 1);
			bmp.x = factTime.width;
			factTime.addChild(bmp);
			
			var d2:TextField = TextUtil.createTextField(factTime.width, 0);
			d2.text = fact.end_date.getDate().toString();
			d2.setTextFormat(textFormat);
			
			bmp = TextUtil.textFieldToBitmap(d2, 1);
			bmp.x = factTime.width;
			factTime.addChild(bmp);
			
			var d2Month:TextField = TextUtil.createTextField(factTime.width, 0);
			d2Month.text = TextUtil.month[fact.end_date.getMonth()];
			d2Month.setTextFormat(textFormatMonth);
			
			bmp = TextUtil.textFieldToBitmap(d2Month, 1);
			bmp.x = factTime.width;
			bmp.y = d2.height - d2Month.height - 3;
			factTime.addChild(bmp);
		}
		
		private function addFactTitle():void
		{
			var textFormat:TextFormat = new TextFormat("TornadoL", 24, factTitleColor);
			
			factTitle = TextUtil.createTextField(8, 55);
			factTitle.multiline = true;
			factTitle.wordWrap = true;
			factTitle.width = 313;
			factTitle.text = fact.title;
			TextUtil.truncate(factTitle, MAX_LINES, textFormat);
			
			factTitleBmp = TextUtil.textFieldToBitmap(factTitle);
			initFT = factTitleBmp.y = factTime.y + factTime.height + 20;
			factTitleBmp.x = factTime.x;
			
			addChild(factTitleBmp);
		}
		
		private function addIsMain():void
		{
			main = Assets.create("mainfactsIco");
			addChild(main);
			
			main.y = 0;// factTime.y - main.height - 15;
			main.x = -4;
		}
		
		private function addIsLive():void
		{
			live = Assets.create("live");
			addChild(live);
			
			if (main)
			{
				live.x = main.x + main.width + 15;
			}
			else
			{
				live.x = -4;
			}
			live.y = 0;// factTime.y - live.height - 15;
		}
		
		override public function getSelfRec():Rectangle
		{
			//trace("GET FACT RECTANGLE");
			var point:Point = localToGlobal(new Point(x, y));
			var point1:Point = parent.localToGlobal(new Point(x, y));
			var finWidth:Number = width;
			var finHeight:Number = height;
			//if (point.x + width > AppSettings.WIDTH)
			//{
			finWidth = AppSettings.WIDTH - point.x;
			//}
			if (point.x < 0)
			{
				finWidth = width + point.x;
				point.x = 0;
			}
			if (point.y + height > AppSettings.HEIGHT)
			{
				finHeight = AppSettings.HEIGHT - point1.y;
			}
			
			return new Rectangle(point.x, point1.y, finWidth, finHeight);
		
		}
		
		private function addBillet():void
		{
			var h:Number = height + 40;// ownHeight ? height + 40 : 240;
			billet = Tool.createShape(width + 80, h, 0xFFFF00);
			addChild(billet);
			billet.y = -40;
			billet.x = -50;
			billet.alpha = 0;
		}
		
		public function over():void
		{
			TweenLite.to(factTitleBmp, 0.4, {y: initFT - 13});
			TweenLite.to(factTime, 0.4, {colorTransform: {tint: 0xfff000, tintAmount: 1}});
			TweenLite.delayedCall(1, showCloseBtn);
		}
		
		public function out():void
		{
			TweenLite.to(factTitleBmp, 0.4, {y: initFT});
			TweenLite.to(factTime, 0.4, {colorTransform: {tint: 0X193a2c, tintAmount: 1}});
			
			TweenLite.killDelayedCallsTo(showCloseBtn);
			TweenLite.to(closeFav, 0.5, {alpha: 0});
			closeFav.chargeEnabled = false;
		}
		
		private function showCloseBtn():void
		{
			TweenLite.to(closeFav, 0.5, {alpha: 1});
			closeFav.chargeEnabled = true;
		}
	}
}
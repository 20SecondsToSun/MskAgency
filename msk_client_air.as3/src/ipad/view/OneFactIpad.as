package ipad.view
{
	import app.assets.Assets;
	import app.model.materials.Fact;
	import app.view.baseview.io.InteractiveButton;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author castor troy
	 */
	public class OneFactIpad extends Sprite
	{
		private var factTitle:TextField;
		private var factTitleBmp:Bitmap;
		public var factTime:Sprite;
		protected var billet:Shape;
		public var fact:Fact;
		public var currentDate:String;
		private var main:Sprite;
		private var factTitleColor:uint;
		static public const MAX_LINES:int = 5;
		
		public var id:int;
		private var eventDate:String;
		private var ownHeight:Boolean;
		private var live:Sprite;
		
		public function OneFactIpad(_fact:Fact, _factTitleColor:uint = 0Xffffff, _eventDate:String = "", _ownHeight:Boolean = false)
		{
			factTitleColor = _factTitleColor;
			fact = _fact;
			eventDate = _eventDate;
			id = fact.id;
			
			ownHeight = _ownHeight;
			
			/*if (fact.is_main == "1")
				addIsMain();
			
			if (fact.live_broadcast != "0")
				addIsLive();*/
			
			
			addFactTime();
			addFactTitle();
			
			addBillet();
			
			
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
				factTime.y = main.y +main.height + 8;
				else if (live)
				factTime.y = live.y +live.height + 8;
			}
			else
			{
				factTime.x = 0;
				factTime.y = 3;
			}
			
			addChild(factTime);
			
			var textFormat:TextFormat = new TextFormat("TornadoL", 33, 0X193a2c);
			
			//if (TextUtil.isEqualDayDate(fact.start_date, fact.end_date))
			/*{
				var factTimeText:TextField = TextUtil.createTextField(0, 0);
				var startTime:String = TextUtil.getFormatTime(fact.start_date);
				var endTime:String = TextUtil.getFormatTime(fact.end_date);
				
				factTimeText.text = startTime + " — " + endTime;
				factTimeText.setTextFormat(textFormat);
				
				factTime.addChild(factTimeText);
			/*}
			else
			{*/
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
				
				/*var tire:TextField = TextUtil.createTextField(factTime.width, 0);
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
				factTime.addChild(bmp);*/
			//}*/
		
		}
		private var initFT:Number;
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
			//if (main || live)
			//{
			initFT = factTitleBmp.y = factTime.y +factTime.height +20;
			factTitleBmp.x = factTime.x;
			//}
			//else			
		//	factTitleBmp.y = 68;
			
			addChild(factTitleBmp);
		
		}
		
		private function addIsMain():void
		{
			main = Assets.create("mainfactsIco");
			addChild(main);
			
			main.y = 0;// factTime.y - main.height - 15;
			main.x =  -4;
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
				live.x = - 4;
			}
			live.y = 0;// factTime.y - live.height - 15;
		}
		
		private function addBillet():void
		{
			var h:Number = factTitleBmp.y +factTitleBmp.height;// ownHeight ? height + 40 : 240;
			billet = Tool.createShape(width + 80, h, 0xFFFF00);
			addChild(billet);
			//billet.y = -40;
			billet.x = -50;
			billet.alpha = 0;
		}
		
		public function over():void
		{
			TweenLite.to(factTitleBmp, 0.4, {y: initFT-13});
			TweenLite.to(factTime, 0.4, {colorTransform: {tint: 0xfff000, tintAmount: 1}});
		}
		
		public function out():void
		{
			TweenLite.to(factTitleBmp, 0.4, {y: initFT});
			TweenLite.to(factTime, 0.4, {colorTransform: {tint: 0X193a2c, tintAmount: 1}});
		}
	}

}
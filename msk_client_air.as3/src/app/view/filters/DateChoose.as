package app.view.filters
{
	import app.assets.Assets;
	import app.view.baseview.io.InteractiveButton;
	import app.view.baseview.io.InteractiveObject;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.easing.Back;
	import com.greensock.easing.Ease;
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class DateChoose extends InteractiveObject
	{
		private var krug1:Sprite;
		private var krug2:Sprite;
		private var center:Sprite;
		
		private var centerHeight:int = 480;
		private var chooseDateText:TextField;
		
		private var sliderDay:FilterSlider;
		private var sliderMonth:FilterSlider;
		private var sliderYear:FilterSlider;
		
		private var okButton:InteractiveButton;
		private var overButton:InteractiveObject;
		
		private var square:Shape;
		private static const START_YEAR:int = 2013;
		private var okButtonFill:Shape;
		
		public function DateChoose()
		{
			square = Tool.createShape(490, 900, 0x02a7df);
			square.y = 704;
			square.height = 10;
			square.x = 4;
			addChild(square);
			
			krug1 = Assets.create("half_krug1");
			addChild(krug1);
			
			krug2 = Assets.create("half_krug2");
			addChild(krug2);
			krug2.y = krug1.height;
			visible = false;
			
			center = new Sprite();
			addChild(center);
			center.y = 0.5 * (504 - center.height);
			
			var shape:Shape = Tool.createShape(47, 11, 0xffffff);
			center.addChild(shape);
			shape = Tool.createShape(47, 11, 0xffffff);
			shape.x = 504 - shape.width;
			center.addChild(shape);
			
			var textFormat:TextFormat = new TextFormat("Tornado", 18, 0x02a7df);
			textFormat.align = "center";
			chooseDateText = TextUtil.createTextField(0, 0);
			chooseDateText.width = 200;
			chooseDateText.multiline = true;
			chooseDateText.wordWrap = true;
			chooseDateText.text = "Нажмите, чтобы выбрать дату";
			chooseDateText.setTextFormat(textFormat);
			addChild(chooseDateText);
			
			chooseDateText.x = 0.5 * (width - chooseDateText.width);
			chooseDateText.y = 0.5 * (height - chooseDateText.height) + 230;
			
			drawLine(0, -710, krug1.height - 83);
			drawLine(0, -710, krug1.height + 100);
			drawLine(0, -710, krug1.height + 248);
			
			drawLine(krug1.width, krug1.width + 710, krug1.height - 83);
			drawLine(krug1.width, krug1.width + 710, krug1.height + 100);
			drawLine(krug1.width, krug1.width + 710, krug1.height + 248);
			
			okButton = new InteractiveButton();
			okButton.downEnabled = false;
			okButton.name = "close";
			okButton.alpha = 0;
			
			var okButtonFill:Shape = Tool.createShape(krug1.width, 850, 0xff0000);
			okButtonFill.y -= 200;
			okButton.addChild(okButtonFill);
			
			sliderDay = new FilterSlider("day", 120, 231);
			addChild(sliderDay);
			
			sliderMonth = new FilterSlider("month", 45, 65);
			sliderMonth.y = 320;
			addChild(sliderMonth);
			
			sliderYear = new FilterSlider("year", 76.5, 76.5);
			sliderYear.y = 460;
			addChild(sliderYear);
			
			addChild(okButton);
			
			var squareMask:Sprite = makeCapsule();
			addChild(squareMask);
			square.mask = squareMask;
		}
		
		public function getFilteredDate():String
		{
			var day:String = (sliderDay.currentID + 1).toString();
			var month:String = (sliderMonth.currentID + 1).toString();
			var year:String = sliderYear.year[sliderYear.currentID].toString();
			
			if (day.length == 1)
				day = "0" + day;
			
			if (month.length == 1)
				month = "0" + month;
			
			return day + "." + month + "." + year;
		}
		
		private function makeCapsule():Sprite
		{
			var fill:Sprite = new Sprite();
			
			var circle1:Shape = new Shape();
			circle1.graphics.beginFill(0xff0000);
			circle1.graphics.drawCircle(krug1.height, 0, krug1.height);
			fill.addChild(circle1);
			
			var circle2:Shape = new Shape();
			circle2.graphics.beginFill(0xff0000);
			circle2.graphics.drawCircle(krug1.height, krug1.width, krug1.height);
			fill.addChild(circle2);
			
			var okButtonFill:Shape = Tool.createShape(krug1.width, 450, 0xff0000);
			fill.addChild(okButtonFill);
			circle1.y += 70;
			circle2.y -= 70;
			
			return fill;
		}
		
		private function drawLine(from:Number, to:Number, y:Number):void
		{
			var line:Shape = new Shape();
			line.graphics.lineStyle(2, 0xffffff, 0.1);
			line.graphics.moveTo(from, y);
			line.graphics.lineTo(to, y);
			addChild(line);
		}
		
		public function over():void
		{
			TweenLite.delayedCall(1, animateFill);
		}
		
		private function animateFill():void
		{
			if (!square)
				return;
			var time:Number = 1.3;
			TweenLite.to(square, time, {y: -204, height: 900, ease: Back.easeOut});
		}
		
		public function out():void
		{
			TweenLite.killDelayedCallsTo(animateFill);
			var time:Number = 1.3;
			TweenLite.to(square, time, {y: 704, height: 10, ease: Back.easeOut});
		}
		
		public function hide():void
		{
			visible = false;
		}
		
		public function show(currentDate:String, date:String = ""):void
		{
			var dateArray:Array;
			
			if (date)
			{
				dateArray = date.split(".");
				
				if (dateArray[2] >= START_YEAR)
					sliderYear.setIndex(dateArray[2] - START_YEAR);
			}
			else if (currentDate)
			{
				dateArray = currentDate.split(".");
				
				var currentDateYear:String = currentDate.split(".")[2];
				var num:int = int(currentDateYear) - START_YEAR + 1;
				if (num > 0)
				{
					sliderYear.initIncrease(START_YEAR, num, "year", 76.5, 76.5);
					sliderYear.setIndex(num - 1);
				}
			}
			
			sliderDay.setIndex(dateArray[0] - 1);
			sliderMonth.setIndex(dateArray[1] - 1);
			
			krug1.y = 0;
			krug2.y = krug1.height;
			center.y = krug1.height;
			center.height = 10;
			chooseDateText.alpha = 0;
			visible = true;
			
			var time:Number = 1.3;
			var ease:Ease = Expo.easeOut;
			
			TweenLite.to(krug1, time, {y: "-215", ease: ease});
			TweenLite.to(krug2, time, {y: "215", ease: ease});
			TweenLite.to(center, time, {height: "430", y: -215 + krug1.height, ease: ease});
			TweenLite.to(chooseDateText, time, {alpha: 1, ease: ease});
		}
	}
}
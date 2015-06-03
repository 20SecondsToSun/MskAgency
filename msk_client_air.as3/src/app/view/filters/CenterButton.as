package app.view.filters
{
	import app.AppSettings;
	import app.contoller.events.InteractiveEvent;
	import app.view.baseview.io.InteractiveButton;
	import app.view.utils.DrawingShapes;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.easing.Back;
	import com.greensock.easing.Quint;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class CenterButton extends InteractiveButton
	{
		static public const RADIUS:int = 190;
		static public const FULL_CIRCLE:int = 360;
		public var date:String = "";
		public var lastDate:String = "";
		
		private var newsTextDef:TextField;
		
		private var dayText:TextField;
		private var monthText:TextField;
		private var yearText:TextField;
		private var dateArray:Array;
		private var square:Shape;
		private var squareMask:Shape;
		private var chooseDateText:TextField;
		
		private var percent:Number = 0;
		private var endDegree:Number = 0;
		private var center:Shape;
		private var sign:int = 1;
		
		private var textFormat:TextFormat = new TextFormat("Tornado", 34, 0xffffff);
		private var textFormatLight:TextFormat = new TextFormat("TornadoL", 121, 0xffffff);
		
		private var dateHolder:Sprite = new Sprite();
		
		public function CenterButton()
		{			
			center = new Shape();
			addChild(center);
			
			squareMask = new Shape();
			squareMask.graphics.beginFill(0xffffff);
			squareMask.graphics.drawCircle(RADIUS, RADIUS, RADIUS);
			addChild(squareMask);			
			
			square = Tool.createShape(RADIUS * 2, RADIUS * 2, 0x02a7df);
			square.height = 1;
			square.y = squareMask.height
			addChild(square);
			
			square.mask = squareMask;
			
			x = 0.5 * (AppSettings.WIDTH - width);
			y = 0.5 * (AppSettings.HEIGHT - height);
			
			textFormat.align = "center";
			textFormatLight.align = "center";			
		
			newsTextDef = TextUtil.createTextField(0, 0);			
			newsTextDef.width = 250;
			newsTextDef.multiline = true;
			newsTextDef.wordWrap = true;
			newsTextDef.autoSize = TextFieldAutoSize.CENTER;
			newsTextDef.text = "Новости\nза все время";			
			newsTextDef.setTextFormat(textFormat);			
			newsTextDef.x = 0.5 * (width - newsTextDef.width);
			newsTextDef.y = 0.5 * (height - newsTextDef.height) - 20;			
			newsTextDef.visible = false;
			addChild(newsTextDef);		
		
			dayText = TextUtil.createTextField(0, 0);
			dayText.text = "12"; // dateArray[0];			
			dateHolder.addChild(dayText);
			
			textFormatLight.size = 34.4;
			monthText = TextUtil.createTextField(0, 0);
			monthText.text = "мая"; // TextUtil.month[dateArray[1] - 1].toLowerCase();			
			dateHolder.addChild(monthText);			
		
			yearText = TextUtil.createTextField(0, 0);
			yearText.text = "2013"; //dateArray[2] ;				
			yearText.alpha = 0.4;			
			dateHolder.addChild(yearText);
			
			textFormat.size = 18;
			textFormat.color = 0x02a7df;
			
			chooseDateText = TextUtil.createTextField(0, 0);
			chooseDateText.width = 200;
			chooseDateText.multiline = true;
			chooseDateText.wordWrap = true;
			chooseDateText.autoSize = TextFieldAutoSize.CENTER;
			chooseDateText.text = "Нажмите, чтобы выбрать дату";
			
			chooseDateText.setTextFormat(textFormat);
			addChild(chooseDateText);
			chooseDateText.x = 0.5 * (width - chooseDateText.width);
			chooseDateText.y = 0.5 * (height - chooseDateText.height) + 120;
			
			var splash:Shape = new Shape();
			splash.graphics.beginFill(0xffffff);
			splash.graphics.drawCircle(RADIUS, RADIUS, RADIUS);
			splash.alpha = 0;
			addChild(splash);
			
			addChild(dateHolder);
		}
		
		public function show(_date:String = ""):void
		{
			//_date = "07.10.2013";
			if (_date)
			{
				date = _date;
				//trace("DATE", date);
				dateArray = date.split(".");
				
				textFormatLight.size = 121;				
				dayText.text = dateArray[0];				
				dayText.setTextFormat(textFormatLight);
				dayText.x = 0.5 * (width - dayText.width);
				dateHolder.y = 0.5 * (height - dayText.height) - 100;
				
				textFormatLight.size = 34.4;					
				monthText.text = TextUtil.month[dateArray[1] - 1].toLowerCase();
				monthText.setTextFormat(textFormatLight);
				monthText.x = 0.5 * (width - monthText.width);
				monthText.y = 0.5 * (height - monthText.height) - 20;
				
				yearText.text = dateArray[2];
				yearText.setTextFormat(textFormatLight);
				yearText.x = 0.5 * (width - yearText.width);
				yearText.y = 0.5 * (height - yearText.height) + 40;
				
				dayText.visible = true;
				monthText.visible = true;
				yearText.visible = true;
				newsTextDef.visible = false;			
			}
			else
			{
				dayText.visible = false;
				monthText.visible = false;
				yearText.visible = false;
				
				newsTextDef.visible = true;
				date = "";
			}
			
			alpha = 0;
			visible = true;
			
			TweenLite.to(this, 0.8, {alpha: 1, ease: Quint.easeInOut});		
		}
		
		public function hide():void
		{
			this.alpha = 0;
		}
		
		public function over():void
		{		
			if (!date)
			{
				TweenLite.killTweensOf(newsTextDef);
				TweenLite.to(newsTextDef, 0.8, {y: 0.5 * (380 - newsTextDef.height), ease: Back.easeOut});
			}
			else
			{					
				TweenLite.killTweensOf(dateHolder);				
				TweenLite.to(dateHolder, 0.8, { y: - 0.5 * (dateHolder.height - 380), ease: Back.easeOut } );				
			}
			TweenLite.to(square, 0.8, {y: 0, height: RADIUS * 2 + 10, ease: Back.easeOut});		
		}
		
		public function out():void
		{
			if (!date)
			{
				TweenLite.killTweensOf(newsTextDef);
				TweenLite.to(newsTextDef, 0.8, {y: 0.5 * (380 - newsTextDef.height) - 20, ease: Back.easeOut});
			}
			else
			{				
				TweenLite.killTweensOf(dateHolder);				
				TweenLite.to(dateHolder, 0.8, { y:20.95, ease: Back.easeOut } );				
			}
			
			TweenLite.to(square, 0.8, {y: squareMask.height, height: 1, ease: Back.easeOut});
		}
		
		private function fill(e:Event):void
		{
			percent += sign;
			
			endDegree = FULL_CIRCLE * percent * 0.03;
			
			if (endDegree > FULL_CIRCLE || endDegree < 0)
			{
				if (endDegree > FULL_CIRCLE)
					endDegree = FULL_CIRCLE;
				else if (endDegree < 0)
					endDegree = 0;
				
				center.graphics.clear();
				center.graphics.beginFill(0x02a7df);
				DrawingShapes.drawWedge(center.graphics, 0.5 * width, 0.5 * height, RADIUS, endDegree, 0, RADIUS);
				removeEventListener(Event.ENTER_FRAME, fill);
				return;
			}
			
			center.graphics.clear();
			center.graphics.beginFill(0x02a7df);
			DrawingShapes.drawWedge(center.graphics, 0.5 * width, 0.5 * height, RADIUS, endDegree, 0, RADIUS);
		}
	}
}
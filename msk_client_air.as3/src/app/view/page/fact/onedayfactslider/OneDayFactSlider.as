package app.view.page.fact.onedayfactslider
{
	import app.AppSettings;
	import app.model.datafact.DateInfo;
	import app.model.materials.Fact;
	import app.view.baseview.slider.Slider;
	import app.view.page.fact.factsslider.OneFactPageGraphic;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.TweenLite;
	import flash.display.CapsStyle;
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
	public class OneDayFactSlider extends Slider
	{
		private static const isPreview:Boolean = true;
		private static const isShowFullTime:Boolean = true;
		
		private var day:Vector.<Fact>;
		private var _dateInfo:DateInfo;
		private var _color:uint;
		private var _fon:Sprite;
		private var line:Shape;
		
		private static const SHIFT_Y:int = 84;
		private static const SHIFT_X:int = 210;
		public static const HEIGHT:int = 345;
		private static const WIDTH:int = 178;
		private static const WIDTH_BLOCK:int = 377;
		
		private var datecolor:uint;
		public var over:Shape;
		
		private static const INIT_NUM_TO_SHOW:int = 5;
		private static const OFFSET_NUM_TO_SHOW:int = 5;
		private var NOW_NUM_SHOWING:int = 0;
		private var ALL_NUM:int = 0;
		private var factTitleColor:uint;
		private var offset:Number = 0;
		
		public function get dateInfo():DateInfo
		{
			return _dateInfo;
		}
		
		public function set dateInfo(value:DateInfo):void
		{
			_dateInfo = value;
		}
		
		public function OneDayFactSlider(_day:Vector.<Fact>, _dateInfo:DateInfo, direction:String = "", isSplash:Boolean = false ):void
		{
			if (!isSplash)
			{
				day = _day;
				dateInfo = _dateInfo;
			}
			
			super(new Rectangle(SHIFT_X, SHIFT_Y, AppSettings.WIDTH, HEIGHT));
			holder.x = SHIFT_X;
			holder.y = SHIFT_Y;
			
			_fon = new Sprite();
			addChild(_fon);
			swapChildren(_fon, holder);
			
			var fon:Shape = Tool.createShape(AppSettings.WIDTH, HEIGHT, 0x509338);
			_fon.addChild(fon);
			
			var polosa:Shape = Tool.createShape(WIDTH, HEIGHT, 0x1a1b1f);
			_fon.addChild(polosa);
			
			factTitleColor = 0xffffff;
			
			if (isSplash) return;
			
			switch (dateInfo.futurePastCurrent)
			{
				case "CURRENT": 
					datecolor = 0xffffff;
					Tool.changecolor(fon, 0x5c9f42);
					Tool.changecolor(polosa, 0x2b2c32);
					break;
				
				case "PAST": 
					datecolor = 0xb8b9c0;
					addLine(new Point(0, 0), new Point(WIDTH, 0), 0x000000);
					addLine(new Point(WIDTH, 0), new Point(AppSettings.WIDTH, 0), 0x4b8735);
					over = Tool.createShape(AppSettings.WIDTH, HEIGHT, 0x000000);
					over.alpha = direction != "TO_PAST" ? 0.68 : 0;
					addChild(over);
					Tool.changecolor(fon, 0x447631);
					factTitleColor = 0xdce8d8;
					break;
				
				case "FUTURE": 
					datecolor = 0xb8b9c0;
					addLine(new Point(0, 1), new Point(WIDTH, 1), 0x000000);
					addLine(new Point(WIDTH, 1), new Point(AppSettings.WIDTH, 1), 0x5c9f42);
					break;
				
				default: 
			}
			addDate();
			
			//{ region 		
			
			ALL_NUM = day.length;
			NOW_NUM_SHOWING = ALL_NUM > INIT_NUM_TO_SHOW ? INIT_NUM_TO_SHOW : ALL_NUM;			
			addBlockElements(0, NOW_NUM_SHOWING);
		
			//} endregion
		
		}
		
		private function addBlockElements(_offset:int, _limit:int):void
		{			
			const shift:int = 30;
			for (var i:int =_offset; i < _limit; i++)
			{
				var oneHour:OneFactPageGraphic = new OneFactPageGraphic(day[i], factTitleColor, dateInfo.thisDate);				
				oneHour.currentDate = dateInfo.thisDate;
				oneHour.x = offset;
				oneHour.setY();
				offset += WIDTH_BLOCK + shift;
				addElement(oneHour);				
			}			
		}
		
		override protected function checkElementsToAdd():Boolean
		{
			if (NOW_NUM_SHOWING == ALL_NUM)
				return false;
			
			var len:int;
			
			if (NOW_NUM_SHOWING + OFFSET_NUM_TO_SHOW < ALL_NUM)
			{
				len = NOW_NUM_SHOWING + OFFSET_NUM_TO_SHOW;
			}
			else
			{
				len = ALL_NUM;
			}
			
			addBlockElements(NOW_NUM_SHOWING, len);
			NOW_NUM_SHOWING = len;
			
			return true;
		
		}
		
		public function lightPast():void
		{
			if (over)
				TweenLite.to(over, 0.5, {alpha: 0});
		}
		
		public function darkPast():void
		{
			if (over)
				TweenLite.to(over, 0.5, {alpha: 0.68});
		}
		
		override public function startInteraction():void
		{
			if (holder.width > AppSettings.WIDTH )
			{
				super.startInteraction();
				isPause = true;
			}
		}
		
		private function addDate():void
		{
			var date:Array = dateInfo.thisDate.split(".");
			var textFormat:TextFormat = new TextFormat("TornadoL", 72, datecolor);
			
			var textTitle:TextField = TextUtil.createTextField(0, 66);
			textTitle.multiline = false;
			textTitle.wordWrap = false;
			textTitle.text = date[0];
			textTitle.setTextFormat(textFormat);
			textTitle.x = 0.5 * (WIDTH - textTitle.width);
			_fon.addChild(textTitle);
			
			textFormat.size = 18;
			
			var textDay:TextField = TextUtil.createTextField(0, 142);
			textDay.multiline = false;
			textDay.wordWrap = false;
			var hourtext:String = TextUtil.month[int(date[1]) - 1];
			textDay.text = hourtext;
			textDay.setTextFormat(textFormat);
			textDay.x = 0.5 * (WIDTH - textDay.width);
			_fon.addChild(textDay);
		}
		
		public function addLine(point1:Point, point2:Point, color:uint):void
		{
			line = new Shape();
			line.graphics.lineStyle(2, color, 1, false, "normal", CapsStyle.NONE);
			line.graphics.moveTo(point1.x, point1.y);
			line.graphics.lineTo(point2.x, point2.y);
			_fon.addChild(line);
		}
	
	}

}
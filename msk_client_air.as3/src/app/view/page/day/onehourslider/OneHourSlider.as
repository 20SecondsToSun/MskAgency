package app.view.page.day.onehourslider 
{
	import app.AppSettings;
	import app.model.materials.Material;
	import app.view.allnews.OneHourGraphic;
	import app.view.baseview.slider.Slider;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class OneHourSlider extends Slider
	{
		private static const isPreview:Boolean = true;
		private static const isShowFullTime:Boolean = true;
		
		private var hour:Vector.<Material>;
		private var _color:uint;
		private var fon:Shape;
		private var line:Shape;
		
		private static const SHIFT_Y:int = 84;
		private static const SHIFT_X:int = 240;
		
		public function OneHourSlider(_hour:Vector.<Material>,isDarkColor:Boolean) 
		{
			super(new Rectangle(SHIFT_X, SHIFT_Y, AppSettings.WIDTH - 98, 345));			
			holder.x = SHIFT_X;
			holder.y = SHIFT_Y;
			
			hour = _hour;			
			_color = isDarkColor? 0x1a1b1f:0x101114;			
			
			fon = Tool.createShape(AppSettings.WIDTH, 345, _color);			
			addChild(fon);
			swapChildren(fon, holder);				
			
			addHourTitle();			
			
			var offset:int = 0;
			const shift:int = 30;
			const WIDTH_BLOCK:int = 377;
			var _widthBlock:int = 377;
			
			
			for (var i:int = 0; i < _hour.length; i++) 
			{
				var oneHour:OneHourGraphic = new OneHourGraphic(_hour[i], i == 0, isPreview, isShowFullTime );	
				oneHour._color = _color;
				oneHour.x = offset;
				
				if (_hour[i].type == "video" || _hour[i].type == "photo")_widthBlock = WIDTH_BLOCK * 2 + shift;					
				else _widthBlock = 	WIDTH_BLOCK;	
				
				offset += _widthBlock + shift;	
				
				oneHour.showMainLive();
				addElement(oneHour);
			}
			
			addLine();			
			setChildIndex(line, 1);
			
		}
		private function addHourTitle():void
		{
			var textFormat:TextFormat = new TextFormat("TornadoL", 72 , 0X7b8193);			
			
			var textTitle:TextField = TextUtil.createTextField(61, 82);
			textTitle.multiline = false;
			textTitle.wordWrap = false;
			textTitle.width = 210;
			
			textTitle.text = hour[0].publishedDate.getHours().toString();
			
			textTitle.setTextFormat(textFormat);			
			addChild(textTitle);
			
			textFormat.size = 18;
			
			var textHour:TextField = TextUtil.createTextField(70, 152);
			textHour.multiline = false;
			textHour.wordWrap = false;
			textHour.width = 210;
			
			var hourtext:String = TextUtil.hourInRussian(textTitle.text);
			textHour.text = hourtext;
			
			textHour.setTextFormat(textFormat);		
			textHour.x = .5 * (textTitle.width - textHour.width) + textTitle.x;
			
			addChild(textHour);			
		}
		
		public function addLine():void 
		{
			line = new Shape();			
			line.graphics.lineStyle(2, 0x000000, .75);			 
			line.graphics.moveTo(SHIFT_X, 33 + SHIFT_Y);					
			line.graphics.lineTo(width + 35, 33 + SHIFT_Y);			
			addChild(line);
		}
		
	}

}
package app.view.page.days.onedayslider 
{
	import app.AppSettings;
	import app.model.materials.Material;
	import app.view.allnews.OneHourGraphic;
	import app.view.baseview.slider.Slider;
	import app.view.HELPTEMPSCREEN.minislider.MiniSlider;
	import app.view.utils.Tool;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class OneDaySlider extends Slider
	{
		private static const INIT_NUM_TO_SHOW:int = 5;
		private static const OFFSET_NUM_TO_SHOW:int = 5;
		private var NOW_NUM_SHOWING:int = 0;
		private var ALL_NUM:int = 0;
		
		private static const isPreview:Boolean = true;
		private static const isShowFullTime:Boolean = true;
		
		public var day:Vector.<Material>;
		private var _color:uint;
		private var fon:Shape;
		private var line:Shape;
		
		private static const SHIFT_Y:int = 84;
		private static const SHIFT_X:int = 210;
		public static const HEIGHT:int = 345;	
		private static const WIDTH_BLOCK:int = 377;
		private var dateButton:DateButton;
		
		private const shift:int = 30;	
		private var offset:int = 0;	
		
		private var initY:Number = 0;
		private var minHeight:int = 279;
		private var maxHeight:int = 405;
		
		public function OneDaySlider(_day:Vector.<Material>, isDarkColor:Boolean, id:int) 		
		{
			super(new Rectangle(SHIFT_X, SHIFT_Y, AppSettings.WIDTH, HEIGHT));			
			holder.x = SHIFT_X;
			holder.y = SHIFT_Y;
			
			day = _day;			
			_color = isDarkColor? 0x1a1b1f: 0x101114;			
			
			fon = Tool.createShape(AppSettings.WIDTH, HEIGHT, _color);			
			addChild(fon);
			swapChildren(fon, holder);				
			
			dateButton = new DateButton(day[0].publishedDate, id);			
			addChild(dateButton);
			
			ALL_NUM = day.length;
			NOW_NUM_SHOWING = ALL_NUM > INIT_NUM_TO_SHOW ? INIT_NUM_TO_SHOW : ALL_NUM;	
			addBlockElements(0, NOW_NUM_SHOWING);			
			
			addLine();			
			initY = this.y;			
		}
		
		public function setY( _y:Number):void
		{
			initY = _y;
		}
		
		private function addBlockElements(_offset:int, _limit:int):void
		{		
			var _widthBlock:int = 377;	
			
			for (var i:int = _offset; i < _limit ; i++) 
			{
				var oneHour:OneHourGraphic = new OneHourGraphic(day[i], i == 0, isPreview, isShowFullTime );	
				oneHour._color = _color;
				oneHour.x = offset;
				
				if (day[i].type == "video" || day[i].type == "photo") _widthBlock = WIDTH_BLOCK * 2 + shift;					
				else _widthBlock = 	WIDTH_BLOCK;	
				
				offset += _widthBlock + shift;				
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
			
			setChildIndex(line, 1);
			
			return true;		
		}
		
		public function stretch(percent:Number):void
		{			
			parent.setChildIndex(this, parent.numChildren - 1);
			
			var changeHeight:Number = minHeight + (maxHeight - minHeight) * percent * 1.2;			
			var scale:Number = changeHeight / minHeight;
			
			var _y:Number = -parent.parent.y*percent + /*AppSettings.HEIGHT * 0.5 */initY * (1 - percent);//initY+(globalToLocal(new Point(0, AppSettings.HEIGHT * 0.5)).y - initY) * percent;
			
			if (percent >= 1)
			{
				scale = changeHeight / minHeight + 0.5 + 5;
				holder.visible = false;
				TweenLite.to(holder, 0.4, { alpha:0 } );
				TweenLite.to(this,   0.8, { colorTransform: { tint:_color, tintAmount:1 }, scaleX: scale, scaleY: scale, y: -parent.parent.y - 500 , x: -AppSettings.WIDTH * (scale - 1) * 0.5, onComplete: endStretch } );
				return;
			}
			
			TweenLite.to(this, 0.5, { scaleX: scale, scaleY: scale, y: _y/*initY + (changeHeight - minHeight) * 0.5*/, x: -AppSettings.WIDTH * (scale - 1) * 0.5 } );	
		}
		
		private function endStretch():void
		{
			holder.visible = false;
			dateButton.push();
		}
		
		public function addElements(_day:Vector.<Material>):void
		{
			day = day.concat(_day);	
			ALL_NUM = day.length;
			
			if (NOW_NUM_SHOWING < INIT_NUM_TO_SHOW)
			{
				var offset:int = NOW_NUM_SHOWING;
				NOW_NUM_SHOWING = ALL_NUM > INIT_NUM_TO_SHOW ? INIT_NUM_TO_SHOW : ALL_NUM;	
				addBlockElements(offset, NOW_NUM_SHOWING);	
			}	
		}
		
		override public function startInteraction():void
		{
			if (holder.width > AppSettings.WIDTH )
			{				
				super.startInteraction();
				isPause = true;
			}
		}
		
		public function addLine():void 
		{
			line = new Shape();			
			line.graphics.lineStyle(2, 0x000000, .75);			 
			line.graphics.moveTo(SHIFT_X, 33 + SHIFT_Y);					
			line.graphics.lineTo(width + 35, 33 + SHIFT_Y);			
			addChild(line);
			setChildIndex(line, 1);
		}			
	}
}
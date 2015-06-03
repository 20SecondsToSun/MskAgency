package app.view.filters
{
	import app.assets.Assets;
	import app.contoller.events.FilterEvent;
	import app.contoller.events.InteractiveEvent;
	import app.model.datafilters.Rubric;
	import app.view.baseview.io.InteractiveButton;
	import app.view.utils.DrawingShapes;
	import app.view.utils.TextUtil;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FilterButton extends InteractiveButton
	{
		public var data:Rubric;
		
		public var isSelect:Boolean = false;
		public var filtersID:Array = [7, 5, 9, 10, 11, 3];	
		public var id:int;
		public var index:int;
		
		public function FilterButton(i:int, _color:uint)
		{
			id = filtersID[i];
			index = i + 1;
			name = "filter" + (i + 1).toString();	
			
			alpha = 0;		
			
			var btn:Shape = new Shape();
			btn.graphics.clear();
			btn.graphics.beginFill(_color);
			DrawingShapes.drawWedge(btn.graphics, 252, 252, Circle.RADIUS2 + 400, Circle.SECTOR, Circle.SECTOR * i + 90, Circle.RADIUS2 + 400);			
			addChild(btn);			
		}
		
		public function select(e:FilterEvent):void
		{			
			if( int(e.data.id) == id)
			{				
				isSelect = true;
				alpha = 0;			
				TweenLite.to(this, 0.5, { alpha:Circle.buttons[index - 1].alpha } );		
			}
		}
		
		public function diselect(e:FilterEvent):void
		{
			if (!isSelect) return;
		
			isSelect = false;
			TweenLite.to(this, 0.5, {alpha: 0});
		}
		
		public function over(e:InteractiveEvent):void
		{
			if (isSelect) return;
			
			alpha = 0;			
			TweenLite.to(this, 0.5, { alpha:Circle.buttons[index - 1].alpha } );			
		}
		
		public function out(e:InteractiveEvent):void
		{
			if (isSelect) return;
			TweenLite.to(this, 0.5, {alpha: 0});
		}
	}
}
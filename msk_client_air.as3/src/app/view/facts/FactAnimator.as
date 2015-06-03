package app.view.facts
{
	import app.AppSettings;
	import app.view.baseview.io.InteractiveObject;
	import app.view.utils.Tool;
	import com.greensock.easing.Quart;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FactAnimator extends Sprite
	{
		static public const ANIMATION_DELAY_TIME:int = 8;
		
		private var blist:Vector.<Bitmap>;
		private var index:int = 0;
		
		public function FactAnimator(list:Vector.<FactsGraphic>)
		{
			trace("CREATE FACT ANIMATOR!!!!!!!!");
			blist = new Vector.<Bitmap>();
			
			for (var i:int = 0; i < list.length; i++)
			{
				var bd:BitmapData = new BitmapData(list[i].width, list[i].height);
				bd.draw(list[i]);
				
				blist.push(new Bitmap(bd));
				blist[i].x = 0;
			}
			
			x = AppSettings.WIDTH - 410;
			
			var fon:Shape = Tool.createShape(500, 410, 0x5c9f42);
			fon.y = 100;
			addChild(fon);
			
			var _mask:Shape = Tool.createShape(500, 410, 0x5c9f42);
			_mask.y = 100;
			addChild(_mask);
			this.mask = _mask;
			
			change();
		}
		
		private function wait():void
		{
			TweenLite.delayedCall(ANIMATION_DELAY_TIME, change);
		}
		private var prev:Bitmap;
		private var cur:Bitmap;
		
		private function change():void
		{	
			if (prev && contains(prev))			
				removeChild(prev);			
			
			if (cur && contains(cur))			
				removeChild(cur);			
			
			prev = blist[index];
			index = nextIndex();
			
			cur = blist[index];
			
			cur.y = -400;
			
			addChild(cur);			
			addChild(prev);
			
			TweenLite.to(prev, 0.8, {y: 450,  ease: Quart.easeInOut, onComplete: function():void
				{
					wait();
				}});
				
			TweenLite.to(cur, 0.8, {y: 0, ease: Quart.easeInOut});
		}

		
		public function kill():void
		{
			TweenLite.killDelayedCallsTo(change);
		
			for (var i:int = 0; i < blist.length; i++)			
				blist[i].bitmapData.dispose();			
			
			InteractiveObject.removeAllChildren(this);			
		}
		
		private function nextIndex():int
		{
			return (index + 1) % blist.length;
		}	
	}
}
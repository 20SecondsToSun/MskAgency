package app.view.popup
{
	import app.AppSettings;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.IpadEvent;
	import app.model.materials.Fact;
	import app.model.materials.Material;
	import app.view.baseview.io.InteractiveButton;
	import app.view.baseview.io.InteractiveObject;
	import app.view.utils.Tool;
	import com.greensock.easing.Back;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class IpadPopup extends InteractiveObject
	{
		private var tint:InteractiveButton = new InteractiveButton();
		private var isOpen:Boolean;
		private var closeBtn:CloseButton;
		
		private var newsHolder:IpadNewBody;
		private var screenshot:Sprite;
		private var matrix:Matrix = new Matrix(1, 0, 0, 1, 0);
		
		public function IpadPopup()
		{
			visible = false;			
			
			var tintFill:Shape = Tool.createShape(AppSettings.WIDTH, AppSettings.HEIGHT, 0x1a1b1f);
			tint.alpha = 0;			
			
			addChild(tint);
			tint.addChild(tintFill);			
			
			closeBtn = new CloseButton();
			closeBtn.x = AppSettings.WIDTH - closeBtn.width - 110;
			closeBtn.y = 110;
			addChild(closeBtn);
			
			screenshot = new Sprite();
			screenshot.x = 311;
			addChild(screenshot);		
		}
		
		public function show(event:IpadEvent):void
		{
			var isMaterial:Boolean = false;
			if (event.data.type == "Material")
				isMaterial = true;
			else
				isMaterial = false;
				
			if (isOpen == false)
			{				
				newsHolder = new IpadNewBody();
				newsHolder.x = 311;
				addChild(newsHolder);
				
				isOpen = true;
				visible = true;
				newsHolder.y = AppSettings.HEIGHT;
				
				if (isMaterial)
				{
					newsHolder.refreshAsMaterial(event.data.value as Material);
				}
				else
				{					
					newsHolder.refreshAsFact(event.data.value as Fact);
				}
				
				TweenLite.to(tint, 0.5, {alpha: 0.80});
				TweenLite.to(newsHolder, 0.8, {y: 0, ease: Back.easeOut});
				closeBtn.alpha = 0;
				TweenLite.to(closeBtn, 0.5, {alpha: 1});
			}
			else
			{
				screenshot.y = 0;
				var bd:BitmapData = new BitmapData(1298, AppSettings.HEIGHT);
				bd.draw(newsHolder, matrix);
				screenshot.addChild(new Bitmap(bd));
				
				newsHolder.y = AppSettings.HEIGHT;
				
				if (isMaterial)
					newsHolder.refreshAsMaterial(event.data.value as Material);
				else
					newsHolder.refreshAsFact(event.data.value as Fact);
				
				TweenLite.to(newsHolder, 0.8, {delay: 0.3, y: 0, ease: Back.easeOut});
				TweenLite.to(screenshot, 0.8, {y: -AppSettings.HEIGHT, onComplete: finishAnimation, ease: Back.easeOut});
			}
		}
		
		private function finishAnimation():void
		{
			Tool.removeAllChildren(screenshot);
		}
		
		public function hide(e:ChangeLocationEvent = null):void
		{
			if (!isOpen ) return;
			isOpen = false;
			TweenLite.to(tint, 0.5, {alpha: 0, onComplete: function():void
				{
					visible = false;					
					dispatchEvent(new ChangeLocationEvent(ChangeLocationEvent.IPAD_POPUP_IS_HIDDEN));
				}});
			
			screenshot.y = 0;
			
			var bd:BitmapData = new BitmapData(1298, AppSettings.HEIGHT);
			bd.draw(newsHolder, matrix);
			screenshot.addChild(new Bitmap(bd));
			
			TweenLite.to(screenshot, 0.8, {y: -AppSettings.HEIGHT, ease: Back.easeOut});
			removeChild(newsHolder);
			
			TweenLite.to(closeBtn, 0.5, {alpha: 0});		
		}	
	}
}
package ipad.view.slider
{
	import app.model.materials.Fact;
	import app.view.utils.TextUtil;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ipad.assets.Assets;
	import ipad.controller.IpadConstants;
	import ipad.view.OneFactIpad;

	public class ElementFact extends Sprite
	{
		public var isActive:Boolean = false;
		public var mat:Fact;
		private var _width:int = 628;
		private var _height:int = 415;
		private var clip:Sprite;
		public var oneHour:OneFactIpad;
		private var clip2:Sprite;
		private var textFormat:TextFormat = new TextFormat("Tornado", 26 * IpadConstants.contentScaleFactor, 0x02a5dc);	
		private var closeFav:Sprite;
		public var id:int;
		
		
		public function ElementFact(mat:Fact)
		{
			doubleClickEnabled = true;
			
			this.mat = mat;
			id = mat.id;
			
			_width *= IpadConstants.contentScaleFactor;
			_height *= IpadConstants.contentScaleFactor;
			
			oneHour = new OneFactIpad(mat); //OneNewIpad(mat, true, false, true);
			addChild(oneHour);
			oneHour.scaleX = 0.8;
			oneHour.scaleY = 0.8;
			oneHour.x = 35;
			oneHour.y = 40;
			oneHour.mouseEnabled = false;	
			
			
			closeFav = new Sprite();
			closeFav.name = "closeFav";
			
			var image:Sprite= Assets.create("closeFavEvents");		
			image.mouseChildren = false;
			image.mouseEnabled = false;
			closeFav.addChild(image);
			
			closeFav.scaleX = 
			closeFav.scaleY = 0.8;	
			
			closeFav.x = width - closeFav.width;	
			closeFav.y = oneHour.factTime.y + oneHour.factTime.height - closeFav.height +40;	
			
			addChild(closeFav);
			closeFav.visible = false;
			
			
			clip = new Sprite();
			clip.graphics.beginFill(0x5c9f42);
			clip.graphics.drawRoundRect(10, 0, _width -20, oneHour.height + 20, 10, 10);			
			clip.graphics.endFill();
			clip.visible = false;
			clip.mouseEnabled = false;
			addChildAt(clip, 0);			
			
			clip2 = new Sprite();
			clip2.mouseEnabled  = false;
			clip2.mouseChildren  = false;
			var overSplash:Sprite = new Sprite();
			overSplash.graphics.beginFill(0x1c3114,0.9);
			overSplash.graphics.drawRoundRect(10, 0, _width -20, oneHour.height + 20, 10, 10);	
			overSplash.graphics.endFill();
			addChild(clip2);
			clip2.addChild(overSplash);			
			
			var icon:Sprite = Assets.create("closeMat");
			icon.scaleX = icon.scaleY = IpadConstants.contentScaleFactor;
			clip2.addChild(icon);
			icon.x = (clip2.width - icon.width)   * 0.5;
			icon.y = (clip2.height - icon.height) * 0.5  -IpadConstants.contentScaleFactor*40;
			
			var mainTitle:TextField = TextUtil.createTextField(156 * IpadConstants.contentScaleFactor, 0);
			mainTitle.text = "СКРЫТЬ МАТЕРИАЛ";
			mainTitle.setTextFormat(textFormat);
			clip2.addChild(mainTitle);		
			mainTitle.x = (clip2.width - mainTitle.width)   * 0.5;
			mainTitle.y = icon.y + icon.height + IpadConstants.contentScaleFactor * 30;				
			clip2.visible = false;	
			
			clip2.y = 30;
			clip.y  = 30;	
			
		}
		
		public function closeShow():void
		{
			closeFav.visible = true;
			closeFav.alpha = 0;
			TweenLite.to(closeFav, 0.8, { alpha:1 } );
			TweenLite.delayedCall(3, delayToHide);			
		}
		
		private function delayToHide():void 
		{
			TweenLite.to(closeFav, 0.8, { alpha:0, onComplete:function ():void 
			{
				closeFav.visible = false;
			} } );
		}
		
		public function clear():void
		{
			clip.visible = false;
			clip2.visible = false;
		}
		
		public function state2():void
		{			
			clip.visible = false;
			clip2.visible = true;
		}
		
		public function down() :void
		{
			clip.visible = true;
		}
		
		public function up()  :void
		{
			clip.visible = false;
			clip2.visible = false;			
		}		
	}
}
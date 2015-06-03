package ipad.view.slider 
{
	import app.view.utils.TextUtil;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ipad.assets.Assets;
	import app.model.materials.Material;
	import app.view.utils.Tool;
	import flash.display.Sprite;
	import ipad.controller.IpadConstants;
	import ipad.view.OneNewIpad;

	public class Element extends Sprite
	{
		public  var mat:Material;		
		private var _width:int = 628;
		private var _height:int = 415;
		private var clip:Sprite;
		private var clip2:Sprite;
		public  var isActive:Boolean = false;		
		private var oneHour:OneNewIpad;
		private var textFormat:TextFormat = new TextFormat("Tornado", 26 * IpadConstants.contentScaleFactor, 0x02a5dc);
	
		public function Element(mat:Material) 
		{
			this.mat = mat;
			
			_width *= IpadConstants.contentScaleFactor;
			_height *= IpadConstants.contentScaleFactor;			
	
			clip = new Sprite();
			clip.graphics.beginFill(0x2c3843);
			clip.graphics.drawRoundRect(0, 0, _width + 15, _height, 10, 10);
			clip.graphics.endFill();
			clip.visible = false;
			clip.mouseEnabled  = false;
			addChild(clip);				
			
			oneHour = new OneNewIpad(mat, true, false, true);
			addChild(oneHour);
			oneHour.scaleX = 0.8;
			oneHour.scaleY = 0.8;
			oneHour.x = 35;
			oneHour.y = 40;
			oneHour.mouseEnabled = false;	
			
			clip2 = new Sprite();
			clip2.mouseEnabled  = false;
			clip2.mouseChildren  = false;
			var overSplash:Sprite = new Sprite();
			overSplash.graphics.beginFill(0x000000,0.8);
			overSplash.graphics.drawRoundRect(0, 0, _width + 15, _height, 10, 10);
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
			mainTitle.y = icon.y + icon.height +IpadConstants.contentScaleFactor * 30;			
			clip2.visible = false;		
		}
		
		public function clear():void
		{
			clip.visible = false;
			clip2.visible = false;
			Tool.changecolor(oneHour.line, 0x000000);
		}
		
		public function state2():void
		{			
			clip.visible = false;
			clip2.visible = true;
			Tool.changecolor(oneHour.line, 0x000000);			
		}
		
		public function down() :void
		{
			clip.visible = true;
			Tool.changecolor(oneHour.line, 0x0a96c8);
		}
		
		public function up()  :void
		{
			clip.visible = false;
			clip2.visible = false;			
			Tool.changecolor(oneHour.line, 0x000000);
		}		
	}
}
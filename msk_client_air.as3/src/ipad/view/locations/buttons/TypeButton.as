package ipad.view.locations.buttons
{
	import app.view.utils.Tool;
	import flash.text.AntiAliasType;
	import ipad.assets.Assets;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import ipad.controller.IpadConstants;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class TypeButton extends Sprite
	{
		public var rub:Object;
		private var billet:Shape
		private var textFormat:TextFormat = new TextFormat("TornadoL", 36 * IpadConstants.contentScaleFactor, 0Xffffff);
		
		public var isActive:Boolean;
		public var ico:Sprite;
		public var fon:Sprite;
		private var _line:Shape;
		private var isLine:Boolean = true;
		
		public function TypeButton(type:Object, isLine:Boolean)
		{		
			name = type.name;
			
			if (isLine)
			{
				_line = new Shape();
				_line.graphics.lineStyle(0.3, 0x828696, 0.58);
				_line.graphics.moveTo( 4, 106 * IpadConstants.contentScaleFactor - 1);				
				_line.graphics.lineTo(520 * IpadConstants.contentScaleFactor - 4 , 106 * IpadConstants.contentScaleFactor-1);				
				addChild(_line);
			}			
			
			fon = new Sprite();
			addChild(fon);
			fon.graphics.beginFill(0x364150);
			fon.graphics.drawRoundRect(0, 0, 520 * IpadConstants.contentScaleFactor, 106 * IpadConstants.contentScaleFactor, 10, 10);
			fon.graphics.endFill();
			fon.visible = false;				
			
			ico = Assets.create(type.icon);
			ico.mouseEnabled = false;
			Tool.changecolor(ico, 0x8fa8bf);
			ico.scaleX = ico.scaleY =  IpadConstants.contentScaleFactor;
			ico.y = 0.5 * (height - ico.height);	
			ico.x = 40* IpadConstants.contentScaleFactor;
			addChild(ico);			
			
			var textTitle:TextField = new TextField();
			textTitle.autoSize = TextFieldAutoSize.LEFT;
			textTitle.text = type.text;
			textTitle.selectable = false;
			textTitle.embedFonts = true;
			textTitle.setTextFormat(textFormat);
			textTitle.mouseEnabled = false;
			textTitle.antiAliasType = AntiAliasType.ADVANCED;
			textTitle.x = Math.floor(ico.x + 90 * IpadConstants.contentScaleFactor);
			textTitle.y = Math.floor(0.5 * (height - textTitle.height));			
			addChild(textTitle);
			
			
			
			var splash:Shape = Tool.createShape(520 * IpadConstants.contentScaleFactor, height-1, 0x101114);	
			splash.alpha = 0;
			addChild(splash);
			
			//name:"photo", text:"Фотографии", icon:"iphoto" 
		}
		
		public function click(_name:String):void
		{
			
			if (_name == name)
			{
				//this.alpha = 0.4;
				fon.visible = true;
				Tool.changecolor(ico, 0xffffff);
				isActive = true;
			}
			else
			{
				//this.alpha = 1;
				fon.visible = false;
				Tool.changecolor(ico, 0x8fa8bf);
				isActive = false;
			}
		
		}
	
	}

}
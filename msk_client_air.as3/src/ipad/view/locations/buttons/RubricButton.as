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
	public class RubricButton extends Sprite
	{
		public var rub:Object;
		private var billet:Shape
		private var textFormat:TextFormat = new TextFormat("TornadoL", 36 * IpadConstants.contentScaleFactor, 0Xffffff);
		
		public var isActive:Boolean;
		public var icon:Sprite;
		public var fon:Sprite;
		private var _line:Shape;
		private var isLine:Boolean = true;
		
		public function RubricButton(rub:Object, activeId:Object, _isLine:Boolean = true, _color:uint = 0x5c9f42, i:int = 0)
		{
			this.rub = rub;
			this.rub.nomer = i;
			isLine = _isLine;

			if (isLine)
			{
				_line = new Shape();
				_line.graphics.lineStyle(0.3, 0x828696, 0.58);
				_line.graphics.moveTo(4, 106 * IpadConstants.contentScaleFactor - 1);				
				_line.graphics.lineTo(444 * IpadConstants.contentScaleFactor - 4, 106 * IpadConstants.contentScaleFactor - 1);
				addChild(_line);
			}
			
			
			fon = new Sprite();
			addChild(fon);
			fon.graphics.beginFill(_color);
			fon.graphics.drawRoundRect(0, 0, 444 * IpadConstants.contentScaleFactor, 106 * IpadConstants.contentScaleFactor, 10, 10);			
			fon.graphics.endFill();
			fon.visible = false;		
			
			var textTitle:TextField = new TextField();
			textTitle.autoSize = TextFieldAutoSize.LEFT;
			textTitle.text = rub.name;
			textTitle.selectable = false;
			textTitle.embedFonts = true;
			textTitle.setTextFormat(textFormat);
			textTitle.mouseEnabled = false;
			textTitle.antiAliasType = AntiAliasType.ADVANCED;
			textTitle.x =  Math.floor(136 * IpadConstants.contentScaleFactor);
			textTitle.y = Math.floor(0.5 * (height - textTitle.height));
			
			icon = Assets.create("icon" + rub.id);
			Tool.changecolor(icon, 0x8fa8bf);
			icon.scaleX = icon.scaleY = IpadConstants.contentScaleFactor;
			icon.x = 135 * IpadConstants.contentScaleFactor * 0.5 - icon.width * 0.5;
			icon.y = 0.5 * (height - icon.height);
			icon.mouseEnabled  = false;
			addChild(icon);
			addChild(textTitle);
			
			billet = Tool.createShape(width, height-1, 0xffffff);
			billet.alpha = 0;
			addChild(billet);
			
			
			trace("activeId", activeId);
			if (activeId && activeId.id == rub.id)
			{
				activeId.nomer = i;
				click(rub);
			}		
		}
		
		public function click(_rub:Object):void
		{
			if(!_rub) return;
		
			if (isLine)
			{
				if (rub.nomer == _rub.nomer-1)
				{
					_line.visible = false;	
				}
				else _line.visible = true;
			}
			
			
			if (rub.id == _rub.id)
			{
				//this.alpha = 0.4;
				fon.visible = true;
				Tool.changecolor(icon, 0xffffff);
				isActive = true;
			}
			else
			{
				//this.alpha = 1;
				fon.visible = false;
				Tool.changecolor(icon, 0x8fa8bf);
				isActive = false;
			}
		
		}
	
	}

}
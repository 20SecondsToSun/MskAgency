package ipad.view
{
	import app.view.baseview.io.InteractiveButton;
	import app.view.baseview.io.InteractiveObject;
	import ipad.assets.Assets;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ipad.controller.IpadConstants;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class Button extends Sprite
	{
		private var over:Shape;
		private var textTitle:TextField;
		public var active:Boolean = false;
		
		public var id:int;
		public var icon:Sprite;
		public var defaultColor:uint = 0x2c3843;
		
		public var iconNamesArray:Array = ["main", "theme", "izbr", "news", "sob", "map", "m24"];		
		public var nameArray:Array = ["Главное", "По теме", "Избранное", "Новости", "События", "Карта", "Москва 24"];
		
		public var textFormat:TextFormat;
		
		public function Button(id:int)
		{
			this.id = id;
			
			over = Tool.createShape(IpadConstants.GameWidth / Menu.ICONS_NUM, 290 * IpadConstants.contentScaleFactor, 0x5c9f42);
			addChild(over);
			over.visible = false;
			
			textFormat = new TextFormat("TornadoL", 36  * IpadConstants.contentScaleFactor, 0X494949);
			textTitle = TextUtil.createTextField(0, 210 * IpadConstants.contentScaleFactor);
			textTitle.text = setName();
			textTitle.setTextFormat(textFormat);
			textTitle.x = 0.5 * (width - textTitle.width);
			addChild(textTitle);
			
			icon = setIcon();
			icon.scaleX = icon.scaleY = IpadConstants.contentScaleFactor;
			icon.x = 0.5 * (width - icon.width);
			icon.y = 0.5 * (height - icon.height) - 30 * IpadConstants.contentScaleFactor;
			icon.mouseChildren = false;
			icon.mouseEnabled = false;
			addChild(icon);
			
			var billet:Shape = Tool.createShape(IpadConstants.GameWidth / Menu.ICONS_NUM, 290 * IpadConstants.contentScaleFactor, 0x5c9f42);
			billet.alpha = 0;
			addChild(billet);			
		}
		
		public function setIcon():Sprite
		{
			return Assets.create(iconNamesArray[id]);
		}
		
		public function setName():String
		{
			return nameArray[id];
		}
		
		public function click(id:int):void
		{
			var color:uint;
			var iconcolor:uint;
			
			if (this.id == id)
			{
				over.visible = true;
				active = true;
				iconcolor = color = 0xffffff;
			}
			else
			{
				over.visible = false;
				active = false;
				color = defaultColor;
				iconcolor  = 0x828696;
			}
			
			textFormat.color = color;
			Tool.changecolor(icon, iconcolor);			
			textTitle.setTextFormat(textFormat);		
		
		}
	
	}

}
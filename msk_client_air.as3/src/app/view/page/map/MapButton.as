package app.view.page.map
{
	import app.view.baseview.io.InteractiveButton;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class MapButton extends InteractiveButton
	{
		private static const margin:int = 70;
		
		private var fon:Shape;
		public var _color:uint;
		public var group_id:int;
		public var type_id:int;
		
		public function MapButton(data:Object,_group_id:int)
		{
			group_id = _group_id;
			type_id = data.type_id;
			
			var textFormat:TextFormat = new TextFormat("TornadoL", 36, 0Xfffffff);
			var title:TextField = TextUtil.createTextField(0, 0);			
			title.text = data.type;
			title.setTextFormat(textFormat);
			title.x = margin;
			title.y = (ButtonBlock.HEIGHT - title.height)* 0.5;
			addChild(title);
			
			fon = Tool.createShape(title.width + margin * 2, ButtonBlock.HEIGHT-1, 0x00ff00);
			addChild(fon);
			fon.alpha  = 0;
			
			swapChildren(title, fon);
			
			var circleMC:Shape = new Shape();
			circleMC.graphics.beginFill(0xFFFFFF);
			circleMC.graphics.drawCircle(0, ButtonBlock.HEIGHT * 0.5, 5);
			addChild(circleMC);
		}
		public function setColor(_color:uint):void
		{
			this._color = _color;
			Tool.changecolor(fon, _color);
			fon.alpha = 0;
		}
		public function over():void
		{
			fon.alpha = 1;
			
		}
		public function out():void
		{
			fon.alpha = 0;
		}
	
	}

}
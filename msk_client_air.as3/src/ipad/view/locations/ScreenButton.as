package ipad.view.locations
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class ScreenButton extends Sprite
	{
		public var screen:String;
		private var billet:Shape
		private var textFormat:TextFormat = new TextFormat("TornadoL", 21, 0Xffffff);
		
		public var isActive:Boolean;
		
		public function ScreenButton(screen:String, activeScreen:String)
		{
			
			this.screen = screen;
			
			var textTitle:TextField = new TextField();
			textTitle.autoSize = TextFieldAutoSize.LEFT;
			textTitle.text = screen;
			textTitle.selectable = false;
			textTitle.embedFonts = true;
			textTitle.setTextFormat(textFormat);
			textTitle.mouseEnabled = false;
			billet = new Shape();
			billet.graphics.beginFill(0x178B14, 1);
			billet.graphics.drawRect(0, 0, textTitle.width + 10, 50);
			billet.graphics.endFill();
			
			addChild(billet);
			addChild(textTitle);
			
			if (activeScreen == screen)
			{
				this.alpha = 0.4;
				isActive = true;
			}
		}
		public function click(_screen:String):void
		{
		
			if (screen == _screen)
			{
				this.alpha = 0.4;
				isActive = true;
			}
			else
			{
				this.alpha = 1;
				isActive = false;
			}	
		
		}
		
		
	
	}

}
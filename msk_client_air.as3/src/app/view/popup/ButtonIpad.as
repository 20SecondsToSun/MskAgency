package app.view.popup 
{
	import app.assets.Assets;
	import app.view.baseview.io.InteractiveButton;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.globalization.StringTools;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class ButtonIpad extends InteractiveButton
	{		
		private var ramka:Sprite;
		private var textFormat1:TextFormat = new TextFormat("Tornado", 26, 0xffffff);		
		private var overPlashka:Shape;
		
		private static const ALLOW_ACCESS:String = "РАЗРЕШИТЬ ДОСТУП";	
		private static const DENIED_ACCESS:String = "ОТКЛОНИТЬ";	
		
		public function ButtonIpad(mode:String = "OK") 
		{
			ramka = Assets.create("ramkaPopup");			
			addChild(ramka);			
			
			var titleTxt1:String = 	ALLOW_ACCESS;	
			var title1:TextField = TextUtil.createTextField(0, 0);
			
			overPlashka = Tool.createShape(ramka.width, 1, 0xe6e8ed);
			overPlashka.y = ramka.height - 4;
			addChild(overPlashka);
			
			if (mode == "OK")
			{				
				Tool.changecolor(ramka, 0x5c9f42);
				Tool.changecolor(overPlashka, 0x5c9f42);
				titleTxt1 = ALLOW_ACCESS;
			}
			else
			{
				Tool.changecolor(overPlashka, 0x3e3e3e);
				titleTxt1 = DENIED_ACCESS;
			}	
			
			title1.text = titleTxt1;			
			title1.setTextFormat(textFormat1);
			title1.x = 0.5 * (width -  title1.width);
			title1.y = 0.5 * (height -  title1.height);
			addChild(title1);			

			var over:Shape  = Tool.createShape(ramka.width, ramka.height, 0xe6e8ed);
			over.alpha = 0;			
			addChild(over);			
		}
		
		public function over() :void
		{
			TweenLite.to(overPlashka, 0.5, { height:ramka.height, y:0 } );
		}
		
		public function out():void
		{
			TweenLite.to(overPlashka, 0.5, { height:1, y:ramka.height - 4 } );
		}		
	}
}
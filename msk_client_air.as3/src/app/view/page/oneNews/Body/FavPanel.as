package app.view.page.oneNews.Body
{
	import app.assets.Assets;
	import app.view.baseview.io.InteractiveObject;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FavPanel extends InteractiveObject
	{		
		public function FavPanel()
		{
			var panel:Sprite = Assets.create("favpanel");
			addChild(panel);
			
			var  over:Shape = Tool.createShape(622, 268, 0x3b4c5c);
			addChild(over);			
			
			var favhand:Sprite = Assets.create("favhand");
			favhand.x = .5 * (width - favhand.width);
			favhand.y = 503;
			addChild(favhand);
			
			var arrowFav:Sprite = Assets.create("favarrow");
			arrowFav.x = favhand.x - 80;
			arrowFav.y = favhand.y + 0.5 * (favhand.height - arrowFav.height);
			addChild(arrowFav);
			
			var tf:TextFormat = new TextFormat("TornadoL", 48, 0xffffff);
			
			var text1:TextField = TextUtil.createTextField(116, 98);
			text1.text = "Избранное";
			text1.setTextFormat(tf);
			addChild(text1);
			
			tf.color = 0x8fa8bf;
			tf.size = 24;
			tf.font = "Tornado";
			
			var text2:TextField = TextUtil.createTextField(116, 162);
			text2.text = "Новости, которые вам важны";
			text2.setTextFormat(tf);
			addChild(text2);
			
			tf.size = 36;
			tf.color = 0xd1e2f3;
			tf.align = TextFormatAlign.CENTER;
			
			var text3:TextField = TextUtil.createTextField(0, 783);
			text3.text = "Перетащите сюда,";
			text3.autoSize = TextFieldAutoSize.CENTER;
			text3.setTextFormat(tf);
			text3.x = .5 * (width - text3.width);
			addChild(text3);
			
			tf.size = 24;
			
			var text4:TextField = TextUtil.createTextField(0, 824);
			text4.multiline = true;
			text4.wordWrap = true;
			text4.width = 300;
			
			text4.text = "чтобы добавить материал\nв Избранное";
			text4.setTextFormat(tf);
			text4.x = .5 * (width - text4.width);
			addChild(text4);
			
			x = -width * 2;
			//alpha = 0.3;
			visible = false;
		}
		
		public function show():void
		{
			visible = true;
			TweenLite.to(this, 0.5, {x: -width, ease: Expo.easeInOut});
		}
		
		public function hide():void
		{
			TweenLite.to(this, 0.5, {x: -2 * width, ease: Expo.easeInOut, onComplete: function():void
				{
					visible = false;				
				}});
		}
	}
}
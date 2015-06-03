package app.view.menu
{
	import app.assets.Assets;
	import app.contoller.events.AnimationEvent;
	import app.view.baseview.io.InteractiveButton;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class MenuButton extends InteractiveButton
	{
		private var circleMC:Shape;
		private var circleCounturMC:Shape;
		private var ico:Sprite;
		private var icoTitle:TextField;
		private var fingimg:Sprite;
		
		public var isSelect:Boolean = false;
		
		public function MenuButton()
		{
			circleMC = new Shape();
			circleMC.graphics.beginFill(0x02a7df);
			circleMC.graphics.drawCircle(125, 125, 125);
			addChild(circleMC);
			circleMC.alpha = 0;
			
			circleCounturMC = new Shape();
			circleCounturMC.graphics.lineStyle(4, 0x000000);
			circleCounturMC.graphics.drawCircle(125, 125, 125);
			addChild(circleCounturMC);
		}
		
		public function init(s:String):void
		{
			var _color:uint = 0Xffffff;
			
			if (s != "1" && s != "2" && s != "3")
			{
				ico = Assets.create(s);
				ico.x = circleMC.x + (circleMC.width - ico.width) * 0.5;
				ico.y = circleMC.y + (circleMC.height - ico.height) * 0.5;
				addChild(ico);
			}
			else
			{
				_color = 0x000000;
				fingimg = Assets.create("fing_" + s);
				fingimg.x = (circleMC.width - fingimg.width) * 0.5;
				fingimg.y = (circleMC.width - fingimg.height) * 0.5;
				
				addChild(fingimg);
			}
			
			var textFormat:TextFormat = new TextFormat("TornadoL", 48, _color);
			
			var title:TextField = TextUtil.createTextField(45, 310);
			title.multiline = false;
			title.wordWrap = false;
			title.width = 120;
			title.autoSize = TextFieldAutoSize.CENTER;
			
			var title2:TextField = TextUtil.createTextField(45, 365);
			title2.multiline = false;
			title2.wordWrap = false;
			title2.width = 120;
			title2.autoSize = TextFieldAutoSize.CENTER;
			
			switch (s)
			{
			case "allnewsMenu": 
				title.text = "Новости";
				title2.text = "Все новости Москвы";
				break;
			case "eventsMenu": 
				title.text = "Cобытия";
				title2.text = "Календарь важнейших событий";
				break;
			
			case "mapMenu": 
				title.text = "Карта";
				title2.text = "Все происшествия на карте";
				break;
			
			case "msk24": 
				title.text = "Москва 24";
				title2.text = "Трансляция прямого эфира";
				break;
			
			case "1": 
				title.text = "Главное";
				title2.text = "Самые свежие новости";
				break;
			case "2": 
				title.text = "По теме";
				title2.text = "Все по выбранной теме";
				break;
			case "3": 
				title.text = "Избранное";
				title2.text = "Новости, которые важны вам";
				break;
			default: 
			}
			
			title.setTextFormat(textFormat);
			
			textFormat.size = 24;
			textFormat.color = 0x8fa8bf;
			textFormat.font = "Tornado";
			
			title2.setTextFormat(textFormat);
			
			title.x = (circleMC.width - title.width) * 0.5;
			title2.x = (circleMC.width - title2.width) * 0.5;
			
			addChild(title);
			addChild(title2);
		}
		
		public function deactive():void
		{
			isSelect = false;
			if (ico == null) return;
			
			Tool.changecolor(circleMC, 0x02a7df);
			circleMC.visible = true;
			circleMC.alpha = 0;
			
			Tool.changecolor(ico, 0xffffff);
			dispatchEvent(new AnimationEvent(AnimationEvent.ACTIVATE));
		}
		
		public function active():void
		{
			isSelect = true;
			if (ico == null) return;
			
			Tool.changecolor(circleMC, 0x000000);
			circleMC.alpha = 1;
			
			Tool.changecolor(ico, 0x5c9f42);
			TweenLite.to(circleCounturMC, 0.8, {alpha: 1});
			
			dispatchEvent(new AnimationEvent(AnimationEvent.DEACTIVATE));
		}
		
		public function overState():void
		{
			TweenPlugin.activate([ColorTransformPlugin]);
			TweenLite.to(circleCounturMC, 0.2, {alpha: 0});// colorTransform: { tint:0x02a7df, tintAmount:1 }} );
			TweenLite.to(circleMC, 0.8, {alpha: 1});
			
			if (fingimg)
				TweenLite.to(fingimg, 0.5, {colorTransform: {tint: 0xffffff, tintAmount: 1}});
		}
		
		public function outState():void
		{
			TweenLite.to(circleMC, 0.8, {alpha: 0});
			TweenLite.to(circleCounturMC, 0.8, {alpha: 1});
			
			if (fingimg)
				TweenLite.to(fingimg, 0.5, {removeTint: true});
		}
	}

}
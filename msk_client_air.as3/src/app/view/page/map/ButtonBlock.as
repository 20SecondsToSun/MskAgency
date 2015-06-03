package app.view.page.map
{
	import app.AppSettings;
	import app.assets.Assets;
	import app.assets.AssetsEmbeds;
	import app.view.baseview.io.InteractiveButton;
	import app.view.baseview.io.InteractiveObject;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import flash.display.CapsStyle;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class ButtonBlock extends InteractiveObject
	{
		private static const WIDTH:int = 365;
		public static const HEIGHT:int = AppSettings.HEIGHT / 5;
		
		private var buttons:InteractiveObject;
		private var bckgrnd:Sprite;
		private var _color:uint;
		
		private var hasSubTypes:Boolean = true;
		
		private var __mask:Shape;
		public var group_id:int;
		
		private var selectSplash:Shape;
		
		private var interBtn:InteractiveButton;
		public var slider:Sprite;
		private var billet:Shape;
		
		public function ButtonBlock(data:Object)
		{
			group_id = data.group_id;
			
			bckgrnd = new Sprite();
			addChild(bckgrnd);
			
			var fon:Shape = Tool.createShape(WIDTH, HEIGHT, 0x1a1b1f);
			bckgrnd.addChild(fon);
			
			__mask = Tool.createShape(WIDTH, HEIGHT, 0x1a1b1f);
			addChild(__mask);
			__mask.x = WIDTH - 5;
			
			selectSplash = Tool.createShape(10, HEIGHT, data.group_color);
			addChild(selectSplash);
			selectSplash.visible = false;
			
			var line:Shape = new Shape();
			line.graphics.lineStyle(2, 0x000000, 1, false, "normal", CapsStyle.SQUARE);
			line.graphics.moveTo(0, HEIGHT);
			line.graphics.lineTo(WIDTH - 1, HEIGHT);
			addChild(line);
			
			var img:Sprite = Assets.create(data.img);
			img.y = 50;
			img.x = (WIDTH - img.width) * 0.5;
			addChild(img);
			
			var textFormat:TextFormat = new TextFormat("Tornado", 21, 0Xfffffff);
			var title:TextField = TextUtil.createTextField(0, 0);
			title.text = data.group.toUpperCase();
			title.setTextFormat(textFormat);
			title.y = 140;
			title.x = (WIDTH - title.width) * 0.5;
			addChild(title);
			
			buttons = new InteractiveObject();
			buttons.x = WIDTH;
			addChild(buttons);
			buttons.mask = __mask;
			
			_color = data.group_color;
			var fill:Shape = Tool.createShape(AppSettings.WIDTH - WIDTH, HEIGHT - 1, _color);
			buttons.addChild(fill);
			buttons.visible = false;
			
			billet = Tool.createShape(WIDTH, HEIGHT, 0x1a1b1f);
			billet.alpha = 0;
			
			if (data.group_id == 5)
				hasSubTypes = false;
			
			slider = new Sprite();
			buttons.addChild(slider);
			
			if (data.group_id != 5)
			{
				var offset:int = 0;
				for (var i:int = 0; i < data.types.length; i++)
				{
					var btn:MapButton = new MapButton(data.types[i], data.group_id);
					
					btn.setColor(data.type_color);
					slider.addChild(btn);
					btn.x = offset;
					offset += btn.width;
				}
			}
			if (buttons.width > AppSettings.WIDTH - WIDTH)
				fill.width = buttons.width;
			
			interBtn = new InteractiveButton();
			interBtn.name = "own";
			var btnIn:Shape = Tool.createShape(WIDTH, HEIGHT, 0x1a1b1f);
			btnIn.alpha = 0;
			interBtn.addChild(btnIn);
			addChild(interBtn);
			addChild(billet);
		}
		
		public function open():void
		{
			if (hasSubTypes)
			{
				TweenLite.delayedCall(0.7, maskGo);
				
			}
			Tool.changecolor(bckgrnd, _color);
		}
		
		private function maskGo():void
		{
			__mask.width = 1;
			buttons.visible = true;
			TweenLite.to(__mask, 0.5, {width: AppSettings.WIDTH, ease: Cubic.easeInOut});
			billet.width = AppSettings.WIDTH;
		}
		
		public function close():void
		{
			if (hasSubTypes)
			{
				buttons.visible = false;
				billet.width = WIDTH;
				TweenLite.killDelayedCallsTo(maskGo);
			}
			Tool.changecolor(bckgrnd, 0x1a1b1f);
		}
		
		private var _select:Boolean = false;
		
		public function set select(value:Boolean):void
		{
			_select = value;
			selectSplash.visible = value;		
		}
		
		public function get select():Boolean
		{
			return _select;
		}
		
		public function moveLeft():void
		{
			//trace(buttons.x);
			//return;
			if (buttons.x - 0.1 > ((AppSettings.WIDTH - 365) - buttons.width) + WIDTH + 10)
				buttons.x -= 0.1;
			else
				buttons.x = ((AppSettings.WIDTH - 365) - buttons.width) + WIDTH + 10;
			// buttons.x -0.01 ;
			//trace(buttons.x);
		
			//else buttons.x = -((AppSettings.WIDTH - 365) - buttons.width)- WIDTH;
		}
		
		public function moveRight():void
		{
			if (buttons.x + 0.1 < WIDTH)
				buttons.x += 0.1;
			else
				buttons.x = WIDTH;
		}
	}

}
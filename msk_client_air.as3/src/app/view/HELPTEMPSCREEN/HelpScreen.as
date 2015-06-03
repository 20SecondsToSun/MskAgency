package app.view.HELPTEMPSCREEN
{
	import app.AppSettings;
	import app.view.HELPTEMPSCREEN.minislider.MiniSlider;
	import app.view.utils.MemoryMonitor;
	import app.view.utils.TextUtil;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Quart;
	import com.greensock.TweenMax;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class HelpScreen extends Sprite
	{
		public var btn_1:Sprite;
		public var btn_2:Sprite;
		public var btn_3:Sprite;
		public var btn_4:Sprite;
		public var btn_5:Sprite;
		
		public var menu_1:Sprite;
		public var menu_2:Sprite;
		public var menu_3:Sprite;
		public var menu_4:Sprite;
		public var menu_5:Sprite;
		public var menu_6:Sprite;
		public var menu_7:Sprite;
		public var menu_8:Sprite;
		public var menu_9:Sprite;
		public var menu_10:Sprite;
		
		//plane texture
		
		public function HelpScreen()
		{
			
			name = "HelpScreen";
			
			//visible  = false;
			
			for (var i:int = 1; i <= 3; i++)
			{
				this["btn_" + i.toString()] = new Sprite;
				addChild(this["btn_" + i.toString()]);
				this["btn_" + i.toString()].x = 100 + 50 * i;
				this["btn_" + i.toString()].y = 30;
				
				var btn1:Shape = new Shape();
				btn1.graphics.beginFill(0xaa0020, 1);
				btn1.graphics.drawCircle(0, 00, 20);
				btn1.graphics.endFill();
				this["btn_" + i.toString()].addChild(btn1);
				
				this["btn_" + i.toString()].alpha  = 0;
				
			}
			
			//var fps:FPSCounter = new FPSCounter(100, 100, 0xffffff, true);
			
			var memM:MemoryMonitor = new MemoryMonitor()
			//memM.x = AppSettings.WIDTH - memM.width;
			//memM.y = AppSettings.HEIGHT - memM.height;
			addChild(memM);
			memM.visible = false;
			
			var locations:Array = [ /*"Карта", "События", "Новости", "Трансляции",*/"Фильтры", "Меню", "Юзер вошел", "Юзер вышел", "пауза/плей", "Новость пришла", "ГеоНовость пришла", "Новость с айпада пришла", "Фото новость пришла", "Изменить рубрику"];
			var offset:Number = 400;
			for (var j:int = 0; j < locations.length; j++)
			{
				var textFormat:TextFormat = new TextFormat("TornadoL", 21 * AppSettings.SCALEFACTOR, 0Xffffff);
				
				var textTitle:TextField = new TextField();
				textTitle.autoSize = TextFieldAutoSize.LEFT;
				textTitle.text = locations[j];
				textTitle.selectable = false;
				textTitle.embedFonts = true;
				textTitle.setTextFormat(textFormat);
				
				this["menu_" + (j + 1).toString()] = new Sprite();
				this["menu_" + (j + 1).toString()].addChild(textTitle);
				this["menu_" + (j + 1).toString()].x = offset;
				this["menu_" + (j + 1).toString()].y = 20;
				offset += this["menu_" + (j + 1).toString()].width + 20;
				addChild(this["menu_" + (j + 1).toString()]);
				
				var billet:Shape = new Shape();
				billet.graphics.beginFill(0x178B14, 1);
				billet.graphics.drawRect(0, 0, textTitle.width + 10, 50);
				billet.graphics.endFill();
				this["menu_" + (j + 1).toString()].addChild(billet);
				this["menu_" + (j + 1).toString()].addChild(textTitle);
				this["menu_" + (j + 1).toString()].alpha = 0;//visible = false;
				
			}
			
			this["menu_" + (6).toString()].x = 1200;
			this["menu_" + (7).toString()].x = 900;
			this["menu_" + (8).toString()].x = 1400;
			this["menu_" + (9).toString()].x = 1400;
			//this["menu_" + (9).toString()].y = 200;
			
			for (var k:int = 7; k < 11; k++)
			{
				this["menu_" + (k).toString()].visible = false;
			}
			
			var mini:MiniSlider = new MiniSlider();
			 //  addChild(mini);
			   mini.x = 1200;
			   mini.y = 50;
			 
			
			mainTitle = TextUtil.createTextField(0, 0);
			//addChild(mainTitle);	
			stage ? init():addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);			
			
		}
		
		private function onKeyboardDown(e:KeyboardEvent):void 
		{
			//trace("KEY CODE:::::::::::123  ", e.keyCode);
			
			dispatchEvent(e.clone());
			
			switch (e.keyCode) 
			{
				case 49:
					
				break;
				
				case 50:
					
				break;
				
				case 51:
					
				break;
				
				default:
			}
		}
		private var textFormat:TextFormat = new TextFormat("Tornado", 100, 0xffffff);
		
		public function setCommand(volume:String):void
		{
			mainTitle.text = volume;
			mainTitle.setTextFormat(textFormat);
			mainTitle.y = 0.5 * (AppSettings.HEIGHT - mainTitle.height);
			mainTitle.x = 0.5 * (AppSettings.WIDTH - mainTitle.width);
		}
		
		private var d2:Sprite;
		private var d3:Sprite;
		private var d4:Sprite;
		private var angle:Number = 45;
		private var shiftY:Number = 40;
		private var scale:Number = 0.8;
		private var mainTitle:TextField;
		
		public function goto():void
		{
			
			TweenMax.to(d2, 1.2, {alpha: 1, y: shiftY, x: (d2.width - d2.width * scale) * 0.5, ease: Quart.easeOut, scaleX: scale, scaleY: scale, rotationX: angle, rotationY: 0});
			
			TweenMax.to(d3, 1.2, {alpha: 1, y: shiftY + 300, x: (d3.width - d3.width * scale) * 0.5, scaleX: scale, scaleY: scale, ease: Quart.easeOut, rotationX: angle, rotationY: 0});
			
			var filter:BitmapFilter = getBitmapFilter();
			var myFilters:Array = new Array();
			myFilters.push(filter);
			d3.filters = myFilters;
			
			TweenMax.to(d4, 1.2, {alpha: 1, y: shiftY + 600, x: (d4.width - d4.width * scale) * 0.5, scaleX: scale, scaleY: scale, ease: Quart.easeOut, rotationX: angle, rotationY: 0});
			
			myFilters.push(filter);
			d4.filters = myFilters;
		}
		
		public function goto1():void
		{
			goto();
			TweenMax.delayedCall(2, showScreen, [d3, d2, d4]);
		}
		
		private function showScreen(mc1:Sprite, mc2:Sprite, mc3:Sprite):void
		{
			TweenMax.to(mc1, 1.2, {alpha: 1, scaleX: 1, scaleY: 1, y: 0, x: 0, ease: Quart.easeOut, rotationX: 0, rotationY: 0});
			TweenMax.to(mc2, 0.8, {alpha: 1, scaleX: 1, scaleY: 1, y: AppSettings.HEIGHT, x: 0, ease: Expo.easeOut, rotationX: 0, rotationY: 0});
			TweenMax.to(mc3, 0.8, {alpha: 1, scaleX: 1, scaleY: 1, y: AppSettings.HEIGHT, x: 0, ease: Expo.easeOut, rotationX: 0, rotationY: 0});
		}
		
		public function goto2():void
		{
			goto();
			TweenMax.delayedCall(2, showScreen, [d2, d3, d4]);
		}
		
		public function goto3():void
		{
			goto();
			TweenMax.delayedCall(2, showScreen, [d4, d2, d3]);
		}
		
		private function getBitmapFilter():BitmapFilter
		{
			var color:Number = 0x000000;
			var angle:Number = 180;
			var alpha:Number = 0.8;
			var blurX:Number = 18;
			var blurY:Number = 18;
			var distance:Number = 25;
			var strength:Number = 0.95;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.HIGH;
			return new DropShadowFilter(distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}
		
		private function createSprite(colour:uint, w:Number, h:Number):Sprite
		
		{
			var mySprite:Sprite = new Sprite();
			mySprite.graphics.beginFill(colour);
			mySprite.graphics.drawRect(0, 0, w, h);
			mySprite.graphics.endFill();
			return mySprite;
		}
	
	}

}
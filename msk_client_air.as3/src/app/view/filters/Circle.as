package app.view.filters
{
	import app.assets.Assets;
	import app.contoller.events.InteractiveEvent;
	import app.model.datafilters.Rubric;
	import app.view.baseview.io.InteractiveButton;
	import app.view.baseview.io.InteractiveObject;
	import app.view.utils.DrawingShapes;
	import app.view.utils.TextUtil;
	import com.greensock.easing.Back;
	import com.greensock.easing.Expo;
	import com.greensock.plugins.ShortRotationPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.BlendMode;
	import flash.display.CapsStyle;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author castor troy
	 */
	public class Circle extends InteractiveObject
	{
		private var angleConvert:Number = 180 / Math.PI;
		private var angle:Number = 0;
		public var speed:Number = 3;
		
		private var iconsClip:Sprite;
		private var bigButtonsArray:Array;
		private var iconsArray:Vector.<Sprite>;
		private var iconsTxtArray:Vector.<TextField>;
		private var circlesArray:Vector.<Shape>;
		
		private var __maskButtons:Shape;
		private var btnsHolder:Sprite;
		private var mainBtnsHolder:Sprite;
		private var movePart:Sprite;
		
		public static var buttons:Array = [ {color: 0x02a7df, alpha: 0.20 }, 
											{color: 0x88b943, alpha: 0.20 }, 
											{color: 0x534c44, alpha: 0.20 }, 
											{color: 0x836fad, alpha: 0.21 }, 
											{color: 0xff625f, alpha: 0.20 },
											{color: 0xfebd01, alpha: 0.17}];
		private static const NUM:int = 6;
		private var endDegree:Number = 0;
		private var center:Shape;
		
		public static const RADIUS2:Number = 350;
		public static const SECTOR:Number = FULL_CIRCLE / NUM;
		public static const THICKNESS:Number = 47;
		public static const FULL_CIRCLE:int = 360;
		public static const RADIUS:Number = 312; // - THICKNESS;		
		public static const DIAMETER:Number = RADIUS * 2 + THICKNESS;
		private var percent:Number = 0;
		private var krug:Sprite;
		private var klin:Sprite;
		private var movePartBaby:Sprite;
		private var centerX:Number;
		private var centerY:Number;
		
		public function Circle()
		{
			TweenPlugin.activate([ShortRotationPlugin]);
			
			center = new Shape();
			center.cacheAsBitmap = true;
			
			krug = Assets.create("filterkrug");
			krug.cacheAsBitmap = true;
			addChild(krug);
			
			krug.mask = center;
			centerX = krug.width * 0.5;
			centerY = krug.height * 0.5;
			
			movePart = new Sprite();
			movePart.cacheAsBitmap = true;
			
			movePartBaby = new Sprite();
			movePartBaby.cacheAsBitmap = true;
			
			mainBtnsHolder = new Sprite();
			mainBtnsHolder.cacheAsBitmap = true;
			addChild(mainBtnsHolder);
			
			btnsHolder = new Sprite();
			btnsHolder.cacheAsBitmap = true;
			mainBtnsHolder.addChild(btnsHolder);
			
			buttons = buttons.reverse();
			for (var i:int = 0; i < NUM; i++)
			{
				var btn:Shape = new Shape();
				btn.graphics.clear();
				btn.graphics.beginFill(buttons[i].color);
				btn.graphics.lineStyle(1, buttons[i].color, 1, false, "normal", CapsStyle.NONE);
				DrawingShapes.drawWedge(btn.graphics, centerX, centerY, RADIUS2 + 5, SECTOR, SECTOR * i + 90, RADIUS2 + 5);
				btnsHolder.addChild(btn);
			}
			
			bigButtonsArray = new Array();
			
			var bigButtons:InteractiveObject = new InteractiveObject();
			bigButtons.name = "big";
			addChild(bigButtons);
			for (i = 0; i < NUM; i++)
			{
				var ibtn:FilterButton = new FilterButton(i, buttons[i].color);					
				bigButtons.addChild(ibtn);
				bigButtonsArray.push(ibtn);
			}
			
			var BBmask:Shape = new Shape();
			BBmask.graphics.beginFill(0xff0000);
			BBmask.graphics.drawCircle(250, 240, 235);
			addChild(BBmask);
			BBmask.blendMode = BlendMode.ERASE;
			bigButtons.addChild(BBmask);
			bigButtons.blendMode = BlendMode.LAYER;
			
			var krug2:Sprite = Assets.create("_krug_hole");
			krug2.cacheAsBitmap = true;
			movePart.addChild(krug2);
			krug2.x = -krug.width * 0.5;
			krug2.y = -krug.height * 0.5;
			
			var baby:Sprite = Assets.create("baby");
			baby.cacheAsBitmap = true;
			
			baby.x = -550 * 0.5;
			baby.y = -550 * 0.5;
			
			movePartBaby.addChild(baby);
			addChild(movePart);
			btnsHolder.addChild(movePartBaby);
			
			movePart.x = krug.x + krug.width * 0.5;
			movePart.y = krug.y + krug.width * 0.5;
			movePartBaby.x = movePart.x;
			movePartBaby.y = movePart.y;
			
			btnsHolder.mask = movePartBaby;
			
			circlesArray = new Vector.<Shape>();
			createCircles(RADIUS);
			createCircles(RADIUS + 40);			
			
			function createCircles(rad:Number):void
			{
				var angle:Number = 240;
				for (var j:int = 0; j < 6; j++)
				{
					var circleMC:Shape = new Shape();
					circleMC.graphics.beginFill(0xffffff);
					circleMC.graphics.drawCircle(2.5, 2.5, 5);
					addChild(circleMC);
					circleMC.alpha = 0;
					
					circleMC.x = centerX + Math.cos(angle * Math.PI / 180) * rad;
					circleMC.y = centerY + Math.sin(angle * Math.PI / 180) * rad;
					angle += 60;
					circlesArray.push(circleMC);								
				}
			}
			
			var textFormat:TextFormat = new TextFormat("Tornado", 34, 0xffffff);
			
			iconsClip = new Sprite();
			addChild(iconsClip);
			
			
			iconsArray = new Vector.<Sprite>();
			iconsTxtArray = new Vector.<TextField>();
			
			var icons1:Sprite = Assets.create("_socialIcon");
			icons1.x = 19;
			icons1.y = -191;
			iconsClip.addChild(icons1);
			
			var icons1T:TextField = TextUtil.createTextField(0, 0);
			icons1T.text = "Общество";
			icons1T.setTextFormat(textFormat);
			icons1T.x = icons1.x - icons1T.width - 20;
			icons1T.y = icons1.y + 50;
			iconsClip.addChild(icons1T);
			
			
			var icons2:Sprite = Assets.create("_politicsIcon");
			icons2.x = 421;
			icons2.y = -197;
			iconsClip.addChild(icons2);
			
			
			var icons2T:TextField = TextUtil.createTextField(0, 0);
			icons2T.text = "Политика";
			icons2T.setTextFormat(textFormat);
			icons2T.x = icons2.x + icons2.width + 20;
			icons2T.y = icons2.y + 50;
			iconsClip.addChild(icons2T);
			
			
			var icons3:Sprite = Assets.create("_dtpIcon");
			icons3.x = 688;
			icons3.y = 173;
			iconsClip.addChild(icons3);
			
			
			var icons3T:TextField = TextUtil.createTextField(0, 0);
			icons3T.text = "Происшествия";
			icons3T.setTextFormat(textFormat);
			icons3T.x = icons3.x + 0.5 * (icons3.width - icons3T.width);
			icons3T.y = icons3.y + icons3.height + 30;
			iconsClip.addChild(icons3T);
			
		
			
			var icons4:Sprite = Assets.create("_cultureIcon");
			icons4.x = 377;
			icons4.y = 614;
			iconsClip.addChild(icons4);			
			
			var icons4T:TextField = TextUtil.createTextField(0, 0);
			icons4T.text = "Культура";
			icons4T.setTextFormat(textFormat);
			icons4T.x = icons4.x + icons4.width + 30;
			icons4T.y = icons4.y + 2;
			iconsClip.addChild(icons4T);
			
			
			var icons5:Sprite = Assets.create("_sportIcon");
			icons5.x = -23;
			icons5.y = 582;
			iconsClip.addChild(icons5);
			
			var icons5T:TextField = TextUtil.createTextField(0, 0);
			icons5T.text = "Спорт";
			icons5T.setTextFormat(textFormat);
			icons5T.x = icons5.x - icons5T.width - 30;
			icons5T.y = icons5.y + 35;
			iconsClip.addChild(icons5T);
			
			
			var icons6:Sprite = Assets.create("_economicsIcon");
			icons6.x = -257;
			icons6.y = 173;
			iconsClip.addChild(icons6);
			
			
			var icons6T:TextField = TextUtil.createTextField(0, 0);
			icons6T.text = "Экономика";
			icons6T.setTextFormat(textFormat);
			icons6T.x = icons6.x + 0.5 * (icons6.width - icons6T.width);
			icons6T.y = icons6.y + icons6.height + 30;
			iconsClip.addChild(icons6T);
			
			
			iconsArray.push(icons3);
			iconsTxtArray.push(icons3T);
			
			iconsArray.push(icons2);
			iconsTxtArray.push(icons2T);
			
			iconsArray.push(icons1);
			iconsTxtArray.push(icons1T);
			
			iconsTxtArray.push(icons6T);
			iconsArray.push(icons6);
			
			iconsArray.push(icons5);
			iconsTxtArray.push(icons5T);
			
			iconsArray.push(icons4);
			iconsTxtArray.push(icons4T);		
			
		}
		
		public function startRotate():void
		{
			if (!hasEventListener(InteractiveEvent.HAND_UPDATE))
			addEventListener(InteractiveEvent.HAND_UPDATE, uuuu, true);
		}
		
		public function stopRotate():void
		{
			removeEventListener(InteractiveEvent.HAND_UPDATE, uuuu, true);
		}
		
		public function hide():void
		{
			if (contains(center))
				removeChild(center);
			
			btnsHolder.visible = false;
			movePartBaby.visible = false;
			movePart.visible = false;
			
			percent = 0;
			removeEventListener(Event.ENTER_FRAME, fill);
			removeEventListener(Event.ENTER_FRAME, uuuu);
		}
		
		public function show():void
		{
			visible = true;
			addChild(center);
			
			btnsHolder.visible = false;
			movePartBaby.visible = false;
			movePart.visible = false;
			
			for (var i:int = 0; i < circlesArray.length; i++) 
			{
				TweenLite.to(circlesArray[i], 0.6, { delay:0.8 + 0.1 * i, alpha:0.4, ease:Expo.easeInOut } );	
			}
			for (var j:int = 0; j < 6; j++)
			{
				iconsArray[j].alpha = 0;
				iconsTxtArray[j].alpha = 0;
				TweenLite.to(iconsArray[j], 1., { delay:0.1 + 0.15 * j, alpha:1, ease:Expo.easeInOut } );					
				TweenLite.to(iconsTxtArray[j], 1., { delay:0.1 + 0.15 * j, alpha:1, ease:Expo.easeInOut } );					
			}
			
			percent = 0;
			addEventListener(Event.ENTER_FRAME, fill);
		}
		
		private function uuuu(e:InteractiveEvent):void
		{
			var point:Point = globalToLocal(new Point(e.stageX, e.stageY));
			var cy:Number = point.y - movePart.y;
			var cx:Number = point.x - movePart.x;
			
			var Radians:Number = Math.atan2(cy, cx);
			var Degrees:Number = Radians * 180 / Math.PI + 180;
			
			if (Degrees > 340 || Degrees < 20)
			{
				Degrees = 359;
			}
			else if (Degrees > 40 && Degrees < 80)
			{
				Degrees = 60;
			}
			
			else if (Degrees > 100 &&  Degrees < 140)
			{
				Degrees = 120;
			}
			else if (Degrees > 160 &&  Degrees < 200)
			{
				Degrees = 180;
			}
			else if (Degrees > 220 &&  Degrees < 260)
			{
				Degrees = 240;
			}
			
			else if (Degrees > 280 && Degrees < 320)
			{
				Degrees = 300;
			}

			TweenMax.killTweensOf(movePart);
			TweenMax.killTweensOf(movePartBaby);			
			
			TweenMax.to(movePart,  0.2, {shortRotation:{rotation:Degrees}});
			TweenMax.to(movePartBaby,  0.2, {shortRotation:{rotation:Degrees}});			
		}
		
		private function fill(e:Event):void
		{
			center.graphics.clear();
			endDegree = FULL_CIRCLE * percent * 0.03;
			center.graphics.beginFill(0xff0000);
			DrawingShapes.drawWedge(center.graphics, centerX, centerY, RADIUS2 + 5, endDegree, 0, RADIUS2 + 5);
			
			if (endDegree >= FULL_CIRCLE)
			{
				removeEventListener(Event.ENTER_FRAME, fill);
				animateAll();
				//addEventListener(Event.ENTER_FRAME, uuuu);
				addEventListener(InteractiveEvent.HAND_UPDATE, uuuu, true);
			}
			percent++;
		}
		
		private function animateAll():void
		{
			center.graphics.clear();
			removeChild(center);
			
			btnsHolder.visible = true;
			movePartBaby.visible = true;
			movePart.visible = true;
		}	
	}
}
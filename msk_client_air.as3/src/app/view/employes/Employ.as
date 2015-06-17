package app.view.employes
{
	import app.AppSettings;
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.model.materials.Informer;
	import app.model.materials.Weather;
	import app.model.types.AnimationType;
	import app.view.baseview.MainScreenView;
	import app.view.utils.Tool;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class Employ extends MainScreenView
	{
		private var services:Sprite;
		
		private var rotatorTimer:Timer;
		
		private var weth1:Sprite;
		private var weth2:Sprite;
		private var weth3:Sprite;
		
		private var wethArray:Array;
		
		private var dtp1:Sprite;
		private var dtp2:Sprite;
		private var dtp3:Sprite;
		
		private var dtpArray:Array;
		
		private var val1:Sprite;
		private var val2:Sprite;
		private var val3:Sprite;
		
		private var valArray:Array;
		
		private var initScreenShot:Sprite;
		
		private var NUM:int = 3;
		private var weather:Vector.<Weather>;
		
		public function Employ()
		{
			rotatorTimer = new Timer(3000);
			rotatorTimer.addEventListener(TimerEvent.TIMER, showBlock);
			rotatorTimer.start();
		}
		
		public function setInformer(inf:Informer):void
		{
			var w:WeatherGr = new WeatherGr();
			w.road(inf);
			w.x = AppSettings.WIDTH / 3;
			addChildAt(w, 0);
			
			var w1:WeatherGr = new WeatherGr();
			w1.financial(inf);
			w1.x = AppSettings.WIDTH / 3 * 2;
			addChildAt(w1, 0);
		}
		
		public function setWeather(weather:Vector.<Weather>):void
		{
			this.weather = weather;
			
			var w:WeatherGr = new WeatherGr();
			w.weather(weather[0]);
			addChild(w);
			addChildAt(w, 0);
			
			var l1:Shape = Tool.createShape(2, 69, 0x000000);
			addChild(l1);
			l1.x = AppSettings.WIDTH / 3;
			
			var l2:Shape = Tool.createShape(2, 69, 0x000000);
			addChild(l2);
			l2.x = AppSettings.WIDTH / 3 * 2;
		}
		
		public function setScreenShot():void
		{
			var bitmapData:BitmapData = new BitmapData(AppSettings.WIDTH, 69);
			bitmapData.drawWithQuality(this, null, null, null, null, true, StageQuality.BEST);
			config.setScreenShot(new Bitmap(bitmapData), "EMPLOY_NEWS");
		}
		
		override public function setScreen():void
		{
			y = AppSettings.HEIGHT;
			initScreenShot = config.getScreenShot("EMPLOY_NEWS");
			addChild(initScreenShot);
			visible = true;
		}
		
		private function showBlock(e:TimerEvent):void
		{
			if (initScreenShot && contains(initScreenShot))
				removeChild(initScreenShot);
		}
		
		override public function kill():void
		{
			rotatorTimer.removeEventListener(TimerEvent.TIMER, showBlock);
			rotatorTimer.stop();
			super.kill();
		}
		
		public function refreshData():void
		{
		
		}
		
		public function toMainScreen():void
		{
			x = 0;
			y = AppSettings.HEIGHT;
			visible = true;
			animateToXY(0, AppSettings.HEIGHT - this.height, 1.0);
			dispatchEvent(new DataLoadServiceEvent(DataLoadServiceEvent.REFRESH_COMPLETED_EMPLOY, true, true));
		}
		
		public function show():void
		{
			visible = true;
			y = AppSettings.HEIGHT - this.height;
			dispatchEvent(new DataLoadServiceEvent(DataLoadServiceEvent.REFRESH_COMPLETED_EMPLOY, true, true));
		}
		
		public function gotoNewsDay():void
		{
			animateOutXY(this.x, AppSettings.HEIGHT, anim.MainScreen1AllNews.animOutSpeed, anim.MainScreen1AllNews.animOutEase);
		}
		
		override public function animationInFinished():void
		{
			dispatchEvent(new AnimationEvent(AnimationEvent.EMPLOY_ANIMATION_FINISHED, AnimationType.IN, this));
		}
		
		override public function animationOutFinished():void
		{
			dispatchEvent(new AnimationEvent(AnimationEvent.EMPLOY_ANIMATION_FINISHED, AnimationType.OUT, this));
		}
	}
}

import app.AppSettings;
import app.assets.Assets;
import app.model.materials.Informer;
import app.model.materials.Weather;
import app.view.utils.TextUtil;
import app.view.utils.Tool;
import flash.display.Shape;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.Dictionary;

internal class WeatherGr extends Sprite
{
	private var txt:TextField;
	private var txtW:TextField;
	private var txtW2:TextField;
	public var surf:Sprite;
	public var textFormat:TextFormat = new TextFormat("Tornado", 16, 0xfff000);
	
	public static var weatherArray:Dictionary = new Dictionary();
	
	public function WeatherGr():void
	{
		weatherArray["4"] = {text: "Дождь", img: "wrain"};
		weatherArray["5"] = {text: "Ливень", img: "wshower"};
		weatherArray["6"] = {text: "Снег", img: "wsnow"};
		weatherArray["7"] = {text: "Снег", img: "wsnow"};
		weatherArray["8"] = {text: "Гроза", img: "wstorm"};
		weatherArray["9"] = {text: "Нет данных", img: ""};
		weatherArray["10"] = {text: "Ясно", img: "wclear"};
	}
	
	public function financial(inf:Informer):void
	{
		surf = new Sprite();
		addChild(surf);
		
		var sh:Shape = Tool.createShape(AppSettings.WIDTH / 3, 69, 0x101114);
		surf.addChild(sh);
		
		txt = TextUtil.createTextField(0, 0);
		txt.text = "ФИНАНСЫ";
		txt.setTextFormat(textFormat);
		
		txt.y = 0.5 * (surf.height - txt.height);
		txt.x = 40;
		
		addChild(txt);
		
		var img:Sprite = Assets.create("backs");
		addChild(img);
		
		img.x = txt.x + txt.width + 30;
		img.y = 0.5 * (surf.height - img.height);
		
		textFormat.color = 0xf4f4f4;
		textFormat.size = 25;
		
		txtW = TextUtil.createTextField(0, 0);
		txtW.text = inf.usd_current;
		txtW.setTextFormat(textFormat);
		
		txtW.y = 0.5 * (surf.height - txtW.height);
		txtW.x = txt.x + txt.width + 50;
		
		addChild(txtW);
		
		//trace("inf.usd_change", inf.usd_change);
		
		var img1:Sprite = Assets.create(inf.getUsdChangeImg());
		addChild(img1);
		
		img1.x = txtW.x + txtW.width + 10;
		img1.y = 0.5 * (surf.height - img1.height);
		
		var img3:Sprite = Assets.create("backs");
		addChild(img3);
		
		img3.x = img1.x + img1.width + 50;
		img3.y = 0.5 * (surf.height - img3.height);
		
		txtW2 = TextUtil.createTextField(0, 0);
		txtW2.text = inf.eur_current;
		txtW2.setTextFormat(textFormat);
		
		txtW2.y = 0.5 * (surf.height - txtW2.height);
		txtW2.x = img3.x + img3.width + 10;
		
		addChild(txtW2);
		
		var img2:Sprite = Assets.create(inf.getEuroChangeImg());
		addChild(img2);
		
		img2.x = txtW2.x + txtW2.width + 10;
		img2.y = 0.5 * (surf.height - img2.height);
	}
	
	public function road(inf:Informer):void
	{
		surf = new Sprite();
		addChild(surf);
		
		var sh:Shape = Tool.createShape(AppSettings.WIDTH / 3, 69, 0x101114);
		surf.addChild(sh);
		
		txt = TextUtil.createTextField(0, 0);
		txt.text = "ПРОБКИ";
		txt.setTextFormat(textFormat);
		
		txt.y = 0.5 * (surf.height - txt.height);
		txt.x = 40;
		
		addChild(txt);
		
		textFormat.color = 0xf4f4f4;
		textFormat.size = 25;
		
		txtW = TextUtil.createTextField(0, 0);
		txtW.text = inf.getBallText(); //inf.getRoadText(); //"";//w.maxT + " °C";
		txtW.setTextFormat(textFormat);
		
		txtW.y = 0.5 * (surf.height - txtW.height);
		txtW.x = txt.x + txt.width + 50;
		
		addChild(txtW);
		
		var img:Sprite = Assets.create(inf.geImage());
		addChild(img);
		//Tool.changecolor(img, 0x7a8092);
		//img.scaleX = img.scaleY = 0.3;
		img.x = txtW.x + txtW.width + 20;
		img.y = 0.5 * (surf.height - img.height);
		
		txtW2 = TextUtil.createTextField(0, 0);
		txtW2.text = inf.getRoadText();
		if (txtW2.text.length > 17)
		{
			textFormat.size = 20;
			txtW2.setTextFormat(textFormat);
			textFormat.size = 25;
		}
		else
		{
			txtW2.setTextFormat(textFormat);
		}
		
		txtW2.x = img.x + img.width + 40;
		txtW2.y = 0.5 * (surf.height - txtW2.height);
		addChild(txtW2);
	}
	
	public function weather(w:Weather):void
	{
		//Employ.wethArray
		surf = new Sprite();
		addChild(surf);
		
		var sh:Shape = Tool.createShape(AppSettings.WIDTH / 3, 69, 0x101114);
		surf.addChild(sh);
		
		txt = TextUtil.createTextField(0, 0);
		txt.text = "СЕЙЧАС";
		txt.setTextFormat(textFormat);
		
		txt.y = 0.5 * (surf.height - txt.height);
		txt.x = 40;
		
		addChild(txt);
		
		textFormat.color = 0xf4f4f4;
		textFormat.size = 35;
		
		txtW = TextUtil.createTextField(0, 0);
		txtW.text = w.maxT + " °C";
		txtW.setTextFormat(textFormat);
		
		txtW.y = 0.5 * (surf.height - txtW.height);
		txtW.x = txt.x + txt.width + 50;
		
		addChild(txtW);
		
		var _w:Object = weatherArray[w.precipitation];
		
		if (_w)
		{
			var img:Sprite = Assets.create(_w.img);
			addChild(img);
			Tool.changecolor(img, 0x7a8092);
			img.scaleX = img.scaleY = 0.3;
			img.x = txtW.x + txtW.width + 40;
			img.y = 0.5 * (surf.height - img.height);
			
			txtW2 = TextUtil.createTextField(0, 0);
			txtW2.text = _w.text;
			txtW2.setTextFormat(textFormat);
			txtW2.x = img.x + img.width + 40;
			txtW2.y = 0.5 * (surf.height - txtW2.height);
			addChild(txtW2);
		}
	}
}
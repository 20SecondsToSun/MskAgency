package app.view.page
{
	import app.AppSettings;
	import app.assets.Assets;
	import app.contoller.events.AnimationEvent;
	import app.model.types.AnimationType;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import app.view.utils.video.VideoPlayer;
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class BroadcastPage extends BasePage
	{
		private var img:Sprite;
		private var splash:Sprite;
		private var adapter:VideoPlayer;
		private var mainTitle:TextField;
		private var textFormat:TextFormat = new TextFormat("TornadoL", 36, 0xffffff);
		
		private var textFormat1:TextFormat = new TextFormat("Tornado", 22, 0x828696);
		
		public function refreshData():void
		{
		
		}
		
		override public function flip():void
		{
			//createBroadcastImg();
			//
			splash = new Sprite();
			addChild(splash);
			
			
			var sp:Shape = Tool.createShape(AppSettings.WIDTH, AppSettings.HEIGHT, 0x1a1b1f);			
			splash.addChild(sp);
			
			
			
			adapter = new VideoPlayer(AppSettings.WIDTH, AppSettings.HEIGHT);
			adapter.initBroadcast("rtmp://vgtrk.cdnvideo.ru/rr2/?auth=vh&cast_id=1661/");
			
			
			
			
			
			var logo:Sprite = Assets.create("mskLogo");
			splash.addChild(logo);
			logo.x = (AppSettings.WIDTH - logo.width) * 0.5;
			logo.y = 220;
			
			
			
			var sp1:Shape = Tool.createShape(AppSettings.WIDTH, 329, 0x0f0f12);
			sp1.y = AppSettings.HEIGHT  - sp1.height;
			splash.addChild(sp1);
			
			
			var titleTxt:String = "Трансляция прямого эфира телеканала временно недоступна";
			
			var title:TextField = TextUtil.createTextField(0, 0);
			title.text = titleTxt;
			title.setTextFormat(textFormat);
			title.x = 0.5 * (AppSettings.WIDTH -  title.width);
			title.y = 885;
			splash.addChild(title);
			
			titleTxt = "В ближайшее время мы восстановим трансляцию";
			
			var title2:TextField = TextUtil.createTextField(0, 0);
			title2.text = titleTxt;
			title2.setTextFormat(textFormat1);
			title2.x = 0.5 * (AppSettings.WIDTH -  title2.width);
			title2.y = 932;
			splash.addChild(title2);
			
			
			
			
			splash.y = AppSettings.HEIGHT;
			TweenLite.to(splash, 1, { delay:0.8,y: 0, ease: Expo.easeOut, onComplete: animationInFinished() } );
			/*mainTitle = TextUtil.createTextField(0, 0);
			addChild(mainTitle);
			setVolume("100");*/
			
			
		}
		public function setVolume(volume:String):void
		{
			/*mainTitle.text = volume;
			mainTitle.setTextFormat(textFormat);
			mainTitle.y = 0.5 * (AppSettings.HEIGHT - mainTitle.height);
			mainTitle.x = 0.5 * (AppSettings.WIDTH - mainTitle.width);*/
		}
		
		private function createBroadcastImg():void
		{
			img = Assets.create("broadcastPage");
			img.x = AppSettings.WIDTH;
			addChild(img);
		
		}
		
		override public function expand():void
		{
			createBroadcastImg();
			img.alpha = 0;
			
			TweenLite.to(img, 0.5, {alpha: 1, delay: 0.8, onComplete: animationInFinished()});
		}
	
	}
}
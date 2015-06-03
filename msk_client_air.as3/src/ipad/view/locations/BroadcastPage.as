package ipad.view.locations 
{
	import app.contoller.events.IpadEvent;
	import flash.events.MouseEvent;
	import ipad.assets.Assets;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import flash.display.CapsStyle;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ipad.controller.IpadConstants;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class BroadcastPage extends Sprite
	{
		private var textFormat:TextFormat = new TextFormat("TornadoL", 48 * IpadConstants.contentScaleFactor, 0Xe6e8ed);
		private var textFormat1:TextFormat = new TextFormat("TornadoL", 30 * IpadConstants.contentScaleFactor, 0x828696);
		private var textFormat2:TextFormat = new TextFormat("TornadoItalic", 24 * IpadConstants.contentScaleFactor, 0xe6e8ed);
	
		private var mainTitle:TextField;
		private var mainTitle1:TextField;
		private var helpPromt:TextField;
		
		public var TITLE1:String = "Прямой эфир телеканала Москва 24";
		public var TITLE2:String = "Следите за новостями Москвы 24 часа в сутки";
		public var TITLE3:String = "При необходимости регулируйте\nгромкость звука";
		public var promtCoords_x:Number = IpadConstants.GameWidth - (460+144)* IpadConstants.contentScaleFactor ;
		public var promtCoords_y:Number = IpadConstants.GameHeight - (290 + 144 +20) * IpadConstants.contentScaleFactor;
		
		private var vol:Sprite;		
		private var progress:Sprite;
		
		public function BroadcastPage() 
		{
			mainTitle = TextUtil.createTextField(156 * IpadConstants.contentScaleFactor, 136 * IpadConstants.contentScaleFactor);
			mainTitle.text = TITLE1;
			mainTitle.setTextFormat(textFormat);
			addChild(mainTitle);
			
			mainTitle1 = TextUtil.createTextField(156 * IpadConstants.contentScaleFactor, 0);
			mainTitle1.text = TITLE2;
			mainTitle1.setTextFormat(textFormat1);
			addChild(mainTitle1);				
			
			helpPromt = TextUtil.createTextField(156 * IpadConstants.contentScaleFactor, 0);
			helpPromt.text = TITLE3;
			helpPromt.setTextFormat(textFormat2);
			helpPromt.x = promtCoords_x;
			helpPromt.y = promtCoords_y;
			addChild(helpPromt);			
			
			mainTitle.y = 136 * IpadConstants.contentScaleFactor - 20;
			mainTitle.alpha = 0.4;
			
			mainTitle1.y = mainTitle.y + mainTitle1.height - 20;
			mainTitle1.alpha = 0.4;
			
			helpPromt.alpha = 0.4;
			
			TweenLite.to(mainTitle,  0.5,  { y: 136 * IpadConstants.contentScaleFactor, alpha: 1, ease: Quad.easeInOut});
			TweenLite.to(mainTitle1, 0.5,  { y: 136 * IpadConstants.contentScaleFactor + mainTitle.height + 5, alpha: 1, ease: Quad.easeInOut});
			TweenLite.to(helpPromt,  0.5,  { alpha: 1, ease: Quad.easeInOut } );			
			
			progress = new Sprite();			
			progress.graphics.lineStyle(19* IpadConstants.contentScaleFactor, 0x2b2c32,1,false,"normal",CapsStyle.ROUND);
			progress.graphics.moveTo(0,0);
			progress.graphics.lineTo(1131 * IpadConstants.contentScaleFactor, 0);			
			progress.x = 0.5 * (IpadConstants.GameWidth - progress.width);
			progress.y = 0.5 * (IpadConstants.GameHeight - (progress.height + 290 * 0.5) * IpadConstants.contentScaleFactor);			
			addChild(progress);
			
			vol = new Sprite();
			var spr:Sprite = Assets.create("vol");
			spr.mouseEnabled = false;
			vol.addChild(spr); 
			vol.name = "vol";
			vol.scaleX = vol.scaleY =  IpadConstants.contentScaleFactor;
			
			vol.x = 0.5 * (IpadConstants.GameWidth - vol.width);
			vol.y =  progress.y + 0.5 * (progress.height - vol.height );
			addChild(vol);			
			
		}
		public function init(percent:Number):void 
		{
			vol.x = progress.width * percent  + progress.x - vol.width * 0.5;				
		}
		public function startDragSlider(_x:Number):void 
		{
			//vol.x = _x - vol.width * 0.5;			
		}
		
		public function updateDragSlider(e:MouseEvent):void 
		{
			vol.x = e.stageX - vol.width * 0.5;	
			if (vol.x < progress.x - vol.width * 0.5)
			{
				vol.x = progress.x - vol.width * 0.5;
			}
			else if (vol.x > progress.x + progress.width - vol.width * 0.5)
			{
				vol.x = progress.x + progress.width - vol.width * 0.5;
			}
			
			var percent:Number = Math.floor((vol.x - progress.x + vol.width * 0.5) / (progress.width) * 100) / 100;	
			dispatchEvent(new IpadEvent(IpadEvent.VOLUME, true, false, percent));
		}
	}
}
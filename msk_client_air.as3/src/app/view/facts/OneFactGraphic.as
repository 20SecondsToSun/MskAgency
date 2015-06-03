package app.view.facts
{
	import app.AppSettings;
	import app.assets.Assets;
	import app.contoller.events.InteractiveEvent;
	import app.model.materials.Fact;
	import app.view.baseview.io.InteractiveButton;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	
	public class OneFactGraphic extends InteractiveButton
	{
		private static const MAX_LINES:int = 3;
		
		private var billet:Shape;
		public var factData:Fact;		
		private var factTime:Sprite;
		private var factTitle:TextField;
		private var factTitleBmp:Bitmap;
		public var id:int;
		
		public function OneFactGraphic(fact:Fact)
		{
			factData = fact;
			id = fact.id;
			
			addFactTime();
			addFactTitle();
			//addIsLive();
			
			addBillet();
		}	
		
		private function addFactTime():void
		{
			factTime = new Sprite();
			factTime.x = -3;
			factTime.y = 3;
			addChild(factTime);
			
			var textFormat:TextFormat = new TextFormat("TornadoL", 33, 0X193a2c);
			
			if (TextUtil.isEqualDayDate(factData.start_date, factData.end_date))
			{				
				var factTimeText:TextField = TextUtil.createTextField(0, 0);
				var startTime:String = TextUtil.getFormatTime(factData.start_date);
				var endTime:String = TextUtil.getFormatTime(factData.end_date);
				
				factTimeText.text = startTime + " — " + endTime;
				factTimeText.setTextFormat(textFormat);
				
				factTime.addChild(factTimeText);
			}
			else
			{
				var textFormatMonth:TextFormat = new TextFormat("Tornado", 21, 0X193a2c);
				
				var d1:TextField = TextUtil.createTextField(0, 0);
				d1.text = factData.start_date.getDate().toString();
				d1.setTextFormat(textFormat);
				var bmp:Bitmap = TextUtil.textFieldToBitmap(d1, 1);
				factTime.addChild(bmp);
				
				var d1Month:TextField = TextUtil.createTextField(factTime.width,0);
				d1Month.text = TextUtil.month[factData.start_date.getMonth()];
				d1Month.setTextFormat(textFormatMonth);
				
				bmp = TextUtil.textFieldToBitmap(d1Month, 1);
				bmp.y = d1.height - d1Month.height - 3;
				bmp.x = factTime.width;				
				factTime.addChild(bmp);			
				
				var tire:TextField = TextUtil.createTextField(factTime.width, 0);
				tire.text = " — ";
				tire.setTextFormat(textFormat);
				
				bmp = TextUtil.textFieldToBitmap(tire, 1);				
				bmp.x = factTime.width;				
				factTime.addChild(bmp);							
				
				var d2:TextField = TextUtil.createTextField(factTime.width, 0);
				d2.text = factData.end_date.getDate().toString();
				d2.setTextFormat(textFormat);
				
				bmp = TextUtil.textFieldToBitmap(d2, 1);				
				bmp.x = factTime.width;				
				factTime.addChild(bmp);				
				
				var d2Month:TextField = TextUtil.createTextField(factTime.width, 0);
				d2Month.text = TextUtil.month[factData.end_date.getMonth()];
				d2Month.setTextFormat(textFormatMonth);				
				
				bmp = TextUtil.textFieldToBitmap(d2Month, 1);				
				bmp.x = factTime.width;	
				bmp.y = d2.height - d2Month.height - 3;
				factTime.addChild(bmp);				
			}			
		}
		
		private function addFactTitle():void
		{
			var textFormat:TextFormat = new TextFormat("TornadoL", 21 , 0Xffffff);
			
			factTitle = TextUtil.createTextField(0, 55);
			factTitle.multiline = true;
			factTitle.wordWrap = true;
			factTitle.width = 313;
			factTitle.text = factData.title;			
			TextUtil.truncate(factTitle, MAX_LINES,textFormat);			
			factTitleBmp = TextUtil.textFieldToBitmap(factTitle);
			factTitleBmp.y = 55;
			addChild(factTitleBmp);				
		}
		
		private function addIsLive():void
		{
			var live:Sprite = Assets.create("live");
			addChild(live);
			live.y = factTime.y + 5;
			live.x = factTime.x + factTime.width + 20;		
		}
		
		private function addBillet():void
		{
			var _w:Number = width + 80 > 400?400:width + 80;
			billet = Tool.createShape(_w, 190, 0xFFFF00);	
			
			addChild(billet);
			billet.y = - 40;
			billet.x = - 50
			billet.alpha = 0;
		}
		
		public function overState(e:InteractiveEvent):void
		{			
			TweenLite.to(factTitleBmp, 0.4, {y:45} );
			TweenLite.to(factTime, 0.4, { colorTransform: { tint:0xfff000, tintAmount:1 }} );			
		}
		
		public function outState(e:InteractiveEvent):void
		{				
			TweenLite.to(factTitleBmp, 0.4, {y:55} );
			TweenLite.to(factTime, 0.4, { colorTransform: { tint:0X193a2c, tintAmount:1 }} );			
		}
		
		override public function getSelfRec():Rectangle
		{	
			var point:Point = parent.localToGlobal(new Point(x, y));
			var finWidth:Number = width;
			if (point.x + width > AppSettings.WIDTH)
			{
				finWidth = AppSettings.WIDTH - point.x;
			}
			if (point.x <0)
			{
				finWidth = width + point.x;
				point.x = 0;
			}
			return new Rectangle(point.x,point.y, finWidth, height);
		}
		
		public function kill():void
		{
			if (factTitleBmp) factTitleBmp.bitmapData.dispose();
			
			TweenLite.killTweensOf(factTitleBmp);
			TweenLite.killTweensOf(factTime);
		}
	
	}

}
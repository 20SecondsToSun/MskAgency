package app.view.page.days.onedayslider 
{
	import app.assets.Assets;
	import app.contoller.events.AnimationEvent;
	import app.view.baseview.io.InteractiveButton;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.TweenLite;
	import flash.display.CapsStyle;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author castor troy
	 */
	public class DateButton extends InteractiveButton
	{
		private static const WIDTH_LEFT_BLOCK:int = 178;
		private static const HEIGHT:int = 345;
		
		private var allnew:Sprite;
		private var textTitle:TextField;
		private var textDay:TextField;
		public var id:int;
		public var date:Date;
		
		public function DateButton(_date:Date, _id:int) 
		{
			name = "charge";
			
			id = _id;
			date = _date;
			
			var fon:Shape = Tool.createShape(WIDTH_LEFT_BLOCK, HEIGHT, 0x02a7df);
			addChild(fon);
			
			var line:Shape = new Shape();
			line.graphics.lineStyle(1, 0x46bfe8, 1, false, "normal", CapsStyle.NONE);			
			line.graphics.moveTo(0, HEIGHT);
			line.graphics.lineTo(WIDTH_LEFT_BLOCK, HEIGHT);	
			line.y -= 1;
			addChild(line);
			
			var textFormat:TextFormat = new TextFormat("TornadoL", 72 , 0Xffffff);			
			
			textTitle = TextUtil.createTextField(0, 80);
			textTitle.multiline = false;
			textTitle.wordWrap = false;			
			textTitle.text = date.getDate().toString();			
			textTitle.setTextFormat(textFormat);
			textTitle.x = 0.5 * (WIDTH_LEFT_BLOCK - textTitle.width);			
			addChild(textTitle);			
			
			textFormat.size = 18;
			
			textDay = TextUtil.createTextField(0, 152);
			textDay.multiline = false;
			textDay.wordWrap = false;
			
			var hourtext:String = TextUtil.month[date.getMonth()];
			textDay.text = hourtext;
			
			textDay.setTextFormat(textFormat);		
			textDay.x = 0.5 * (WIDTH_LEFT_BLOCK - textDay.width);
			
			addChild(textDay);			
			
			allnew =  Assets.create("allnew");
			allnew.alpha = 0;					
			allnew.y = 203;
			allnew.x  = 0.5 * (WIDTH_LEFT_BLOCK - allnew.width);
			addChild(allnew);	
			
			var billet:Shape = Tool.createShape(WIDTH_LEFT_BLOCK, HEIGHT, 0x02a7df);
			billet.alpha  = 0;
			addChild(billet);			
		}
		
		public function push():void
		{
			dispatchEvent(new AnimationEvent(AnimationEvent.STRETCH, "", this));
			
		}
		
		public function over():void
		{			
			TweenLite.to(allnew, 0.5, { alpha:1 } );
			TweenLite.to(textTitle, 0.5, { y:60 } );
			TweenLite.to(textDay, 0.5, { y:132 } );
			
		}
		
		public function out():void
		{
			TweenLite.to(allnew, 0.5, { alpha:0 } );
			TweenLite.to(textTitle, 0.5, { y:80 } );
			TweenLite.to(textDay, 0.5, { y:152 } );
		}
		
	}

}
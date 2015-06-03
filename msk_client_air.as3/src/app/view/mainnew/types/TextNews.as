package app.view.mainnew.types 
{
	import app.assets.Assets;
	import app.model.materials.Material;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class TextNews extends MainType
	{		
		static public const MAX_LINES:int = 5;
		private var splash:Shape;
		private var _flagok:Shape;
		
		private var flagok:Sprite;
		
		private var timeFormat:TextFormat = new TextFormat("TornadoL", 33, 0Xf4f4f4);
		private var dateFormat:TextFormat = new TextFormat("TornadoMedium", 14, 0Xf4f4f4);
		private var titleFormat:TextFormat = new TextFormat("TornadoL", 45, 0x404040);
		private var timeText:TextField;
		private var titleText:TextField;	 
		private var dateTitle:TextField;
		
		public function TextNews() 
		{
			visible = false;
			name = "textnews";
			splash = Tool.createShape(WIDTH, HEIGHT, 0xf4f4f4);
			addChild(splash);
			
			flagok = Assets.create("flagok");
			addChild(flagok);
			flagok.x = 60;
			flagok.y = 60;	
			
			_flagok = Tool.createShape(124, 20, 0x0e9ac2);
			_flagok.visible = false;
			_flagok.x = _flagok.y = 60;
			addChild(_flagok);
			
			timeText = TextUtil.createTextField(52, 272);			
			timeText.multiline = false;
			timeText.wordWrap = false;
			timeText.y = flagok.y + 10;			
			addChild(timeText);					
			
			dateTitle = TextUtil.createTextField(52, 272);			
			addChild(dateTitle);			
		
			titleText = TextUtil.createTextField(60, 272);			
			titleText.multiline = true;
			titleText.width = 570;
			titleText.wordWrap = true;
			titleText.y = 270;			
			addChild(titleText);
			
			addFooter();
		}
		
		public function changeDate():void
		{
			var textFormat:TextFormat = new TextFormat("TornadoMedium", 14, 0xa5a5a5);
			if (dateTitle.text == "" || dateTitle.text == "ВЧЕРА")
			{
				dateTitle.text = "";
				dateTitle.setTextFormat(textFormat);
			}			
		}	
		
		override  public function show(mat:Material):void
		{
			visible = true;
			
			this.mat = mat;
			great = true;
			
			timeText.text =  TextUtil.getFormatTime(mat.publishedDate);	
			timeText.setTextFormat(timeFormat);
			timeText.x = flagok.x +0.5 * (flagok.width - timeText.width);			
			
			dateTitle.text = TextUtil.formatDate1(mat.publishedDate);	
			dateTitle.setTextFormat(dateFormat);
			dateTitle.x = timeText.x +0.5 * (timeText.width - dateTitle.width);			
			dateTitle.y = timeText.y +timeText.height -2;	
			
			if (dateTitle.text == "")
			{
				flagok.y = 60;	
				_flagok.visible = false;
			}
			else
			{
				_flagok.visible = true;
				flagok.y = 60+ _flagok.height;	
			}
			
			titleText.text = mat.title;	
			titleText.setTextFormat(titleFormat);
			TextUtil.truncate(titleText, MAX_LINES);			
			titleText.setTextFormat(titleFormat);
			titleText.y = HEIGHT - titleText.height - 60;	
		}	
		
		override public function kill():void 
		{
			TweenLite.killTweensOf(this);
			TweenLite.killDelayedCallsTo( readyToOver);
		}
	}
}
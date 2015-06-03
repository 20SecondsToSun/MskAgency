package app.view.mainnew.types
{
	import app.assets.Assets;
	import app.model.materials.Material;
	import app.model.materials.MaterialFile;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import app.view.utils.video.VideoPlayer;
	import com.greensock.layout.ScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class VideoNews extends MainType
	{
		static public const MAX_LINES:int = 10;
		private var fon:Shape;
		
		private var titleFormat:TextFormat = new TextFormat("TornadoBold", 21, 0x151515);
		private var titleText:TextField;
		private var ugolok:Sprite;
		
		private var offset:int = 25;
		private var adapter:VideoPlayer;
		
		public function VideoNews()
		{			
			adapter = new VideoPlayer(WIDTH, HEIGHT, ScaleMode.STRETCH);
			adapter.control = false;
			addChild(adapter);	
			setChildIndex(adapter, 0);
			
			fon = Tool.createShape(1, 1, 0xffdd1d);
			fon.y = fon.x = offset;
			addChild(fon);
			
			titleText = TextUtil.createTextField(60, 272);
			titleText.multiline = true;
			titleText.width = 500;
			titleText.wordWrap = true;
			addChild(titleText);
			//titleText.border = true;
			
			ugolok = Assets.create("ugolok");
			addChild(ugolok);				
			
			var billet:Shape = Tool.createShape(WIDTH, HEIGHT, 0xffdd1d);
			billet.alpha = 0;
			addChild(billet);			
			addFooter();
		}
		
		override public function show(mat:Material):void
		{
			this.mat = mat;
			var matFile:MaterialFile = mat.files[0];
			var  title:String = mat.title;
			
			great = false;			
			fon.x = great ? FRAME_SIZE + offset : offset;
			fon.y = fon.x;
			
			titleText.text = title;			
			TextUtil.truncate(titleText, MAX_LINES, titleFormat);			
			titleText.x = titleText.y = fon.y + 5;			
			
			fon.width = titleText.textWidth + 10;
			fon.height = titleText.height + 10;
			
			ugolok.x = fon.x;
			ugolok.y = fon.y + fon.height;			
			
			adapter.duration = Number(matFile.duration);
			adapter.init(matFile.pathToSource);
			adapter.mute();				
		}
		
		override public function stop():void
		{
			if (adapter)
				adapter.playStop();
		}
		
		override public function kill():void
		{
			if (adapter && contains(adapter))  
				removeChild(adapter);
		}	
	}
}
package app.view.mainnew.types 
{
	import app.assets.Assets;
	import app.model.materials.Material;
	import app.model.materials.MaterialFile;
	import app.view.baseview.photo.OnePhoto;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.layout.ScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class PhotoNews extends MainType
	{
		static public const MAX_LINES:int  = 10;
		private var thumb:OnePhoto;
		private var fon:Shape;
		
		private var titleFormat:TextFormat = new TextFormat("TornadoBold", 21, 0x151515);
		private var titleText:TextField;
		private var ugolok:Sprite;
		
		public function PhotoNews() 
		{		
			thumb = new OnePhoto("", -1, false);	
			thumb._scaleMode = ScaleMode.STRETCH;
			thumb._width = WIDTH;
			thumb._height = HEIGHT;	
			addChild(thumb);
			
			fon = Tool.createShape(1, 1, 0xffdd1d);
			fon.x = 50;
			fon.y = 50;
			addChild(fon);	
			
			titleText = TextUtil.createTextField(60, 272);			
			titleText.multiline = true;
			titleText.width = 500;
			titleText.wordWrap = true;
			titleText.y = fon.y	+5;		
			titleText.x = fon.x	+5;		
			addChild(titleText);
			
			ugolok = Assets.create("ugolok");
			addChild(ugolok);			
			addFooter();		
		}
		
		override  public function show(mat:Material):void
		{
			this.mat = mat;
			var matFile:MaterialFile = mat.files[0];
			var  title:String = mat.title;
			
			great = true;
			
			Tool.removeAllChildren(thumb);
			thumb._path = matFile.getPathToSourceWithScale(HEIGHT);
			thumb._id = matFile.id;	
			thumb.load();
			
			titleText.text = title;			
			titleText.setTextFormat(titleFormat);
			TextUtil.truncate(titleText, MAX_LINES);			
			titleText.setTextFormat(titleFormat);
			
			fon.width = titleText.textWidth + 10;
			fon.height = titleText.height + 10;
			
			ugolok.x = fon.x;
			ugolok.y = fon.y + fon.height;			
		}		
	}
}
package app.view.videonews
{
	import app.AppSettings;
	import app.assets.Assets;
	import app.model.materials.Material;
	import app.view.baseview.io.InteractiveButton;
	import app.view.baseview.photo.OnePhoto;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.easing.Cubic;
	import com.greensock.layout.ScaleMode;
	import com.greensock.TweenLite;
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
	public class OneVideoNewGraphic extends InteractiveButton
	{
		private static const MAX_LINES:int = 3;
		
		private var billet:Shape;
		private var textTitle:TextField;
		private var timeTitle:TextField;
		private var dateTitle:TextField;
		
		public var videoBackground:Sprite;
		public var holder:Sprite;
		public var mat:Material;
		public var id:int;
		public var thumbPath:String;
		
		public function OneVideoNewGraphic(mat:Material, isFirst:Boolean = false)
		{
			this.mat = mat;
			thumbPath = mat.files[0].thumbPath;
			id = mat.id;
			
			holder = new Sprite();
			addChild(holder);
			
			addBackground();
			addTimeTitle();
			addTextTitle();
			addThumb();
			addFooter();
			
			var __mask:Shape = Tool.createShape(width, 500, 0xff0000);
			__mask.alpha = 0;
			addChild(__mask);
			holder.mask = __mask;
		}
		
		private function addFooter():void
		{
			var footer:Shape = Tool.createShape(this.width, 77, 0x02a7df);
			footer.y = 500;
			holder.addChild(footer);
			
			var icon:Sprite = Assets.create("playOver");
			icon.y = 0.5 * (77 - icon.height) + 500;
			icon.x = 0.5 * (77 - icon.height);
			holder.addChild(icon);
			
			var textFormat:TextFormat = new TextFormat("Tornado", 16, 0Xffffff);
			var watch:TextField = TextUtil.createTextField(0, 0);
			watch.text = "СМОТРЕТЬ ВИДЕО";
			watch.setTextFormat(textFormat);
			
			watch.y = 0.5 * (77 - watch.height) + 500;
			watch.x = icon.x + icon.width + 15;
			holder.addChild(watch);
		}
		
		private function addThumb():void
		{
			var thumb:OnePhoto = new OnePhoto(mat.files[0].thumbPath, mat.files[0].id);
			thumb._scaleMode = ScaleMode.STRETCH;
			thumb._width = videoBackground.width;
			thumb._height = 297;
			holder.addChild(thumb);
			addBillet();
		}
		
		private function addBackground():void
		{
			videoBackground = Assets.create("videoBckgrnd");
			holder.addChild(videoBackground);
		}
		
		private function addLine():void
		{
			var line:Shape = new Shape();
			line.graphics.lineStyle(2, 0xdcd6d8, 1);
			line.graphics.moveTo(this.width, 0);
			line.graphics.lineTo(this.width, this.height - 1);
			holder.addChild(line);
		}
		
		private function addTimeTitle():void
		{
			var textFormat:TextFormat = new TextFormat("TornadoL", 33, 0X000000);
			timeTitle = TextUtil.createTextField(43, 338);
			timeTitle.text = TextUtil.getFormatTime(mat.publishedDate);
			timeTitle.setTextFormat(textFormat);
			holder.addChild(timeTitle);
			
			textFormat.color = 0xa5a5a5;
			textFormat.size = 14;
			textFormat.font = "TornadoMedium";
			
			dateTitle = TextUtil.createTextField(timeTitle.x + timeTitle.width + 13, 341);
			dateTitle.text = TextUtil.formatDate1(mat.publishedDate);
			dateTitle.setTextFormat(textFormat);
			holder.addChild(dateTitle);
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
		
		private function addTextTitle():void
		{
			var textFormat:TextFormat = new TextFormat("TornadoL", 21, 0X494949);
			
			textTitle = TextUtil.createTextField(43, 386);
			textTitle.multiline = true;
			textTitle.wordWrap = true;
			textTitle.width = 310;
			textTitle.text = mat.title;
			TextUtil.truncate(textTitle, MAX_LINES, textFormat);
			holder.addChild(textTitle);
		}
		
		private function addBillet():void
		{
			billet = Tool.createShape(width, height, 0xFFFF00);
			billet.alpha = 0;
			addChild(billet);
		}
		
		public function overState():void
		{
			TweenLite.delayedCall(0.3, readyToOver);
		}
		
		private function readyToOver():void
		{
			if (holder)
				TweenLite.to(holder, 0.5, {y: -77, ease: Cubic.easeInOut});
		}
		
		public function outState():void
		{
			TweenLite.killDelayedCallsTo(readyToOver);
			TweenLite.to(holder, 0.5, {y: 0, ease: Cubic.easeInOut});
		}
		
		override public function getSelfRec():Rectangle
		{
			var point:Point = parent.localToGlobal(new Point(x, 0));
			var finWidth:Number = width;
			
			if (point.x + width > AppSettings.WIDTH)
			{
				finWidth = AppSettings.WIDTH - point.x;
			}
			
			if (point.x < 0)
			{
				finWidth = width + point.x;
				point.x = 0;
			}
			
			return new Rectangle(point.x - 2, point.y, finWidth + 4, height);
		}
		
		public function kill():void
		{
			TweenLite.killDelayedCallsTo(readyToOver);
			TweenLite.killTweensOf(holder);
		}
	}
}
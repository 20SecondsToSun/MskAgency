package app.view.page.oneNews.Body
{
	import app.AppSettings;
	import app.model.materials.MaterialFile;
	import app.PresentationHelper;
	import app.view.baseview.io.InteractiveObject;
	import app.view.baseview.photo.OnePhoto;
	import app.view.utils.Tool;
	import com.greensock.easing.Quart;
	import com.greensock.layout.ScaleMode;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class Gallery extends Sprite
	{
		public var files:Vector.<MaterialFile>;
		
		public var slider:GallerySlider = new GallerySlider();
		public var previewSlider:PreviewSlider;
		private var previewHolder:InteractiveObject;
		private var previewMask:Sprite;
		private var fon:Shape;
		
		private static var FIELD_WIDTH:Number = 1298;
		private static var FIELD_HEIGHT:Number = 668;
		
		private var countPreview:int = 0;
		
		private var isPreviewOpen:Boolean = false;
		public var isWaitUpdate:Boolean;
		
		public function init(_files:Vector.<MaterialFile>):void
		{
			if (_files == null || _files.length == 0)
				return;
			
			kill();
			
			fon = Tool.createShape(FIELD_WIDTH, FIELD_HEIGHT, 0x000000);
			addChild(fon);
			
			slider = new GallerySlider();
			addChild(slider);
			
			previewHolder = new InteractiveObject();
			previewHolder.y = height - 416;
			addChild(previewHolder);
			
			var previewFon:Shape = Tool.createShape(FIELD_WIDTH, 417, 0xf4f5f7);
			previewHolder.addChild(previewFon);
			
			previewMask = new Sprite();
			
			var maskFon:Shape = Tool.createShape(FIELD_WIDTH, 417, 0xffffff);
			previewMask.addChild(maskFon);
			previewMask.height = 0;
			previewMask.y = FIELD_HEIGHT;
			
			previewHolder.mask = previewMask;
			addChild(previewMask);
			
			previewSlider = new PreviewSlider();
			previewHolder.addChild(previewSlider);
			
			countPreview = 0;
			isPreviewOpen = false;
			
			files = _files;
			
			var filesLength:int = files.length;
			var onePhoto:OnePhoto;
			
			var num:Array = [];
			for (var i:int = 0; i < 10; i++)
			{
				var s:String = PresentationHelper.getNum().toString();
				num.push(s);
				onePhoto = new OnePhoto("photos/" + s + ".jpg", i, false);
				onePhoto._height = FIELD_HEIGHT;
				onePhoto._scaleMode = ScaleMode.HEIGHT_ONLY;
				slider.addElement(onePhoto);
			}
			
			slider.loadOneByOne();
			
			if (filesLength == 1) return;
			
			//EDIT_PRES
			
			for (var j:int = 0; j < 10; j++)// filesLength; j++)
			{
				onePhoto = new OnePhoto("photos/" + num[j] + ".jpg", j, false);// files[j].pathToSource, files[j].id, false);
				onePhoto._height = 150;
				onePhoto._width = 150;
				onePhoto._scaleMode = ScaleMode.NONE;
				previewSlider.addElement(onePhoto);
			}
			previewSlider.loadOneByOne();
		}
		
		public function openPeview():void
		{
			if (isPreviewOpen)
			{
				slider.stopInteraction();
				TweenLite.to(previewMask, 0.5, {height: 0, y: FIELD_HEIGHT, ease: Quart.easeOut});
				TweenLite.to(slider, 0.5, {y: 0, ease: Quart.easeOut, colorTransform: {tint: 0x000000, tintAmount: 0}, onComplete: function():void
				{
					Tool.changecolor(fon, 0x000000);
					slider.startInteraction();
				}});
			}
			else
			{
				Tool.changecolor(fon, 0xf4f5f7);
				TweenLite.to(previewMask, 0.5, {height: 417, y: FIELD_HEIGHT - 417, ease: Quart.easeOut});
				TweenLite.to(slider, 0.9, {y: -170, ease: Quart.easeOut, colorTransform: {tint: 0x000000, tintAmount: 0.6}});
			}
			
			isPreviewOpen = !isPreviewOpen;
		}
		
		public function closePeview():void
		{
			if (isPreviewOpen)
			{
				
				slider.stopInteraction();
				TweenLite.to(previewMask, 0.5, {height: 0, y: FIELD_HEIGHT, ease: Quart.easeOut});
				TweenLite.to(slider, 0.5, {y: 0, ease: Quart.easeOut, colorTransform: {tint: 0x000000, tintAmount: 0}, onComplete: function():void
				{
					Tool.changecolor(fon, 0x000000);
					slider.startInteraction();
				}});
				isPreviewOpen = false;
			}
		}
		
		public function focusOnPhoto(id:Number):void
		{
			closePeview();
			slider.focusOnElement(id);
		}
		
		public function kill():void
		{
			countPreview = 0;
			isPreviewOpen = false;
			
			if (previewSlider)
			{
				for (var i:int = 0; i < previewSlider.numChildren - 1; i++)
				{
					var child:DisplayObject = previewSlider.getChildAt(i);
					if (child is Bitmap)
						(child as Bitmap).bitmapData.dispose();
					
					previewSlider.removeChild(child);
				}
			}
			
			Tool.removeAllChildren(this);
		}
	}
}
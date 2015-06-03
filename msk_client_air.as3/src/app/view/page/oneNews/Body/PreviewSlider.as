package app.view.page.oneNews.Body 
{
	import app.AppSettings;
	import app.view.baseview.photo.OnePhoto;
	import app.view.baseview.slider.Slider;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	/**
	 * ...
	 * @author metalcorehero
	 */
	public class PreviewSlider extends Slider
	{		
		private var clipArray:Vector.<OnePhotoPreview>;
		
		public var count:int = 0;
		private var photoLoadedCount:int = 0;
		
		private static const IN_ROW:int = 6;
		private static const MAX_PREVIEW:int = 12;		
		
		private static var initX:int = 67;
		private static var initY:int = 67;
		
		private static var shiftX:int = 48;
		private static var shiftY:int = 48
		
		private const GALLERY_HEIGHT:Number = 668;
		private const GALLERY_MARGIN:Number = 622;
		
		public function PreviewSlider() 
		{
			clipArray = new Vector.<OnePhotoPreview>;			
			super(new Rectangle(initX, 0, AppSettings.WIDTH -GALLERY_MARGIN - initX , GALLERY_HEIGHT), false);			
			holder.x = initX;
		}
		
		override public function addElement(photo:DisplayObject) :void
		{	
			var photoButton:OnePhotoPreview  = new OnePhotoPreview(photo as OnePhoto, clipArray.length);			
			clipArray.push(photoButton);	
			super.addElement(photoButton);
		}
		
		public function loadOneByOne():void
		{			
			clipArray[photoLoadedCount].load();			
		}
		
		public function loadNext():void
		{		
			var photo:OnePhotoPreview = clipArray[photoLoadedCount];
			
			if (clipArray.length <= MAX_PREVIEW)
			{
				photo.x = (shiftX + 150) * (photoLoadedCount % IN_ROW);
				photo.y = initY + (shiftY + 150) * (Math.floor(photoLoadedCount / IN_ROW));	
			}
			else
			{
				photo.x = (shiftX + 150) * (Math.floor(photoLoadedCount / 2));
				photo.y = initY + (shiftY + 150) * (Math.floor(photoLoadedCount % 2));	
			}			
			
			if (++photoLoadedCount < clipArray.length)
			{
				loadOneByOne();
			}
			else
			{
				if (photoLoadedCount > MAX_PREVIEW)
					startInteraction();
			}
		}

	}
}
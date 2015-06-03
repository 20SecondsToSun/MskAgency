package app.view.page.oneNews.Body 
{
	import app.view.baseview.io.InteractiveButton;
	import app.view.baseview.photo.OnePhoto;
	import app.view.utils.Tool;
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.Shape;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class OnePhotoPreview extends InteractiveButton
	{	
		public var id:int;
		public var preview:Bitmap;
		public var photo:OnePhoto;
		
		public function OnePhotoPreview(_photo:OnePhoto, _id:int) 		
		{
			id = _id;
			photo = _photo;
			addChild(photo);	
			
			var over:Shape = Tool.createShape(150, 150, 0xf4f5f7);			
			over.alpha = 0;
			addChild(over);
		}
		
		public function load():void 
		{
			photo.load();
		}
		
		public function overState() :void
		{
			TweenMax.to(this, 0.8, { colorTransform: { tint: 0x254121, tintAmount: 0.5 }} );			
		}
		
		public function outState() :void
		{
			TweenMax.to(this, 0.8, { removeTint:true });		
		}	
		
		public function kill() :void
		{			
			if (preview) preview.bitmapData.dispose();
		}
	}

}
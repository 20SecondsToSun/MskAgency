package app.view.photonews
{
	import app.AppSettings;
	import app.contoller.events.LoadPhotoEvent;
	import app.view.baseview.photo.OnePhoto;
	import app.view.baseview.slider.Slider;
	import app.view.utils.Tool;
	import com.greensock.easing.Back;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Quart;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class PhotoSlider extends Slider
	{
		private static const showNum:int = 6;
		
		public var onComplete:Function = null;
		public var callBackStart:Function = null;
		
		private var counter:int = 0;
		private var isInit:Boolean = false;
		
		private var photoData:Vector.<OnePhotoGraphic>;
		private var photoLoadedCount:int = 0;
		private var curX:Number = 0;
		private var fullWidth:Number = 0;
		
		private var numToShow:int = 5;
		private var countToShow:int = 0;		
		
		public function PhotoSlider(_viewPort:Rectangle = null)
		{
			photoLoadedCount = 0;			
			super(_viewPort);
		}
		
		public function init(_photoData:Vector.<OnePhotoGraphic>):void
		{
			photoLoadedCount = 0;			
			photoData = _photoData;		
			addElement(photoData[photoLoadedCount]);			
			holder.alpha = 0;			
			photoData[photoLoadedCount].alpha = 0;
			loadOneByOne();				
		}
		
		public function addOnePhoto(_photoData:OnePhotoGraphic, onComplete:Function):void
		{
			this.onComplete = onComplete;			
			var offset:Number = 0;
			fullWidth = 0;
			
			for (var i:int = 0; i < photoData.length; i++) 
			{
				photoData[i].x = fullWidth;
				if (!isNaN(photoData[i].__width)) 
					fullWidth += photoData[i].__width;
			}
			
			addElement(_photoData);			
			(photoData[photoData.length - 1].photo as OnePhoto).load();				
		}		
		
		public function loadOneByOne():void
		{	
			(photoData[photoLoadedCount].photo as OnePhoto).load();			
		}
		
		public function loadNextOne(photo:Bitmap):void
		{			
			
			photoData[photoData.length - 1].overlay(photo.width, photo.height);
			
			fullWidth += photoData[photoData.length - 1].__width;
			holder.x = maxBorder - fullWidth;
			holder.alpha = 1;				
			animate();
		}
		
		public function resetPositions():void
		{
			TweenLite.killTweensOf(holder);
			holder.x = maxBorder - fullWidth;
		}
		
		public function loadNext(photo:Bitmap):void
		{
			if (photoLoadedCount >= photoData.length)			
				return;			
			
			photoData[photoLoadedCount].x = curX;
			photoData[photoLoadedCount].overlay(photo.width, photo.height);
			curX += photoData[photoLoadedCount].width;
			photoData[photoLoadedCount].alpha = 1;
		
			if (++photoLoadedCount < photoData.length)
			{				
				addElement(photoData[photoLoadedCount]);				
				photoData[photoLoadedCount].alpha = 0;
				loadOneByOne();
			}
			else
			{
				var bckgrnd:Shape =	Tool.createShape(width, 232, 0x0000FF);			
				bckgrnd.alpha = 0;			
				addChild(bckgrnd);	
				startInteraction();
				
				holder.x = maxBorder - holder.width  - AppSettings.WIDTH;
				fullWidth = holder.width;
				holder.alpha = 1;
				isReady = true;				
				animate();				
				dispatchEvent(new LoadPhotoEvent(LoadPhotoEvent.COMPLETED));
			}
		}	
		
		public function animate():void 
		{	
			var j:int = 0;
			countToShow = 0;
			
			TweenLite.to(holder, 0.9, { x:maxBorder - holder.width } );
			
			if (callBackStart != null)
				callBackStart();	
		}
		
		private function startAnim(mc:OnePhotoGraphic):void 
		{
			mc.alpha = 1;
		}
		
		private function completeAnim(mc:OnePhotoGraphic):void 
		{
			countToShow++;			
			if (countToShow == numToShow) 
				if (onComplete != null) onComplete();
		}		
	}
}
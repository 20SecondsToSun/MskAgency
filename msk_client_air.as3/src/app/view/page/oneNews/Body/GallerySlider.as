package app.view.page.oneNews.Body
{
	import app.AppSettings;
	import app.contoller.events.GraphicInterfaceEvent;
	import app.contoller.events.InteractiveEvent;
	import app.view.baseview.photo.OnePhoto;
	import app.view.baseview.slider.Slider;
	import app.view.utils.Tool;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class GallerySlider extends Slider
	{
		private var clipArray:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		private var maskArray:Vector.<Shape> = new Vector.<Shape>();
		private var polosaArray:Vector.<Shape> = new Vector.<Shape>();
		
		private const MASK_MARGIN:Number = 600;
		private const GALLERY_HEIGHT:Number = 668;
		private const GALLERY_MARGIN:Number = 622;
		
		private var maskWidth:Number = 0;
		private var photoLoadedCount:int = 0;
		
		public function GallerySlider()
		{
			super(new Rectangle(0, 0, AppSettings.WIDTH - GALLERY_MARGIN, GALLERY_HEIGHT));
		}
		
		override public function addElement(photo:DisplayObject):void
		{
			var photoMask:Shape = Tool.createShape(1, GALLERY_HEIGHT, 0xff0000);
			
			photo.alpha = 0;
			photo.mask = photoMask;
			super.addElement(photo);
			super.addElement(photoMask);
			
			maskArray.push(photoMask);
			clipArray.push(photo);
		}
		
		public function loadOneByOne():void
		{
			(clipArray[photoLoadedCount] as OnePhoto).load();
		}
		
		public function loadNext():void
		{
			var photo:OnePhoto = clipArray[photoLoadedCount] as OnePhoto;
			var myMask:Shape = maskArray[photoLoadedCount];
			
			if (photoLoadedCount)
			{
				var polosa:Shape = Tool.createShape(5, GALLERY_HEIGHT, 0x000000);
				polosa.x = photo.x + photo.width;
				polosaArray.push(polosa);
				super.addElement(polosa);
			}
			
			if (photoLoadedCount > 0)
			{
				maskArray[photoLoadedCount - 1].width = clipArray[photoLoadedCount - 1].width;
				photo.x = holder.width;
				myMask.x = photo.x;
				resetPositions();
			}
			
			TweenLite.to(photo, 0.5, {alpha: 1});
			
			if (++photoLoadedCount < clipArray.length)
			{
				loadOneByOne();
			}
			else
			{
				if (clipArray.length > 1)
				{
					startInteraction();
				}
				else
				{					
					TweenLite.delayedCall(0.3, function():void
						{
							var center:Number = (AppSettings.WIDTH - GALLERY_MARGIN) * 0.5 + GALLERY_MARGIN;
							holder.x = ((AppSettings.WIDTH - GALLERY_MARGIN) - holder.width) * 0.5;
							if (clipArray && clipArray.length)
							{
								maskArray[0].width = clipArray[0].width;
								maskArray[0].x = clipArray[0].x;
							}						
						});
				}
			}
		}
		
		override public function startInteraction():void
		{
			super.startInteraction();
			resetPositions();
		}
		
		private function resetPositions():void
		{			
			var center:Number = (AppSettings.WIDTH - GALLERY_MARGIN) * 0.5 + GALLERY_MARGIN;
			var minDistance:Number = Number.POSITIVE_INFINITY;
			var minIndex:int = -1;
			
			//var _w:Number = 0;
			
			for (var i:int = 0; i < clipArray.length; i++)
			{
				//_w += clipArray[i].width;
				var maskX:Number = holder.localToGlobal(new Point(maskArray[i].x, 0)).x;
				var widthPercent:Number = 0;
				
				//trace(holder.x); 
				
				if (maskX > AppSettings.WIDTH)
				{
					widthPercent = 1;
				}
				else
				{
					widthPercent = (AppSettings.WIDTH - maskX) / (AppSettings.WIDTH - GALLERY_MARGIN);
				}
				
				widthPercent = widthPercent > 1 ? 1 : widthPercent;
				widthPercent = widthPercent < 0 ? 0 : widthPercent;
				
				maskArray[i].width = clipArray[i].width - MASK_MARGIN * (1 - widthPercent);
				if (i == clipArray.length - 1)
					maskArray[i].width = clipArray[i].width;
				
				if (i)
				{
					maskArray[i].x = maskArray[i - 1].x + maskArray[i - 1].width + 5;
				}
				if (i < polosaArray.length)
				{
					polosaArray[i].x = maskArray[i].x + maskArray[i].width;
				}
				if (maskX < GALLERY_MARGIN)
				{
					clipArray[i].x = maskArray[i].x - 0.5 * (1 - maskArray[i].width * (GALLERY_MARGIN - maskX) / GALLERY_MARGIN);
				}
				else
				{
					clipArray[i].x = maskArray[i].x + 0.5 * (maskArray[i].width - clipArray[i].width);
				}
			}
			//trace("===========");
			//trace(_w);
		}
		
		public function focusOnElement(id:Number):void
		{
			//return;
			var center:Number = (AppSettings.WIDTH - GALLERY_MARGIN) * 0.5 + GALLERY_MARGIN;
			var _clipX:Number = holder.localToGlobal(new Point(clipArray[id].x, 0)).x + clipArray[id].width * 0.5;
			var xPos:Number;
			var __w:Number = 0;
			
			if (id == 0)
			{
				xPos = 0;
			}
			else if (id == clipArray.length - 1)
			{
				xPos = -holder.width + maxBorder;
			}
			else
			{
				//xPos = center - _clipX;
				
				for (var i:int = 0; i < id; i++)
				{
					maskArray[i].width = clipArray[i].width - MASK_MARGIN;
					
					if (i)
					{
						maskArray[i].x = maskArray[i - 1].x + maskArray[i - 1].width + 5;
					}
					if (i < polosaArray.length)
					{
						polosaArray[i].x = maskArray[i].x + maskArray[i].width;
					}
					__w += maskArray[i].width;
						//maskArray[i].width = clipArray[i].width - MASK_MARGIN;
						//clipArray[i].x = maskArray[i].x -0.5 * (1 - maskArray[i].width * (GALLERY_MARGIN - maskX) / GALLERY_MARGIN);
				}
				maskArray[id].width = clipArray[id].width;
				maskArray[id].x = maskArray[id - 1].x + maskArray[id - 1].width + 5;
				clipArray[id].x = maskArray[id].x + 0.5 * (maskArray[id].width - clipArray[id].width);
			}
			
			holder.x = -__w;
			
			//trace("holder.x", holder.x);
			// 
			//resetPositions();
			
			/*
			 * 
	
			*/
		}
		
		override public function startDragSlider(e:InteractiveEvent):void
		{
			super.startDragSlider(e);
			dispatchEvent(new GraphicInterfaceEvent(GraphicInterfaceEvent.CLOSE_PREVIEW_PHOTO));
		}
		
		override public function updateDragSlider(e:InteractiveEvent):void
		{
			super.updateDragSlider(e);
			resetPositions();
			//trace("HERE2222222222222");
		}
		
		override protected function finishDraggingAnimation():void
		{
			super.finishDraggingAnimation();
			resetPositions();
			//trace("HERE!!!!!!!!!!!!!!!");
		}
		
		override public function updateFinAnimation():void
		{
			resetPositions();
			//trace("HERE3333333333333333");
		}
	}
}
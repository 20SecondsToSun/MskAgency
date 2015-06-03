package app.view.page.oneNews.Body
{
	import app.model.materials.Material;
	import app.view.page.oneNews.Buttons.PhotoButton;
	import app.view.utils.Tool;
	import com.greensock.easing.Quart;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class PhotoContainer extends Sprite
	{
		private var photoContainer:Gallery;
		private var maskLayer:Shape;	
		public var photoBtn:PhotoButton;
		public var id:String = "";
		public function PhotoContainer()
		{
			photoContainer = new Gallery();
			photoContainer.y = 0;
			photoContainer.x = 0;
			addChild(photoContainer);
			
			photoBtn = new PhotoButton();
			photoBtn.visible = false;
			photoBtn.x = 206 + 1000 - photoBtn.width;
			photoBtn.y = 794;		
			addChild(photoBtn);
			
			maskLayer = Tool.createShape(1298, 1, 0x000000);
			maskLayer.visible = false;
			addChild(maskLayer);
			
			photoContainer.mask = maskLayer;
		}
		
		public function animate(cur:String, last:String, mat:Material):void
		{
			if (cur != "photo" && last != "photo") return;
			
			if (cur == "text" || cur == "video"|| cur =="broadcast")
			{
				photoBtn.visible = false;
			}			
			else if (cur == "photo")
			{			
				var photoNum:String = mat.files.length.toString();
				
				if (int(photoNum) <= 1) photoBtn.visible = false;
				else photoBtn.visible = true;
				
				photoBtn.setText(photoNum);						
				//photoBtn.visible = true;				
				photoContainer.init(mat.files);
				
				maskLayer.visible = true;		
				TweenLite.to(maskLayer, 0.7, { height: 668, ease: Quart.easeOut } );				
			}
			
			if (last == "photo" && (cur == "video" || cur =="broadcast") )
			{
				photoContainer.kill();	
				maskLayer.visible = false;
			}			
			else if (last == "photo" && cur!="photo")
			{				
				TweenLite.to(maskLayer, 0.7, {height: 0, ease: Quart.easeOut, onComplete: function():void
					{
						photoContainer.kill();	
						maskLayer.visible = false;
					}});
			}				
		}		
		public function openPhotoBtn():void
		{
			photoContainer.openPeview();
		}	
	}

}
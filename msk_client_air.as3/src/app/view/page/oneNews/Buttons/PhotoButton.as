package app.view.page.oneNews.Buttons 
{
	import app.assets.Assets;
	import app.view.baseview.io.InteractiveButton;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.TweenMax;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class PhotoButton extends InteractiveButton
	{
		private var photoTextFormat:TextFormat = new TextFormat("Tornado", 24, 0xffffff);		
		private var photoBtnImg:Sprite
		private var photoPhotik:Sprite;
		private var photoDetail:Sprite;
		private var photoText:TextField;
		
		public function PhotoButton() 
		{
			photoBtnImg = Assets.create("fullScreen");
			var photoBtnFon:Shape = Tool.createShape( photoBtnImg.width, photoBtnImg.height, 0xf4f5f7);
		
			addChild(photoBtnFon);
			addChild(photoBtnImg);
			
			photoDetail = Assets.create("photik");
			addChild(photoDetail);
			
			photoDetail.y = 0.5 * (height - photoDetail.height);
			photoDetail.x = photoDetail.y;
			
			photoText = TextUtil.createTextField(photoDetail.y, 0);
			photoText.multiline = false;
			photoText.wordWrap = false;
			photoText.text = "";
			photoText.setTextFormat(photoTextFormat);
			
			addChild(photoText);
			
			photoText.y = 0.5 * (height - photoDetail.height);
			photoText.x = photoDetail.x + photoDetail.width + 20;
		}
		public function setText(photoNum:String):void 
		{
			photoText.text = photoNum + " " + TextUtil.formatCaseFoto(photoNum);			
			photoText.setTextFormat(photoTextFormat);			
		}
		public function over():void
		{
			TweenMax.to(photoBtnImg, 0.3, {colorTransform: {tint: 0x02a7df, tintAmount: 1}});
		}
		
		public function out():void
		{
			TweenMax.to(photoBtnImg, 0.3, {removeTint:true});
		}
		
	}

}
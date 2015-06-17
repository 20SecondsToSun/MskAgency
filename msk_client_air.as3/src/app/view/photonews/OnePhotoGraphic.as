package app.view.photonews
{
	import app.AppSettings;
	import app.assets.Assets;
	import app.contoller.events.InteractiveEvent;
	import app.model.materials.Material;
	import app.view.baseview.io.InteractiveButton;
	import app.view.baseview.photo.OnePhoto;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.layout.ScaleMode;
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
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
	public class OnePhotoGraphic extends InteractiveButton
	{
		private static const MAX_LINES:int = 7;
		
		private var graphic:Sprite;
		private var textFormat:TextFormat;
		private var titleText:TextField;
		public var photo:OnePhoto;
		
		private var mat:Material;		
		
		public var id:Number;		
		private var initX:Number;
		private var initY:Number;
		
		protected var timeTitleBmp:Bitmap;
		public var __width:Number;
		
		public function OnePhotoGraphic(photoNews:Material)
		{
			mat = photoNews;
			id = photoNews.id;
			
			if (photoNews.important == "0")			
				graphic = Assets.create("photoNewsNoImp");			
			else			
				graphic = Assets.create("photoNewsImp");			
			
			addChild(graphic);
			photo = new OnePhoto(photoNews.files[0].thumbPath, photoNews.files[0].id, false);	
			photo._scaleMode = ScaleMode.HEIGHT_ONLY;
			photo._height = 232;
			addChild(photo);
			
			photo.x = initX = graphic.width -20;
			initY = 0;						
	
			swapChildren(photo, graphic);
			
			textFormat = new TextFormat("TornadoL", 21, 0Xb1b7cb);
			textFormat.leading = 0.4;
			
			titleText = TextUtil.createTextField(41, 41);
			titleText.width = 220;
			//titleText.border = true;
			titleText.multiline = true;
			titleText.multiline = true;
			titleText.wordWrap = true;
			titleText.text = photoNews.title;
			
			titleText.setTextFormat(textFormat);
			TextUtil.truncate(titleText, MAX_LINES);
			titleText.setTextFormat(textFormat);
			
			timeTitleBmp = TextUtil.textFieldToBitmap(titleText);
			addChild(timeTitleBmp);				
		}
		
		public function overlay(_width:Number,_height:Number = 10, _scale:Number = 1):void
		{
			_scale = 232/_height;			
			__width = width + _width - 20;
			var w:Number = width  + _width*_scale  - 20;
			var overlay:Shape = Tool.createShape(w, height, 0xffffff);			
			overlay.alpha = 0;
			addChild(overlay);	
		}
		
		public function overState(e:InteractiveEvent):void
		{
			TweenMax.to(graphic, 0.8, {colorTransform: {tint: 0x02a7df, tintAmount: 1}});
			TweenMax.to(timeTitleBmp, 0.8, { colorTransform: { tint: 0xffffff, tintAmount: 1 }} );
			var __scale:Number = 1.1;
			TweenMax.to(photo, 1.8, { scaleX:__scale,  scaleY:__scale, x:initX + ( photo.width - photo.width*__scale ) * 0.5, y:initY + ( photo.height - photo.height*__scale ) * 0.5 } );				
		}
		
		public function outState(e:InteractiveEvent):void
		{			
			TweenMax.to(graphic, 0.5, { removeTint:true } );
			TweenMax.to(timeTitleBmp, 0.5, { removeTint:true } );
			TweenMax.to(photo, 0.5, { scaleX:1,  scaleY:1, x:initX, y:initY } );			
		}
		
		override public function getSelfRec():Rectangle
		{	
			var point:Point = parent.localToGlobal(new Point(x, y));
			var finWidth:Number = width;
			if (point.x + width > AppSettings.WIDTH)
			{
				finWidth = AppSettings.WIDTH - point.x;
			}
			if (point.x <0)
			{
				finWidth = width + point.x;
				point.x = 0;
			}
			return new Rectangle(point.x,point.y, finWidth, 232);
		}
		
		public function kill():void 
		{
			TweenMax.killTweensOf(graphic);
			TweenMax.killTweensOf(timeTitleBmp);
			TweenMax.killTweensOf(photo);
		}	
	}
}
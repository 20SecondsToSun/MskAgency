package app.view.baseview.onenewpage
{
	import app.AppSettings;
	import app.contoller.events.InteractiveEvent;
	import app.model.materials.Material;
	import app.view.page.oneNews.Body.FavPanel;
	import app.view.page.oneNews.Body.PhotoContainer;
	import app.view.page.oneNews.Body.PreloaderNews;
	import app.view.page.oneNews.Body.TextContainer;
	import app.view.page.oneNews.Body.VideoContainer;
	import app.view.page.oneNews.Buttons.FavoritesButton;
	import app.view.utils.BigCanvas;
	import app.view.utils.Tool;
	import caurina.transitions.Tweener;
	import com.greensock.easing.Expo;
	import com.greensock.motionPaths.RectanglePath2D;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	
	public class BaseNewsBody extends Sprite
	{
		public var textNews:TextContainer;
		protected var videoNews:VideoContainer;
		protected var photoNews:PhotoContainer;
		
		public var star:FavoritesButton;
		
		public var mat:*;		
		protected var lastType:String = "NONE";	
		
		public var favPanel:FavPanel;
		private var shot:BigCanvas;			
		public var activeID:int = -1;		
		private const favWidth:int = 622;		
		public var screenField :Rectangle = new Rectangle(favWidth, 0, AppSettings.WIDTH - favWidth, AppSettings.HEIGHT);		
		public var isFavorite:Boolean = false;	
		
		protected var preloader:PreloaderNews;
		
		public function BaseNewsBody()
		{
			preloader = new PreloaderNews();
			addChild(preloader);

			var fon:Shape = Tool.createShape(AppSettings.WIDTH - favWidth, AppSettings.HEIGHT, 0xf4f5f7);
			addChild(fon);
			
			star = new FavoritesButton();
			addChild(star);		
			
			textNews = new TextContainer();
			textNews.id = "base";
			addChild(textNews);
			
			photoNews = new PhotoContainer();
			photoNews.id = "base";
			addChild(photoNews);
			
			videoNews = new VideoContainer();
			videoNews.id = "base";
			addChild(videoNews);	
			
			favPanel = new FavPanel();
			addChild(favPanel);		
		}
		
		public function init(_mat:*):void
		{
			if (_mat == null) return;
			
			mat = _mat;
			
			if (mat.type == "text") refresh(mat);
			else
			TweenLite.delayedCall(0.9,function ():void 
			{				
				refresh(mat);
			});
		}
		
		public function starOver():void
		{
			if (isFavorite == false)			
				star.over();	
		}		
		
		public function setFavState(value:Boolean):void
		{
			isFavorite = value;
			star.fav(isFavorite);
		}		
		
		public function refresh(_mat:*):void
		{
			if (_mat == null) return;
			
			mat = _mat;			
			activeID = mat.id;			
			
			textNews.refresh();
			textNews.textTitle = mat.title;
			textNews.textMain = mat.text;
			textNews.timeTitle = mat.publishedDate;
			textNews.dateTitle = mat.publishedDate;
			textNews.rubrics = mat.rubrics;
			
			textNews.animate(mat.type, lastType);
			videoNews.animate(mat.type, lastType, mat);
			photoNews.animate(mat.type, lastType, mat);
			
			lastType = mat.type;			
		}
		
		public function dragFavShot(e:InteractiveEvent):void
		{
			shot.x = e.stageX - favWidth - (star.x)*shot.scaleX ;
			shot.y = e.stageY - (star.y) * shot.scaleY;			
		}
		
		public function addFavShot(bmp:BigCanvas):void
		{
			shot = bmp;			
			shot.alpha  = 0.5;
			shot.scaleX = shot.scaleY = 0.6;
			addChild(shot);			
		}
		
		public function backPanel(e:InteractiveEvent):Boolean 
		{
			if (e.stageX > favWidth)
			{
				removeFavShot();
				favPanel.hide();
				return false;
			}
			else
			{
				TweenLite.to(shot, 0.3, { alpha : 1 ,scaleX: 0.4, scaleY:0.4, x: 0.5 * (favWidth - shot.width*0.7) - favWidth, y:300  } );
				TweenLite.delayedCall(0.5, hidePanel);
				TweenLite.to(shot, 0.5, { delay:0.5, x: -2 * favWidth, ease: Expo.easeInOut, onComplete:removeFavShot } );
				return true;			
			}
		}
		
		private function hidePanel():void 
		{		
			favPanel.hide();
		}
		
		public function removeFavShot():void
		{		
			if (contains(shot)) removeChild(shot);
		}		
	}
}
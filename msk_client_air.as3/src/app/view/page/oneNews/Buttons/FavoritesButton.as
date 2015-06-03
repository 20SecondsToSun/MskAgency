package app.view.page.oneNews.Buttons 
{
	import app.AppSettings;
	import app.assets.Assets;
	import app.view.baseview.io.InteractiveButton;
	import app.view.utils.Tool;
	import flash.display.Shape;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FavoritesButton extends InteractiveButton
	{
		private var star:Sprite;
		public var starOver:Sprite;
		public var starGold:Sprite;
		
		public function FavoritesButton() 
		{
			star = new Sprite();		
			
			addChild(star);		
			
			var starFon:Shape = Tool.createShape(200, 200, 0xff0000);
			starFon.x = - 100;
			starFon.y = - 100;
			starFon.alpha = 0;
			addChild(starFon);			
			
			star = Assets.create("star")
			addChild(star);
			
			starOver = Assets.create("starOver");
			starOver.alpha = 0;	
			starOver.x = -69;
			starOver.y = -10;
			addChild(starOver);	
			
			
			starGold = Assets.create("starGold")
			addChild(starGold);
			starGold.visible = false;
			
			x = 109;
			y = AppSettings.HEIGHT - 135;
		}
		public function fav(isFav:Boolean):void
		{
			starGold.visible = isFav;
			star.visible = !isFav;
			starOver.visible = !isFav;
			
		}
		public function over():void
		{
			star.alpha = 0;
			starOver.alpha = 1;
		}
		
		public function out():void
		{
			starOver.alpha = 0;
			star.alpha = 1;
		}		
		
	}

}
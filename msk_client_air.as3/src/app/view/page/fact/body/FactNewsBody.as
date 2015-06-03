package app.view.page.fact.body
{
	import app.AppSettings;
	import app.model.materials.Material;
	import app.view.baseview.onenewpage.BaseNewsBody;
	import app.view.page.oneNews.Body.FavPanel;
	import app.view.page.oneNews.Body.PhotoContainer;
	import app.view.page.oneNews.Body.TextContainer;
	import app.view.page.oneNews.Body.VideoContainer;
	import app.view.page.oneNews.Buttons.FavoritesButton;
	import app.view.utils.Tool;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FactNewsBody extends BaseNewsBody
	{
		public function FactNewsBody()
		{
			/*var fon:Shape = Tool.createShape(AppSettings.WIDTH - 622, AppSettings.HEIGHT, 0xf4f5f7);
			addChild(fon);
			
			star = new FavoritesButton();
			addChild(star);		
			
			textNews = new TextContainer();
			addChild(textNews);
			
			videoNews = new VideoContainer();
			addChild(videoNews);
			
			favPanel = new FavPanel();
			addChild(favPanel);*/
			
			preloader.factcolor();
		}
		
		override public function init(_mat:*):void
		{
			if (_mat == null) return;
			
			mat = _mat;			
			refresh(mat);
		}
		
		override public function refresh(_mat:*):void
		{
			if (_mat == null) return;
			
			mat = _mat;			
			activeID = mat.id;
			textNews.refresh();
			textNews.textTitle = mat.title;
			textNews.textMain = mat.text;			
			textNews.rubrics = mat.rubrics;
			textNews.addFactTime(_mat.start_date, _mat.end_date);			
			textNews.animate("text", "text");			
		}		
	}
}
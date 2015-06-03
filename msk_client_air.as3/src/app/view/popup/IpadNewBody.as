package app.view.popup 
{
	import app.AppSettings;
	import app.model.materials.Material;
	import app.view.baseview.onenewpage.BaseNewsBody;
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class IpadNewBody extends BaseNewsBody
	{		
		public var type:String = "";
		
		public function IpadNewBody() 
		{
			super();
			videoNews.id = "ipad news";
			textNews.id = "ipad news";
			photoNews.id = "ipad news";
			screenField  = new Rectangle(311, 0, AppSettings.WIDTH - 622, AppSettings.HEIGHT);
			
			preloader.visible = false;			
		}
		
		public function refreshAsMaterial(mat:*):void
		{
			type = "material";
			refresh(mat);
		}		
		
		public function refreshAsFact(_mat:*):void
		{
			if (_mat == null) return;		
			
			mat = _mat;	
			type = "fact";
			textNews.refresh();
			textNews.textTitle = mat.title;
			textNews.textMain = mat.text;			
			textNews.rubrics = mat.rubrics;
			textNews.addFactTime(_mat.start_date, _mat.end_date);			
			textNews.animate("text", "text");			
		}		
		
		public function moveRight():void
		{
			star.visible = false;
			TweenLite.to(this, 0.5, { x:622, ease: Expo.easeInOut });
		}	
		
		public function moveLeft() :void
		{
			star.visible = true;
			TweenLite.to(this, 0.5, {delay:0.5, x:311, ease: Expo.easeInOut } );
		}			
	}
}
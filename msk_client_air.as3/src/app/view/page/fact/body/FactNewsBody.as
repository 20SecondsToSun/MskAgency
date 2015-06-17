package app.view.page.fact.body
{
	import app.view.baseview.onenewpage.BaseNewsBody;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FactNewsBody extends BaseNewsBody
	{
		public function FactNewsBody()
		{
			preloader.factcolor();
		}
		
		override public function init(_mat:*):void
		{
			if (_mat)
			{
				mat = _mat;
				refresh(mat);
			}
		}
		
		override public function refresh(_mat:*):void
		{
			if (_mat)
			{
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
}
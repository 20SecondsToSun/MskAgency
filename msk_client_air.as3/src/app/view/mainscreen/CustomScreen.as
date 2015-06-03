package app.view.mainscreen{
	import app.contoller.events.ChangeModelOut;
	import app.view.allnews.AllNews;
	import app.view.employes.Employ;
	import app.view.facts.Facts;
	import app.view.mainnew.MainNews;
	import app.view.map.Map;
	import app.view.photonews.PhotoNews;
	import app.view.videonews.VideoNews;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class CustomScreen extends MainBase
	{	
		public var employ:Employ;
		public var photonews:PhotoNews;
		public var allnews:AllNews;
		public var videonews:VideoNews;
		public var mainnews:MainNews;
		public var map:Map;
		public var facts:Facts;			
		
		public function CustomScreen():void
		{
			screenName = "CUSTOM_SCREEN";
			pageNum = 2;
			allViews = 7;
		}	
		public function startShow():void
		{
			dispatchEvent(new ChangeModelOut(ChangeModelOut.CUSTOM_SCREEN));
			addChilds();
			addMask();
			
			isReady = true;
			activePage = 2;
		}
		
		override protected function childHide():void
		{
			employ.visible = false;
			videonews.visible = false;
			mainnews.visible = false;
			map.visible = false;
			facts.visible = false;
			allnews.visible = false;
			photonews.visible = false;
		}
		
		override protected function childShow():void
		{
			employ.visible = true;
			videonews.visible = true;
			mainnews.visible = true;
			map.visible = true;
			facts.visible = true;
			allnews.visible = true;
			photonews.visible = true;
		}
		
		override protected function addChilds():void
		{
			employ = new Employ();
			videonews = new VideoNews();
			mainnews = new MainNews();
			map = new Map();
			facts = new Facts();
			allnews = new AllNews();
			photonews = new PhotoNews();
			
			addChild(mainnews);
			addChild(map);
			addChild(facts);
			addChild(videonews);
			addChild(employ);
			addChild(photonews);
			addChild(allnews);			
		}
		
		override protected function removeChilds():void
		{
			removeChild(mainnews);
			removeChild(map);
			removeChild(facts);
			removeChild(videonews);
			removeChild(employ);
			removeChild(allnews);
			removeChild(photonews);
		}		
	}
}
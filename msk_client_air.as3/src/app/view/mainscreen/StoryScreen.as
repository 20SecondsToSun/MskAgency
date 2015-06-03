package app.view.mainscreen

{	
	import app.contoller.events.ChangeModelOut;
	import app.view.favorites.Favorites;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class StoryScreen extends MainBase
	{
		private var fav:Favorites;		
		
		public function StoryScreen():void
		{
			screenName = "STORY_SCREEN";
			pageNum = 3;
			allViews = 1;			
		}
		
		public function startShow():void
		{
			dispatchEvent(new ChangeModelOut(ChangeModelOut.STORY_SCREEN));
			addChilds();
			addMask();
			
			isReady = true;
			activePage = 3;
		}
		
		override protected function childHide():void
		{
			fav.visible = false;
		}
		
		override protected function childShow():void
		{
			fav.visible = true;	
		}
		
		override protected function addChilds():void
		{
			fav = new Favorites();
			addChild(fav);				
		}
		
		override protected function removeChilds():void
		{
			removeChild(fav);	
		}		
	}
}
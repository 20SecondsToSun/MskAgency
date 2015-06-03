package app.view
{
	import app.view.allnews.AllNews;
	import app.view.animator.Animator;
	import app.view.employes.Employ;
	import app.view.facts.Facts;
	import app.view.filters.FiltersView;
	import app.view.handsview.HandsView;
	import app.view.HELPTEMPSCREEN.HelpScreen;
	import app.view.mainnew.MainNews;
	import app.view.mainscreen.CustomScreen;
	import app.view.mainscreen.MainScreen;
	import app.view.mainscreen.StoryScreen;
	import app.view.map.Map;
	import app.view.menu.MenuView;
	import app.view.page.BroadcastPage;
	import app.view.page.day.OneDayNewPage;
	import app.view.page.days.DaysNewPage;
	import app.view.page.fact.FactPage;
	import app.view.page.fact.OneNewFactPage;
	import app.view.page.MapPage;
	import app.view.page.OneNewPage;
	import app.view.photonews.PhotoNews;
	import app.view.popup.IpadPopup;
	import app.view.popup.ServicePopup;
	import app.view.videonews.VideoNews;
	import flash.display.Sprite;
	import org.robotlegs.core.IInjector;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class MainView extends Sprite
	{
		private var hands:HandsView;
		private var help:HelpScreen;
		
		private var employ:Employ;
		private var photonews:PhotoNews;
		private var allnews:AllNews;
		private var videonews:VideoNews;
		private var mainnews:MainNews;
		private var map:Map;
		private var facts:Facts;
		private var menu:MenuView;
		private var filter:FiltersView;
		
		private var oneNewPage:OneNewPage;
		private var oneNewFactPage:OneNewFactPage;
		private var oneHourNewPage:OneDayNewPage;
		private var daysNewPage:DaysNewPage;
		private var mapPage:MapPage;
		private var factPage:FactPage;
		private var favPage:OneNewPage;
		private var broadcastPage:BroadcastPage;
		
		private var mainScreen:MainScreen;
		private var customScreen:CustomScreen;
		private var storyScreen:StoryScreen;
		private var popup:ServicePopup;
		private var ipadPopup:IpadPopup;
		
		private var animator:Animator;
		private var injector:IInjector;
		
		public function MainView(injector:IInjector)
		{
			this.injector = injector;
			hands = new HandsView();
			help = new HelpScreen();
			menu = new MenuView();
			filter = new FiltersView();
			popup = new ServicePopup();
			ipadPopup = new IpadPopup();
			
			addAnimator();
			
			addChild(hands);
			addChild(help);
			addChild(menu);
			addChild(filter);
			
			addChild(popup);
			addChild(ipadPopup);		
		}
		
		public function addAllScreen():void
		{
			mainScreen = new MainScreen();
			addChild(mainScreen);
			
			customScreen = new CustomScreen();
			addChild(customScreen);
			
			storyScreen = new StoryScreen();
			addChild(storyScreen);
			
			setToTOP();
		}
		
		public function add3Screen(loc:String):void
		{
			switch (loc)
			{
				case "MAIN_SCREEN": 
					customScreen = new CustomScreen();
					addChild(customScreen);
					
					storyScreen = new StoryScreen();
					addChild(storyScreen);					
					break;
					
				case "CUSTOM_SCREEN": 
					mainScreen = new MainScreen();
					addChild(mainScreen);
					swapChildren(customScreen, mainScreen);
					
					storyScreen = new StoryScreen();
					addChild(storyScreen);					
					break;
					
				case "STORY_SCREEN":
					
					customScreen = new CustomScreen();
					addChild(customScreen);
					
					swapChildren(customScreen, storyScreen);
					
					mainScreen = new MainScreen();
					addChild(mainScreen);
					
					swapChildren(mainScreen, storyScreen);
					swapChildren(mainScreen, customScreen);					
					break;
			}
			
			setToTOP();
		}
		
		public function addPageLocation(loc:String):void
		{
			switch (loc)
			{
				case "ONE_NEW_PAGE": 
					oneNewPage = new OneNewPage();
					addChild(oneNewPage);
					break;
				
				case "ONE_NEW_FACT_PAGE": 
					oneNewFactPage = new OneNewFactPage();
					addChild(oneNewFactPage);
					break;
				
				case "NEWS_PAGE_HOUR": 
					oneHourNewPage = new OneDayNewPage();
					addChild(oneHourNewPage);
					break;
				
				case "NEWS_PAGE_DAY": 
					daysNewPage = new DaysNewPage();
					addChild(daysNewPage);
					break;
				
				case "MAP_PAGE": 
					mapPage = new MapPage();
					addChild(mapPage);
					break;
				
				case "BROADCAST_PAGE": 
					broadcastPage = new BroadcastPage();
					addChild(broadcastPage);
					break;
				/*	case "FAVORITES_PAGE":
				   favPage = new OneNewPage();
				   addChild(favPage);
				 break*/
				case "FACT_PAGE": 
					factPage = new FactPage();
					addChild(factPage);
					break;
				default: 
			}
			setToTOP();
		}
		
		public function addAnimator():void
		{
			animator = new Animator();
			addChild(animator);
		}
		
		public function removeLocation(loc:String):void
		{
			switch (loc)
			{
				case "ONE_NEW_FACT_PAGE": 
					removeChild(oneNewFactPage);
					break;
				
				case "MAIN_SCREEN": 
					removeChild(mainScreen);
					break;
				
				case "CUSTOM_SCREEN": 
					removeChild(customScreen);
					break;
				
				case "STORY_SCREEN": 
					removeChild(storyScreen);
					break
				case "ONE_NEW_PAGE": 
					removeChild(oneNewPage);
					break;
				case "MAP_PAGE": 
					removeChild(mapPage);
					break;
				case "BROADCAST_PAGE": 
					removeChild(broadcastPage);
					break;
				
				case "FAVORITES_PAGE": 
					removeChild(favPage);
					break;
				
				case "FACT_PAGE": 
					removeChild(factPage);
					break;
				
				case "NEWS_PAGE_HOUR": 
					removeChild(oneHourNewPage);
					break;
				
				case "NEWS_PAGE_DAY": 
					removeChild(daysNewPage);
					break;
				
				case "ONE_NEW_PAGE": 
					removeChild(oneNewPage);
					break;
			
			}
		}
		
		public function addMainScreen(loc:String):void
		{
			switch (loc)
			{
				case "MAIN_SCREEN": 
					mainScreen = new MainScreen();
					addChild(mainScreen);
					
					break;
				case "CUSTOM_SCREEN": 
					customScreen = new CustomScreen();
					addChild(customScreen);
					
					break;
				case "STORY_SCREEN": 
					storyScreen = new StoryScreen();
					addChild(storyScreen);
					break;
				
				case "NEWS_PAGE_HOUR": 
					oneHourNewPage = new OneDayNewPage();
					addChild(oneHourNewPage);
					break;
				
				case "NEWS_PAGE_DAY": 
					daysNewPage = new DaysNewPage();
					addChild(daysNewPage);
					break;
				
				case "ONE_NEW_PAGE": 
					oneNewPage = new OneNewPage();
					addChild(oneNewPage);
					
					break;
				case "MAP_PAGE": 
					mapPage = new MapPage();
					addChild(mapPage);
					break;
			}
			setToTOP();
		}		

		public var animatorToFront:Boolean = false;
		
		private function setToTOP():void
		{
			if (contains(animator) && animatorToFront)
				setChildIndex(animator, this.numChildren - 1);
			
			setChildIndex(ipadPopup, this.numChildren - 1);
			setChildIndex(menu, this.numChildren - 1);
			setChildIndex(filter, this.numChildren - 1);
			setChildIndex(popup, this.numChildren - 1);
			setChildIndex(hands, this.numChildren - 1);
			setChildIndex(help, this.numChildren - 1);		
		}	
	}
}
package ipad
{
	import app.contoller.bootstraps.BootstrapConfigValues;
	import app.model.config.Config;
	import app.model.config.IConfig;
	import app.model.datafilters.FilterDataModel;
	import app.model.datafilters.IFilterDataModel;
	import app.model.datauser.IUser;
	import app.model.datauser.User;
	import app.services.auth.AuthService;
	import app.services.auth.IAuthService;
	import app.services.interactive.IInteractiveControlService;
	import app.services.interactive.InteractiveControlService;
	import app.view.baseview.photo.OnePhoto;
	import app.view.baseview.photo.OnePhotoMediator;
	import flash.display.DisplayObjectContainer;
	import ipad.bootstraps.BootstrapCommands;
	import ipad.model.datafav.FavoritesModel;
	import ipad.model.datafav.IFavoritesModel;
	import ipad.model.IInfo;
	import ipad.model.Info;
	import ipad.model.ipad.IIpadFactsModel;
	import ipad.model.ipad.IIpadNewsModel;
	import ipad.model.ipad.IpadFactsModel;
	import ipad.model.ipad.IpadNewsModel;
	import ipad.services.dataloading.DataLoadingService;
	import ipad.services.dataloading.IDataLoadingService;
	import ipad.services.state.INavigationService;
	import ipad.services.state.NavigationService;
	import ipad.view.Body;
	import ipad.view.BodyMediator;
	import ipad.view.locations.BroadcastPage;
	import ipad.view.locations.BroadcastPageMediator;
	import ipad.view.locations.CustomPage;
	import ipad.view.locations.CustomPageMediator;
	import ipad.view.locations.FactsPage;
	import ipad.view.locations.FactsPageMediator;
	import ipad.view.locations.favorites.FavFactGraphic;
	import ipad.view.locations.favorites.FavFactGraphicMediator;
	import ipad.view.locations.favorites.Favorites;
	import ipad.view.locations.favorites.FavoritesMediator;
	import ipad.view.locations.favorites.FavPreview;
	import ipad.view.locations.favorites.FavPreviewMediator;
	import ipad.view.locations.MainPage;
	import ipad.view.locations.MainPageMediator;
	import ipad.view.locations.MapPage;
	import ipad.view.locations.MapPageMediator;
	import ipad.view.locations.news.DateChoose;
	import ipad.view.locations.news.DateChooseMediator;
	import ipad.view.locations.news.FilterSlider;
	import ipad.view.locations.news.FilterSliderMediator;
	import ipad.view.locations.news.RubricChoose;
	import ipad.view.locations.news.RubricChooseMediator;
	import ipad.view.locations.news.TypeChoose;
	import ipad.view.locations.news.TypeChooseMediator;
	import ipad.view.locations.NewsPage;
	import ipad.view.locations.NewsPageMediator;
	import ipad.view.MainSlider;
	import ipad.view.MainSliderMediator;
	import ipad.view.Menu;
	import ipad.view.MenuMediator;
	import ipad.view.slider.Slider;
	import ipad.view.slider.SliderMediator;
	import ipad.view.slider.VerticalNewsSlider;
	import ipad.view.slider.VerticalSliderMediator;
	import ipad.view.Top;
	import ipad.view.TopMediator;
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.SwipeGesture;
	import org.robotlegs.mvcs.Context;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class InteractiveIpadContext extends Context
	{		
		public function InteractiveIpadContext(contextView:DisplayObjectContainer)
		{
			super(contextView, true);			
		
           // Gestouch.addDisplayListAdapter(starling.display.DisplayObject, new StarlingDisplayListAdapter());
           // Gestouch.addTouchHitTester(new StarlingTouchHitTester(_starling), -1);
			
			var swipe:SwipeGesture = new SwipeGesture(contextView);
            swipe.addEventListener(GestureEvent.GESTURE_RECOGNIZED, onDoubleTap);		
		}	
		
		private function onDoubleTap(event:GestureEvent):void
		{
			trace( "handle double tap !");
		}			
		
		override public function startup():void
		{
			//new BootstrapClasses(injector);
			//new BootstrapServices(injector);
			//new BootstrapModels(injector);
			
			injector.mapSingletonOf(INavigationService, NavigationService);
			injector.mapSingletonOf(IAuthService, AuthService);
			injector.mapSingletonOf(IInteractiveControlService, InteractiveControlService);
			injector.mapSingletonOf(IDataLoadingService, DataLoadingService);
			injector.mapSingletonOf(IUser, User);
			injector.mapSingletonOf(IIpadNewsModel, IpadNewsModel);
			injector.mapSingletonOf(IIpadFactsModel, IpadFactsModel);
			injector.mapSingletonOf(IConfig, Config);
			injector.mapSingletonOf(IFilterDataModel, FilterDataModel);
			injector.mapSingletonOf(IInfo, Info);
			injector.mapSingletonOf(IFavoritesModel, FavoritesModel);
			
			mediatorMap.mapView(Menu, MenuMediator);
			mediatorMap.mapView(MainSlider, MainSliderMediator);
			mediatorMap.mapView(Slider, SliderMediator);
			mediatorMap.mapView(Top, TopMediator);			
			
			mediatorMap.mapView(MainPage, MainPageMediator);
			mediatorMap.mapView(CustomPage, CustomPageMediator);
			//mediatorMap.mapView(StoryPage, StoryPageMediator);
			mediatorMap.mapView(NewsPage, NewsPageMediator);
			mediatorMap.mapView(FactsPage, FactsPageMediator);
			mediatorMap.mapView(MapPage, MapPageMediator);
			mediatorMap.mapView(BroadcastPage, BroadcastPageMediator);	
			mediatorMap.mapView(TypeChoose, TypeChooseMediator);	
			mediatorMap.mapView(DateChoose, DateChooseMediator);	
			mediatorMap.mapView(RubricChoose, RubricChooseMediator);	
			mediatorMap.mapView(FilterSlider, FilterSliderMediator);	
			
			mediatorMap.mapView(Favorites, FavoritesMediator);	
			mediatorMap.mapView(FavFactGraphic, FavFactGraphicMediator);	
			mediatorMap.mapView(FavPreview, FavPreviewMediator);
			
			mediatorMap.mapView(VerticalNewsSlider, VerticalSliderMediator);			
			
			mediatorMap.mapView(OnePhoto, OnePhotoMediator);				
			
			//injector.mapSingleton(Body);
			mediatorMap.mapView(Body, BodyMediator);
			
			new BootstrapConfigValues(injector);
			new BootstrapCommands(commandMap);
			// new BootstrapViewMediators(mediatorMap);
			
			addRootView();
			
			// and we're done
			super.startup();
		}
		
		protected function addRootView():void
		{
			var mainView:Body = new Body();
			mainView.name = "body";
			contextView.addChild(mainView);
		}	
	}
}
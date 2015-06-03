package ipad.bootstraps
{
	import app.view.allnews.AllNews;
	import app.view.allnews.AllNewsMediator;
	import app.view.allnews.AllNewsSlider;
	import app.view.allnews.AllNewsSliderMediator;
	import app.view.allnews.OneHourGraphic;
	import app.view.allnews.OneHourGraphicMediator;
	import app.view.animator.Animator;
	import app.view.animator.AnimatorMediator;
	import app.view.baseview.photo.OnePhoto;
	import app.view.baseview.photo.OnePhotoMediator;
	import app.view.baseview.slider.Slider;
	import app.view.baseview.slider.SliderMediator;
	import app.view.baseview.slider.VerticalHorizontalSlider;
	import app.view.baseview.slider.VerticalHorizontalSliderMediator;
	import app.view.employes.Employ;
	import app.view.employes.EmployMediator;
	import app.view.facts.FactAnimator;
	import app.view.facts.FactAnimatorMediator;
	import app.view.facts.Facts;
	import app.view.facts.FactsMediator;
	import app.view.facts.FactsSlider;
	import app.view.facts.FactsSliderMediator;
	import app.view.facts.OneFactGraphic;
	import app.view.facts.OneFactGraphicMediator;
	import app.view.favorites.Favorites;
	import app.view.favorites.FavoritesMediator;
	import app.view.filters.FilterButton;
	import app.view.filters.FilterButtonMediator;
	import app.view.filters.FilterSlider;
	import app.view.filters.FilterSliderMediator;
	import app.view.filters.FiltersView;
	import app.view.filters.FiltersViewMediator;
	import app.view.handsview.HandsView;
	import app.view.handsview.HandsViewMediator;
	import app.view.HELPTEMPSCREEN.HelpScreen;
	import app.view.HELPTEMPSCREEN.HelpScreenMediator;
	import app.view.HELPTEMPSCREEN.minislider.MiniSlider;
	import app.view.HELPTEMPSCREEN.minislider.MiniSliderMediator;
	import app.view.mainnew.MainNews;
	import app.view.mainnew.MainNewsMediator;
	import app.view.mainscreen.CustomScreen;
	import app.view.mainscreen.CustomScreenMediator;
	import app.view.mainscreen.MainScreen;
	import app.view.mainscreen.MainScreenMediator;
	import app.view.mainscreen.StoryScreen;
	import app.view.mainscreen.StoryScreenMediator;
	import app.view.MainView;
	import app.view.MainViewMediator;
	import app.view.map.Map;
	import app.view.map.MapMediator;
	import app.view.menu.MenuButton;
	import app.view.menu.MenuButtonMediator;
	import app.view.menu.MenuView;
	import app.view.menu.MenuViewMediator;
	import app.view.page.BroadcastPage;
	import app.view.page.BroadcastPageMediator;
	import app.view.page.day.hoursslider.HourSlider;
	import app.view.page.day.hoursslider.HourSliderMediator;
	import app.view.page.day.leftpanelhour.LeftPanel;
	import app.view.page.day.leftpanelhour.LeftPanelMediator;
	import app.view.page.day.OneDayNewPage;
	import app.view.page.day.OneDayNewPageMediator;
	import app.view.page.day.onehourslider.OneHourSlider;
	import app.view.page.day.onehourslider.OneHourSliderMediator;
	import app.view.page.days.DaysNewPage;
	import app.view.page.days.DaysNewPageMediator;
	import app.view.page.days.daysslider.DaysSlider;
	import app.view.page.days.daysslider.DaysSliderMediator;
	import app.view.page.days.onedayslider.OneDaySlider;
	import app.view.page.days.onedayslider.OneDaySliderMediator;
	import app.view.page.fact.body.FactNewsBody;
	import app.view.page.fact.body.FactNewsBodyMediator;
	import app.view.page.fact.FactPage;
	import app.view.page.fact.FactPageMediator;
	import app.view.page.fact.factsslider.FactsAllSlider;
	import app.view.page.fact.factsslider.FactsAllSliderMediator;
	import app.view.page.fact.leftpanel.FactLeftPanelSlider;
	import app.view.page.fact.leftpanel.FactLeftPanelSliderMediator;
	import app.view.page.fact.leftpanel.OneFactPreviewGraphic;
	import app.view.page.fact.leftpanel.OneFactPreviewGraphicMediator;
	import app.view.page.fact.onedayfactslider.OneDayFactSlider;
	import app.view.page.fact.onedayfactslider.OneDayFactSliderMediator;
	import app.view.page.fact.OneNewFactPage;
	import app.view.page.fact.OneNewFactPageMediator;
	import app.view.page.map.LeftPanelMap;
	import app.view.page.map.LeftPanelMapMediator;
	import app.view.page.MapPage;
	import app.view.page.MapPageMediator;
	import app.view.page.OneNewPage;
	import app.view.page.OneNewPageMediator;
	import app.view.page.oneNews.Body.Gallery;
	import app.view.page.oneNews.Body.GalleryMediator;
	import app.view.page.oneNews.Body.GallerySlider;
	import app.view.page.oneNews.Body.GallerySliderMediator;
	import app.view.page.oneNews.Body.NewsBody;
	import app.view.page.oneNews.Body.NewsBodyMediator;
	import app.view.page.oneNews.Body.OnePhotoPreview;
	import app.view.page.oneNews.Body.OnePhotoPreviewMediator;
	import app.view.page.oneNews.Body.PhotoContainer;
	import app.view.page.oneNews.Body.PhotoContainerMediator;
	import app.view.page.oneNews.Body.PreviewSlider;
	import app.view.page.oneNews.Body.PreviewSliderMediator;
	import app.view.page.oneNews.Body.TextContainer;
	import app.view.page.oneNews.Body.TextContainerMediator;
	import app.view.page.oneNews.Body.VideoContainer;
	import app.view.page.oneNews.Body.VideoContainerMediator;
	import app.view.page.oneNews.LeftPanelSlider;
	import app.view.page.oneNews.LeftPanelSliderMediator;
	import app.view.page.oneNews.OneNewPreview;
	import app.view.page.oneNews.OneNewPreviewMediator;
	import app.view.page.oneNews.VerticalNewsSlider;
	import app.view.page.oneNews.VerticalSliderMediator;
	import app.view.photonews.OnePhotoGraphic;
	import app.view.photonews.OnePhotoGraphicMediator;
	import app.view.photonews.PhotoNews;
	import app.view.photonews.PhotoNewsMediator;
	import app.view.photonews.PhotoSlider;
	import app.view.photonews.PhotoSliderMediator;
	import app.view.popup.IpadNewBody;
	import app.view.popup.IpadNewBodyMediator;
	import app.view.popup.IpadPopup;
	import app.view.popup.IpadPopupMediator;
	import app.view.popup.ServicePopup;
	import app.view.popup.ServicePopupMediator;
	import app.view.utils.video.VideoPlayer;
	import app.view.utils.video.VideoPlayerMediator;
	import app.view.videonews.OneVideoNewGraphic;
	import app.view.videonews.OneVideoNewGraphicMediator;
	import app.view.videonews.VideoAnimator;
	import app.view.videonews.VideoAnimatorMediator;
	import app.view.videonews.VideoNews;
	import app.view.videonews.VideoNewsMediator;
	import app.view.videonews.VideoSlider;
	import app.view.videonews.VideoSliderMediator;
	import org.robotlegs.core.IMediatorMap;
	
	
	public class BootstrapViewMediators extends Object
	{
		public function BootstrapViewMediators(mediatorMap:IMediatorMap)
		{			
			mediatorMap.mapView(MainView, MainViewMediator);
			
			mediatorMap.mapView(Employ, EmployMediator);
			mediatorMap.mapView(PhotoNews, PhotoNewsMediator);
			mediatorMap.mapView(AllNews, AllNewsMediator);			
			mediatorMap.mapView(MainNews, MainNewsMediator);
			mediatorMap.mapView(Map, MapMediator);
			mediatorMap.mapView(Facts, FactsMediator);
			mediatorMap.mapView(HandsView, HandsViewMediator);
			mediatorMap.mapView(MenuView, MenuViewMediator);
			
			
			mediatorMap.mapView(FactsSlider, FactsSliderMediator);
			mediatorMap.mapView(PhotoSlider, PhotoSliderMediator);
			mediatorMap.mapView(Slider, SliderMediator);
			mediatorMap.mapView(AllNewsSlider, AllNewsSliderMediator);
			mediatorMap.mapView(Favorites, FavoritesMediator);			
			
			
			mediatorMap.mapView(OneFactGraphic, OneFactGraphicMediator);
			mediatorMap.mapView(OnePhotoGraphic, OnePhotoGraphicMediator);
			mediatorMap.mapView(OneHourGraphic, OneHourGraphicMediator);
			
			mediatorMap.mapView(HelpScreen, HelpScreenMediator);			
			
			
			mediatorMap.mapView(OneDayNewPage, OneDayNewPageMediator);
			mediatorMap.mapView(OneNewFactPage, OneNewFactPageMediator);
			mediatorMap.mapView(DaysNewPage, DaysNewPageMediator);
			mediatorMap.mapView(OneNewPreview, OneNewPreviewMediator);
			
			
			mediatorMap.mapView(OneNewPage, OneNewPageMediator);
			mediatorMap.mapView(FactPage, FactPageMediator);
			mediatorMap.mapView(FactLeftPanelSlider, FactLeftPanelSliderMediator);
			mediatorMap.mapView(BroadcastPage, BroadcastPageMediator);
			mediatorMap.mapView(MapPage, MapPageMediator);			
			
			mediatorMap.mapView(MainScreen, MainScreenMediator);
			mediatorMap.mapView(CustomScreen, CustomScreenMediator);
			mediatorMap.mapView(StoryScreen, StoryScreenMediator);
			
			mediatorMap.mapView(MiniSlider, MiniSliderMediator);
			mediatorMap.mapView(HourSlider, HourSliderMediator);
			
			mediatorMap.mapView(LeftPanel, LeftPanelMediator);
			mediatorMap.mapView(LeftPanelSlider, LeftPanelSliderMediator);
			mediatorMap.mapView(MenuButton, MenuButtonMediator);
			mediatorMap.mapView(NewsBody, NewsBodyMediator);
			
			
			mediatorMap.mapView(VerticalNewsSlider, VerticalSliderMediator);
			mediatorMap.mapView(Gallery, GalleryMediator);
			mediatorMap.mapView(VerticalHorizontalSlider, VerticalHorizontalSliderMediator);
			
			mediatorMap.mapView(OnePhotoPreview, OnePhotoPreviewMediator);
			mediatorMap.mapView(PhotoContainer, PhotoContainerMediator);
			mediatorMap.mapView(VideoContainer, VideoContainerMediator);
			mediatorMap.mapView(TextContainer, TextContainerMediator);
			
			mediatorMap.mapView(OnePhoto, OnePhotoMediator);
			
			
			mediatorMap.mapView(GallerySlider, GallerySliderMediator);
			mediatorMap.mapView(PreviewSlider, PreviewSliderMediator);
			mediatorMap.mapView(DaysSlider, DaysSliderMediator);
			
			mediatorMap.mapView(FactsAllSlider, FactsAllSliderMediator);
			mediatorMap.mapView(FactNewsBody, FactNewsBodyMediator);
			mediatorMap.mapView(OneFactPreviewGraphic, OneFactPreviewGraphicMediator);
			
			mediatorMap.mapView(OneDayFactSlider, OneDayFactSliderMediator);
			mediatorMap.mapView(OneDaySlider, OneDaySliderMediator);
			mediatorMap.mapView(OneHourSlider, OneHourSliderMediator);
			mediatorMap.mapView(FilterSlider, FilterSliderMediator);
			
			
			mediatorMap.mapView(LeftPanelMap, LeftPanelMapMediator);
			mediatorMap.mapView(FiltersView, FiltersViewMediator);
			mediatorMap.mapView(FilterButton, FilterButtonMediator);
			
			mediatorMap.mapView(Animator, AnimatorMediator);	
			
			mediatorMap.mapView(ServicePopup, ServicePopupMediator);
			
			mediatorMap.mapView(FactAnimator, FactAnimatorMediator);
			
			
		//--------------------------------------------------------------------------
		//
		//     VIDEO
		//
		//--------------------------------------------------------------------------
		
			mediatorMap.mapView(VideoNews, VideoNewsMediator);
			mediatorMap.mapView(VideoPlayer, VideoPlayerMediator);
			mediatorMap.mapView(VideoSlider, VideoSliderMediator);
			mediatorMap.mapView(OneVideoNewGraphic, OneVideoNewGraphicMediator);
			mediatorMap.mapView(VideoAnimator, VideoAnimatorMediator);
			
				
		//--------------------------------------------------------------------------
		//
		//     IPAD
		//
		//--------------------------------------------------------------------------
			
			mediatorMap.mapView(IpadPopup, IpadPopupMediator);		
			mediatorMap.mapView(IpadNewBody, IpadNewBodyMediator);
			
			
		
		}
	}
}
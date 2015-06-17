package app.contoller.bootstraps
{
	import app.model.dataall.AllNewsModel;
	import app.model.dataall.IAllNewsModel;
	import app.model.dataemploy.EmployModel;
	import app.model.dataemploy.IEmployModel;
	import app.model.datafact.FactsModel;
	import app.model.datafact.IFactsModel;
	import app.model.datafav.FavoritesModel;
	import app.model.datafav.IFavoritesModel;
	import app.model.datafilters.FilterDataModel;
	import app.model.datafilters.IFilterDataModel;
	import app.model.datageo.GeoModel;
	import app.model.datageo.IGeoModel;
	import app.model.datahotnews.HotNewsModel;
	import app.model.datahotnews.IHotNewsModel;
	import app.model.dataphoto.IPhotoNewsModel;
	import app.model.dataphoto.PhotoNewsModel;
	import app.model.datauser.IUser;
	import app.model.datauser.User;
	import app.model.datavideo.IVideoNewsModel;
	import app.model.datavideo.VideoNewsModel;
	import app.model.daysnews.DaysNewsModel;
	import app.model.daysnews.IDaysNewsModel;
	import app.model.mainnews.IMainNewsModel;
	import app.model.mainnews.MainNewsModel;
	import app.model.materials.IMaterialModel;
	import app.model.materials.MaterialModel;
	import app.view.MainView;
	import org.robotlegs.core.IInjector;
	
	public class BootstrapModels
	{
		public function BootstrapModels(injector:IInjector)
		{
			injector.mapSingletonOf(IUser, User);
			injector.mapSingletonOf(IPhotoNewsModel, PhotoNewsModel);			
			injector.mapSingletonOf(IAllNewsModel, AllNewsModel);
			injector.mapSingletonOf(IMainNewsModel, MainNewsModel);
			injector.mapSingletonOf(IVideoNewsModel, VideoNewsModel);
			injector.mapSingletonOf(IMaterialModel, MaterialModel);
			injector.mapSingletonOf(IFactsModel, FactsModel);
			injector.mapSingletonOf(IEmployModel, EmployModel);
			injector.mapSingletonOf(IHotNewsModel, HotNewsModel);
			injector.mapSingletonOf(IGeoModel, GeoModel);
			injector.mapSingletonOf(IDaysNewsModel, DaysNewsModel);
			injector.mapSingletonOf(IFilterDataModel, FilterDataModel);
			injector.mapSingletonOf(IFavoritesModel, FavoritesModel);			
			injector.mapSingleton(MainView);
		}
	}
}
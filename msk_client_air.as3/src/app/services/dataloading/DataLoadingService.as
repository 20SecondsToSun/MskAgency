package app.services.dataloading
{
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.InteractiveServiceEvent;
	import app.contoller.events.LoadPhotoEvent;
	import app.contoller.events.ServerErrorEvent;
	import app.contoller.events.ServerUpdateEvent;
	import app.model.config.IConfig;
	import app.model.dataall.IAllNewsModel;
	import app.model.dataemploy.IEmployModel;
	import app.model.datafact.IFactsModel;
	import app.model.datafav.IFavoritesModel;
	import app.model.datafilters.IFilterDataModel;
	import app.model.datafilters.Rubric;
	import app.model.datageo.IGeoModel;
	import app.model.dataphoto.IPhotoNewsModel;
	import app.model.datauser.IUser;
	import app.model.datauser.server.Server;
	import app.model.datavideo.IVideoNewsModel;
	import app.model.daysnews.IDaysNewsModel;
	import app.model.mainnews.IMainNewsModel;
	import app.model.materials.Fact;
	import app.model.materials.Filters;
	import app.model.materials.Informer;
	import app.model.materials.Material;
	import app.model.materials.Weather;
	import app.services.state.INavigationService;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	import org.robotlegs.mvcs.Actor;
	
	public class DataLoadingService extends Actor implements IDataLoadingService
	{
		[Inject]
		public var user:IUser;
		
		[Inject]
		public var navigationService:INavigationService;
		
		[Inject]
		public var server:Server;
		
		[Inject]
		public var photoNews:IPhotoNewsModel;
		
		[Inject]
		public var allNews:IAllNewsModel;
		
		[Inject]
		public var mainNews:IMainNewsModel;
		
		[Inject]
		public var daysNews:IDaysNewsModel;
		
		[Inject]
		public var videoNews:IVideoNewsModel;
		
		[Inject]
		public var geoNews:IGeoModel;
		
		[Inject]
		public var facts:IFactsModel;
		
		[Inject]
		public var filterModel:IFilterDataModel;
		
		[Inject]
		public var conf:IConfig;
		
		[Inject]
		public var fav:IFavoritesModel;
		
		[Inject]
		public var employ:IEmployModel;
		
		protected var loaders:Vector.<URLLoader> = new Vector.<URLLoader>();
		
		public function flush():void
		{
			for (var i:int = 0; i < loaders.length; i++)
				loaders.pop().close();
		}
		
		public function loadData():void
		{
		
		}
		
		//--------------------------------------------------------------------------
		//
		//  Load Ipad Data
		//
		//--------------------------------------------------------------------------
		
		public function loadIpadData():void
		{
			var loader:URLLoader = new URLLoader();
			//var request:URLRequest = new URLRequest(server + "/get_materials_list");
			var request:URLRequest = new URLRequest(server + "/get_published_materials_list");
			request.method = URLRequestMethod.POST;
			
			var variables:URLVariables = new URLVariables();
			
			variables.offset = 0;
			variables.limit = 20;
			variables.status = "Published";
			
			request.data = variables;
			
			loaders.push(loader);
			//loader.addEventListener(Event.COMPLETE, on_complete_loading_main_news);
			loader.load(request);
		}
		
		public function loadDaysDataNews(important:String = "1", limit:int = 500):void
		{
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(server + "/get_materials_list");
			request.method = URLRequestMethod.POST;
			
			var variables:URLVariables = new URLVariables();
			
			if (filterModel.daysNewsFilters.isFilter)
			{
				variables.offset = filterModel.daysNewsFilters.offset;
				variables.limit = filterModel.daysNewsFilters.limit;
				
				if (filterModel.daysNewsFilters.rubrics)
					variables.rubric = filterModel.daysNewsFilters.rubrics;
				
				if (filterModel.daysNewsFilters.from)
				{
					variables.from = filterModel.daysNewsFilters.from;
					variables.limit = 10;
				}
				
				if (filterModel.daysNewsFilters.to)
					variables.to = filterModel.daysNewsFilters.to;
				
			}
			else
			{
				variables.offset = 0;
				variables.limit = limit;
				var day:String = daysNews.loadingDate;
				variables.important = important;
				variables.from = day;
				variables.to = day;
			}
			
			variables.status = "Published";
			request.data = variables;
			
			if (important == "0")
				loader.addEventListener(Event.COMPLETE, on_complete_loading_days_news_final);
			else
				loader.addEventListener(Event.COMPLETE, on_complete_loading_days_news);
			
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loaders.push(loader);
			loader.load(request);
		}
		
		public function loadFiltersData():void
		{
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(server + "/get_material_filters_data");
			request.method = URLRequestMethod.POST;
			
			loader.addEventListener(Event.COMPLETE, on_complete_loading_filters_data);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loaders.push(loader);
			loader.load(request);
		}
		
		private function loader_success():void
		{
			if (!isBadRequest)
				return;
			
			dispatch(new InteractiveServiceEvent(InteractiveServiceEvent.START_INTERACTION));
			TweenLite.killDelayedCallsTo(reconnect);
			
			dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_COMPLETE));
			
			isBadRequest = false;
		}
		
		private var isBadRequest:Boolean = false;
		
		private function ioErrorHandler(e:IOErrorEvent):void
		{
			if (isBadRequest == false)
			{
				dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_FAILED));
				dispatch(new InteractiveServiceEvent(InteractiveServiceEvent.STOP_INTERACTION));
			}
			
			flush();
			TweenLite.delayedCall(2, reconnect);
			isBadRequest = true;
		}
		
		private function reconnect():void
		{
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.RELOAD_DATA));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Breaking News Data
		//
		//--------------------------------------------------------------------------
		
		static public const MAIN_NEWS_LIMIT_MAIN_PAGE:int = 10;
		
		public function loadMainNews(filtersOff:Boolean = false):void
		{
			var loader:URLLoader = new URLLoader();
			//var request:URLRequest = new URLRequest(server + "/get_materials_list");
			var request:URLRequest = new URLRequest(server + "/get_published_materials_list");
			request.method = URLRequestMethod.POST;
			
			var variables:URLVariables = new URLVariables();
			
			variables.offset = 0;
			variables.limit = MAIN_NEWS_LIMIT_MAIN_PAGE;
			variables.important = "1";
			variables.status = "Published";
			
			if (filtersOff == false)
			{
				setVariables(variables, user.getfilters());
			}
			else
			{
				
			}
			request.data = variables;
			
			loader.addEventListener(Event.COMPLETE, on_complete_loading_main_news);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loaders.push(loader);
			loader.load(request);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Photo Data
		//
		//--------------------------------------------------------------------------
		
		static public const PHOTO_LIMIT_MAIN_PAGE:int = 20;
		
		public function loadPhotoNews():void
		{
			var loader:URLLoader = new URLLoader();
			//var request:URLRequest = new URLRequest(server + "/get_materials_list?123345");
			var request:URLRequest = new URLRequest(server + "/get_published_materials_list");
			request.method = URLRequestMethod.POST;
			//request.manageCookies = false;
			//request.requestHeaders.push(new URLRequestHeader("Set-Cookie", ""));
			var variables:URLVariables = new URLVariables();
			setVariables(variables, user.getfilters());
			
			variables.offset = 0;
			variables.limit = PHOTO_LIMIT_MAIN_PAGE;
			variables.type = "photo";
			variables.status = "Published";
			request.data = variables;
			
			loader.addEventListener(Event.COMPLETE, on_complete_loading_photo_news);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loaders.push(loader);
			loader.load(request);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Favorites Data
		//
		//--------------------------------------------------------------------------
		
		public function removeFromFavs(mat:*, type:String):void
		{
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(server + "/remove_from_favorites");
			request.method = URLRequestMethod.POST;
			
			var variables:URLVariables = new URLVariables();
			variables.type = type;
			variables.id = mat;
			request.data = variables;
			//trace('maaaaaaaaaaaaaaaaaaaaaaaaaaaaaat', mat);
			
			loader.addEventListener(Event.COMPLETE, on_complete_removing_favorites);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loaders.push(loader);
			loader.load(request);
		}
		
		private function on_complete_removing_favorites(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			var data:Object = JSON.parse(loader.data);
			//trace("FAVORITES", data.success);
			if (data.success)
			{
				//	trace("REMOVE FAVORITES SUCCESS");
			}
		}
		
		public function addToFavs(mat:*, type:String):void
		{
			//trace("FAVORITES SUCCESS", type, mat.id);
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(server + "/add_to_favorites");
			request.method = URLRequestMethod.POST;
			
			var variables:URLVariables = new URLVariables();
			variables.type = type;
			variables.id = mat.id;
			request.data = variables;
			
			loader.addEventListener(Event.COMPLETE, function():void
				{
					var data:Object = JSON.parse(loader.data);
					//	trace("FAVORITES", data.success);
					if (data.success)
					{
						if (type == "material")
							fav.insertMaterial(mat);
						else if (type == "activity")
							fav.insertFact(mat);
						
						loader_success()
					}
					else
					{
						dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_FAILED, data.error.code, data.error.message));
					}
				});
			
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loaders.push(loader);
			loader.load(request);
		}
		
		public function loadWeather():void
		{
			var _urlDate:String = "http://informer.gismeteo.ru/xml/27612_1.xml"; //"http://export.yandex.ru/weather-ng/forecasts/27612.xml";
			var _urlRequest:URLRequest = new URLRequest(_urlDate);
			var _loader:URLLoader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, loader_complete_weather);
			_loader.load(_urlRequest);
		}
		
		private function loader_complete_weather(e:Event):void
		{
			var loader:URLLoader = URLLoader(e.target);
			
			var xml:XML = new XML(e.target.data);
			var len:int = xml.REPORT.TOWN.FORECAST.length();
			var wetharr:Vector.<Weather> = new Vector.<Weather>();
			
			for (var i:int = 0; i < len; i++)
			{
				var weth:Weather = new Weather();
				weth.day = xml.REPORT.TOWN.FORECAST[i].@day
				weth.month = xml.REPORT.TOWN.FORECAST[i].@day
				weth.hour = xml.REPORT.TOWN.FORECAST[i].@day
				weth.precipitation = xml.REPORT.TOWN.FORECAST[i].PHENOMENA.@precipitation;
				weth.maxT = xml.REPORT.TOWN.FORECAST[i].TEMPERATURE.@max;
				weth.minT = xml.REPORT.TOWN.FORECAST[i].TEMPERATURE.@min;
				
				wetharr.push(weth);
			}
			
			if (wetharr.length)
				employ.weather = wetharr;
			
			var _urlDate:String = "http://www.m24.ru/js/infoline/infoline.js";
			var _urlRequest:URLRequest = new URLRequest(_urlDate);
			var _loader:URLLoader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, loader_complete_msk);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, function ():void 
			{
				trace("ERROOOOOOOOOOOOOOR!!!!!!!!!!!! M 24 info");
			});
			_loader.load(_urlRequest);
			
			function loader_complete_msk(_evt:Event):void
			{
				var __loaderMsk:URLLoader = URLLoader(_evt.target);
				var str:String = __loaderMsk.data;

				var obj:Object = JSON.parse(str.substring(13).slice(0, -3));
				
				var inf:Informer = new Informer();
				inf.eur_change = obj.eur_change;
				inf.eur_current = obj.eur_current;
				inf.usd_change = obj.usd_change;
				inf.usd_current = obj.usd_current;
				inf.probki_city = obj.probki_city;		
				
				employ.informer = inf;
			}		
		}
		
		public function loadFavoritesMaterials():void		
		{
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(server + "/get_favorites");
			request.method = URLRequestMethod.POST;
			
			var variables:URLVariables = new URLVariables();
			variables.offset = 0;
			variables.limit = 10;
			variables.type = "material";
			request.data = variables;
			
			loader.addEventListener(Event.COMPLETE, on_complete_loading_favorites);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loaders.push(loader);
			loader.load(request);
		}
		
		public function loadFavoritesFacts():void
		{
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(server + "/get_favorites");
			request.method = URLRequestMethod.POST;
			
			var variables:URLVariables = new URLVariables();
			variables.offset = 0;
			variables.limit = 10;
			variables.type = "activity";
			request.data = variables;
			
			loader.addEventListener(Event.COMPLETE, on_complete_loading_favorites_facts);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loaders.push(loader);
			loader.load(request);
		}
		
		private function on_complete_loading_favorites(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			var data:Object = JSON.parse(loader.data);
			//trace("FAVORITES LENGTH", data.data.length);
			if (data.success)
			{
				fav.newsList = parseMaterial(data.data);
				loader_success();
			}
			else
			{
				dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_FAILED, data.error.code, data.error.message));
			}
		}
		
		private function on_complete_loading_favorites_facts(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			var data:Object = JSON.parse(loader.data);
			
			if (data.success)
			{
				fav.factsList = parseFact(data.data);
				loader_success();
			}
			else
			{
				dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_FAILED, data.error.code, data.error.message));
			}
		}
		
		//--------------------------------------------------------------------------
		//
		// Video Data
		//
		//--------------------------------------------------------------------------
		static public const VIDEO_LIMIT_MAIN_PAGE:int = 10;
		
		public function loadVideoNews():void
		{
			var loader:URLLoader = new URLLoader();
			//var request:URLRequest = new URLRequest(server + "/get_materials_list");
			var request:URLRequest = new URLRequest(server + "/get_published_materials_list");
			request.method = URLRequestMethod.POST;
			var variables:URLVariables = new URLVariables();
			setVariables(variables, user.getfilters());
			
			variables.offset = 0;
			variables.limit = VIDEO_LIMIT_MAIN_PAGE;
			variables.type = "video";
			variables.status = "Published";
			request.data = variables;
			
			loader.addEventListener(Event.COMPLETE, on_complete_loading_video_news);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loaders.push(loader);
			loader.load(request);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Facts Data
		//
		//--------------------------------------------------------------------------
		static public const FACTS_NEWS_LIMIT_MAIN_PAGE:int = 20;
		
		public function loadFactsDataMainNews(isMain:Boolean = true, useFilters:Boolean = true):void
		{
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(server + "/get_activities_by_day");
			request.method = URLRequestMethod.POST;
			
			var variables:URLVariables = new URLVariables();
			variables.limit = FACTS_NEWS_LIMIT_MAIN_PAGE;
			variables.offset = 0;
			variables.day =  conf.currentDate;
			variables.status = "Published";
			
			if (isMain)
				variables.fake_status = "Main";
			
			facts.notema = false;
			if (useFilters)
			{
				setVariables(variables, user.getfilters());
			}
			else
			{
				facts.notema = true;
			}
			
			request.data = variables;		
			
			loader.addEventListener(Event.COMPLETE, on_complete_loading_facts_main);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loaders.push(loader);
			loader.load(request);
		}
		
		public function loadFactsDataDayNews(day:String):void
		{
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(server + "/get_activities_by_day");
			request.method = URLRequestMethod.POST;
			
			var variables:URLVariables = new URLVariables();
			variables.status = "Published";
			
			//variables.limit = 100;
			//variables.offset = 0;
			
			if (filterModel.factsNewsFilters.isFilter)
			{
				if (filterModel.factsNewsFilters.rubrics)
					variables.rubric = filterModel.factsNewsFilters.rubrics;
			}
			
			variables.day = day;
			request.data = variables;
			
			loader.addEventListener(Event.COMPLETE, on_complete_loading_day_facts);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loaders.push(loader);
			loader.load(request);
		}
		
		public function loadFactsDataAllNews():void
		{
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(server + "/get_activities_by_day");
			request.method = URLRequestMethod.POST;
			
			var variables:URLVariables = new URLVariables();
			variables.day = facts.loadingDate;
			variables.status = "Published";
			
			if (filterModel.factsNewsFilters.isFilter)
			{
				if (filterModel.factsNewsFilters.rubrics)
					variables.rubric = filterModel.factsNewsFilters.rubrics;
				
				if (filterModel.factsNewsFilters.from)
					variables.day = filterModel.factsNewsFilters.from;
			}
			
			request.data = variables;
			
			loader.addEventListener(Event.COMPLETE, on_complete_loading_all_facts);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loaders.push(loader);
			loader.load(request);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Geo Data
		//
		//--------------------------------------------------------------------------
		
		public function loadGeoDataMainNews():void
		{
			geoNewsBaseLoader(10, 0);
		}
		
		public function loadGeoNews():void
		{
			geoNewsBaseLoader(100, 0);
		}
		
		public function geoNewsBaseLoader(_limit:int, _offset:int):void
		{
			var loader:URLLoader = new URLLoader();
			//var request:URLRequest = new URLRequest(server + "/get_materials_list");
			var request:URLRequest = new URLRequest(server + "/get_published_materials_list");
			request.method = URLRequestMethod.POST;
			
			var variables:URLVariables = new URLVariables();
			variables.limit = _limit;
			variables.offset = _offset;
			variables.has_point = "yes";
			variables.status = "Published";
			
			setVariables(variables, user.getfilters());
			
			if (filterModel.geoNewsFilters.isFilter)
			{
				variables.from = filterModel.geoNewsFilters.from;
				variables.to = filterModel.geoNewsFilters.to;
				loader.addEventListener(Event.COMPLETE, on_complete_loading_geo_filtered);
			}
			else
				loader.addEventListener(Event.COMPLETE, on_complete_loading_geo);
			
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			request.data = variables;
			
			loaders.push(loader);
			loader.load(request);
		}
		
		//--------------------------------------------------------------------------
		//
		//
		//
		//--------------------------------------------------------------------------
		
		public function loadOneNew(id:int):void
		{
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(server + "/get_material");
			request.method = URLRequestMethod.POST;
			
			var variables:URLVariables = new URLVariables();
			variables.id = id;
			variables.status = "Published";
			
			setVariables(variables, user.getfilters());
			
			request.data = variables;
			
			loader.addEventListener(Event.COMPLETE, on_complete_loading_one_new);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loaders.push(loader);
			loader.load(request);
		}
		
		public function loadNearNews():void
		{
			filterModel.oneDayFilters.from = TextUtil.convertDateToString(allNews.activeMaterial.publishedDate);
			filterModel.oneDayFilters.to = TextUtil.convertDateToString(allNews.activeMaterial.publishedDate);
			filterModel.oneDayFilters.isFilter = true;
			loadDayNearNews();
			
			filterModel.resetDates();
			filterModel.resetOffsetLimit();
			//filterModel.oneDayFilters.isFilter = false;
		}
		
		public function loadDayNearNews():void
		{
			var loader:URLLoader = new URLLoader();
			//var request:URLRequest = new URLRequest(server + "/get_materials_list");
			var request:URLRequest = new URLRequest(server + "/get_published_materials_list");
			request.method = URLRequestMethod.POST;
			
			var variables:URLVariables = new URLVariables();
			variables.offset = 0;
			variables.limit = 20;
			variables.status = "Published";
			
			if (filterModel.oneDayFilters.isFilter)
			{
				if (filterModel.oneDayFilters.to)
					variables.from = filterModel.oneDayFilters.to;
				else
					variables.from = conf.currentDate;
				
				if (filterModel.oneDayFilters.from)
					variables.to = filterModel.oneDayFilters.from;
				else
					variables.to = conf.currentDate;
				
				if (filterModel.oneDayFilters.rubrics)
					variables.rubric = filterModel.oneDayFilters.rubrics;
				
				if (allNews.offsetLoad)
				{
					variables.offset = allNews.offsetLoad;
					variables.limit = allNews.limitLoad;
				}
			}
			
			request.data = variables;
			
			loader.addEventListener(Event.COMPLETE, on_complete_loading_near_news);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loaders.push(loader);
			loader.load(request);
		}
		
		public function loadDayNews():void
		{
			var loader:URLLoader = new URLLoader();
			//var request:URLRequest = new URLRequest(server + "/get_materials_list");
			var request:URLRequest = new URLRequest(server + "/get_published_materials_list");
			request.method = URLRequestMethod.POST;
			
			var variables:URLVariables = new URLVariables();
			variables.offset = 0;
			variables.limit = 1000;
			variables.status = "Published";
			
			if (filterModel.oneDayFilters.isFilter)
			{
				if (filterModel.oneDayFilters.to)
					variables.from = filterModel.oneDayFilters.to;
				else
					variables.from = conf.currentDate;
				
				if (filterModel.oneDayFilters.from)
					variables.to = filterModel.oneDayFilters.from;
				else
					variables.to = conf.currentDate;
				
				if (filterModel.oneDayFilters.rubrics)
					variables.rubric = filterModel.oneDayFilters.rubrics;
			}
			else
			{
				variables.from = conf.currentDate;
				variables.to = conf.currentDate;
			}
			
			request.data = variables;
			
			loader.addEventListener(Event.COMPLETE, on_complete_loading_near_news);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loaders.push(loader);
			loader.load(request);
		}
		
		public function checkDataFacts():void
		{
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(server + "/get_activities_by_day");
			request.method = URLRequestMethod.POST;
			
			var variables:URLVariables = new URLVariables();
			variables.day = facts.loadingDate;
			variables.status = "Published";
			
			if (filterModel.factsNewsFilters.isFilter)
			{
				if (filterModel.factsNewsFilters.rubrics)
					variables.rubric = filterModel.factsNewsFilters.rubrics;
				
				if (filterModel.factsNewsFilters.from)
					variables.day = filterModel.factsNewsFilters.from;
			}
			
			request.data = variables;
			
			loader.addEventListener(Event.COMPLETE, on_complete_loading_check_facts);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loaders.push(loader);
			loader.load(request);
		}
		
		public function checkDataNews():void
		{
			var loader:URLLoader = new URLLoader();
			//var request:URLRequest = new URLRequest(server + "/get_materials_list");
			var request:URLRequest = new URLRequest(server + "/get_published_materials_list");
			request.method = URLRequestMethod.POST;
			
			var variables:URLVariables = new URLVariables();
			variables.offset = 0;
			variables.limit = 10;
			variables.status = "Published";
			
			if (filterModel.oneDayFilters.isFilter)
			{
				if (filterModel.oneDayFilters.to)
					variables.from = filterModel.oneDayFilters.to;
				else
					variables.from = conf.currentDate;
				
				if (filterModel.oneDayFilters.from)
					variables.to = filterModel.oneDayFilters.from;
				else
					variables.to = conf.currentDate;
				
				if (filterModel.oneDayFilters.rubrics)
					variables.rubric = filterModel.oneDayFilters.rubrics;
			}
			
			request.data = variables;
			
			loader.addEventListener(Event.COMPLETE, on_complete_check_news);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loaders.push(loader);
			loader.load(request);
		}
		
		public function loadAllDataNews(id:String):void
		{
			_loadData(id);
		}
		
		protected function _loadData(id:String = ""):void
		{
			var loader:URLLoader = new URLLoader();
			//var request:URLRequest = new URLRequest(server + "/get_materials_list");
			var request:URLRequest = new URLRequest(server + "/get_published_materials_list");
			request.method = URLRequestMethod.POST;
			
			var variables:URLVariables = new URLVariables();
			variables.offset = 0;
			variables.limit = 20;
			variables.status = "Published";
			
			setVariables(variables, user.getfilters());
			
			var on_complete_loading_all_news_1:Function = function(event:Event):void
			{
				on_complete_loading_all_news(event);
			};
			
			request.data = variables;
			
			loader.addEventListener(Event.COMPLETE, on_complete_loading_all_news_1);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loaders.push(loader);
			loader.load(request);
		
		}
		
		public function setVariables(variables:URLVariables, filters:Filters):void
		{
			if (filters.criteria != "")
				variables.criteria = filters.criteria;
			if (filters.from != "")
				variables.from = filters.from;
			if (filters.to != "")
				variables.to = filters.to;
			if (filters.type != "")
				variables.type = filters.type;
			if (filters.tag != "")
				variables.tag = filters.tag;
			if (filters.status != "")
				variables.status = filters.status;
			if (filters.rubric != "")
				variables.rubric = filters.rubric;
			if (filters.has_point != "")
				variables.has_point = filters.has_point;
		}
		
		//--------------------------------------------------------------------------
		//
		//  COMPLETE
		//
		//--------------------------------------------------------------------------
		
		private function on_complete_loading_photo_news(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			var data:Object = JSON.parse(loader.data);
			//trace("PHOTO LOADED", data.error.code);
			if (data.success)
			{
				photoNews.count = data.info.count;
				photoNews.limit = data.info.limit;
				photoNews.offset = data.info.offset;
				photoNews.newsList = parseMaterial(data.data);
				loader_success();
			}
			else
			{
				dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_FAILED, data.error.code, data.error.message));
			}
		}
		
		private function on_complete_loading_days_news_final(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			var data:Object = JSON.parse(loader.data);
			
			if (data.success)
			{
				daysNews.count = data.info.count;
				daysNews.limit = data.info.limit;
				daysNews.offset = data.info.offset;
				daysNews.newsList = parseMaterial(data.data);
				loader_success();
			}
			else
			{
				dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_FAILED, data.error.code, data.error.message));
			}
		}
		
		private function on_complete_loading_days_news(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			var data:Object = JSON.parse(loader.data);
			if (data.success)
			{
				if (data.info.count == 0 && !filterModel.daysNewsFilters.isFilter)
				{
					loadDaysDataNews("0", 5);
					return;
				}
				daysNews.count = data.info.count;
				daysNews.limit = data.info.limit;
				daysNews.offset = data.info.offset;
				daysNews.newsList = parseMaterial(data.data);
				loader_success();
			}
			else
			{
				dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_FAILED, data.error.code, data.error.message));
			}
		}
		
		private function on_complete_loading_filters_data(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			var data:Object = JSON.parse(loader.data);
			
			if (data.success)
			{
				var filter:Object = data.data;
				
				for (var i:int = 0; i < filter.status.length; i++)
				{
					filterModel.status.push(filter.status[i]);
				}
				
				for (i = 0; i < filter.type.length; i++)
				{
					filterModel.type.push(filter.type[i]);
				}
				
				for (i = 0; i < filter.rubric.length; i++)
				{
					var rub:Rubric = new Rubric();
					rub.id = filter.rubric[i].id;
					rub.title = filter.rubric[i].title;
					filterModel.rubrics.push(rub);
				}
				
				dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_COMPLETED_FILTERS_DATA));
				loader_success();
			}
			else
			{
				dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_FAILED, data.error.code, data.error.message));
			}
		}
		private var counter:int = 0;
		
		private function on_complete_loading_main_news(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			var data:Object = JSON.parse(loader.data);
			//trace("LOADDDDDDDDDDDDDDDEEEEEEEEEEEEEEEEEEEEED", data.success, data.data.length);
			if (data.success)
			{
				if (data.data.length == 0)
				{
					loadMainNews(true);
					return;
				}
				mainNews.count = data.info.count;
				mainNews.limit = data.info.limit;
				mainNews.offset = data.info.offset;
				mainNews.newsList = parseMaterial(data.data);
				loader_success();
			}
			else
			{
				dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_FAILED, data.error.code, data.error.message));
			}
		
			//
			//if (counter++ % 2 == 0) ioErrorHandler(null);			
		}
		
		private function on_complete_loading_day_facts(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			var data:Object = JSON.parse(loader.data);
			if (data.success)
			{
				facts.count = data.info.count;
				facts.limit = data.info.limit;
				facts.offset = data.info.offset;
				facts.dayNewsList = parseFact(data.data);
				loader_success();
			}
			else
			{
				dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_FAILED, data.error.code, data.error.message));
			}
		}
		private var factsMainTries:int = 0;
		
		private function on_complete_loading_facts_main(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			var data:Object = JSON.parse(loader.data);
			//trace("data loading ", data.error.code, data.error.message);
			if (data.success)
			{
				
				if (data.data == undefined || data.data.length == 0)
				{
					factsMainTries++;
					
					if (factsMainTries == 3)
						return;
					
					if (factsMainTries == 1)
					{
						loadFactsDataMainNews(false);
						return;
					}
					
					if (factsMainTries == 2)
					{
						loadFactsDataMainNews(false, false);
						return;
					}
				}
				factsMainTries = 0;
				
				facts.count = data.info.count;
				facts.limit = data.info.limit;
				facts.offset = data.info.offset;
				facts.mainNewsList = parseFact(data.data);
				
				loader_success();
			}
			else
			{
				dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_FAILED, data.error.code, data.error.message));
			}
		}
		
		private function on_complete_loading_all_facts(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			var data:Object = JSON.parse(loader.data);
			if (data.success)
			{
				facts.count = data.info.count;
				//facts.limit = data.info.limit;
				//facts.offset = data.info.offset;
				facts.prevDate = data.prev;
				facts.nextDate = data.next;
				facts.newsList = parseFact(data.data);
				
				loader_success();
			}
			else
			{
				dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_FAILED, data.error.code, data.error.message));
			}
		}
		
		private function on_complete_loading_geo(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			var data:Object = JSON.parse(loader.data);
			
			if (data.success)
			{
				geoNews.count = data.info.count;
				geoNews.limit = data.info.limit;
				geoNews.offset = data.info.offset;
				geoNews.newsList = parseMaterial(data.data);
				
				loader_success();
			}
			else
			{
				dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_FAILED, data.error.code, data.error.message));
			}
		}
		
		private function on_complete_loading_geo_filtered(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			var data:Object = JSON.parse(loader.data);
			
			if (data.success)
			{
				geoNews.count = data.info.count;
				geoNews.limit = data.info.limit;
				geoNews.offset = data.info.offset;
				geoNews.newsListFiltered = parseMaterial(data.data);
				
				loader_success();
			}
			else
			{
				dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_FAILED, data.error.code, data.error.message));
			}
		}
		
		private function on_complete_loading_video_news(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			var data:Object = JSON.parse(loader.data);
			
			if (data.success)
			{
				videoNews.count = data.info.count;
				videoNews.limit = data.info.limit;
				videoNews.offset = data.info.offset;
				videoNews.newsList = parseMaterial(data.data);
				
				loader_success();
			}
			else
			{
				dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_FAILED, data.error.code, data.error.message));
			}
		}
		
		private function on_complete_loading_check_facts(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			var data:Object = JSON.parse(loader.data);
			if (data.success)
			{
				if (data.data.length == 0)
					dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.NO_MATERIALS));
				else
					dispatch(new ChangeLocationEvent(ChangeLocationEvent.FACT_PAGE));
				
				loader_success();
			}
			else
			{
				
				dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_FAILED, data.error.code, data.error.message));
			}
		}
		
		private function on_complete_check_news(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			var data:Object = JSON.parse(loader.data);
			
			if (data.success)
			{
				if (data.info.count == 0)
					dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.NO_MATERIALS));
				else
					dispatch(new ChangeLocationEvent(ChangeLocationEvent.NEWS_PAGE_HOUR));
				
				loader_success();
			}
			else
			{
				dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_FAILED, data.error.code, data.error.message));
			}
		}
		
		private function on_complete_loading_near_news(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			var data:Object = JSON.parse(loader.data);
			
			if (data.success)
			{
				allNews.count = data.info.count;
				allNews.limit = data.info.limit;
				allNews.offset = data.info.offset;
				allNews.newsList = parseMaterial(data.data);
				
				loader_success();
			}
			else
			{
				dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_FAILED, data.error.code, data.error.message));
			}
		}
		
		private function on_complete_loading_all_news(event:Event):void
		{
			
			var loader:URLLoader = URLLoader(event.target);
			var data:Object = JSON.parse(loader.data);
			
			if (data.success)
			{
				allNews.count = data.info.count;
				allNews.limit = data.info.limit;
				allNews.offset = data.info.offset;
				allNews.newsList = parseMaterial(data.data);
				loader_success();
			}
			else
			{
				dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_FAILED, data.error.code, data.error.message));
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//     PARSING
		//
		//--------------------------------------------------------------------------
		protected function parseFact(data:Object):Vector.<Fact>
		{
			var materialList:Vector.<Fact> = new Vector.<Fact>();
			
			for (var i:int = 0; i < data.length; i++)
			{
				var material:Fact = new Fact();
				
				for (var k:int = 0; k < data[i].rubrics.length; k++)
					material.pushRubric(data[i].rubrics[k]);
				
				material.is_main = data[i].is_main;
				material.author_id = data[i].author_id;
				material.id = data[i].id;
				material.is_public = data[i].is_public;
				material.live_broadcast = data[i].live_broadcast;
				material.place = data[i].place;
				material.start_date_timestamp = data[i].start_date;
				material.end_date_timestamp = data[i].end_date;
				
				material.start_date = Tool.timestapToDate(data[i].start_date);
				material.end_date = Tool.timestapToDate(data[i].end_date);
				
				material.text = data[i].text;
				material.title = data[i].title;
				materialList.push(material);
			}
			return materialList;
		}
		
		protected function parseMaterial(data:Object):Vector.<Material>
		{
			var materialList:Vector.<Material> = new Vector.<Material>();
			
			for (var i:int = 0; i < data.length; i++)
			{
				//trace('PUBLISHED AT::::::', data[i].published_at, data[i].id);
				if (data[i].published_at == null)
					continue;
				materialList.push(parseOneMaterial(data[i]));
			}
			return materialList;
		}
		
		protected function parseOneMaterial(data:*):Material
		{
			var material:Material = new Material();
			
			material.author_id = data.author_id;
			material.important = data.important;
			material.modified = data.modified;
			
			material.published_at = data.published_at;
			material.text = data.text;
			material.type = data.type;
			material.id = data.id;
			material.title = data.title;
			material.theme = data.theme;
			material.publishedDate = Tool.timestapToDate(material.published_at);
			
			material.pushPoint(data.point);
			
			if (data.translations)
			{
				for (var p:int = 0; p < data.translations.length; p++)
					material.pushTranslations(data.translations[p]);
			}
			
			for (var k:int = 0; k < data.rubrics.length; k++)
				material.pushRubric(data.rubrics[k]);
			
			for (var j:int = 0; j < data.files.length; j++)
			{
				material.pushFile(data.files[j]);
					//if (material.type == "photo") trace(data.files[j].thumbnail );
			}
			
			for each (var tag:String in data.tags)
				material.tags.push(tag);
			
			return material;
		}
		
		private function on_complete_loading_one_new(e:Event):void
		{
			var loader:URLLoader = URLLoader(e.target);
			var data:Object = JSON.parse(loader.data);
			
			//trace("LOAD ONE NEW!!!!!!!!!!!",  data.error.code, data.error.message);
			
			if (!data.success)
			{
				dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_FAILED, data.error.code, data.error.message));
				return;
			}
			if (data.data == null)
				return;
			if (!data.data.length)
				return;
			
			var material:Material = parseOneMaterial(data.data[0]);
			
			//var evt:DataLoadServiceEvent = new DataLoadServiceEvent(DataLoadServiceEvent.ONE_NEW_LOADED);
			//evt.mat = material;			
			//dispatch(evt);
			
			/*	var mainEvent:ServerUpdateEvent = new ServerUpdateEvent(ServerUpdateEvent.MAIN_NEWS);
			   mainEvent.mat = material;
			   dispatch(mainEvent);
			
			 return;*/
			
			trace("material.type", material.type);
			
			if (material.point != null)
			{
				var geoEvent:ServerUpdateEvent = new ServerUpdateEvent(ServerUpdateEvent.GEO_NEWS);
				geoEvent.mat = material;
				dispatch(geoEvent);
				
			}
			else
			{
				switch (material.type)
				{
					case "video": 
						var videoEvent:ServerUpdateEvent = new ServerUpdateEvent(ServerUpdateEvent.VIDEO_NEWS);
						videoEvent.mat = material;
						dispatch(videoEvent);
						break;
					
					case "photo": 
						var photoEvent:ServerUpdateEvent = new ServerUpdateEvent(ServerUpdateEvent.PHOTO_NEWS);
						photoEvent.mat = material;
						dispatch(photoEvent);
						//trace("HERE!!!!!!!!!!");
						break;
					default: 
				}
			}
			
			allNewsSend(material);
			
			if (material.important == "1")
			{
				var mainEvent:ServerUpdateEvent = new ServerUpdateEvent(ServerUpdateEvent.MAIN_NEWS);
				mainEvent.mat = material;
				dispatch(mainEvent);
			}
			loader_success();
		
		/*
		   var evt1:ServerUpdateEvent = new ServerUpdateEvent(ServerUpdateEvent.MAIN_NEWS);
		
		   if (material.id == 218533)
		   {
		   var evt2:ServerUpdateEvent = new ServerUpdateEvent(ServerUpdateEvent.GEO_NEWS);
		   evt2.mat = material;
		   dispatch(evt2);
		
		   evt1.mat = material;
		   dispatch(evt1);
		
		   return;
		   }
		   if (material.id == 220581)
		   {
		   var evt4:IpadEvent = new IpadEvent(IpadEvent.OPEN_POPUP);
		   evt4.data = material;
		   dispatch(evt4);
		   return;
		   }
		   if (material.id == 213069)
		   {
		
		   var evt_photo:ServerUpdateEvent = new ServerUpdateEvent(ServerUpdateEvent.PHOTO_NEWS);
		   evt_photo.mat = material;
		   allNewsSend(material);
		   dispatch(evt_photo);
		
		   evt1.mat = material;
		   dispatch(evt1);
		   return;
		   }
		
		   var evt:ServerUpdateEvent = new ServerUpdateEvent(ServerUpdateEvent.VIDEO_NEWS);
		   evt.mat = material;
		   allNewsSend(material);
		   dispatch(evt);
		
		   evt1.mat = material;
		 dispatch(evt1);*/
		
			//dispatch(new ServerUpdateEvent(ServerUpdateEvent.VIDEO_NEWS));			
		
		}
		
		public function allNewsSend(mat:Material):void
		{
			var evt3:ServerUpdateEvent = new ServerUpdateEvent(ServerUpdateEvent.ALL_NEWS);
			//mat.publishedDate = new Date();
			//mat.published_at = String(mat.publishedDate.getMilliseconds() * 1000);
			allNews.addMaterial(mat);
			evt3.mat = mat;
			dispatch(evt3);
		}
		
		//--------------------------------------------------------------------------
		//
		// 
		//
		//--------------------------------------------------------------------------	
		
		private var loaderDictionary:Dictionary = new Dictionary();
		
		public function loadPhoto(_path:String, _id:int, _view:DisplayObject):void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadingPhotoError);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadPhotoComplete);
			
			loaderDictionary[_id] = _view;
			
			var lc:LoaderContext = new LoaderContext;
			lc.parameters = {id: _id.toString()};
			loader.load(new URLRequest(_path), lc);
		}
		
		private function loadingPhotoError(e:IOErrorEvent):void
		{
		
		}
		
		private function loadPhotoComplete(e:Event):void
		{
			var id:int = int(e.target.parameters.id);
			
			var evt:LoadPhotoEvent = new LoadPhotoEvent(LoadPhotoEvent.PHOTO_LOADED);
			evt.photo = e.target.content as Bitmap;
			
			if (loaderDictionary[id])
			{
				loaderDictionary[id].dispatchEvent(evt);
				delete loaderDictionary[id];
			}
		}
	
	}
}
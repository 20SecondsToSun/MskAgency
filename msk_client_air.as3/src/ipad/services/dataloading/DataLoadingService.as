package ipad.services.dataloading
{
	import app.contoller.events.IpadEvent;
	import app.contoller.events.LoadPhotoEvent;
	import app.contoller.events.ServerErrorEvent;
	import app.model.datauser.server.Server;
	import app.model.mainnews.IMainNewsModel;
	import app.model.materials.Fact;
	import app.model.materials.Filters;
	import app.model.materials.Material;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
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
	import ipad.model.datafav.IFavoritesModel;
	import ipad.model.IInfo;
	import ipad.model.ipad.IIpadFactsModel;
	import ipad.model.ipad.IIpadNewsModel;
	import org.robotlegs.mvcs.Actor;
	
	public class DataLoadingService extends Actor implements IDataLoadingService
	{
		[Inject]
		public var server:Server;
		
		[Inject]
		public var ipadNews:IIpadNewsModel;
		
		[Inject]
		public var ipadFacts:IIpadFactsModel;
		
		[Inject]
		public var info:IInfo;	
		
		[Inject]
		public var fav:IFavoritesModel;
		
		//protected var currentDate:Date = new Date();
		protected var loaders:Vector.<URLLoader> = new Vector.<URLLoader>();
		private var mapFilters:Filters;
		
		public function flush():void
		{
			for (var i:int = 0; i < loaders.length; i++)
				loaders.pop().close();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Load Ipad Data
		//
		//--------------------------------------------------------------------------
		public function isClear(dataF:Object):Boolean
		{
			if (dataF.criteria != "")
				return false;
			
			if (dataF.from != "")
				return false;
			
			if (dataF.to != "")
				return false;

			if (dataF.rubric != "")
				return false;
				
			return true;

		}
		public function loadFactIpadData(dataF:Object):void
		{
			var loadingDate:String = "";
			
			
			
			if (ipadFacts.newSearch)
			{
				if (dataF.from != "")
					loadingDate = dataF.from;		
			}
			else loadingDate = ipadFacts.nextDate;			
			
			if (loadingDate != "")
			{	
				//trace("BEETWEEN", ipadFacts.getDaysBetweenDates(TextUtil.convertStringToDate(loadingDate), TextUtil.convertStringToDate(ipadFacts.finishDate)));
				if (ipadFacts.getDaysBetweenDates(TextUtil.convertStringToDate(loadingDate), TextUtil.convertStringToDate(ipadFacts.finishDate)) < 0) 
				{
					dispatch(new IpadEvent(IpadEvent.NO_MATERIALS));
					return;
				}
				loadFacts();
				return;
			}
			
		/*	var url:String = "http://json-time.appspot.com/time.json?tz=GMT0";
			var urlRequest:URLRequest = new URLRequest(url);
			var _loader:URLLoader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, loader_complete);
			_loader.load(urlRequest);*/
			
			var __year:String = "2013";
			loadDate();
			/*function loader_complete(evt:Event):void
			{
				var __loader:URLLoader = URLLoader(evt.target);
				var data:Object = JSON.parse(__loader.data);
				var arr:Array = data.datetime.split(" ");
				__year = arr[3];
				loadDate();
			}*/
			
			function loadDate():void
			{
				var _urlDate:String = "http://www.m24.ru/js/infoline/infoline.js";
				var _urlRequest:URLRequest = new URLRequest(_urlDate);
				var _loader:URLLoader = new URLLoader();
				_loader.addEventListener(Event.COMPLETE, loader_complete_msk);
				_loader.load(_urlRequest);
			}
			
			function loader_complete_msk(_evt:Event):void
			{
				var __loaderMsk:URLLoader = URLLoader(_evt.target);
				var str:String = __loaderMsk.data;
				str = str.substr(13);
				str = str.slice(0, str.length - 2);				
				var data:Object = JSON.parse(str);	
				loadingDate =  data.date + "." + __year;
				
				ipadFacts.currentDate = loadingDate;
				
				loadFacts();
			}
			
			function loadFacts():void
			{
				var loader:URLLoader = new URLLoader();
				var request:URLRequest = new URLRequest(server + "/get_activities_by_day");
				request.method = URLRequestMethod.POST;
				
				var variables:URLVariables = new URLVariables();
				setVariables(variables, dataF as Filters);
				variables.day = loadingDate;	
				//variables.from = "11.11.2013"; //loadingDate;	
				//variables.to = "12.11.2013";//loadingDate;	
				//trace("loadingDate", loadingDate);
				request.data = variables;
				
				loader.addEventListener(Event.COMPLETE, on_complete_loading_all_facts);
				loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				
				loaders.push(loader);
				loader.load(request);
			}
		}
		
		public function loadIpadData(data:Object):void
		{
			var loader:URLLoader = new URLLoader();
			//var request:URLRequest = new URLRequest(server + "/get_materials_list");
			var request:URLRequest = new URLRequest(server + "/get_published_materials_list");
			request.method = URLRequestMethod.POST;
			
			var variables:URLVariables = new URLVariables();
			setVariables(variables, data as Filters);
			request.data = variables;
			
			loaders.push(loader);
			loader.addEventListener(Event.COMPLETE, on_complete_loading_main_news);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loader.load(request);
		}
		
		public function loadMapIpadData(data:Object):void
		{
			var loader:URLLoader = new URLLoader();
			//var request:URLRequest = new URLRequest(server + "/get_materials_list");
			var request:URLRequest = new URLRequest(server + "/get_published_materials_list");
			request.method = URLRequestMethod.POST;
			
			var variables:URLVariables = new URLVariables();
			mapFilters = data as Filters;
			setMapVariables(variables, mapFilters);
			
			if (mapFilters.rubric == "5")
			{
				variables.important = "1";
			}
			else
			{
				variables.group_id = mapFilters.rubric;
			}
			
			request.data = variables;
			
			loaders.push(loader);
			loader.addEventListener(Event.COMPLETE, on_complete_loading_map_news);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loader.load(request);
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void
		{
		
		}
		
		public function setMapVariables(variables:URLVariables, filters:Filters):void
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
			
			if (filters.has_point != "")
				variables.has_point = filters.has_point;
			
			variables.limit = filters.limit;
			variables.offset = filters.offset;
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
			
			variables.limit = filters.limit;
			variables.offset = filters.offset;
		}
		
		private function on_complete_loading_main_news(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			var data:Object = JSON.parse(loader.data);
			
			if (data.success)
			{
				ipadNews.count = data.info.count;
				ipadNews.limit = data.info.limit;
				ipadNews.offset = data.info.offset;
				ipadNews.newsList = parseMaterial(data.data);
			}
			else
			{
				dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_FAILED, data.error.code, data.error.message));
			}
		}
		
		private function on_complete_loading_map_news(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			var data:Object = JSON.parse(loader.data);
			
			if (data.success)
			{
				ipadNews.count = data.info.count;
				ipadNews.limit = data.info.limit;
				ipadNews.offset = data.info.offset;
				ipadNews.newsList = parseMaterial(data.data);
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
				if (data.data.length == 0 && data.next == "0")
				{			
					dispatch(new IpadEvent(IpadEvent.NO_MATERIALS));
					return;		
				}
				else if (data.data.length == 0 )
				{
					ipadFacts.nextDate = data.next;
				}
				else
				{
					ipadFacts.nextDate = nextDate(data.info.day.split("."));
				}
				
				ipadFacts.newsList = parseFact(data.data);
			}
			else
			{
				dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_FAILED, data.error.code, data.error.message));
			}
			
		}
		public function nextDate(arr:Array):String
		{
			var prev:Date = new Date(arr[2], arr[1] - 1, arr[0]);			
			prev.date += 1;			
			return  TextUtil.getFormatDatePubl(prev);
		}
		
		
		
		protected function parseFact(data:Object, noCheck:Boolean = false):Vector.<Fact>
		{
			var materialList:Vector.<Fact> = new Vector.<Fact>();
			
			for (var i:int = 0; i < data.length; i++)
			{
				if (!noCheck && ipadFacts.isIdExist(data[i].id)) continue;				
				
				var material:Fact = new Fact();
				material.id = data[i].id;
				
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
				material.pushFile(data.files[j]);
			
			for each (var tag:String in data.tags)
				material.tags.push(tag);
			
			return material;
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
				trace("REMOVE FAVORITES SUCCESS");
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
			variables.id =  mat.id;
			request.data = variables;			
			
			loader.addEventListener(Event.COMPLETE, function ():void 
			{				
				var data:Object = JSON.parse(loader.data);
			//	trace("FAVORITES", data.success);
				if (data.success)
				{
					if (type == "material")
						fav.insertMaterial(mat);
					else if (type == "activity")
						fav.insertFact(mat);
						
					//loader_success()
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
				//loader_success();
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
				
				fav.factsList = parseFact(data.data, true);				
			//	loader_success();
			}
			else
			{
				dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_FAILED, data.error.code, data.error.message));
			}
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
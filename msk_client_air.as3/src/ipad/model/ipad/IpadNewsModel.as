package ipad.model.ipad
{
	import app.AppSettings;
	import app.contoller.events.ChangeModelOut;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.FilterEvent;
	import app.contoller.events.IpadEvent;
	import app.model.datafilters.IFilterDataModel;
	import app.model.materials.Material;
	import app.model.materials.MaterialModel;
	import app.view.utils.TextUtil;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class IpadNewsModel extends MaterialModel implements IIpadNewsModel
	{
		[Inject]
		public var filters:IFilterDataModel;
		
		private static const MAX_NEWS_COUNT:int = 20;		
		private const MAX_ALL_NEWS:int = 1040;
	
		protected var _activeMaterial:Material;
		private var _allNewsHourList:Vector.<Vector.<Material>>;
		public var _videoNum:int;
		public var _photoNum:int;
		public var _broadcastNum:int;
		private var _allTypeNews:Vector.<Material>;
		
		private var _allNewsHourListFilter:Vector.<Vector.<Material>>;
		private var _allNewsHourListToday:Vector.<Vector.<Material>>;
		private var _sortedType:String = "all";
		private var _isAnimate:Boolean = true;
		
		public function get activeMaterial():Material
		{
			return _activeMaterial;
		}
		
		public function set activeMaterial(value:Material):void
		{
			_activeMaterial = value;
		}
		
		override public function set newsList(value:Vector.<Material>):void
		{
			_newsList = value;
			
			if (_newsList.length <= 0)
			{
				dispatch(new IpadEvent(IpadEvent.NO_MATERIALS));
				return;
			}
			
			createLists();		
			dispatch(new IpadEvent(IpadEvent.MATERIALS_LOADED));
		}
		
		private function createLists():void
		{
			sortedType = "all";
			
			sortBydate();
			createDictionary();
			createNews();
			createNewsHourLists();
		}
		
		public function get allTypeNews():Vector.<Material>
		{
			return _allTypeNews;
		}
		
		public function set allTypeNews(value:Vector.<Material>):void
		{
			_allTypeNews = value;
		}
		
		private function createNews():void
		{
			_allTypeNews = new Vector.<Material>;
			_allTypeNews = _newsList;
		}
		
		public function get allNewsHourListFilter():Vector.<Vector.<Material>>
		{
			return _allNewsHourListFilter;
		}
		
		public function set allNewsHourListFilter(value:Vector.<Vector.<Material>>):void
		{
			_allNewsHourListFilter = value;
		}		
		
		public function get allNewsHourListToday():Vector.<Vector.<Material>>
		{
			return _allNewsHourListToday;
		}
		
		public function set allNewsHourListToday(value:Vector.<Vector.<Material>>):void
		{
			_allNewsHourListToday = value;
		}
		
		public function get broadcastNum():int
		{
			return _broadcastNum;
		}
		
		public function get videoNum():int
		{
			return _videoNum;
		}
		
		public function get photoNum():int
		{
			return _photoNum;
		}
		
		public function get allNum():int
		{
			return allTypeNews.length;
		}
		
		public function get allNewsHourList():Vector.<Vector.<Material>>
		{
			return _allNewsHourList;
		}
		
		public function set allNewsHourList(value:Vector.<Vector.<Material>>):void
		{
			_allNewsHourList = value;
		}		
		
		public function get sortedType():String
		{
			return _sortedType;
		}
		
		public function set sortedType(value:String):void
		{
			_sortedType = value;
		}
		
		public function createNewsHourLists():void
		{
			var currentdate:Date = filters.oneDayFiltersDate(); // new Date();// 2013, 8, 18)//();// (2013, 7, 28);
			allNewsHourList = new Vector.<Vector.<Material>>();
			var allNewsHour:Vector.<Material> = new Vector.<Material>();
			
			var len:int = allTypeNews.length;
			_videoNum = 0;
			_photoNum = 0;
			
			for (var i:int = 0; i < len; i++)
			{
				var oneNew:Material = allTypeNews[i];
				
				if (oneNew.type == "photo")
				{
					_photoNum++;
					if (sortedType == "video" || sortedType == "broadcast")
						continue;
				}
				
				if (oneNew.type == "video")
				{
					_videoNum++;
					if (sortedType == "photo" || sortedType == "broadcast")
						continue;
				}
				
				if (oneNew.type == "broadcast")
				{
					_broadcastNum++;
					if (sortedType == "photo" || sortedType == "video")
						continue;
				}
				
				if (oneNew.type == "text")
				{
					
					if (sortedType == "photo" || sortedType == "video" || sortedType == "broadcast")
						continue;
				}
				
				if (allNewsHour.length >= 1)
				{
					if (!isEqualeHours(allNewsHour[0].publishedDate, oneNew.publishedDate))
					{
						allNewsHourList.push(allNewsHour);
						allNewsHour = new Vector.<Material>();
					}
				}
				allNewsHour.push(oneNew);
				
			}
			if (allNewsHour && allNewsHour.length)
				allNewsHourList.push(allNewsHour);
			
			var hoursTotal:int = allNewsHourList.length;
			
			_allNewsHourListToday = new Vector.<Vector.<Material>>();
			
			mainloop: for (var p:int = 0; p < hoursTotal; p++)
			{
				_allNewsHourListToday[p] = new Vector.<Material>();
				
				for (var l:int = 0; l < allNewsHourList[p].length; l++)
				{
					if (isEqualDayDate(allNewsHourList[p][l].publishedDate, currentdate))
					{
						_allNewsHourListToday[p].push(allNewsHourList[p][l]);
					}
					else
					{
						if (_allNewsHourListToday[p].length == 0)
							_allNewsHourListToday = _allNewsHourListToday.slice(0, p);
						break mainloop;
					}
				}
			}
			
			dispatch(new FilterEvent(FilterEvent.ONE_DAY_NEWS_SORTED));
		}
		
		override public function setModel(value:ChangeModelOut):void
		{
			if (_newsList == null || _newsList.length == 0)
				return;
			
			_isAnimate = false;
			
			switch (value.type)
			{
				case ChangeModelOut.MAIN_SCREEN: 
					_allNewsHourListFilter = getHourListFilteredMainScreen();
					
					break;
				case ChangeModelOut.CUSTOM_SCREEN: 
					_allNewsHourListFilter = getHourListFilteredMainScreen();
					break;
				case ChangeModelOut.STORY_SCREEN: 
					_allNewsHourListFilter = getHourListFilteredMainScreen();
					break;
				
				case ChangeModelOut.MAIN_SCREEN_SCREENSHOT: 
				case ChangeModelOut.STORY_SCREEN_SCREENSHOT: 
				case ChangeModelOut.CUSTOM_SCREEN_SCREENSHOT: 
					_isAnimate = false;
					_allNewsHourListFilter = getHourListFilteredMainScreen();
					break;
				
				case ChangeModelOut.ONE_DAY_NEWS:
					
					break;
				
				default: 
			}
		}
		
		private function getHourListFilteredMainScreen():Vector.<Vector.<Material>>
		{
			var filtr:Vector.<Vector.<Material>> = new Vector.<Vector.<Material>>();
			var len:int = _allNewsHourList.length;
			var counter:int = 0;
			
			for (var i:int = 0; i < len; i++)
			{
				var len1:int = _allNewsHourList[i].length;
				filtr[i] = new Vector.<Material>();
				for (var j:int = 0; j < len1; j++)
				{
					filtr[i].push(_allNewsHourList[i][j]);
					
					counter++;
					
					if (counter == MAX_ALL_NEWS)
					{
						return filtr;
					}
				}
			}
			return filtr;
		}
		
		public function get isAnimate():Boolean
		{
			return _isAnimate;
		}
		
		public function set isAnimate(value:Boolean):void
		{
			_isAnimate = value;
		}
	}
}
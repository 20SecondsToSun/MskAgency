package app.model.daysnews
{
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.model.datafilters.FilterData;
	import app.model.datafilters.IFilterDataModel;
	import app.model.materials.Material;
	import app.model.materials.MaterialModel;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class DaysNewsModel extends MaterialModel implements IDaysNewsModel
	{
		[Inject]
		public var filters:IFilterDataModel;
		
		public static const DAYS_BLOCK_NUM:int = 5;
		
		private var _isAnimate:Boolean = true;
		private var _data:Vector.<Material>;
		private var _allNewsDaysList:Vector.<Material>;
		private var _allNewsDaysBlockList:Vector.<Vector.<Material>>;
		
		private var _offsetLoad:int = 0;
		private var _limitLoad:int = DAYS_BLOCK_NUM;
		private var _loadingDate:String = "";
		
		override public function set newsList(value:Vector.<Material>):void
		{
			_newsList = value;
			
			if (filters.daysNewsFilters.from)
			{
				if (_newsList.length > 0)
				{
					gotoOneDayPage(filters.daysNewsFilters.from);
					return;
				}
			}
			
			filters.daysNewsFilters.to = "";
			filters.daysNewsFilters.from = "";
			
			if (_newsList.length <= 0)
			{
				if (filterModel.daysNewsFilters.isFilter)
				{
					dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.NO_MATERIALS));
					return;
				}
				else
				{
					_offsetLoad--;
					
					if (_limitLoad >= 0)
						dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_DAYS_DATA));
					else if (_limitLoad < 0)
						initValues();
					
					return;
				}
			}
			
			sortBydate();
			createDictionary();
			
			if (filterModel.daysNewsFilters.isFilter)
			{
				createFilterNews();
				filters.daysNewsFilters.offset += filters.daysNewsFilters.limit;
				dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_COMPLETED_DAYS_NEWS_FILTERED));
				return;
			}
			
			createNews();
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_COMPLETED_DAYS_NEWS));
			
			_limitLoad--;
			_offsetLoad--;
			
			if (_limitLoad >= 0)
				dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_DAYS_DATA));
			else if (_limitLoad < 0)
				initValues();
		}
		
		private function gotoOneDayPage(_date:String):void
		{
			var fd:FilterData = new FilterData();
			fd.from = _date;
			fd.to = fd.from;
			fd.rubrics = filterModel.daysNewsFilters.rubrics;
			
			filters.oneDayFilters = fd;
			
			var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.NEWS_PAGE_HOUR);
			event.mode = "STRETCH_IN";
			dispatch(event);
		}
		
		private function initValues():void
		{
			_offsetLoad = 0;
			_limitLoad = DAYS_BLOCK_NUM;
			_loadingDate = "";
		}
		
		private function createNews():void
		{
			_allNewsDaysList = _newsList;
		}
		
		private function createFilterNews():void
		{
			var len:int = _newsList.length;
			_allNewsDaysBlockList = new Vector.<Vector.<Material>>();
			var allNewsDay:Vector.<Material> = new Vector.<Material>();
			
			for (var i:int = 0; i < len; i++)
			{
				var oneNew:Material = _newsList[i];
				
				if (allNewsDay.length >= 1)
				{
					if (!isEqualDayDate(allNewsDay[0].publishedDate, oneNew.publishedDate))
					{
						_allNewsDaysBlockList.push(allNewsDay);
						allNewsDay = new Vector.<Material>();
					}
				}
				allNewsDay.push(oneNew);
			}
			if (allNewsDay && allNewsDay.length)
				_allNewsDaysBlockList.push(allNewsDay);
		}
		
		public function get isAnimate():Boolean
		{
			return _isAnimate;
		}
		
		public function set isAnimate(value:Boolean):void
		{
			_isAnimate = value;
		}
		
		public function get data():Vector.<Material>
		{
			return _data;
		}
		
		public function set data(value:Vector.<Material>):void
		{
			_data = value;
		}
		
		public function get allNewsDaysList():Vector.<Material>
		{
			return _allNewsDaysList;
		}
		
		public function set allNewsDaysList(value:Vector.<Material>):void
		{
			_allNewsDaysList = value;
		}
		
		public function get allNewsDaysBlockList():Vector.<Vector.<Material>>
		{
			return _allNewsDaysBlockList;
		}
		
		public function set allNewsDaysBlockList(value:Vector.<Vector.<Material>>):void
		{
			_allNewsDaysBlockList = value;
		}
		
		public function get offsetLoad():int
		{
			return _offsetLoad;
		}
		
		public function set offsetLoad(value:int):void
		{
			_offsetLoad = value;
		}
		
		public function get limitLoad():int
		{
			return _limitLoad;
		}
		
		public function set limitLoad(value:int):void
		{
			_limitLoad = value;
		}
		
		public function set loadingDate(value:String):void
		{
			_loadingDate = value;
		}
		
		public function get loadingDate():String
		{
			_loadingDate = config.getShiftDate(_offsetLoad);
			return _loadingDate;
		}
	}
}
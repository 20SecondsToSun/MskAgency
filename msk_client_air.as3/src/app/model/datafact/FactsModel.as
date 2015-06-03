package app.model.datafact
{
	import app.AppSettings;
	import app.contoller.events.ChangeModelOut;
	import app.contoller.events.DataLoadServiceEvent;
	import app.model.config.IConfig;
	import app.model.datafilters.IFilterDataModel;
	import app.model.materials.Fact;
	import app.model.materials.Material;
	import app.model.materials.MaterialModel;
	import app.view.utils.TextUtil;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FactsModel extends Actor implements IFactsModel
	{
		[Inject]
		public var conf:IConfig;
		
		[Inject]
		public var filterModel:IFilterDataModel;
		
		protected var _limit:String;
		protected var _count:String;
		protected var _offset:String;
		protected var _newsList:Vector.<Fact> = new Vector.<Fact>();
		protected var _mainNewsList:Vector.<Fact> = new Vector.<Fact>();
		
		protected var needToRefresh:Boolean = true;
		private var _isAnimate:Boolean = true;
		protected var _activeMaterial:Fact;
		protected var _sliderDate:String;
		
		private var _offsetLoad:int = 0;
		private var _limitLoad:int = 3;
		private var _direction:String = "TO_FUTURE";
		
		private var isLoadingMainSceen:Boolean = false;
		protected var _loadingDate:String = "";
		protected var _dateInfo:DateInfo = new DateInfo();
		
		private var _data:Vector.<Fact>;
		private var allFactsDaysList:Vector.<Vector.<Fact>>;
		private var _dayNewsList:Vector.<Fact>;
		
		private var _centerDate:String = "12.11.2013";
		
		private var _nextDate:String = "0";
		private var _prevDate:String = "0";
		
		private var savePrevDate:String = "";
		private var saveFutureDate:String = "";
		private var _notema:Boolean = false;
		
		public function set notema(value:Boolean):void
		{
			_notema = value;
		}
		
		public function get notema():Boolean
		{
			return _notema;
		}
		
		
		public function set nextDate(value:String):void
		{
			_nextDate = value;
		}
		
		public function get nextDate():String
		{
			return _nextDate;
		}
		
		public function set prevDate(value:String):void
		{
			_prevDate = value;
		}
		
		public function get prevDate():String
		{
			return _prevDate;
		}
		
		public function set centerDate(value:String):void
		{
			_centerDate = value;
		}
		
		public function get centerDate():String
		{
			return _centerDate;
		}
		
		public function set isInitLoad(value:Boolean):void
		{
			_isInitLoad = value;
		}
		
		public function get isInitLoad():Boolean
		{
			return _isInitLoad;
		}
		
		private var _isStop:Boolean = false;
		private var _isInitLoad:Boolean = true;
		
		public function allInit():void
		{
			_isInitLoad = true;
			_limitLoad = 3;
			_offsetLoad = 0;
			_nextDate = "0";
			_prevDate = "0";
			_direction = "TO_FUTURE";
		}
		
		public function set newsList(value:Vector.<Fact>):void
		{
			if (value.length == 0 && _offsetLoad == 0)
			{
				dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.NO_MATERIALS));
				return;
			}
			
			_newsList = value;
			_dateInfo.currentDate = conf.currentDate;
			_dateInfo.thisDate = _loadingDate;
			_dateInfo.futurePastCurrent = conf.compareDate(_loadingDate);
			
			if (filterModel.factsNewsFilters.from)
			{
				_dateInfo.currentDate = filterModel.factsNewsFilters.from;
				_dateInfo.thisDate = filterModel.factsNewsFilters.from;
				dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_COMPLETED_FACTS));
				return;
			}
			
			if (isInitLoad)
			{
				if (_direction == "TO_FUTURE")
					toFutureHandler();
				else if (_direction == "TO_PAST")
					toPastHandler();
			}
			else
			{
				if (_direction == "TO_FUTURE")
					toFutureHandlerNotInit();
				else if (_direction == "TO_PAST")
					toPastHandlerNotInit();
			}
			
			function toPastHandlerNotInit():void
			{
				if (_newsList.length == 0)
				{
					if (_prevDate == "0")
					{
						dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.NO_MORE));
						return;
					}
					dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_FACTS_DATA));
					return;
				}
				dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_COMPLETED_FACTS));
				
				_limitLoad--;
				_nextDate = "0";
				_prevDate = "0";
				
				if (_limitLoad < 0)
				{
					
				}
				else
					dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_FACTS_DATA));
			}
			
			function toFutureHandlerNotInit():void
			{
				if (_newsList.length == 0)
				{
					if (_nextDate == "0")
					{
						dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.NO_MORE));
						return;
					}
					dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_FACTS_DATA));
					return;
				}
				dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_COMPLETED_FACTS));
				
				_limitLoad--;
				_nextDate = "0";
				_prevDate = "0";
				
				if (_limitLoad < 0)
				{
					
				}
				else
					dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_FACTS_DATA));
			}
			
			function toPastHandler():void
			{
				if (_newsList.length == 0)
				{
					if (_prevDate == "0")
					{
						dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.NO_MORE));
						return;
					}
					dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_FACTS_DATA));
					return;
				}
				dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_COMPLETED_FACTS));
				
				savePrevDate = _loadingDate;
				_nextDate = "0";
				_prevDate = "0";
				_offsetLoad = 0;
				_limitLoad = 3;
				_direction = "TO_FUTURE";
			}
			
			function toFutureHandler():void
			{
				if (_newsList.length == 0)
				{
					if (_nextDate == "0")
					{
						dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.NO_MORE));
						
						_direction = "TO_PAST";
						saveFutureDate = _loadingDate;
						_offsetLoad = -1;
						_nextDate = "0";
						_prevDate = "0";
						dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_FACTS_DATA));
						return;
					}
					dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_FACTS_DATA));
					return;
				}
				
				_offsetLoad++;
				_limitLoad--;
				_nextDate = "0";
				_prevDate = "0";
				
				dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_COMPLETED_FACTS));
				
				if (_limitLoad > 0)
				{
					dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_FACTS_DATA));
				}
				else
				{
					_direction = "TO_PAST";
					_offsetLoad = -1;
					saveFutureDate = _loadingDate;
					dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_FACTS_DATA));
				}
			}
		}
		
		public function setOffset():void
		{
			if (_direction == "TO_FUTURE")
			{				
				_loadingDate = saveFutureDate;
			}
			else
			{				
				_loadingDate = savePrevDate;
			}
			
			_nextDate = "0";
			_prevDate = "0";			
		}
		
		public function get loadingDate():String
		{			
			if (isInitLoad)
			{
				_loadingDate = conf.getShiftDate(_offsetLoad);
				
				if (_direction == "TO_FUTURE" && _nextDate != "0")
				{
					_loadingDate = _nextDate;
					var days:int = getDaysBetweenDates(TextUtil.convertStringToDate(conf.getShiftDate(_offsetLoad)), TextUtil.convertStringToDate(_nextDate));
					_offsetLoad += days;
				}
				
				if (_direction == "TO_PAST" && _prevDate != "0")
				{
					_loadingDate = _prevDate;
					var days1:int = getDaysBetweenDates(TextUtil.convertStringToDate(conf.getShiftDate(_offsetLoad)), TextUtil.convertStringToDate(_nextDate));
					_offsetLoad -= days1;
				}
			}
			else
			{				
				if (_direction == "TO_PAST")
				{
					if (_prevDate != "0")
					{					
						_loadingDate = _prevDate;
					}
					else
					{					
						_loadingDate = conf.getprevDate(TextUtil.convertStringToDate(_loadingDate));						
					}
					
				}
				else if (_direction == "TO_FUTURE")
				{
					if (_nextDate != "0")
					{						
						_loadingDate = _nextDate;
					}
					else
						_loadingDate = conf.getnextDate(TextUtil.convertStringToDate(_loadingDate));
				}
			}
			
			return _loadingDate;
		}
		
		public function initValues():void
		{
			_offsetLoad = 0;
			_limitLoad = 3;
			_loadingDate = "";
			_direction = "TO_FUTURE";
		}
		
		public function getDaysBetweenDates(date1:Date, date2:Date):int
		{
			var oneDay:Number = 1000 * 60 * 60 * 24;
			var date1Milliseconds:Number = date1.getTime();
			var date2Milliseconds:Number = date2.getTime();
			var differenceMilliseconds:Number = date1Milliseconds - date2Milliseconds;
			return -Math.round(differenceMilliseconds / oneDay);
		}
		
		public function set dayNewsList(value:Vector.<Fact>):void
		{
			_dayNewsList = value;
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_COMPLETED_DAY_FACTS));
		}
		
		public function get dayNewsList():Vector.<Fact>
		{
			return _dayNewsList;
		}
		
		public function set mainNewsList(value:Vector.<Fact>):void
		{
			_mainNewsList = value;
			_dateInfo.currentDate = conf.currentDate;
			_dateInfo.thisDate = conf.currentDate;
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_COMPLETED_MAIN_FACTS));
		}
		
		public function set loadingDate(value:String):void
		{
			_loadingDate = value;
		}
		
		private function setDaysLists():void
		{
		
		}
		
		public function setModel(value:ChangeModelOut):void
		{
		
		}
		
		public function getMaterialByID(id:Number):Fact
		{
			for (var i:int = 0; i < _newsList.length; i++)
			{
				if (_newsList[i].id == id)
				{
					return _newsList[i];
				}
			}
			return null;
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////     GET/SET      ///////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////
		
		public function get activeMaterial():Fact
		{
			return _activeMaterial;
		}
		
		public function set activeMaterial(value:Fact):void
		{
			_activeMaterial = value;
		}
		
		public function set sliderDate(value:String):void
		{
			_sliderDate = value;
		}
		
		public function get sliderDate():String
		{
			return _sliderDate;
		}
		
		public function get count():String
		{
			return _count;
		}
		
		public function set count(value:String):void
		{
			_count = value;
		}
		
		public function get limit():String
		{
			return _limit;
		}
		
		public function set limit(value:String):void
		{
			_limit = value;
		}
		
		public function get offset():String
		{
			return _offset;
		}
		
		public function set offset(value:String):void
		{
			_offset = value;
		}
		
		public function get newsList():Vector.<Fact>
		{
			return _newsList;
		}
		
		public function get mainNewsList():Vector.<Fact>
		{
			return _mainNewsList;
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
		
		public function get direction():String
		{
			return _direction;
		}
		
		public function set direction(value:String):void
		{
			_direction = value;
		}
		
		public function get data():Vector.<Fact>
		{
			return _data;
		}
		
		public function set data(value:Vector.<Fact>):void
		{
			_data = value;
		}
		
		public function get isAnimate():Boolean
		{
			return _isAnimate;
		}
		
		public function set isAnimate(value:Boolean):void
		{
			_isAnimate = value;
		}
		
		public function set dateInfo(value:DateInfo):void
		{
			_dateInfo = value;
		}
		
		public function get dateInfo():DateInfo
		{
			return _dateInfo;
		}
	}
}
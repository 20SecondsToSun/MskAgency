package ipad.model.ipad
{
	import app.AppSettings;
	import app.contoller.events.ChangeModelOut;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.IpadEvent;
	import app.model.config.IConfig;
	import app.model.datafact.DateInfo;
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
	public class IpadFactsModel extends Actor implements IIpadFactsModel
	{
		[Inject]
		public var conf:IConfig;
		
		protected var _limit:String;
		protected var _count:String;
		protected var _offset:String;
		protected var _newsList:Vector.<Fact> = new Vector.<Fact>();
		protected var _mainNewsList:Vector.<Fact> = new Vector.<Fact>();
		
		protected var needToRefresh:Boolean = true;
		private var _isAnimate:Boolean = true;
		protected var _activeMaterial:Fact;		
		protected var _sliderDate:String;
		
		private var _offsetLoad:int = -1;
		private var _limitLoad:int = 3;
		private var _direction:String = "TO_FUTURE";
		
		private var isLoadingMainSceen:Boolean = false;
		protected var _loadingDate:String = "";
		protected var _dateInfo:DateInfo = new DateInfo();
		
		private var _data:Vector.<Fact>;
		private var allFactsDaysList:Vector.<Vector.<Fact>>;
		private var _dayNewsList:Vector.<Fact>;
		
		protected var _currentDate:String  = "";
		protected var _nextDate:String  = "";
		protected var _startDate:String  = "";
		protected var _finishDate:String  = "";
		protected var _newSearch:Boolean  = true;
		
		
		
		protected var _idsArray:Vector.<int> = new Vector.<int>();
		
		public function  isIdExist(value:String):Boolean
		{
			for (var i:int = 0; i < _idsArray.length; i++) 			
				if (_idsArray[i] == int(value)) return true;
				
				
			_idsArray.push(int(value));
			return false;			
		}
		
		public function getDaysBetweenDates(date1:Date, date2:Date):int
		{
			var oneDay:Number = 1000 * 60 * 60 * 24;
			var date1Milliseconds:Number = date1.getTime();
			var date2Milliseconds:Number = date2.getTime();
			var differenceMilliseconds:Number = date1Milliseconds - date2Milliseconds;
			return -Math.round(differenceMilliseconds / oneDay);
		}
		
		
		public function get idsArray():Vector.<int>
		{
			return _idsArray;
		}
		
		public function set idsArray(value:Vector.<int>):void
		{
			_idsArray = value;
		}	
		
		
		public function get finishDate():String
		{
			return _finishDate;
		}
		
		public function set finishDate(value:String):void
		{
			_finishDate = value;
		}	
		
		
		
		public function get startDate():String
		{
			return _startDate;
		}
		
		public function set startDate(value:String):void
		{
			_startDate = value;
		}			
	
		
		public function get newSearch():Boolean
		{
			return _newSearch;
		}
		
		public function set newSearch(value:Boolean):void
		{
			_newSearch = value;
		}	
		
		
		
		
		
		
		
		
		
		
		
		
		public function get currentDate():String
		{
			return _currentDate;
		}
		
		public function set currentDate(value:String):void
		{
			_currentDate = value;
		}	
		
		public function get nextDate():String
		{
			return _nextDate;
		}
		
		public function set nextDate(value:String):void
		{
			_nextDate = value;
		}	
		
		
		public function set newsList(value:Vector.<Fact>):void
		{
			_newsList = value;			
			//_dateInfo.currentDate = conf.currentDate;
			//_dateInfo.thisDate = _loadingDate;
			//_dateInfo.futurePastCurrent = conf.compareDate(_loadingDate);
			
			
			dispatch(new IpadEvent(IpadEvent.MATERIALS_LOADED));
			
			//dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_COMPLETED_FACTS));
			
		/*	if (_direction == "TO_FUTURE")
				_offsetLoad++;
			else if (_direction == "TO_PAST")
				_offsetLoad--;
			
			_limitLoad--;
			
			if (_newsList.length <= 0)
			{
				dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.NO_MORE));			
				initValues();
				return;
			}
			
			if (_limitLoad >= 0)
				dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_FACTS_DATA));
			else if (_limitLoad < 0)
				initValues();*/
		}
		
		public function initValues():void
		{
			_offsetLoad = -1;
			_limitLoad = 3;
			_loadingDate = "";
			_direction = "TO_FUTURE";
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
		
		public function get loadingDate():String
		{
			_loadingDate = conf.getShiftDate(_offsetLoad);
			return _loadingDate;
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
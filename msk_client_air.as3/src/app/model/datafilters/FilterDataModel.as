package app.model.datafilters
{
	import app.contoller.events.DataLoadServiceEvent;
	import app.model.config.IConfig;
	import app.view.utils.TextUtil;
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * ...
	 * @author castor troy
	 */
	public class FilterDataModel extends Actor implements IFilterDataModel
	{
		protected var _oneDayFilters:FilterData = new FilterData();
		protected var _geoNewsFilters:FilterData = new FilterData();
		
		protected var _daysNewsFilters:FilterData = new FilterData();
		protected var _dayNewsFilters:FilterData = new FilterData();
		protected var _factsNewsFilters:FilterData = new FilterData();
		
		protected var _status:Vector.<String> = new Vector.<String>();
		protected var _type:Vector.<String> = new Vector.<String>();
		protected var _rubrics:Vector.<Rubric> = new Vector.<Rubric>();
		
		[Inject]
		public var config:IConfig;	
		
		public function resetOffsetLimit():void
		{
			_daysNewsFilters.resetOffsetLimit();	
			_factsNewsFilters.resetOffsetLimit();
			_geoNewsFilters.resetOffsetLimit();
			_oneDayFilters.resetOffsetLimit();
		}
		
		public function resetDates():void
		{
			_daysNewsFilters.resetDates();	
			_factsNewsFilters.resetDates();
			_geoNewsFilters.resetDates();
			_oneDayFilters.resetDates();
		}
		
		public function setNullToAll():void
		{
			_daysNewsFilters.setNull();	
			_factsNewsFilters.setNull();
			_geoNewsFilters.setNull();
			_oneDayFilters.setNull();
		}		
		
		public function get factsNewsFilters():FilterData
		{
			return _factsNewsFilters;
		}
		
		public function set factsNewsFilters(value:FilterData):void
		{
			_factsNewsFilters = value;
		}		
		
		public function get geoNewsFilters():FilterData
		{
			return _geoNewsFilters;
		}
		
		public function set geoNewsFilters(value:FilterData):void
		{
			_geoNewsFilters = value;
		}
		
		public function get daysNewsFilters():FilterData
		{
			return _daysNewsFilters;
		}
		
		public function set daysNewsFilters(value:FilterData):void
		{
			_daysNewsFilters = value;
		}
		
		public function setFilter(loc:String, value:FilterData):String
		{
			var loadEvent:String = "";
			
			switch (loc)
			{
				case "MAP_PAGE": 
					loadEvent = DataLoadServiceEvent.LOAD_GEO_DATA;
					_geoNewsFilters = value;
					_geoNewsFilters.resetOffsetLimit();
					_geoNewsFilters.isFilter = true;
					break;
				
				case "NEWS_PAGE_DAY": 
					loadEvent = DataLoadServiceEvent.LOAD_DAYS_DATA;
					_daysNewsFilters = value;				
					_daysNewsFilters.resetOffsetLimit();
					_daysNewsFilters.isFilter = true;
					_oneDayFilters.rubrics = value.rubrics;					
					break;
				
				case "NEWS_PAGE_HOUR": 
					loadEvent = DataLoadServiceEvent.LOAD_DAY_DATA;
					_oneDayFilters = value;
					_oneDayFilters.resetOffsetLimit();
					_oneDayFilters.isFilter = true;					
					_daysNewsFilters.rubrics = value.rubrics;
					break;
				
				case "ONE_NEW_PAGE": 					
					loadEvent = DataLoadServiceEvent.LOAD_ALL_MATERIAL_NEAR_NEWS;					
					_oneDayFilters = value;
					_oneDayFilters.resetOffsetLimit();
					_oneDayFilters.isFilter = true;
					_daysNewsFilters.rubrics = value.rubrics;
					break;
					
				case "FACT_PAGE": 					
				case "ONE_NEW_FACT_PAGE": 					
					loadEvent = DataLoadServiceEvent.LOAD_ALL_FACTS_DATA;
					_factsNewsFilters = value;				
					_factsNewsFilters.resetOffsetLimit();
					_factsNewsFilters.isFilter = true;			
					_factsNewsFilters.rubrics = value.rubrics;						
					break;
					
				default: 
			}
			return loadEvent;
		}
		
		public function getFilter(loc:String):FilterData
		{
			var fd:FilterData;
			
			switch (loc)
			{
				case "MAP_PAGE": 
					fd = _geoNewsFilters;
					break;
				
				case "NEWS_PAGE_DAY": 
					fd = _daysNewsFilters;
					break;
				
				case "NEWS_PAGE_HOUR":					
					fd = _oneDayFilters;
					break;
				
				case "ONE_NEW_PAGE": 
					fd = _oneDayFilters;
					break;
					
				case "FACT_PAGE": 
				case "ONE_NEW_FACT_PAGE": 
					fd = _factsNewsFilters;
					break;
				default: 
			}
			return fd;
		}
		
		public function get oneDayFilters():FilterData
		{
			return _oneDayFilters;
		}
		
		public function set oneDayFilters(value:FilterData):void
		{
			_oneDayFilters = value;
		}
		
		public function oneDayFiltersDate():Date
		{
			if (_oneDayFilters && _oneDayFilters.from)
				return TextUtil.convertStringToDate(_oneDayFilters.from);
			
			return TextUtil.convertStringToDate(config.currentDate);//new Date();
		}
		
		public function getEventToLoadFilterData(loc:String):String
		{
			return null;
		}
		
		public function get status():Vector.<String>
		{
			return _status;
		}
		
		public function set status(value:Vector.<String>):void
		{
			_status = value;
		}
		
		public function get type():Vector.<String>
		{
			return _type;
		}
		
		public function set type(value:Vector.<String>):void
		{
			_type = value;
		}
		
		public function get rubrics():Vector.<Rubric>
		{
			return _rubrics;
		}
		
		public function set rubrics(value:Vector.<Rubric>):void
		{
			_rubrics = value;
		}
	}
}
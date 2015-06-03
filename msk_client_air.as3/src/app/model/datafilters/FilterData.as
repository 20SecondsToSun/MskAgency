package app.model.datafilters 
{
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FilterData 
	{		
		public var _from:String;
		public var _to:String;
		public var _rubrics:int = NaN;
		public var _offset:int = 0;
		public var _limit:int = 100;
		
		public var _isFilter:Boolean = false;		
	
		public function resetOffsetLimit ():void
		{
			_offset = 0;
			_limit = 100;
		}
		public function FilterData ()
		{
			
		}
		
		public  function  resetDates():void
		{
			_from = "";
			_to = "";	
			
		}
		
		public function setNull():void
		{
			_from = "";
			_to = "";
			_rubrics = NaN;			
			_limit = 100;
			_offset = 0;
			_isFilter = false;			
		}
		
		public function set from(value:String):void
		{			
			_from = value;				
		}
		
		public function set to(value:String):void
		{
			_to = value;	
		}
		
		public function set rubrics(value:int):void
		{
			_rubrics = value;
			_isFilter = true;
		}
		
		public function set offset(value:int):void
		{
			_offset = value;
			_isFilter = true;
		}
		
		public function set limit(value:int):void
		{
			_limit = value;	
			_isFilter = true;
		}
		
		public function set isFilter(value:Boolean):void
		{
			_isFilter = value;		
		}		
		
		public function get from():String
		{
			return _from; 
		}
		
		public function get to():String
		{
			return _to;	
		}
		
		public function get rubrics():int
		{
			return _rubrics;	
		}
		
		public function get offset():int
		{
			return _offset;
		
		}
		public function get limit():int
		{
			return _limit;
		}
		
		public function get isFilter():Boolean
		{
			return _isFilter;
		}		
	}
}
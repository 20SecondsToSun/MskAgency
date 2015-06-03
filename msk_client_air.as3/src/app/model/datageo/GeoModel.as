package app.model.datageo
{
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.FilterEvent;
	import app.model.materials.Material;
	import app.model.materials.MaterialModel;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class GeoModel extends MaterialModel implements IGeoModel
	{	
		protected var _activeMaterial:Material;	
		protected var _newsListSorted:Vector.<Material> ;
		protected var _newsListFiltered:Vector.<Material> ;
		
		private var sortedGroupID:int = -1;
		private var sortedTypeID:int = -1;
		private var important:int = 0;
		
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
			sortedGroupID = -1;
			sortedTypeID = -1;
			important = 0;			
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_COMPLETED_GEO_NEWS));
		}
		
		public function get newsListSorted():Vector.<Material>
		{
			return _newsListSorted;
		}
		
        public function set newsListFiltered(value:Vector.<Material>):void
		{
			if (value.length == 0)
			{
				dispatch(new FilterEvent(FilterEvent.SET_NULL));	
				dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.NO_MATERIALS));				
			}
			else
			{
				var hasNews:Boolean = sort(sortedGroupID, sortedTypeID, important, value);				
				if (hasNews) _newsList = value;							
			}
		}
		
        public function set newsListSorted(value:Vector.<Material>):void
		{
			_newsListSorted = value;
			nullFilters();		
		}
		
		private function nullFilters():void 
		{
			sortedGroupID = -1;
			sortedTypeID = -1;
			important = 0;
		}
		
		public function sort(group_id:int, type_id:int = -1, important:int = 0, checkList:Vector.<Material> = null):Boolean			
		{			
			if (checkList == null)			
				checkList = _newsList;						
			
			_newsListSorted = new Vector.<Material>();
			
			var filtersIds:Object;
			
			if (group_id == -1 && !important)
			{
				_newsListSorted = checkList;
				nullFilters();
				filtersIds =  { group_id:sortedGroupID, type_id:sortedTypeID, important:this.important };
				dispatch(new FilterEvent(FilterEvent.GEO_NEWS_SORTED, false, false, filtersIds));				
				return true;
			}
			
			sortedGroupID = group_id;
			sortedTypeID = type_id;
			this.important = important;		
			
			var len:int = checkList.length;
			
			for (var i:int = 0; i < len ; i++) 
			{
				var good:Boolean = false;
				
				if (checkList[i].point.group_id == group_id)
				{
					if (type_id != -1)
					{
						if (checkList[i].point.type_id == type_id)
							good = true;
					}
					else good = true;
				}
				
				if (group_id == -1) good = true;
				
				if (good)
				{
					if (important)
					{						
						if (checkList[i].important == "1")				
							_newsListSorted.push(checkList[i]);
					}
					else		
						_newsListSorted.push(checkList[i]);
				}				
			}
			
			if (_newsListSorted.length == 0)
			{				
				dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.NO_MATERIALS));
				return false;
			}
			else
			{				
				_newsList = checkList;				
				filtersIds =  { group_id:sortedGroupID, type_id:sortedTypeID, important:this.important };
				dispatch(new FilterEvent(FilterEvent.GEO_NEWS_SORTED, false, false, filtersIds));
			}
			
			return true;			
		}	
	}
}
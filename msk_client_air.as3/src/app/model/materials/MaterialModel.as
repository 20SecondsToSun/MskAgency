package app.model.materials
{
	import app.contoller.events.ChangeModelOut;
	import app.model.config.IConfig;
	import app.model.datafilters.IFilterDataModel;
	import app.view.utils.TextUtil;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class MaterialModel extends Actor
	{
		[Inject]
		public var config:IConfig;
		
		[Inject]
		public var filterModel:IFilterDataModel;
		
		public var rec:Rectangle;
		
		protected var _limit:String;
		protected var _count:String;
		protected var _offset:String;
		
		protected var _newsList:Vector.<Material> = new Vector.<Material>();
		protected var _newsListIdDictionary:Dictionary;
		
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
		
		public function get newsList():Vector.<Material>
		{
			return _newsList;
		}
		
		public function set newsList(value:Vector.<Material>):void
		{
			_newsList = value;
			createDictionary();
		}
		
		public function createDictionary():void
		{
			_newsListIdDictionary = new Dictionary();
			
			for (var i:int = 0; i < _newsList.length; i++)
				_newsListIdDictionary[_newsList[i].id] = _newsList[i];
		}
		
		public function getMaterialByID(id:Number):Material
		{
			if (_newsListIdDictionary == null) return null;
			if (_newsListIdDictionary[id]) return _newsListIdDictionary[id]
			return null;
		}
		
		public function removeMaterialByID(id:Number):void
		{
			if (_newsListIdDictionary == null) return;
			if (_newsListIdDictionary[id])
			{
				delete _newsListIdDictionary[id]
					//return 	_newsListIdDictionary[id]
			}
			for (var i:int = 0; i < _newsList.length; i++)
			{
				if (_newsList[i].id == id) _newsList.splice(i, 1);
			}
		}
		
		public function setModel(value:ChangeModelOut):void
		{
		
		}
		
		public function allSortByDate(date:Date = null):Vector.<Material>
		{
			if (date == null) date = TextUtil.convertStringToDate(config.currentDate);//new Date();
			
			var _allSorted:Vector.<Material> = new Vector.<Material>();
			
			for (var k:int = 0; k < _newsList.length; k++)
			{
				if (isEqualDayDate(_newsList[k].publishedDate, date))
					_allSorted.push(_newsList[k]);
			}
			return _allSorted;
		}
		
		protected function sortBydate():void
		{
			var compareFunc:Function = function(obj1:Object, obj2:Object):Number
			{
				if (obj1.published_at > obj2.published_at)
					return -1;
				else if (obj1.published_at == obj2.published_at)
					return 0;
				else
					return 1;
			}
			_newsList.sort(compareFunc);
		}
		
		protected function isEqualDayDate(date1:Date, date2:Date):Boolean
		{
			if (date1.fullYear == date2.fullYear && date1.month == date2.month && date1.day == date2.day)
			{
				return true;
			}
			return false;
		}
		
		protected function isEqualeHours(d1:Date, d2:Date):Boolean
		{
			if (d1.getFullYear() == d2.getFullYear())
				if (d1.getMonth() == d2.getMonth())
					if (d1.getDate() == d2.getDate())
						if (d1.getHours() == d2.getHours())
							return true;
			return false;
		}
		
		public function setChoosenField(value:Object):void
		{
			rec = value.rec;
		}
		
		public function getChoosenField():Object
		{
			return {rec: this.rec};
		}
	}
}
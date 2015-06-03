package ipad.model.datafav
{
	import app.contoller.commadns.favorites.CheckForFavoritesCommand;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.FavoriteEvent;
	import app.contoller.events.FilterEvent;
	import app.model.datafilters.IFilterDataModel;
	import app.model.materials.Fact;
	import app.model.materials.Material;
	import app.model.materials.MaterialModel;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FavoritesModel extends MaterialModel implements IFavoritesModel
	{
		[Inject]
		public var filters:IFilterDataModel;
		
		private var _textList:Vector.<Material>;
		private var _photoVideoList:Vector.<Material>;
		private var _factsList:Vector.<Fact>;
		private var _photoCount:int;
		private var _videoCount:int;
		
		public function get textList():Vector.<Material>
		{
			return _textList;
		}		
		public function set textList(value:Vector.<Material>):void
		{
			_textList = value;
		}
		
		public function get photoVideoList():Vector.<Material>
		{
			return _photoVideoList;
		}		
		public function set photoVideoList(value:Vector.<Material>):void
		{
			_photoVideoList = value;
		}
		
		public function get factsList():Vector.<Fact>
		{
			return _factsList;
		}
		
		public function set factsList(value:Vector.<Fact>):void
		{
			_factsList = value;
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.FAVORITES_FACTS_LOADED));
		}
		
		override public function set newsList(value:Vector.<Material>):void
		{
			_newsList = value;			
			if (_newsList.length == 0) return;
			
			createLists();
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.FAVORITES_MATERIALS_LOADED));
		}	
		
		public function get photoCount():int
		{
			return _photoCount;
		}		
		public function set photoCount(value:int):void
		{
			_photoCount = value;
		}		
		
		public function get videoCount():int
		{
			return _videoCount;
		}		
		public function set videoCount(value:int):void
		{
			_videoCount = value;
		}	
		
		
		private function createLists():void 
		{
			_textList = new Vector.<Material>();
			_photoVideoList = new Vector.<Material>();
			_photoCount = _videoCount = 0;
			for (var i:int = 0; i <_newsList.length ; i++) 
			{
				if (_newsList[i].type == "text")_textList.push(_newsList[i]);
				else if (_newsList[i].type == "photo") 
				{
					_photoCount++;
					_photoVideoList.push(_newsList[i]);
				}
				else if (_newsList[i].type == "video")
				{
					_videoCount++;
					_photoVideoList.push(_newsList[i]);
				}
			}
		}
		public function insertMaterial(mat:Material):void		
		{
			_newsList.push(mat);
			if (mat.type == "text")_textList.push(mat);
				else if (mat.type == "photo") 
				{
					_photoCount++;
					_photoVideoList.push(mat);
				}
				else if (mat.type == "video")
				{
					_videoCount++;
					_photoVideoList.push(mat);
				}
			dispatch(new FavoriteEvent(FavoriteEvent.UPDATE_FAVORITES_LIST));
		}
		
		public function insertFact(mat:Fact):void		
		{
			_factsList.push(mat);
			dispatch(new FavoriteEvent(FavoriteEvent.UPDATE_FAVORITES_LIST));
		}		
		
		public function isFavorite(id:int, type:String):void
		{
			var data:Object = new Object();
			
			switch (type) 
			{
				case "material":				
					data.isFavorite = isFavoritesMaterial(id);
					dispatch(new FavoriteEvent(FavoriteEvent.IS_FAVORITES_ANSWER, true, false, data));					
				break;
				
				case "activity":
					data.isFavorite = isFavoritesFact(id);
					dispatch(new FavoriteEvent(FavoriteEvent.IS_FAVORITES_ANSWER, true, false, data));			
				break;
				
				default:
			}
		}
		public function isFavoritesMaterial(id:int):Boolean
		{
			for (var i:int = 0; i <_newsList.length ; i++) 			
				if (id == _newsList[i].id) return true;
			
			return false;
		}
		
		public function isFavoritesFact(id:int):Boolean
		{
			for (var i:int = 0; i <_factsList.length ; i++) 			
				if (id == _factsList[i].id) return true;
			
			return false;
		}			
		
		
		
		
	}
}
package app.model.materials
{
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class Filters
	{
		public var criteria:String = "";
		public var status:String = "";
		public var from:String = "";
		public var to:String = "";
		public var tag:String = "";
		public var rubric:String = "";
		public var has_point:String = "";
		public var type:String = "";
		
		public var offset:int = 0;
		public var limit :int = 10;
		
		public var names:Array = ["criteria", "status", "from", "to", "tag", "rubric", "has_point", "type"];
		
		public function addFilter(name:String, value:String):void		
		{
			this[name] = value;	
		}
		
		public function removeFilter(name:String):void		
		{
			this[name] = "";	
		}		
		
		public function removeAllFilters():void		
		{
			for (var i:int = 0; i < names.length; i++) 
				this[names[i]] = "";
		}
	
	}
}
package app.model.materials 
{
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class Fact 
	{		
		public var author_id:String;
		public var live_broadcast:String;
		public var start_date:Date;
		public var end_date:Date;		
		public var start_date_timestamp:String;
		public var end_date_timestamp:String;		
		public var title:String;
		public var text:String;
		public var id:Number;
		public var is_public:String;
		public var place:String;  	
		public var is_main:String; 
		public var rubrics:Vector.<MaterialRubric> = new Vector.<MaterialRubric>();
		
		public function pushRubric(_rubric:Object):void
		{
			if (_rubric != null)
			{
				var rubric:MaterialRubric = new MaterialRubric();
				rubric.id = _rubric.id;
				rubric.title = _rubric.title;				
				rubrics.push(rubric);
			}		
		}
	}
}
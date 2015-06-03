package app.contoller.events 
{
	import app.model.materials.Fact;
	import flash.events.Event;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FactsLoadedDataEvent  extends Event
	{
		public static const READY:String = "FactsLoadedDataEvent.READY";		
		protected var _factList:Vector.<Fact> ;
		
		public function get factList():Vector.<Fact> 
		{
			return _factList;
		}		

        public function FactsLoadedDataEvent(type:String, factList: Vector.<Fact> = null )
        {
			_factList = factList;			
            super(type);
        }

        override public function clone():Event
        {
            return new FactsLoadedDataEvent(type, _factList);
        }

	}

}
/**
 * @author metalcorehero
 */
package app.contoller.events
{
	
	import app.model.materials.Fact;
	import app.model.materials.Material;
	import flash.events.Event;
	
	public class FavoriteEvent extends Event
	{
		public static const CHECK_FOR_FAVORITES:String = "FavoriteEvent.CHECK_FOR_FAVORITES";
		public static const IS_FAVORITES_ANSWER:String = "FavoriteEvent.IS_FAVORITES_ANSWER";
		public static const UPDATE_FAVORITES_LIST:String = "FavoriteEvent.UPDATE_FAVORITES_LIST";

		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _data:Object;		

		
		//--------------------------------------------------------------------------
		//
		//  Initialization
		//
		//--------------------------------------------------------------------------
		
		public function FavoriteEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false, data:Object = null)
		{
			super(type, bubbles, cancelable);
			_data = data;
		
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters and setters
		//
		//--------------------------------------------------------------------------
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}		
	
		
		//--------------------------------------------------------------------------
		//
		// Overridden API
		//
		//--------------------------------------------------------------------------
		override public function clone():Event
		{
			return new FavoriteEvent(type, bubbles, cancelable, _data)			
		}
	
	}
}

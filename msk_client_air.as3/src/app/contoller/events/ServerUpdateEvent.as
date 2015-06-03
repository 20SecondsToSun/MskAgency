/**
 * @author metalcorehero
 */
package app.contoller.events
{
	
	import app.model.materials.Fact;
	import app.model.materials.Material;
	import flash.events.Event;
	
	public class ServerUpdateEvent extends Event
	{
		public static const VIDEO_NEWS:String = "ServerUpdateEvent.VIDEO_NEWS";
		public static const PHOTO_NEWS:String = "ServerUpdateEvent.PHOTO_NEWS";
		public static const MAIN_NEWS:String = "ServerUpdateEvent.MAIN_NEWS";
		public static const MAP_NEWS:String = "ServerUpdateEvent.MAP_NEWS";
		public static const FACT_NEWS:String = "ServerUpdateEvent.FACT_NEWS";
		public static const TEXT_NEWS:String = "ServerUpdateEvent.TEXT_NEWS";
		public static const GEO_NEWS:String = "ServerUpdateEvent.GEO_NEWS";
		public static const ALL_NEWS:String = "ServerUpdateEvent.ALL_NEWS";
		
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _data:Object;		
		protected var _mat:Material;
		protected var _fact:Fact;
		
		//--------------------------------------------------------------------------
		//
		//  Initialization
		//
		//--------------------------------------------------------------------------
		
		public function ServerUpdateEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false, data:Object = null, mat:Material = null, fact:Fact = null)
		{
			super(type, bubbles, cancelable);
			_data = data;
			_fact = fact;
			_mat = mat;
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
		
		public function get mat():Material
		{
			return _mat;
		}
		
		public function set mat(value:Material):void
		{
			_mat = value;
		}
		
		public function get fact():Fact
		{
			return _fact;
		}
		
		public function set fact(value:Fact):void
		{
			_fact = value;
		}
		
		
		//--------------------------------------------------------------------------
		//
		// Overridden API
		//
		//--------------------------------------------------------------------------
		override public function clone():Event
		{
			return new ServerUpdateEvent(type, bubbles, cancelable, _data, _mat, _fact)			
		}
	
	}
}

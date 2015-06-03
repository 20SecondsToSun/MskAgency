/**
 * @author metalcorehero
 */
package app.services.interactive.gestureDetector
{

import flash.display.DisplayObject;
import flash.events.Event;

public class GestureEvent extends Event
{
    public static const PUSH:String         	     		= "PUSH";
    public static const CHARGE:String         	     		= "CHARGE";
    public static const STRETCH_OUT:String         			 = "STRETCH_OUT";
    public static const STRETCH_OUT_HAND_UP:String         	 = "STRETCH_OUT_HAND_UP";
	
    public static const FINGER_DONE:String         	 = "FINGER_DONE";
    public static const FINGER_FAILED:String         	 = "FINGER_FAILED";
	
    public static const HAND_ONE_FINGER:String         	 = "HAND_ONE_FINGER";
    public static const HAND_TWO_FINGERS:String         	 = "HAND_TWO_FINGERS";
    public static const HAND_THREE_FINGERS:String         	 = "HAND_THREE_FINGERS";
	//--------------------------------------------------------------------------
	//
	//  Instance Properties
	//
	//--------------------------------------------------------------------------
	private var _percent:Number = 0;
	private var _data:Object;

	//--------------------------------------------------------------------------
	//
	//  Initialization
	//
	//--------------------------------------------------------------------------
	
	public function GestureEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false,
					percent:Number = 0, data:Object = null)
	{
		super(type, bubbles, cancelable);
		
		this._percent = percent;
		this._data = data;
	
		
	}	
	//--------------------------------------------------------------------------
	//
	//  Getters and setters
	//
	//--------------------------------------------------------------------------
		public function get percent():Number
		{
			return _percent;
		}
		
		public function set percent(n:Number):void
		{
			_percent = n;
		}
		
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
		return new GestureEvent(type, bubbles, cancelable,
					_percent, _data)
	}

}
}

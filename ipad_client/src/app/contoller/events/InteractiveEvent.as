/**
 * @author metalcorehero
 */
package app.contoller.events
{

import flash.display.DisplayObject;
import flash.events.Event;


public class InteractiveEvent extends Event
{
    public static const HAND_DOWN:String         	 = "HAND_DOWN";
    public static const HAND_UP:String           	 = "HAND_UP";
    public static const HAND_PUSH:String         	 = "HAND_PUSH";
    public static const HAND_ONE_FINGER:String   	 = "HAND_ONE_FINGER";
    public static const HAND_TWO_FINGERS:String  	 = "HAND_TWO_FINGERS";
    public static const HAND_THREE_FINGERS:String 	 = "HAND_THREE_FINGERS";
    public static const HAND_UP_TO_TOP:String     	 = "HAND_UP_TO_TOP";
    public static const HAND_GRIP_ZOOM_IN:String     = "HAND_GRIP_ZOOM_IN";
    public static const HAND_GRIP_ZOOM_OUT:String    = "HAND_GRIP_ZOOM_OUT";
    public static const HAND_OVER:String    		 = "HAND_OVER";
    public static const HAND_OUT:String    			 = "HAND_OUT";
    public static const HAND_UPDATE:String    		 = "HAND_UPDATE";
    public static const USER_ACTIVE:String    		 = "USER_ACTIVE";
    public static const USER_LOST:String    		 = "USER_LOST";
    public static const ACTIVATE_HAND:String    	 = "ACTIVATE_HAND";
    public static const DEACTIVATE_HAND:String    	 = "DEACTIVATE_HAND";
    public static const FIGURE_GESTURE:String    	 = "FIGURE_GESTURE";
    public static const HAND_CHARGED:String    	 		= "HAND_CHARGED";
    public static const STRETCH:String    	 		= "STRETCH";
    public static const STRETCH_OFF:String    	 		= "STRETCH_OFF";
    public static const CLICK:String    	 		= "CLICK";
	
	
   

	//--------------------------------------------------------------------------
	//
	//  Instance Properties
	//
	//--------------------------------------------------------------------------
	private var _localX:Number = NaN;
	private var _localY:Number = NaN;
	private var _localZ:Number = NaN;
	private var _stageX:Number = NaN;
	private var _stageY:Number = NaN;
	private var _stageZ:Number = NaN;
	private var _relatedObject:DisplayObject;
	
	private var _handType:String;
	private var _gesture:int = 0;
	
	public function get localX():Number
	{
		return _localX;
	}
	public function get localY():Number
	{
		return _localY;
	}
	
	public function set stageX(n:Number):void
	{
		 _stageX = n;
	}
	public function set stageY(n:Number):void
	{
		 _stageY = n;
	}
	
	public function get stageX():Number
	{
		return _stageX;
	}
	public function get stageY():Number
	{
		return _stageY;
	}
	
	public function set stageZ(n:Number):void
	{
		 _stageZ = n;
	}
	public function get stageZ():Number
	{
		return _stageZ;
	}
	
	public function set handType(ht:String):void
	{
		_handType = ht;
	}
	public function get handType():String
	{
		return _handType;
	}
	
	public function set gesture(g:int):void
	{
		_gesture = g;
	}
	public function get gesture():int
	{
		return _gesture;
	}
	public var percent:Number;
	//--------------------------------------------------------------------------
	//
	//  Initialization
	//
	//--------------------------------------------------------------------------
	
	public function InteractiveEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false,
					stageX:Number = NaN,
					stageY:Number = NaN,
					stageZ:Number = NaN,
					localX:Number = NaN,
					localY:Number = NaN,
					localZ:Number = NaN,					
					handType:String = "LeftHand",					
					relatedObject:DisplayObject = null,
					gesture:int = 0)
	{
		super(type, bubbles, cancelable);
		
		this._relatedObject = relatedObject;
		
		this._stageX = stageX;
		this._stageY = stageY;
		this._stageZ = stageZ;
			
		this._localX = localX;
		this._localY = localY;
		this._localZ = localZ;
		
		this._handType = handType;
		this._gesture = gesture;
		
	}
	
	
	
	
	
	
	
	//--------------------------------------------------------------------------
	//
	//  Getters and setters
	//
	//--------------------------------------------------------------------------
	/*public function get body():*
	{
		return _body;
	}*/
	
	//--------------------------------------------------------------------------
	//
	// Overridden API
	//
	//--------------------------------------------------------------------------
	override public function clone():Event
	{
		return new InteractiveEvent(type, bubbles, cancelable,
					_stageX,
					_stageY,
					_stageZ,
					_localX,
					_localY,
					_localZ,	
					_handType,
					_relatedObject,
					_gesture)
	}

}
}

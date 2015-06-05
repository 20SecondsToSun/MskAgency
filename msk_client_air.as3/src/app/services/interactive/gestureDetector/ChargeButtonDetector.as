package app.services.interactive.gestureDetector 
{
	import app.AppSettings;
	import app.contoller.events.InteractiveEvent;
	import app.view.baseview.io.InteractiveChargeButton;
	import com.greensock.TweenLite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import app.services.interactive.gestureDetector.DisplayListHelper;
	import app.view.baseview.io.InteractiveButton;
	import app.view.baseview.io.InteractiveObject;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class ChargeButtonDetector extends EventDispatcher
	{	
		private static const HAND_SPEED_LIMIT:int = 5;
		private static const percentInc:int = 2;
		
		private var frameCounter:int = 0;
		public  var percent:Number = 0;		
		private var startZ:Number = Number.MIN_VALUE;
		private var lastZ:Number  = -100;			
		
		public var blockUpdate:Boolean = false;	
		private var maincolor:Object = new Object();
		private var _isAllowed:Boolean = true;
		private var _chargeButton:InteractiveChargeButton;
		
		public function get isAllowed():Boolean
		{
			 return _isAllowed;
		}
		
		public function set isAllowed(allow:Boolean):void
		{
			_isAllowed = allow;			
			if (!allow)			
				stopInteract();					
		}	
				
		public function set chargeButton(pb:InteractiveChargeButton):void
		{
			if (pb != _chargeButton)
			{
				_chargeButton = pb;
				resetValues();							
			}		
		}
		
		public function get chargeButton():InteractiveChargeButton
		{
			return _chargeButton;			
		}
		
		private function stopInteract():void
		{						   
			_chargeButton = null;
			resetValues();			
			dispatchEvent(new GestureEvent(GestureEvent.CHARGE, false, false, percent, maincolor));
		}
		
		private function resetValues():void
		{			
			percent = 0;
			removeEventListener(Event.ENTER_FRAME, checkCharge);			
			dispatchEvent(new GestureEvent(GestureEvent.CHARGE, false, false, 0, maincolor));
		}	
		
		public function update(x:Number, y:Number, z:Number, stage:Stage):void		
		{			
			if ( !_isAllowed ) 
			{
				resetData();
				return;
			}
		
			if (HandSpeed.getInstance().averageSpeedMax > HAND_SPEED_LIMIT) 
			{			
				stopInteract();
				return;
			}
			
			var ib:InteractiveChargeButton =  checkForInteractiveButton(x, y, stage);	
			
			if (ib == null || !ib.enabled) 
			{				
				stopInteract();
				return;
			}
			
			if (ib != _chargeButton) 
			{
				resetData();
				_chargeButton = ib;
			}
			
			percent += percentInc;
			var color:Object = new Object();
			color.color = ib.color;
			
			dispatchEvent(new GestureEvent(GestureEvent.CHARGE, false, false, percent, color));	
			
			if (percent >= 100)
			{
				_isAllowed = false;
				chargeOK();
			}			
		}
		
		private function chargeOK():void 
		{
			_isAllowed = true;
			if (!_chargeButton) return;
			
			var charged:InteractiveEvent = new InteractiveEvent(InteractiveEvent.HAND_CHARGED, false, false );
			_chargeButton.dispatchEvent(charged);
			_isAllowed = true;
		}
		
		private function checkCharge(e:Event):void 
		{
			
		}		
		
		private function checkForInteractiveButton(x:Number,y:Number,stage:Stage):InteractiveChargeButton 
		{
			var interactiveArray:Vector.<InteractiveObject>	= DisplayListHelper.getTopDisplayChargeButtonUnderPoint( new Point (x, y ), stage);	
			if (interactiveArray)			
				for (var i:int = 0; i< interactiveArray.length; i++)				
					if(interactiveArray[i] is InteractiveChargeButton)										
						return interactiveArray[i] as InteractiveChargeButton;	
			return null;
		}
		
		private function resetData():void 
		{
			frameCounter = 0;
			percent = 0;
			blockUpdate = false;
		}	
		
		private static var _instance:ChargeButtonDetector = new ChargeButtonDetector();			
		
		public function ChargeButtonDetector() 
		{
			if ( _instance ) throw new Error( "Singleton and can only be accessed through Singleton.getInstance()" ); 		
			
			maincolor.color = 0xffffff;
		}
		
		public static function getInstance():ChargeButtonDetector 
		{  			
            return _instance;
        }		
	}
}
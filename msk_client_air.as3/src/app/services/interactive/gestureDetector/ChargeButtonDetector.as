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
		private var frameCounter:int = 0;
		public  var percent:Number = 0;	
		private var startZ:Number = Number.MIN_VALUE;
		private var lastZ:Number  = -100;
		
		private var maxDiffInMetters:Number = 0.10;
		private var minDiffInMetters:Number = 0.02;
		private static const HAND_SPEED_LIMIT:int = 5;
		
		public var blockUpdate:Boolean = false;	
		
		private var _isAllowed:Boolean = true;
		public function get isAllowed():Boolean
		{
			 return _isAllowed;
		}
		public function set isAllowed(allow:Boolean):void
		{
			_isAllowed = allow;			
			if (!allow) 
			{
				stopInteract();					
			}
		}	
		private var _chargeButton:InteractiveChargeButton;		
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
			
			//if (!AppSettings.CONTROLL_BY_KINECT) return;
			if ( !_isAllowed ) 
			{
				//trace("STOP1");
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
				//trace("!!!!!!!!!");
				//addEventListener(Event.ENTER_FRAME, checkCharge);
			}
			percent += 1;
			//trace(percent);
			var color:Object = new Object();
			color.color = ib.color;
			
			dispatchEvent(new GestureEvent(GestureEvent.CHARGE, false, false, percent, color));			
			if (percent == 100)
			{
				_isAllowed = false;
				chargeOK();
				//TweenLite.killDelayedCallsTo(chargeOK);
				//TweenLite.delayedCall(0.2, chargeOK);
			}
			
			//dispatchEvent(new GestureEvent(GestureEvent.PUSH, false, false, percent));			
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
			var interactiveArray:Vector.<InteractiveObject>	= DisplayListHelper.getTopDisplayChargeButtonUnderPoint( new Point (x, y ), stage) ;	
			if (interactiveArray)
			{
				for (var i:int = 0; i< interactiveArray.length; i++)
				{
					if(interactiveArray[i] is InteractiveChargeButton)
					{						
						return interactiveArray[i] as InteractiveChargeButton ;
					}
				}
			}
				
			return null;
		}
		
		private function resetData():void 
		{
			frameCounter = 0;
			percent = 0;
			blockUpdate = false;
		}
		/*public function checkPUSH(x:Number, y:Number, z:Number, stage:Stage):void		
		{
			var ib:InteractiveChargeButton =  checkForInteractiveButton(x, y, stage);
				
			if (ib)
			{
				var push:InteractiveEvent = new InteractiveEvent(InteractiveEvent.HAND_PUSH, true, false );
					ib.dispatchEvent(push);				
			}
		}*/
		
		private static var _instance:ChargeButtonDetector = new ChargeButtonDetector();	
		private var maincolor:Object = new Object();
		
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

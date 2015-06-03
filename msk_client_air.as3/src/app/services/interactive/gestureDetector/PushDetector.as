package app.services.interactive.gestureDetector 
{
	import app.AppSettings;
	import app.contoller.events.InteractiveEvent;
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
	public class PushDetector extends EventDispatcher
	{		
		private var frameCounter:int = 0;
		public  var percent:Number = 0;	
		private var startZ:Number = Number.MIN_VALUE;
		private var lastZ:Number  = -100;
		
		private var maxDiffInMetters:Number = 0.08;
		private var minDiffInMetters:Number = 0.05;
		private static const HAND_SPEED_LIMIT:int = 5;
		
		public var blockUpdate:Boolean = false;	
		
		private var _isAllowed:Boolean = true;
		private var part:int = 1;
		private var _pushButton:InteractiveButton;		
		
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
		
		public function set pushButton(pb:InteractiveButton):void
		{
			if (pb != _pushButton)
			{
				_pushButton = pb;
				resetValues();							
			}		
		}
		
		public function getCenter():Point
		{
			if (!_pushButton)	return null;	
			var centerX:Number = _pushButton.localToGlobal(new Point(0, 0)).x + _pushButton.width * 0.5;
			var centerY:Number = _pushButton.localToGlobal(new Point(0, 0)).y + _pushButton.height * 0.5;
			return new Point(centerX,centerY);			
		}
		
		public function get pushButton():InteractiveButton
		{
			return _pushButton;			
		}	
		
		private function stopInteract():void
		{						   
			_pushButton = null;
			resetValues();			
			dispatchEvent(new GestureEvent(GestureEvent.PUSH, false, false, percent));
		}
		
		private function resetValues():void
		{
			lastZ = startZ = Number.MIN_VALUE;
			frameCounter  = 1;
			percent = 0;
			dispatchEvent(new GestureEvent(GestureEvent.PUSH, false, false, 0));
		}		
		
		public function update(x:Number, y:Number, z:Number, stage:Stage):void		
		{
			if (!AppSettings.CONTROLL_BY_KINECT) return;
			
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
			
			var ib:InteractiveButton = checkForInteractiveButton(x, y, stage);
			if (ib == null) 
			{
				stopInteract();
				return;
			}
			
			if (ib != _pushButton) 
			{
				resetData();
				_pushButton = ib;
			}				
			
			if (z > startZ && part == 1)			
			{
				lastZ = startZ = z;
				resetData();				
			}
			else if (part == 1)	
			{
				if (startZ - z - minDiffInMetters>= maxDiffInMetters)
				{
					part = 2;
					//_isAllowed = false;
					percent = 100;					
					dispatchEvent(new GestureEvent(GestureEvent.PUSH, false, false, percent));		
					lastZ = startZ = z;						
					//TweenLite.killDelayedCallsTo(pushOK);
					//TweenLite.delayedCall(0.5, pushOK);					
				}
				else if  (startZ - z <= minDiffInMetters )
				{
					//lastZ = startZ = z;
					//resetData();
					return;
				}
				else
				{				
					percent = 100 * (startZ - z - minDiffInMetters) / (maxDiffInMetters );					
					dispatchEvent(new GestureEvent(GestureEvent.PUSH, false, false, percent));
				}
				
				lastZ = z;
			}	
			else if (part == 2)
			{
				
				percent = 100 + 100 * (startZ - z) / z;
				dispatchEvent(new GestureEvent(GestureEvent.PUSH, false, false, percent));			
				
				//if (z - startZ > minDiffInMetters)			
				{				
					_isAllowed = false;	
						
					lastZ = startZ = z;			
					resetData();
					TweenLite.killDelayedCallsTo(pushOK);
					TweenLite.delayedCall(0.5, pushOK);
				}
			}
		}
		
		private function pushOK():void 
		{
			resetData();
			
			_isAllowed = true;
			
			if (!_pushButton) return;
			
			var push:InteractiveEvent = new InteractiveEvent(InteractiveEvent.HAND_PUSH, false, false );
			_pushButton.dispatchEvent(push);
			
		}
		
		private function checkForInteractiveButton(x:Number, y:Number, stage:Stage):InteractiveButton 		
		{
			var interactiveArray:Vector.<InteractiveObject>	= DisplayListHelper.getTopDisplayButtonUnderPoint( new Point (x, y ), stage) ;	
			if (interactiveArray)
			{
				for (var i:int = 0; i< interactiveArray.length; i++)
				{
					if(interactiveArray[i] is InteractiveButton)
					{						
						return interactiveArray[i] as InteractiveButton ;
					}
				}
			}
				
			return null;
		}
		
		private function resetData():void 
		{
			frameCounter = 0;
			percent = 0;
			part = 1;
			blockUpdate = false;										
			dispatchEvent(new GestureEvent(GestureEvent.PUSH, false, false, 200));	
		}
		
		public function checkPUSH(x:Number, y:Number, z:Number, stage:Stage):void		
		{
			var ib:InteractiveButton =  checkForInteractiveButton(x, y, stage);
				
			if (ib)
			{
				var push:InteractiveEvent = new InteractiveEvent(InteractiveEvent.HAND_PUSH, true, false );
					ib.dispatchEvent(push);				
			}
		}
		
		private static var _instance:PushDetector = new PushDetector();	
		
		public function PushDetector() 
		{
			 if( _instance ) throw new Error( "Singleton and can only be accessed through Singleton.getInstance()" ); 
		}
		
		public static function getInstance():PushDetector 
		{  			
            return _instance;
        }		
	}
}
package app.view.handsview
{	
	import app.AppSettings;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.InteractiveRemoteEvent;
	import app.services.interactive.gestureDetector.ChargeButtonDetector;
	import app.services.interactive.gestureDetector.DisplayListHelper;
	import app.services.interactive.gestureDetector.GestureEvent;
	import app.services.interactive.gestureDetector.HandDownDetector;
	import app.services.interactive.gestureDetector.HandFingerDetector;
	import app.services.interactive.gestureDetector.HandOverOutDetector;
	import app.services.interactive.gestureDetector.HandSpeed;
	import app.services.interactive.gestureDetector.HandUpDetector;
	import app.services.interactive.gestureDetector.PushDetector;
	import app.services.interactive.gestureDetector.StretchOutDetector;
	import com.greensock.TweenLite;
	import flash.data.EncryptedLocalStore;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	
	public class HandsView extends Sprite
	{
		public static var activeHand:Hand;
		public var pushPercent:Number = 0;
		
		private var leftHand:Hand;
		private var rightHand:Hand;			
		private var lastXYZ:Object = { x: 0, y: 0, z: 0 };		
		private var magneteToCenter:Boolean = false;
		private var isPushInteraction:Boolean = false;
		
		private var stretchDetector:StretchOutDetector = StretchOutDetector.getInstance();
		private var pushDetector:PushDetector = PushDetector.getInstance();
		private var chargeButtonDetector:ChargeButtonDetector = ChargeButtonDetector.getInstance();
		private var handOverOutDetector:HandOverOutDetector = HandOverOutDetector.getInstance()
		private var handDownDetector:HandDownDetector = HandDownDetector.getInstance();
		private var handUpDetector:HandUpDetector = HandUpDetector.getInstance();
		private var handfingerDetector:HandFingerDetector = HandFingerDetector.getInstance();		
		
		public function fingerUpdater(e:InteractiveRemoteEvent):void
		{
			handfingerDetector.update(e.type, e.gesturePart, fingerUpdate);
		}
		
		private function fingerUpdate(state:String, type:String):void
		{
			if (state == "CHARGING")
			{
				pushDetector.isAllowed = false;
				handDownDetector.isAllowed = false;
				chargeButtonDetector.isAllowed = false;
				handUpDetector.isAllowed = false;
			}
			else
			{
				pushDetector.isAllowed = true;
				handDownDetector.isAllowed = true;
				chargeButtonDetector.isAllowed = true;
				handUpDetector.isAllowed = true;
			}
			activeHand.fingerUpdate(state, type);
		}
		
		public function fingerDone(e:GestureEvent):void
		{
			handfingerDetector.finished();
			pushDetector.isAllowed = true;
			handDownDetector.isAllowed = true;
			chargeButtonDetector.isAllowed = true;
			handUpDetector.isAllowed = true;
		
		}
		
		public function HandsView()
		{
			name = "HandsView";
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		public function init():void
		{
			leftHand = new Hand();
			leftHand.handType = HandType.LEFT;
			addChild(leftHand);
			
			rightHand = new Hand();
			rightHand.handType = HandType.RIGHT;
			addChild(rightHand);
			
			activeHand = new Hand();
			activeHand.handType = HandType.NONE;
			addChild(activeHand);	
			
			pushDetector.addEventListener(GestureEvent.PUSH, updateHandFill);
			chargeButtonDetector.addEventListener(GestureEvent.CHARGE, updateHandFillCircle);		
		}		
		
		public function activateHand(ht:String):void
		{
			
			if (ht == HandType.LEFT)
			{
				leftHand.isTracked = true;
			}
			else if (ht == HandType.RIGHT)
			{
				rightHand.isTracked = true;
			}
			
			if (activeHand.handType == HandType.NONE)
			{
				if (ht == HandType.LEFT)
					activateLeftHand()
				else if (ht == HandType.RIGHT)
					activateRightHand();
			}
		}
		
		public function loseHand(ht:String):void
		{
			
			activeHand.handType = HandType.NONE;
			activeHand.clear();
			
			if (ht == HandType.LEFT)
			{
				leftHand.isTracked = false;
				if (rightHand.isTracked == true)
					activateRightHand();
			}
			else if (ht == HandType.RIGHT)
			{
				rightHand.isTracked = false;
				if (leftHand.isTracked == true)
					activateLeftHand();
			}		
		}
		
		private function activateRightHand():void
		{
			activeHand = rightHand;
			activeHand.handType = HandType.RIGHT;
			rightHand.show();
		}
		
		private function activateLeftHand():void
		{
			activeHand = leftHand;
			activeHand.handType = HandType.LEFT;
			leftHand.show();
		}
		
		public function showHand():void
		{
			activeHand.show();
		}
		
		public function hideHand():void
		{
			activeHand.hide();
		}
		
		////////////////////////////// TEMP//////////////////////////////////////////////
		public function pushHand(x:Number, y:Number, z:Number, ht:String):void
		{
			pushDetector.checkPUSH(x, y, z, stage);
		}
		
		//////////////////////////////////////	
		
		public function updateHandFillCircle(e:GestureEvent):void
		{
			activeHand.pushProgressCircle(e.percent, e.data.color);
		}
		
		public function updateHandFill(e:GestureEvent):void
		{
			pushPercent = e.percent;
			activeHand.pushProgress(pushPercent);
		}
		
		public function handPushProgress(percent:Number):void
		{
			pushPercent = percent;
			activeHand.pushProgress(percent);
		}
		
		public function updateHand(x:Number, y:Number, z:Number, ht:String):void
		{
			
			if (ht == activeHand._handType)
			{
				interactiveLHandler(x, y, z);
			}
		}
		
		public function checkHand():Boolean
		{
			if (activeHand.x < 10 || activeHand.x > AppSettings.WIDTH  || activeHand.y > AppSettings.HEIGHT || activeHand.y < 0 )
			return true;
			else return false;
			
		}
		
		public function upHand():void
		{			
			chargeButtonDetector.isAllowed = true;
			pushDetector.isAllowed = true;
			handOverOutDetector.isAllowed = true;
			stretchDetector.stretchOff();
			stretchDetector.isAllowed = false;	
			
			//--------------------------------------------------------------------------
			//
			//  Up Detection
			//
			//--------------------------------------------------------------------------
			
			var point:Point = new Point(activeHand.x + activeHand.width * 0.5, activeHand.y + activeHand.height * 0.5);
			handUpDetector.update(point.x, point.y, stage);
			activeHand.open();		
		}
		
		public function downHand():void
		{
			var point:Point = new Point(activeHand.x + activeHand.width * 0.5, activeHand.y + activeHand.height * 0.5);
			handDownDetector.update(point.x, point.y, stage);					
			chargeButtonDetector.isAllowed = false;
			pushDetector.isAllowed = false;
			handOverOutDetector.isAllowed = false;
			stretchDetector.findStretch(point.x, point.y,activeHand._z, stage);
			
			activeHand.close();			
		}		
		
		private function interactiveLHandler(x:Number, y:Number, z:Number):void
		{
			
			if (pushDetector.percent)
			{
				if (magneteToCenter)
				{
					activeHand.x = lastXYZ.x - (pushDetector.percent / 100) * (lastXYZ.x - pushDetector.getCenter().x) - activeHand.width * 0.5 //20 * (1 / pushDetector.percent) * (x - lastXYZ.x) - activeHand.width  * 0.5;				
					activeHand.y = lastXYZ.y - (pushDetector.percent / 100) * (lastXYZ.y - pushDetector.getCenter().y) - activeHand.height * 0.5 //20 * (1 / pushDetector.percent) * (x - lastXYZ.x) - activeHand.width  * 0.5;				
				}
			}
			else
			{
				activeHand.x = x - activeHand.width * 0.5;
				activeHand.y = y - activeHand.height * 0.5;
				
				lastXYZ.x = x;
				lastXYZ.y = y;
				lastXYZ.z = z;
			}
			activeHand._z = z;
			//}
			
			HandSpeed.getInstance().calculateSpeed(x, y);
			
			//--------------------------------------------------------------------------
			//
			//  Over and Out Detection
			//
			//--------------------------------------------------------------------------
			
			var point:Point = new Point(activeHand.x + activeHand.width * 0.5, activeHand.y + activeHand.height * 0.5);
			handOverOutDetector.update(point.x, point.y, z, stage);
			
			//-----------------------------------------------------------------------
			//
			// 
			//
			//--------------------------------------------------------------------------			
			
			//--------------------------------------------------------------------------
			//
			//  Push Detection
			//
			//--------------------------------------------------------------------------
			pushDetector.update(point.x, point.y, z, stage);
			
			//--------------------------------------------------------------------------
			//
			// 
			//
			//--------------------------------------------------------------------------
			
			//--------------------------------------------------------------------------
			//
			//  Charge Detection
			//
			//--------------------------------------------------------------------------
			chargeButtonDetector.update(point.x, point.y, z, stage);
		
			//--------------------------------------------------------------------------
			//
			// 
			//
			//--------------------------------------------------------------------------	
			
			//--------------------------------------------------------------------------
			//
			//  Charge Detection
			//
			//--------------------------------------------------------------------------
			stretchDetector.update(point.x, point.y, z, stage);
		
			//--------------------------------------------------------------------------
			//
			// 
			//
			//--------------------------------------------------------------------------		
		}
	}
}
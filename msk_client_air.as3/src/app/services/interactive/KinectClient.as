package app.services.interactive
{
	import app.AppSettings;
	import app.contoller.events.GesturePostEvent;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.InteractiveRemoteEvent;
	import app.model.datauser.IUser;
	import app.services.trackers.Gesture;
	import app.services.trackers.TrackerEvent;
	import app.view.handsview.HandType;
	import com.greensock.TweenLite;
	import com.tastenkunst.airkinectv2.KV2Joint;
	import flash.events.DatagramSocketDataEvent;
	import flash.events.EventDispatcher;
	import flash.net.DatagramSocket;
	import flash.utils.getTimer;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class KinectClient extends EventDispatcher
	{
		//[Inject]
		public var userActive:Boolean = false;
		
		private var ieHandDown:InteractiveRemoteEvent 		= new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_DOWN);
		private var ieHandUp:InteractiveRemoteEvent 		= new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_UP);
		private var ieActivateHand:InteractiveRemoteEvent 	= new InteractiveRemoteEvent(InteractiveRemoteEvent.ACTIVATE_HAND);
		private var ieDeActivateHand:InteractiveRemoteEvent = new InteractiveRemoteEvent(InteractiveRemoteEvent.DEACTIVATE_HAND);
		private var ieHandUpdate:InteractiveRemoteEvent 	= new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_UPDATE);
		private var figureGesture:InteractiveRemoteEvent 	= new InteractiveRemoteEvent(InteractiveRemoteEvent.FIGURE_GESTURE);		
		private var twoFingers:InteractiveRemoteEvent 		= new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_TWO_FINGERS);
		private var oneFinger:InteractiveRemoteEvent 		= new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_ONE_FINGER);
		
		private var fingersNum:int = 1;
		
		private var kinect:KinectV2;
		
		private var lastLeftGrip:Boolean 	= false;
		private var lastRightGrip:Boolean 	= false;
		private var lastLeftActive:Boolean 	= false;
		private var lastRightActive:Boolean = false;
		private var isDelayedHandUP:Boolean = false;
		
		private var handUPTYPE:String 		= "";
		private var _handOverHead:Boolean 	= false;
		private var fingerCharging:Boolean 	= false;
		
		private var fAbort:int = 0;
		
		public function startListening(port:uint):void
		{
			kinect = new KinectV2();
			kinect.init();
			kinect.addEventListener(Event.EXIT_FRAME, onEnterFrame);
			kinect.addEventListener(TrackerEvent.GESTURE_TRACK, trackerHandler);
		}
		
		private function trackerHandler(e:TrackerEvent):void
		{
			if (e.type == TrackerEvent.GESTURE_TRACK )
			{
				switch (e.getGesture().getType())
				{
				//case Gesture.HAND_OVER_HEAD: 
				case Gesture.DOWN_LINE: 
					handOverHead();
					break;
				
				case Gesture.DOUBLE_ELLIPSE: 
				//case Gesture.CIRCLE: 
				//case Gesture.CIRCLE_CW: 
					figureGesture.handType = "LEFT";
					figureGesture.gesture  = GestureID.CW_CIRCLE;
					dispatchEvent(figureGesture);
					break;
				
				case Gesture.HORIZONT_LINE: 
				/*case Gesture.SQUARE: 
				case Gesture.SQUARE_CW: 
				case Gesture.TRIANGLE: 
				case Gesture.TRIANGLE_CW: 
				case Gesture.CHECK: 
				case Gesture.CHECK_CW: */
					figureGesture.handType = "LEFT";
					figureGesture.gesture  = GestureID.GALKA;
					dispatchEvent(figureGesture);
					break;
				
				case Gesture.TWO_FINGERS: 
					//trace("-------------------  TWO_FINGERS -------------  ");	
					if (activeHandType != e.getGesture().getHandType())
					return;
					
					if (fingersNum == 1)
					{
						oneFinger.gesturePart = "START"
						dispatchEvent(oneFinger);
					}
					else
					{
						twoFingers.gesturePart = "START"
						dispatchEvent(twoFingers);
					}
						
					fingerCharging = true;
					fAbort = 0;
					break;
				
				case Gesture.FINGERS_ABORT: 
					if (activeHandType != e.getGesture().getHandType())
					return;
					//trace("-------------------  FINGERS_ABORT -------------  ", fAbort);						
					if (fingerCharging && ++fAbort > 4)
					{
						fAbort = 0;
						twoFingers.gesturePart = "INTERRUPT"
						oneFinger.gesturePart = "INTERRUPT"
						dispatchEvent(twoFingers);
						dispatchEvent(oneFinger);
						fingerCharging = false;
					}
					break;
				}
			}
		}
		
		public function gestureDetected(event:GesturePostEvent):void
		{
			if (event.type == GesturePostEvent.HAND_ONE_FINGER)
			{
				fingersNum = 2;
				oneFinger.gesturePart = "INTERRUPT";
				dispatchEvent(oneFinger);	
			}
			else 
			{
				fingersNum = 1;
				twoFingers.gesturePart = "INTERRUPT";			
				dispatchEvent(twoFingers);				
			}
			
			kinect.gesturePause();			
		}		
		
		private function handOverHead():void//e:InteractiveRemoteEvent)
		{
			//if (!_handOverHead)// && !notActiveHandGrip())
			{
				_handOverHead = true;
				dispatchEvent(new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_OVER_HEAD));
			}
		}
		
		private function handUnderHead(e:InteractiveRemoteEvent):void
		{
			_handOverHead = false;
		}
		
		public function stopListing():void
		{
			//kinect.stop();
			kinect.removeEventListener(Event.EXIT_FRAME, onEnterFrame);
		}
		
		private function unload(e:Event):void
		{
			//kinect.stop();
		}
		
		private function notActiveHandGrip():Boolean
		{
			if (lastLeftActive)
				return lastLeftGrip;
			else if (lastRightActive)
				return lastRightGrip;
			
			return false;
		}
		private var act:Boolean = false;
		private var lost:int = 0;
		private var activeHandType:int = -1;
		
		protected function onEnterFrame(event:Event):void
		{
			kinect.update();
			
			if (kinect.getUserCount() > 0)
			{
				if (!act)
					dispatchUserActiveEvent();
				
				act = true;
				lost = 0;
				
				if (kinect.getLeftHand().y > kinect.getRightHand().y)
				{
					//trace("RIGHT!!!!!!!!!!!!!!!!!");
					activeHandType = KV2Joint.JointType_HandRight;
					handleRightHand(kinect.getRightHand());
				}
				else
				{	
					activeHandType = KV2Joint.JointType_HandLeft;
					handleLeftHand(kinect.getLeftHand());
				}
			}
			else
			{
				if (++lost > 2)
				{
					lost = 0;
					act = false;
					dispatchUserLostEvent();
				}
				
					//trace("LOST!!!!!!!!!!!!!!!!!!!!!!", kinect.getUserCount());
			}
		}
		
		private function dispatchUserActiveEvent():void
		{
			if (!userActive)
			{
				userActive = true;
				dispatchEvent(new InteractiveRemoteEvent(InteractiveRemoteEvent.USER_ACTIVE, true, true));
			}
		}
		
		private function dispatchUserLostEvent():void
		{
			if (userActive)
			{
				userActive = false;
				dispatchEvent(new InteractiveRemoteEvent(InteractiveRemoteEvent.USER_LOST, true, true));
			}
		}
		
		private function handleLeftHand(hand:KinectHand):void
		{
			if (lastLeftActive != hand.isTracked())
			{
				lastLeftActive = hand.isTracked();
				activationHandAnalyzer(hand);
			}
			
			if (lastLeftGrip != hand.isGrip())
			{
				lastLeftGrip = hand.isGrip();
				gripHandAnalyzer(hand);
			}
			
			ieHandUpdate.setHandData(hand);
			dispatchEvent(ieHandUpdate);
		}
		
		private function handleRightHand(hand:KinectHand):void
		{
			if (lastRightActive != hand.isTracked())
			{
				lastRightActive = hand.isTracked();
				activationHandAnalyzer(hand);
			}
			
			if (lastRightGrip != hand.isGrip())
			{
				lastRightGrip = hand.isGrip();
				gripHandAnalyzer(hand);
			}
			
			ieHandUpdate.setHandData(hand);
			dispatchEvent(ieHandUpdate);
		}
		
		private function activationHandAnalyzer(hand:KinectHand):void
		{
			if (hand.isTracked())
			{
				ieActivateHand.setHandData(hand);
				dispatchEvent(ieActivateHand);
			}
			else
			{
				ieDeActivateHand.setHandData(hand);
				dispatchEvent(ieDeActivateHand);
			}
		}
		
		private function gripHandAnalyzer(hand:KinectHand):void
		{
			if (hand.isGrip())
			{
				ieHandDown.setHandData(hand);
				dispatchEvent(ieHandDown);
			}
			else
			{
				ieHandUp.setHandData(hand);
				dispatchEvent(ieHandUp);
			}
		}
	
	/*private function dataHandler(event:DatagramSocketDataEvent):void
	   {
	   var type:String;
	   var decoded;
	   switch (type)
	   {
	   case "FIGURE_GESTURE":
	   if(isDelayedHandUP) return;
	   sendFigureGesture(decoded.handType, decoded.gesture);
	   break;
	
	   case "FINGERS":
	   //trace( decoded.gesture, decoded.gesturePart);
	   var ieHUP:InteractiveRemoteEvent;
	   if (decoded.gesture == "20")
	   {
	   ieHUP = new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_ONE_FINGER);
	   ieHUP.gesturePart = decoded.gesturePart;
	   dispatchEvent(ieHUP);
	   }
	   if (decoded.gesture == "21")
	   {
	   ieHUP = new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_TWO_FINGERS);
	   ieHUP.gesturePart = decoded.gesturePart;
	   dispatchEvent(ieHUP);
	   }
	   if (decoded.gesture == "22")
	   {
	   ieHUP = new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_THREE_FINGERS);
	   ieHUP.gesturePart = decoded.gesturePart;
	   dispatchEvent(ieHUP);
	   }
	
	   break;
	   }
	   }			*/
	
	/*private function sendFigureGesture(handType:int, gesture:int):void
	   {
	   switch (gesture)
	   {
	   case GestureID.CW_CIRCLE:
	   case GestureID.ACW_TRIANGLE:
	   case GestureID.ACW_CIRCLE:
	   case GestureID.CW_TRIANGLE:
	   case GestureID.GALKA:
	   trace("GESTURE=====================",gesture);
	   var interactiveGesture:InteractiveRemoteEvent = new InteractiveRemoteEvent(InteractiveRemoteEvent.FIGURE_GESTURE);
	   interactiveGesture.handType = handType == HandID.LEFT ? HandType.LEFT : HandType.RIGHT;
	   interactiveGesture.gesture = gesture;
	   dispatchEvent(interactiveGesture);
	   break;
	
	
	   default:
	   }
	   }	*/
	}
}
package app.services.interactive
{	
	import app.AppSettings;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.InteractiveRemoteEvent;
	import app.model.datauser.IUser;
	import app.view.handsview.HandType;
	import com.greensock.TweenLite;
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
		
		private var kinect : KinectV2;
		
		private var lastLeftGrip:Boolean    = false;
		private var lastRightGrip:Boolean   = false;		
		private var lastLeftActive:Boolean  = false;
		private var lastRightActive:Boolean = false;		
		private var isDelayedHandUP:Boolean = false;	
		
		private var handUPTYPE:String = "";	
		private var _handOverHead:Boolean = false;
		
		public function startListening(port:uint):void
		{			
			kinect = new KinectV2();
			kinect.init();
			kinect.addEventListener(Event.EXIT_FRAME, onEnterFrame);
			kinect.addEventListener(InteractiveRemoteEvent.HAND_OVER_HEAD, handOverHead);
			kinect.addEventListener(InteractiveRemoteEvent.HAND_UNDER_HEAD, handUnderHead);
		}
		
		public function stopListing():void
		{			
			kinect.stop();
			kinect.removeEventListener(Event.EXIT_FRAME, onEnterFrame);
			kinect.removeEventListener(InteractiveRemoteEvent.HAND_OVER_HEAD, handOverHead);
			kinect.removeEventListener(InteractiveRemoteEvent.HAND_UNDER_HEAD, handUnderHead);
		}
		
		private function unload(e:Event):void 
		{
			kinect.stop();
		}
		
		private function handOverHead(e:InteractiveRemoteEvent):void
		{	
			if (!_handOverHead && !notActiveHandGrip())
			{
				_handOverHead = true;
				dispatchEvent(new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_OVER_HEAD));	
			}			
		}
		
		private function notActiveHandGrip():Boolean 
		{
			if (lastLeftActive)
				return lastLeftGrip;
			else if (lastRightActive)
				return lastRightGrip;
				
			return false;
		}
		
		private function handUnderHead(e:InteractiveRemoteEvent):void
		{
			_handOverHead = false;
		}		
		
		protected function onEnterFrame(event : Event) : void 
		{
			kinect.update();
			
			if (kinect.getUserCount() > 0 )	
			{				
				dispatchUserActiveEvent();	
				handleLeftHand(kinect.getLeftHand());			
				handleRightHand(kinect.getRightHand());	
			}
			else
				dispatchUserLostEvent();
		}
		
		private function dispatchUserActiveEvent(): void 
		{
			if (!userActive)
			{
				userActive = true;	
				dispatchEvent(new InteractiveRemoteEvent(InteractiveRemoteEvent.USER_ACTIVE, true, true));
			}			
		}
		
		private function dispatchUserLostEvent(): void 
		{
			if (userActive) 
			{
				userActive = false;				
				dispatchEvent(new InteractiveRemoteEvent(InteractiveRemoteEvent.USER_LOST, true, true));				
			}			
		}
		
		private function handleLeftHand(hand : KinectHand):void
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
		
		private function handleRightHand(hand : KinectHand):void
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
		
		private function activationHandAnalyzer(hand : KinectHand):void
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
		
		private function gripHandAnalyzer(hand : KinectHand):void
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
		
		private function dataHandler(event:DatagramSocketDataEvent):void
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
		}			
		
		private function sendFigureGesture(handType:int, gesture:int):void
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
		}	
	}
}
package app.services.trackers.oneDollarGeture
{
	import app.services.trackers.JointHelper;
	import com.greensock.TweenLite;
	import com.tastenkunst.airkinectv2.KV2Body;
	import com.tastenkunst.airkinectv2.KV2Joint;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import math.oneDollar.Recognizer;
	import app.services.trackers.Gesture;
	import app.services.trackers.TrackerEvent;
	
	public class OneDollarGestureTracking extends Sprite
	{
		private static const STOP:int = 1;
		private static const TRACK:int = 2;
		private static const PAUSE:int = 3;
		private static const RECOGNIZE:int = 4;
		
		private static const GESTURE_MAX_TIME:int = 40;
		private static const GESTURE_MIN_TIME:Number = 0.4;
		private static const MAX_GESTURE_TINE:Number = 5.1;
		
		private static const PAUSE_TIME:Number = 0.5;
		
		private var trackingState:int = STOP;
		private var trackingHandType:int;
		private var rPoints:Array;
		private var lPoints:Array;
		
		private var timer:Timer;
		private var gestureTime:Number = 0;
		
		private var prevRPosition:Point;
		private var prevLPosition:Point;
		
		private var recognizer:Recognizer;
		private var gesture:Gesture;		
	
		public function OneDollarGestureTracking()
		{
			recognizer = new Recognizer();
			gesture = new Gesture();
			
			timer = new Timer(100, GESTURE_MAX_TIME);
			timer.addEventListener(TimerEvent.TIMER, onTick);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		}
		
		private function onTick(event:TimerEvent):void
		{
			gestureTime = event.target.currentCount / 10.0;
		}
		
		private function onTimerComplete(e:TimerEvent):void
		{
			trackingState = STOP;
			graphics.clear();
		}
		
		public function update(body:KV2Body):void
		{
			switch (trackingState)
			{
			case STOP: 
				tryToStart(body);
				break;
			
			case TRACK: 
				trackingHandType = KV2Joint.JointType_HandRight;
				track(body, rPoints, prevRPosition);
				if (trackingState == PAUSE) return;
				trackingHandType = KV2Joint.JointType_HandLeft;
				track(body, lPoints, prevLPosition);
				break;
			}
		}
		
		public function startTrack(lPoint:Point, rPoint:Point):void
		{
			trackingState = TRACK;
			
			lPoints = new Array();
			rPoints = new Array();
			
			lPoints.push(lPoint);
			rPoints.push(rPoint);
			
			prevLPosition = new Point(lPoint.x, lPoint.y);
			prevRPosition = new Point(rPoint.x, rPoint.y);
			
			graphics.clear();
			
			timer.reset();
			timer.start();
			
			gestureTime = 0.0;			
		}	
		
		private function tryToStart(body:KV2Body):void
		{
			var headJoint:KV2Joint = JointHelper.findJoint(KV2Joint.JointType_Head);
			var handRight:KV2Joint = JointHelper.findJoint(KV2Joint.JointType_HandRight);
			var handLeft:KV2Joint = JointHelper.findJoint(KV2Joint.JointType_HandLeft);			
			var distBetweenHands:Number = handRight.depthSpacePoint.x  - handLeft.depthSpacePoint.x;
			
			if (distBetweenHands < 150 && JointHelper.handOverHead(handRight, headJoint) && JointHelper.handOverHead(handLeft, headJoint))			
				startTrack(handLeft.depthSpacePoint, handRight.depthSpacePoint);			
		}	
		
		private function track(body:KV2Body, points:Array, prevPoint:Point):void
		{
			var headJoint:KV2Joint = JointHelper.findJoint(KV2Joint.JointType_Head);
			var handRight:KV2Joint = JointHelper.findJoint(KV2Joint.JointType_HandRight);
			var handLeft:KV2Joint = JointHelper.findJoint(KV2Joint.JointType_HandLeft);
			var elbowLeft:KV2Joint = JointHelper.findJoint(KV2Joint.JointType_ElbowLeft);
			var elbowRight:KV2Joint = JointHelper.findJoint(KV2Joint.JointType_ElbowRight);
			var spine:KV2Joint = JointHelper.findJoint(KV2Joint.JointType_SpineMid);			
			var trackingHand:KV2Joint = handRight.jointType == trackingHandType ? handRight : handLeft;			
			
			var p:Point = new Point(trackingHand.depthSpacePoint.x, trackingHand.depthSpacePoint.y);			
			points.push(p);
			
			/*{
				graphics.lineStyle(5, drawColor, 1);
				graphics.moveTo(prevPoint.x, prevPoint.y);
				graphics.lineTo(p.x, p.y);
			}	*/	

			if (handRight.jointType == trackingHandType)
				prevRPosition = new Point(trackingHand.depthSpacePoint.x, trackingHand.depthSpacePoint.y);
			else
				prevLPosition = new Point(trackingHand.depthSpacePoint.x, trackingHand.depthSpacePoint.y);

			var distBetweenHands:Number = handRight.depthSpacePoint.x  - handLeft.depthSpacePoint.x;
			
			if (gestureTime < MAX_GESTURE_TINE)
			{
				if (gestureTime < 0.7)
				 return;
				 			
				if (distBetweenHands > 280 && JointHelper.handOverHead(handRight, headJoint) && JointHelper.handOverHead(handLeft, headJoint))
				{	
					gesture = new Gesture();
					gesture.setType(Gesture.HORIZONT_LINE);
					dispatchEvent(new TrackerEvent(gesture, TrackerEvent.GESTURE_TRACK));
					pauseMode();
				}
				else if (distBetweenHands < 450 &&( JointHelper.handUnderJoint(handRight, elbowRight) || JointHelper.handUnderJoint(handLeft, elbowLeft)))
				{					
					var xMax:Number = Number.MIN_VALUE, xMin:Number = Number.MAX_VALUE;
					
					for (var i:int = 0; i < lPoints.length; i++)
					{
						if (lPoints[i].x > xMax)
							xMax = lPoints[i].x;
						if (lPoints[i].x < xMin)
							xMin = lPoints[i].x;
					}					
					
					if (xMax - xMin < 100)
						gesture.setType(Gesture.DOWN_LINE);
					else
						gesture.setType(Gesture.DOUBLE_ELLIPSE);				
					
					dispatchEvent(new TrackerEvent(gesture, TrackerEvent.GESTURE_TRACK));
					pauseMode();
				}				
			}			
			else
				pauseMode();
		}	
		
		private function pauseMode():void 
		{
			trackingState = PAUSE;
			TweenLite.killDelayedCallsTo(pauseCompleteHandler);
			TweenLite.delayedCall(PAUSE_TIME, pauseCompleteHandler);
		}
		
		private function pauseCompleteHandler():void
		{
			trackingState = STOP;
			timer.stop();
		}		
		
		public function flushAll():void
		{
			graphics.clear();
			trackingState = STOP;
			timer.stop();
		}
	}
}
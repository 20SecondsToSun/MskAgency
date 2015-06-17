package app.services.trackers.oneDollarGeture
{
	import app.services.trackers.Gesture;
	import app.services.trackers.JointHelper;
	import app.services.trackers.TrackerEvent;
	import com.greensock.TweenLite;
	import com.tastenkunst.airkinectv2.KV2Body;
	import com.tastenkunst.airkinectv2.KV2Joint;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import math.oneDollar.Recognizer;
	import math.oneDollar.Result;
	
	public class OneDollarGestureTracking extends Sprite
	{
		private static const STOP:int = 1;
		private static const TRACK:int = 2;
		private static const PAUSE:int = 3;
		private static const RECOGNIZE:int = 4;
		
		private static const GESTURE_MAX_TIME:int = 40;
		private static const GESTURE_MIN_TIME:Number = 1.5;
		
		private static const PAUSE_TIME:Number = 0.5;
		
		private var trackingState:int = STOP;
		private var trackingHandType:int;
		private var points:Array;
		
		private var timer:Timer;
		private var gestureTime:Number = 0;
		private var drawColor:uint = 0xfff000;
		private var prevHandPosition:Point;
		
		private var recognizer:Recognizer;
		private var gesture:Gesture;
		
		private var mod:int;
		
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
		
		public function startTrack(point:Point):void
		{
			trackingState = TRACK;
			
			points = new Array();
			points.push(point);
			prevHandPosition = point;
			
			graphics.clear();
			graphics.moveTo(point.x, point.y);		
			
			timer.reset();
			timer.start();
			
			gestureTime = 0.0;
			mod = 0;
		}
		
		public function update(body:KV2Body):void
		{
			switch (trackingState)
			{
			case STOP: 
				tryToStart(body);
				break;
			
			case TRACK: 
				track(body);
				break;
			}
		}
		
		private function tryToStart(body:KV2Body):void
		{
			var headJoint:KV2Joint = JointHelper.findJoint(KV2Joint.JointType_Head);
			var handRight:KV2Joint = JointHelper.findJoint(KV2Joint.JointType_HandRight);
			var handLeft:KV2Joint = JointHelper.findJoint(KV2Joint.JointType_HandLeft);
			
			if ((body.handLeftState == KV2Body.HandState_Closed && (headJoint.depthSpacePoint.y > handLeft.depthSpacePoint.y + 20)))
			{
				trackingHandType = KV2Joint.JointType_HandLeft;
				startTrack(handLeft.colorSpacePoint);
			}
			else if (body.handLeftState == KV2Body.HandState_Closed && (headJoint.depthSpacePoint.y > handRight.depthSpacePoint.y + 20))
			{
				trackingHandType = KV2Joint.JointType_HandRight;
				startTrack(handRight.colorSpacePoint);
			}			
		}
		
		private function track(body:KV2Body):void
		{
			var headJoint:KV2Joint = JointHelper.findJoint(KV2Joint.JointType_Head);
			var handRight:KV2Joint = JointHelper.findJoint(KV2Joint.JointType_HandRight);
			var handLeft:KV2Joint = JointHelper.findJoint(KV2Joint.JointType_HandLeft);
			
			var trackingHand:KV2Joint;		
		
			if (handRight.jointType == trackingHandType)			
				trackingHand = handRight;
			else
				trackingHand = handLeft;			
			
			var p:Point = new Point(trackingHand.colorSpacePoint.x, trackingHand.colorSpacePoint.y);
		
			//if (mod++ % 50 == 0 )
			{
				points.push(p);			
				graphics.lineStyle(5, drawColor, 1);
				graphics.lineTo(p.x, p.y);
			}			
			
			prevHandPosition = new Point(p.x, p.y);		
			
			var handBecomeOpen:Boolean = (trackingHand.jointType == KV2Joint.JointType_HandLeft && body.handLeftState == KV2Body.HandState_Open); 
			
			if ( (headJoint.depthSpacePoint.y  > trackingHand.depthSpacePoint.y + 20) && (gestureTime > GESTURE_MIN_TIME || handBecomeOpen))
			{			
				//trace("Complete----------------------------", points.length);
				
				if (points.length)
				{
					var result:Result = recognizer.recognize(points);
					if (result.template.id != Gesture.INVALID && result.score > 0.6)
					{
						gesture.setType(result.template.id);
						dispatchEvent(new TrackerEvent(gesture, TrackerEvent.GESTURE_TRACK));
					}				
				}
				
				graphics.clear();
				trackingState = PAUSE;
				
				TweenLite.killDelayedCallsTo(pauseCompleteHandler);
				TweenLite.delayedCall(PAUSE_TIME, pauseCompleteHandler);
			}					
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
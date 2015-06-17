package app.services.interactive
{
	import app.contoller.events.InteractiveRemoteEvent;
	import app.services.trackers.Gesture;
	import app.services.trackers.JointHelper;
	import app.services.trackers.oneDollarGeture.OneDollarGestureTracking;
	import app.services.trackers.partialGesture.gestures.handUpHead.HandUpHeadGesture;
	import app.services.trackers.partialGesture.gestures.twoFingers.TwoFingersGesture;
	import app.services.trackers.partialGesture.PartialGestureTracking;
	import app.services.trackers.TrackerEvent;
	import app.view.handsview.HandType;
	import app.view.utils.Tool;
	import com.greensock.TweenLite;
	import com.tastenkunst.airkinectv2.KV2Body;
	import com.tastenkunst.airkinectv2.KV2Code;
	import com.tastenkunst.airkinectv2.KV2Config;
	import com.tastenkunst.airkinectv2.KV2Joint;
	import com.tastenkunst.airkinectv2.KV2Manager;
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	public class KinectV2 extends Sprite 
	{
		public var _kv2Config : KV2Config;
		public var _kv2Manager: KV2Manager;
		
		protected var leftHand : KinectHand;
		protected var rightHand: KinectHand;		
		protected var userCount: uint = 0;	
		
		public var _bmColor:Bitmap;
		public var _bmDepth:Bitmap;
		public var _bmBodyIndexFrame:Bitmap;
		public var _bmDepthFrameMappedToColorSpace:Bitmap;
		public var _bmBodyIndexFrameMappedToColorSpace:Bitmap;
		
		public var _drawSprite:Sprite;
		public var _draw:Graphics;
		public var _tmpPoint:Point;
		
		private var overHeadEvent:InteractiveRemoteEvent 	= new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_OVER_HEAD);
		private var underHeadEvent:InteractiveRemoteEvent 	= new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_UNDER_HEAD);
		
		private var figureGestureTracking:OneDollarGestureTracking;
		private var partialGestureTracking:PartialGestureTracking
		
		private static const GESTURE_PAUSE_TIME:Number = 1.5;
		private var gestureUpdate:Boolean = true;			
		
		private var trackedIDcolor:int = -1;
		
		public function KinectV2()
		{			
			_kv2Config = new KV2Config();
			_kv2Manager = new KV2Manager();
		}
		
		public function init():void
		{				
			_kv2Config.enableColorFrame = true;
			_kv2Config.enableDepthFrame = true;
			_kv2Config.enableBodyIndexFrame = true;
			_kv2Config.enableBodyFrame = true;
			
			_kv2Config.enableColorFrameMappingToDepthSpace = true;
			_kv2Config.enableDepthFrameMappingToColorSpace = false;
			_kv2Config.enableBodyIndexFrameMappingToColorSpace = true;	
			
			initKinect();			
		}		
		
		public function initKinect():void
		{
			var started:int = _kv2Manager.start(_kv2Config);
			
			if (started == KV2Code.OK)			
				onKinectStarted();			
			else
				onKinectFailedToStarted();			
		}
		
		private function onKinectFailedToStarted():void 
		{
			
		}
		
		public function gesturePause():void
		{
			partialGestureTracking.flushAll();
			figureGestureTracking.flushAll();			
			TweenLite.killDelayedCallsTo(pauseCompleteHandler);
			TweenLite.delayedCall(3.0, pauseCompleteHandler);
			gestureUpdate = false;
		}
		
		protected function onKinectStarted():void
		{
			leftHand = new KinectHand(HandType.LEFT);		
			rightHand = new KinectHand(HandType.RIGHT);	
			
			initKinectChannels();
			initGraphics();
			initStats();
			initTrackers();		
		}
		
		private function initKinectChannels():void
		{
			_bmColor = new Bitmap(_kv2Manager.colorFrameBmd, PixelSnapping.AUTO, true);
			_bmDepth = new Bitmap(_kv2Manager.depthFrameBmd, PixelSnapping.AUTO, true);
			_bmBodyIndexFrame = new Bitmap(_kv2Manager.bodyIndexFrameBmd, PixelSnapping.AUTO, true);
			
			_bmDepthFrameMappedToColorSpace = new Bitmap(_kv2Manager.depthFrameMappedToColorSpaceBmd, PixelSnapping.AUTO, true);
			_bmBodyIndexFrameMappedToColorSpace = new Bitmap(_kv2Manager.bodyIndexFrameMappedToColorSpaceBmd, PixelSnapping.AUTO, true);
			
			_bmColor.visible = _kv2Config.enableColorFrame;
			_bmDepth.visible = _kv2Config.enableDepthFrame;
			_bmBodyIndexFrame.visible = _kv2Config.enableBodyIndexFrame;
			
			_bmDepthFrameMappedToColorSpace.visible = _kv2Config.enableDepthFrameMappingToColorSpace;
			_bmBodyIndexFrameMappedToColorSpace.visible = _kv2Config.enableBodyIndexFrameMappingToColorSpace;
			
			addChild(_bmColor);
			addChild(_bmBodyIndexFrameMappedToColorSpace);
			addChild(_bmDepth);
			addChild(_bmBodyIndexFrame);			
		}
		
		private function initGraphics():void
		{
			_tmpPoint = new Point();
			_drawSprite = new Sprite();
			_draw = _drawSprite.graphics;
			addChild(_drawSprite);
		}
		
		private function stop():void
		{		
			if (_kv2Manager)
				_kv2Manager.stop();		
		}
		
		private function initStats():void
		{
			//addChild(_stats);
		}
		
		private function initTrackers():void
		{	
			figureGestureTracking = new OneDollarGestureTracking();
			figureGestureTracking.addEventListener(TrackerEvent.GESTURE_TRACK, trackerHandler);
			addChild(figureGestureTracking);
			
			partialGestureTracking = new PartialGestureTracking();
			partialGestureTracking.registerGesture(new HandUpHeadGesture(KV2Joint.JointType_HandLeft));
			partialGestureTracking.registerGesture(new HandUpHeadGesture(KV2Joint.JointType_HandRight));
			partialGestureTracking.registerGesture(new TwoFingersGesture(KV2Joint.JointType_HandLeft));
			partialGestureTracking.registerGesture(new TwoFingersGesture(KV2Joint.JointType_HandRight));
			
			partialGestureTracking.addEventListener(TrackerEvent.GESTURE_TRACK, trackerHandler, false);
			addChild(partialGestureTracking);
		}
		
		private function trackerHandler(e:TrackerEvent):void
		{
			if (e.type == TrackerEvent.GESTURE_TRACK)
			{					
				if (e.getGesture().getType() != Gesture.FINGERS_ABORT)
				{
					partialGestureTracking.flushAll();
					figureGestureTracking.flushAll();
					TweenLite.killDelayedCallsTo(pauseCompleteHandler);
					TweenLite.delayedCall(GESTURE_PAUSE_TIME, pauseCompleteHandler);
					gestureUpdate = false;
				}			
			}				
		}
		
		private function pauseCompleteHandler():void 
		{			
			gestureUpdate = true;		
		} 		
		
		public function update():void
		{
			userCount = 0;
			rightHand.setActive(false);
			rightHand.setActive(false);
			
			if (_kv2Manager.updateImages() == KV2Code.FAIL)
				return;		
			
			if (_kv2Manager.updateBodies() != KV2Code.FAIL)
			{							
				var bodies : Vector.<KV2Body> = _kv2Manager.bodies; 
				var body   : KV2Body;				
				var joints : Vector.<KV2Joint>;
				var joint  : KV2Joint;				
				var p 	   : Point;		
				var rHandPosition : Vector3D, lHandPosition : Vector3D, headPosition : Vector3D;			
				
				var trackedBodies : Vector.<KV2Body> = new Vector.<KV2Body>();
				
				for (var i:int = 0; i < bodies.length; ++i)								
					if (bodies[i].tracked)
						trackedBodies.push(bodies[i]);					
				
				if (!trackedBodies || trackedBodies.length == 0)
				{
					userCount = 0;
					return;
				}
					
				userCount = trackedBodies.length;
				
				if (trackedBodies.length == 1)
					body = trackedBodies[0];
				else //if (trackedIDcolor == -1)							
					body = getClosestBody(trackedBodies);			
				
				trackedIDcolor = body.color;								
				joints = body.joints;
				JointHelper.createJointMap(joints);
				
				var handRight:KV2Joint = JointHelper.findJoint(KV2Joint.JointType_HandRight);
				var handLeft:KV2Joint = JointHelper.findJoint(KV2Joint.JointType_HandLeft);					
				
				lHandPosition = handLeft.cameraSpacePoint;
				p = getHandXY(handLeft.cameraSpacePoint);							
				leftHand.setGrip(body.handLeftState == KV2Body.HandState_Closed);
				leftHand.setActive(true);							
				leftHand.setPosition(p.x, p.y, handLeft.cameraSpacePoint.z);
				
				
				rHandPosition = handRight.cameraSpacePoint;
				p = getHandXY(handRight.cameraSpacePoint);		
				rightHand.setGrip(body.handRightState == KV2Body.HandState_Closed);					
				rightHand.setActive(true);
				rightHand.setPosition(p.x, p.y, handRight.cameraSpacePoint.z);				
					
				if (gestureUpdate)
				{
					figureGestureTracking.update(body);
					partialGestureTracking.update(body);	
				}	
			}
		}
		
		private function getClosestBody(trackedBodies:Vector.<KV2Body>):KV2Body 
		{
			var closestIndex:uint = 0;
			var spinMinZ:Number = Number.MAX_VALUE;
			
			for (var i:int = 0; i < trackedBodies.length; i++) 
			{
				var spin:KV2Joint = JointHelper.findJoint(KV2Joint.JointType_SpineMid);
				if (spin.cameraSpacePoint.z < spinMinZ)
				{
					spinMinZ = spin.cameraSpacePoint.z;
					closestIndex = i;
				}
			}
			
			return trackedBodies[closestIndex];
		}
		
		private function drawHand(joint:KV2Joint, body:KV2Body):void
		{
			var p:Point = _tmpPoint;
			p.x = joint.depthSpacePoint.x;
			p.y = joint.depthSpacePoint.y;
			var handRadius:Number = 10;
		}
		
		private function getHandColor(body:KV2Body):uint
		{
			var color:uint = 0x00ff00;
			
			if (body.handLeftState == KV2Body.HandState_Closed)
				color = 0xff0000;
			
			if (body.handLeftState == KV2Body.HandState_Lasso)
				color = 0xffff00;
			
			return color;
		}
		
		private function getHandXY(point : Vector3D):Point 
		{
			var _x:String = Tool.map(point.x, -0.2, 0.2, 0, 1920).toFixed(2);
			var _y:String = Tool.map(point.y, 0.1, 0.4, 1020, 0).toFixed(2);
			var p : Point = new Point(int(_x), int(_y));	
			return p;
		}
		
		public function getUserCount():uint
		{
			return userCount;
		}
		
		public function getLeftHand():KinectHand
		{
			return leftHand;
		}
		
		public function getRightHand():KinectHand
		{
			return rightHand;
		}		
	}
}
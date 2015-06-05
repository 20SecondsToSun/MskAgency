package app.services.interactive
{
	import app.contoller.events.InteractiveRemoteEvent;
	import app.view.handsview.HandType;
	import app.view.utils.Tool;
	import com.tastenkunst.airkinectv2.KV2Body;
	import com.tastenkunst.airkinectv2.KV2Code;
	import com.tastenkunst.airkinectv2.KV2Config;
	import com.tastenkunst.airkinectv2.KV2Joint;
	import com.tastenkunst.airkinectv2.KV2Manager;
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
		
		private var overHeadEvent:InteractiveRemoteEvent 	= new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_OVER_HEAD);
		private var underHeadEvent:InteractiveRemoteEvent 	= new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_UNDER_HEAD);
		

		public function KinectV2()
		{
			_kv2Config = new KV2Config();
			_kv2Manager = new KV2Manager();					
		}
		
		public function init() : void 
		{
			_kv2Config.enableColorFrame = true;
			_kv2Config.enableDepthFrame = true;
			_kv2Config.enableInfraredFrame = false;
			_kv2Config.enableLongExposureInfraredFrame = false;
			_kv2Config.enableBodyIndexFrame = true;
			_kv2Config.enableBodyFrame = true;
			
			_kv2Config.enableColorFrameMappingToDepthSpace = true;
			_kv2Config.enableDepthFrameMappingToColorSpace = false;
			_kv2Config.enableBodyIndexFrameMappingToColorSpace = true;			

			initKinect();
		}
		
		public function stop() : void 
		{	
			_kv2Manager.stop();
		}
		
		public function initKinect() : void
		{
			var started : int = _kv2Manager.start(_kv2Config);

			if (started == KV2Code.OK) 
				onKinectStarted();
			else
				onKinectFailedToStarted();			
		}
		
		protected function onKinectStarted() : void 
		{
			leftHand = new KinectHand(HandType.LEFT);		
			rightHand = new KinectHand(HandType.RIGHT);	
		}	
		
		private function onKinectFailedToStarted():void 
		{
			
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
				var rHandPosition, lHandPosition, headPosition : Vector3D;
				
				for (var i:int = 0; i < bodies.length; ++i)
				{
					body = bodies[i];
				
					if (body.tracked) 
					{						
						userCount++;						
						joints = body.joints;
						
						for (var j:int = 0; j < joints.length; ++j) 						
						{
							joint = joints[j];							
							
							if (joint.jointType == KV2Joint.JointType_HandLeft)
							{	
								lHandPosition = joint.cameraSpacePoint;
								p = getHandXY(joint.cameraSpacePoint);							
								leftHand.setGrip(body.handLeftState == KV2Body.HandState_Closed);// && body.handLeftConfidence == KV2Body.TrackingConfidence_High);
								leftHand.setActive(true);							
								leftHand.setPosition(p.x, p.y, joint.cameraSpacePoint.z);								
							}							
							else if (joint.jointType == KV2Joint.JointType_HandRight)
							{
								rHandPosition = joint.cameraSpacePoint;
								p = getHandXY(joint.cameraSpacePoint);		
								rightHand.setGrip(body.handRightState == KV2Body.HandState_Closed);// && body.ha == KV2Body.TrackingConfidence_High);							
								rightHand.setActive(true);
								rightHand.setPosition(p.x, p.y, joint.cameraSpacePoint.z);
							}
							else if (joint.jointType == KV2Joint.JointType_Head)
							{
								headPosition = joint.cameraSpacePoint;
							}
						}					
						
						if (rHandPosition.y > headPosition.y + 0.15 || lHandPosition.y > headPosition.y + + 0.15)
						{
							dispatchEvent(overHeadEvent);
						}
						else
						{
							dispatchEvent(underHeadEvent);
						}
					}
				}
			}
		}		
		
		private function getHandXY(point : Vector3D):Point 
		{
			var _x:String = Tool.map(point.x, -0.6, 0.6, 0, 1920).toFixed(1);
			var _y:String = Tool.map(point.y, 0.3, 0.6, 1020, 0).toFixed(1);
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
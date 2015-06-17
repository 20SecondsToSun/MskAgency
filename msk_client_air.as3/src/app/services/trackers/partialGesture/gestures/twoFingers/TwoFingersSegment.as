package app.services.trackers.partialGesture.gestures.twoFingers
{
	import app.services.trackers.JointHelper;
	import com.tastenkunst.airkinectv2.KV2Body;
	import com.tastenkunst.airkinectv2.KV2Joint;
	import app.services.trackers.partialGesture.GesturePartResult;
	import app.services.trackers.partialGesture.gestures.IGestureSegment;
	
	/**
	 * ...
	 * @author 20secondstosun
	 */
	public class TwoFingersSegment implements IGestureSegment
	{
		private var jointType:int;
		
		public function TwoFingersSegment(jointType: int)
		{
			this.jointType = jointType;
		}
		
		public function update(body:KV2Body):int
		{
			var hand:KV2Joint = JointHelper.findJoint(jointType);
			var head:KV2Joint = JointHelper.findJoint(KV2Joint.JointType_Head);
			var spine:KV2Joint = JointHelper.findJoint(KV2Joint.JointType_SpineShoulder);
			var spineDiffZ:Number = spine.cameraSpacePoint.z - hand.cameraSpacePoint.z;	
			
			
			if ((jointType == KV2Joint.JointType_HandLeft && body.handLeftState == KV2Body.HandState_Lasso)
				|| (jointType == KV2Joint.JointType_HandRight && body.handRightState == KV2Body.HandState_Lasso))
			{
				if (spineDiffZ > 0.5 && (hand.depthSpacePoint.y > head.depthSpacePoint.y))			
					return GesturePartResult.SUCCEEDED;	
			}				
			
			return GesturePartResult.FAILED;
		}
	}
}
package app.services.trackers.partialGesture.gestures.handBlink
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
	public class HandBlinkLeftSegment2 implements IGestureSegment
	{
		public function update(joints:Vector.<KV2Joint>, body:KV2Body):int
		{
			var hand:KV2Joint = JointHelper.findJoint(joints, KV2Joint.JointType_HandLeft);
			
			if (body.handLeftState == KV2Body.HandState_Closed && body.handLeftConfidence == KV2Body.TrackingConfidence_High)
				return GesturePartResult.SUCCEEDED;
			
			return GesturePartResult.FAILED;
		}
	}
}
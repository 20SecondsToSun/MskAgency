package app.services.trackers.partialGesture.gestures.handUpHead 
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
	public class HandUpHeadSegment implements IGestureSegment
	{
		private static const DIFF:Number = 50;
		private var jointType:int;	
		
		public function HandUpHeadSegment(jointType:int)
		{
			this.jointType = jointType;
		}
		
		public function update(body:KV2Body):int
		{
			var hand:KV2Joint = JointHelper.findJoint(jointType);
			var head:KV2Joint = JointHelper.findJoint(KV2Joint.JointType_Head);		
			if (DIFF < head.depthSpacePoint.y - hand.depthSpacePoint.y)			
				return GesturePartResult.SUCCEEDED;			
			
			return GesturePartResult.FAILED;
		}		
	}
}
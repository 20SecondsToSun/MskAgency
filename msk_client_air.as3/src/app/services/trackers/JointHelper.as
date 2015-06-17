package app.services.trackers
{
	import com.tastenkunst.airkinectv2.KV2Joint;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author 20secondstosun
	 */
	public class JointHelper
	{		
		private static var jointMap:Dictionary = new Dictionary();
		
		public static function findJoint(jointType:int):KV2Joint
		{		
			return jointMap[jointType];
		}
		
		public static function createJointMap(joints:Vector.<KV2Joint>):void
		{
			for (var j:int = 0, m:int = joints.length; j < m; ++j)
				jointMap[joints[j].jointType] = joints[j];
		}	
		
		public static function handOverHead(hand:KV2Joint, head:KV2Joint):Boolean 
		{			
			return (head.depthSpacePoint.y > hand.depthSpacePoint.y);
		}
		
		public static function handUnderJoint(hand:KV2Joint, spine:KV2Joint):Boolean 
		{			
			return (spine.depthSpacePoint.y < hand.depthSpacePoint.y);
		}
	}
}
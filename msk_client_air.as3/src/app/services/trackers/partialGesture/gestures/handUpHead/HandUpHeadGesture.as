package app.services.trackers.partialGesture.gestures.handUpHead
{
	import app.services.trackers.Gesture;
	import app.services.trackers.partialGesture.gestures.TimeFixedGesture;
	import com.tastenkunst.airkinectv2.KV2Joint;
	
	/**
	 * ...
	 * @author 20secondstosun
	 */
	public class HandUpHeadGesture extends TimeFixedGesture
	{		
		public function HandUpHeadGesture(hand:int)
		{
			FRAMES_FOR_DETECT = 20;
			
			gesture = new Gesture(Gesture.HAND_OVER_HEAD);
			gesture.setHandType(hand);
			
			segment = new HandUpHeadSegment(hand);
		}
	}
}
package app.services.trackers.partialGesture.gestures.twoFingers
{
	import app.services.trackers.partialGesture.gestures.TimeFixedGesture;
	import app.services.trackers.Gesture;
	import app.view.handsview.HandType;
	import com.tastenkunst.airkinectv2.KV2Joint;
	
	/**
	 * ...
	 * @author 20secondstosun
	 */
	public class TwoFingersGesture extends TimeFixedGesture
	{	
		public function TwoFingersGesture(hand:int)
		{
			FRAMES_FOR_DETECT = 1;
			
			gesture = new Gesture(Gesture.TWO_FINGERS);
			gesture.setHandType(hand);
			
			segment = new TwoFingersSegment(hand);
		}		
	}
}
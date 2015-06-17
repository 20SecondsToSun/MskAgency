package app.services.trackers.partialGesture.gestures.handBlink
{
	import app.services.trackers.partialGesture.gestures.PartialGesture;
	import app.services.trackers.Gesture;
	
	/**
	 * ...
	 * @author 20secondstosun
	 */
	public class HandBlinkLeftGesture extends PartialGesture
	{	
		public function HandBlinkLeftGesture()
		{
			gesture = new Gesture(Gesture.HAND_BLINK);			
			segments.push(new HandBlinkLeftSegment1());
			segments.push(new HandBlinkLeftSegment2());
			segments.push(new HandBlinkLeftSegment1());
			segments.push(new HandBlinkLeftSegment2());
		}		
	}
}
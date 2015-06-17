package app.services.trackers.partialGesture
{
	import app.services.trackers.Gesture;
	import app.services.trackers.partialGesture.gestures.IGesture;
	import com.tastenkunst.airkinectv2.KV2Body;
	import com.tastenkunst.airkinectv2.KV2Joint;
	import flash.display.Sprite;
	import app.services.trackers.TrackerEvent;
	import org.gestouch.gestures.ZoomGesture;
	
	public class PartialGestureTracking extends Sprite
	{
		private var gestures:Vector.<IGesture> = new Vector.<IGesture>();
		
		public function registerGesture(gesture:IGesture):void
		{
			gestures.push(gesture);
		}
		
		public function update(body:KV2Body):void
		{
			for (var i:int = 0; i < gestures.length; i++)
			{
				var result:int = gestures[i].update(body);
				//trace("---------  ", result, gestures[i].getGesture().getType());
				if ( result == GesturePartResult.SUCCEEDED)
				{					
					gestures[i].getGesture().setPrevResult(GesturePartResult.SUCCEEDED);
					dispatchEvent(new TrackerEvent(gestures[i].getGesture(), TrackerEvent.GESTURE_TRACK));
				}
				else if (gestures[i].getGesture().getType() == Gesture.TWO_FINGERS)
				{					
					//if (gestures[i].getGesture().getPrevResult() == GesturePartResult.SUCCEEDED)
					{
						var gesture:Gesture = new Gesture(Gesture.FINGERS_ABORT);
						gesture.setHandType(gestures[i].getGesture().getHandType());
						dispatchEvent(new TrackerEvent(gesture, TrackerEvent.GESTURE_TRACK));
					}
				}				
					//g//estures[i].getGesture().setPrevResult(GesturePartResult.FAILED);
			}
			//else
			//	gestures[i].getGesture().setPrevResult(GesturePartResult.FAILED);*/
		}
		
		public function flushAll():void
		{
			for (var i:int = 0; i < gestures.length; i++)
				gestures[i].flush();
		}
	}
}
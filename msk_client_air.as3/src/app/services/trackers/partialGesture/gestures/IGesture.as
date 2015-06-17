package app.services.trackers.partialGesture.gestures 
{
	import app.services.trackers.Gesture;
	import com.tastenkunst.airkinectv2.KV2Body;
	import com.tastenkunst.airkinectv2.KV2Joint;
	/**
	 * ...
	 * @author 20secondstosun
	 */
	public interface IGesture 
	{		
		function update(body:KV2Body):int;  
		function getGesture():Gesture;
		function flush():void;		
	}
}
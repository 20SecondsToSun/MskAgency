package app.services.trackers.partialGesture.gestures 
{
	import com.tastenkunst.airkinectv2.KV2Body;
	import com.tastenkunst.airkinectv2.KV2Joint;
	/**
	 * ...
	 * @author 20secondstosun
	 */
	
	public interface IGestureSegment
    {
        function update(body:KV2Body):int;       
    }
}
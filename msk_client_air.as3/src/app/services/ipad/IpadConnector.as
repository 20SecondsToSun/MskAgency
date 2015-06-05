package app.services.ipad
{
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class IpadConnector extends NetConnection
	{
		private var SERVER:String = 'rtmfp://p2p.rtmfp.net/';
		private var DEVKEY:String = 'f2e7f2134a74f2501a683157-1d2c148a2bf2'
		public var groupspec:GroupSpecifier;
		public var netGroup:NetGroup;
		private var events:Function;
		
		public function IpadConnector(_events:Function = null)
		{
			events = _events;
			addEventListener(NetStatusEvent.NET_STATUS, netStatus);
			connect(SERVER + DEVKEY);
		}
		
		private function netStatus(event:NetStatusEvent):void
		{
			if (events != null)
				events(event);
			
			switch (event.info.code)
			{
			case 'NetConnection.Connect.Success': 
				initNetGroup();
				break;
			
			case 'NetGroup.Neighbor.Connect': 
				connectUser(event.info);
				break;
			
			case 'NetGroup.Connect.Success': 
				trace(event.info, event.info.peerID);
				break;
			}
		}
		
		public function sendData(data:Object):void
		{
			if (netGroup)
			{
				data.hash = getTimer();
				netGroup.post(data);
			}			
		}
		
		private function initNetGroup():void
		{
			groupspec = new GroupSpecifier("test");
			groupspec.serverChannelEnabled = true;
			groupspec.postingEnabled = true;
			groupspec.routingEnabled = true;			
			groupspec.ipMulticastMemberUpdatesEnabled = true;
			
			netGroup = new NetGroup(this, groupspec.groupspecWithAuthorizations());
			netGroup.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
		}
		
		private function connectUser(obj:Object):void
		{
			
		}
	}
}
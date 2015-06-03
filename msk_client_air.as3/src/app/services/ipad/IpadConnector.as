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
			//trace("IPAD::::::", event.info.code);
			if (events != null) events(event);
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
				  // this.dispatchEvent(new AppEvent(AppEvent.P2P_INIT, {}));
				  // sendPost({message: 'test'});
				   break;
			
			/*
			   case 'NetGroup.Neighbor.Disconnect':
			   disconnectUser(event.info);
			   break;
			
			   case 'NetStream.Connect.Rejected':
			   this.dispatchEvent(new AppEvent(AppEvent.ERROR_CONNECTION, {code: event.info.code}));
			   break;
			
			   case 'NetGroup.Posting.Notify':
			   trace(event.info.message);
			 break;*/
			}
		}
		
		public function sendData(data:Object):void
		{
			//return;
			if (!netGroup) return;	
			//trace("/----------------------POST IPAD-------------------/", data.type);
			data.hash = getTimer();
			netGroup.post(data);
		}
		private function initNetGroup():void
		{
			groupspec = new GroupSpecifier("test");
			groupspec.serverChannelEnabled = true; 
			groupspec.postingEnabled = true;
			groupspec.routingEnabled = true;
			
			groupspec.ipMulticastMemberUpdatesEnabled = true;
            //groupspec.addIPMulticastAddress("225.225.0.1:30000");
			
			netGroup = new NetGroup(this, groupspec.groupspecWithAuthorizations());
			netGroup.addEventListener(NetStatusEvent.NET_STATUS, netStatus);			
		}
		
		private function connectUser(obj:Object):void
		{
			//trace( "USER::::::::",obj.peerID);
		}
	}
}
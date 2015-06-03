package app.view.utils.video
{
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	public class VideoAdapt extends EventDispatcher
	{
		// PUBLIC VARIABLES
		public var info:MetaInfo;
		
		// PRIVATE VARIABLES
		
		private var videoURL:String;
		private var _stream:NetStream;
		private var connection:NetConnection;
		
		private var timer:Timer;
		private var playing:Boolean = false;
		
		private var volume:Number = 0.5;
		
		private var type:String = "video";
		
		// PUBLIC FUNCTIONS
		public function VideoAdapt()
		{
			timer = new Timer(50);
			timer.addEventListener(TimerEvent.TIMER, loadProgressListener);
		}
		
		public function init(str_URL:String):void
		{
			//trace("INIT VIDEO = " + str_URL);
			info = null;
			type = "video";
			videoURL = str_URL;
			connection = new NetConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			connection.connect(null);
		
		}
		
		public function initBroadcast(str_URL:String):void
		{
			//trace("INIT VIDEO broadcast = " + str_URL);
			info = null;
			type = "broadcast";	
			
			videoURL = "11058.sdp";
			
			
			
			var params:Array = str_URL.split("/");
			
			for (var i:int = 0; i < params.length; i++) 
			{
				if (params[i].indexOf(".sdp") != -1)
				{
					videoURL = params[i];
					break;
				}
			}
		//	trace("VIDEO URL!!!!!!!", videoURL);
			
			//videoURL = "rtp_m24_sq";
			//	rtmp://vgtrk.cdnvideo.ru"	
			connection = new NetConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);			
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			//connection.connect("rtmp://moscowmedia.cdnvideo.ru/moscowmedia-live/");
			//http://hls.ccube.ru/showmepro/033-136-731.m3u8
			//connection.connect("rtmp://vgtrk.cdnvideo.ru/rr2/?auth=vh&cast_id=1661/");
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public function get stream():NetStream
		{
			if (!_stream)
			{
				throw new Error("Потока не существует");
				return null
			}
			return _stream;
		}
		
		public function kill():void
		{
			connection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
			_stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			
			timer.stop();
			
			if (_stream)
			{
				_stream.close();
				connection.close()
				playing = false;
			}
		}
		
		// PRIVATE FUNCTIONS
		private function netStatusHandler(event:NetStatusEvent):void
		{
			//trace(event.info.code)
			switch (event.info.code)
			{
				case "NetConnection.Connect.Success": 
				{
					connectStream();
					dispatchEvent(new AdaptVideoEvent(AdaptVideoEvent.INIT));
					break;
				}
				case "NetStream.Play.StreamNotFound": 
				{
					trace("Unable to locate video: " + videoURL);
					break;
				}
				case "NetStream.Play.Stop": 
				{
					dispatchEvent(new AdaptVideoEvent(AdaptVideoEvent.VIDEO_COMPLETE));
					break;
				}
			}
		}
		
		private function connectStream():void
		{
			_stream = new NetStream(connection);// , NetStream.DIRECT_CONNECTIONS);
			_stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			
			var customClient:Object = new Object();
			customClient.onMetaData = on_MetaData;			
			_stream.client = customClient;
			
			timer.start();
			//_stream.videoSampleAccess = true;
			//trace("PLAY!!!");
			//_stream.play(videoURL);
			_stream.play(videoURL);
			_stream.bufferTime = 3;
			if (type == "video")
				_stream.pause();
		}
		
		private function on_MetaData(flvMetaData:Object):void
		{			
			info = new MetaInfo();
			info.height = flvMetaData.height;
			info.width = flvMetaData.width;
			info.duration = flvMetaData.duration;
			
			dispatchEvent(new AdaptVideoEvent(AdaptVideoEvent.METADATA));
		}
		
		private function loadProgressListener(e:TimerEvent):void
		{
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _stream.bytesLoaded, _stream.bytesTotal));
			
			if ((_stream.bytesLoaded == _stream.bytesTotal) && (_stream.bytesTotal > 0))
			{
				timer.stop();
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			trace("securityErrorHandler: " + event);
		}
		
		private function asyncErrorHandler(event:AsyncErrorEvent):void
		{
			// ignore AsyncErrorEvent events.
		}
		
		public function play(second:Number = 0):void
		{			
			if (type == "video")
			{
				stream.bufferTime = 5;
				_stream.play(videoURL + "?start=" + Math.floor(second));
				_stream.resume();
				
				playing = true;
				//mute();
			}
		
		}
		
		public function pause():void
		{
			_stream.pause();
			playing = false;
		}
		
		public function resume():void
		{
			_stream.resume();
			playing = true;
		}
		
		public function isPlaying():Boolean
		{
			return playing;
		}
		
		public function currentSecond():Number
		{
			return _stream.time;
		}
		
		public function setVolume(vol:Number = 1):void
		{
			volume = vol;
			var audioTransform:SoundTransform = new SoundTransform(vol);
			_stream.soundTransform = audioTransform;
		
		}
		
		public function unMute():void
		{
			var audioTransform:SoundTransform = new SoundTransform(volume);
			_stream.soundTransform = audioTransform;
		
		}
		
		public function mute():void
		{
			var audioTransform:SoundTransform = new SoundTransform(0);
			_stream.soundTransform = audioTransform;
		}
		
		public function isMuted():Boolean
		{
			if (!_stream.soundTransform.volume)
				return true;
			else
				return false;
		}
	}

}
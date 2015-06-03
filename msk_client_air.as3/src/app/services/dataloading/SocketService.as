package app.services.dataloading
{
	import air.net.SecureSocketMonitor;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.InteractiveServiceEvent;
	import app.contoller.events.ServerErrorEvent;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class SocketService extends Actor implements ISocketService
	{
		private var socket:Socket;
		private var socketMonitor:SecureSocketMonitor;
		private var stream:URLStream;
		private var request:URLRequest;
		private static const ZLIB_CODE:String = "CWS";
		private var isBadRequest:Boolean = false;
		
		public function start():void
		{			
			if (!stream)
			{
				stream = new URLStream();
				request = new URLRequest("http://mskagency.ru/events/");
				configureListeners(stream);
				tryStart();
			}
			else if (!stream.connected)
			{				
				configureListeners(stream);
				tryStart();
			}			
		}
		
		public function tryStart():void
		{
			try
			{
				stream.load(request);
			}
			catch (error:Error)
			{
				trace("Unable to load requested URL.");
			}
		}
		public function stop():void
		{			
			if (stream && stream.connected)
			{
				removeListeners(stream);
				stream.close();
			}
			
		}
		public function resume():void
		{
			configureListeners(stream);
			tryStart();
		}
		
		private function configureListeners(dispatcher:EventDispatcher):void
		{
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		private function removeListeners(dispatcher:EventDispatcher):void
		{
			dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
			dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.removeEventListener(Event.OPEN, openHandler);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		private function parseHeader():void
		{			
			var ba:ByteArray = new ByteArray();
			stream.readBytes(ba);		
			var str:String =  ba.toString();
			
			var i:int = str.search("material_published");		
			if (i == -1)
			{
				trace("no materials came");
			}
			else
			{
				var substr:String = str.substr(i);
				//trace("substr======", substr);
				var n:int = substr.search("material_id");
				var substr1:String = substr.substr(n + ("material_id").length + 2);	
				//trace("substr1======", substr1);
				var arr:Array = substr1.split(",");
				trace("materials nomer  ", arr[0]);
				dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ONE_NEW, true, false, arr[0]));
			}	
		
			stream.close();
			stream.load(request);	
			
			loader_success();		
		}
		
		private function loader_success():void
		{
			if (!isBadRequest) return;
			
			dispatch(new InteractiveServiceEvent(InteractiveServiceEvent.START_INTERACTION));
			TweenLite.killDelayedCallsTo( reconnect);
			
			dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_COMPLETE));	
			
			isBadRequest = false;
		}
		
		private function isCompressed():Boolean
		{
			return (stream.readUTFBytes(3) == ZLIB_CODE);
		}
		
		private function completeHandler(event:Event):void
		{
			//trace("completeHandler: " + event);
			parseHeader();
		}
		
		private function openHandler(event:Event):void
		{
			//trace("openHandler: " + event);
		}
		
		private function progressHandler(event:Event):void
		{
			// trace("progressHandler: " + event);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			// trace("securityErrorHandler: " + event);
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void
		{
			// trace("httpStatusHandler: " + event);
		}		
		
		private function ioErrorHandler(e:IOErrorEvent):void
		{
			if (isBadRequest == false)
			{
				dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_FAILED));	
				dispatch(new InteractiveServiceEvent(InteractiveServiceEvent.STOP_INTERACTION));
			}			
				
			removeListeners(stream);
			stream.close();
			isBadRequest = true;
			TweenLite.delayedCall(2, reconnect);				
		}
		
		private function reconnect():void 
		{
			start();
		}		
	}
}
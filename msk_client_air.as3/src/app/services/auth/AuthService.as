package app.services.auth
{
	import app.contoller.events.AuthenticationEvent;
	import app.contoller.events.InteractiveServiceEvent;
	import app.contoller.events.ServerErrorEvent;
	import app.model.config.IConfig;
	import app.model.datauser.IUser;
	import app.model.datauser.Login;
	import app.model.datauser.Password;
	import app.model.datauser.server.Server;
	import app.model.datauser.User;
	import app.model.StringVO;
	import app.services.dataloading.IDataLoadingService;
	import com.adobe.utils.DateUtil;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import org.robotlegs.mvcs.Actor;
	
	public class AuthService extends Actor implements IAuthService
	{
		private var isBadRequest:Boolean = false;
		
		[Inject]
		public var server:Server;
		
		[Inject]
		public var login:Login;
		
		[Inject]
		public var password:Password;
		
		[Inject]
		public var user:IUser;
		
		[Inject]
		public var conf:IConfig;
		
		public function start():void
		{
			
			
			
			
			var file:File = File.desktopDirectory;
			file = file.resolvePath("login.txt");
			
			var fileStream:FileStream = new FileStream();
			fileStream.addEventListener(Event.COMPLETE, processData);
			fileStream.openAsync(file, FileMode.READ);
			
			var data:Object;
			function processData(event:Event):void
			{
				//data = JSON.parse(fileStream.readUTFBytes(fileStream.bytesAvailable));
				fileStream.close();
					
				user.login = "popov";// data.data[0].login as String;
				user.password = "admiral";// data.data[0].pass as String;
				user.stendID = "1";// data.data[0].id as String;
				
				var loader:URLLoader = new URLLoader();
				var request:URLRequest = new URLRequest(server + "/login");
				request.method = URLRequestMethod.POST;
				//request.manageCookies = false;
				
				var variables:URLVariables = new URLVariables();
				variables.login = user.login ;
				variables.password = user.password;
				
				trace("server:::::::::::",server);
				trace("LOGIN:::::::::::", user.login, user.password);
				// request.requestHeaders.push(new URLRequestHeader("Cookie", ""));
				request.data = variables;
				
				loader.addEventListener(Event.COMPLETE, on_complete_auth);
				loader.addEventListener(IOErrorEvent.IO_ERROR, on_error_handler);
				loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, httpHandler);
				
				loader.load(request);			
			}
		}
		
		public function startIpad():void
		{
			//dispatch(new AuthenticationEvent(AuthenticationEvent.AUTH_SUCCESS));
			trace("START IPAD====", server, login, password);
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(server + "/login");
			request.method = URLRequestMethod.POST;
			
			var variables:URLVariables = new URLVariables();
			variables.login = login;
			variables.password = password;
			// request.requestHeaders.push(new URLRequestHeader("Cookie", ""));
			request.data = variables;
			
			loader.addEventListener(Event.COMPLETE, on_complete_auth);
			loader.addEventListener(IOErrorEvent.IO_ERROR, on_error_handler);
			loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, httpHandler);
			
			loader.load(request);
		
		}
		
		
		private function httpHandler(event:HTTPStatusEvent):void
		{
			var urlHeader:URLRequestHeader = new URLRequestHeader();
			var dateString:String;
			
			for (var i:int = 0; i < event.responseHeaders.length; i++)
				if (event.responseHeaders[i].name == "Date")
				{
					dateString = event.responseHeaders[i].value;
					break;
				}
			
			var date:Date = DateUtil.parseRFC822(dateString);
			conf.init(date);
		}
		
		private function on_error_handler(e:IOErrorEvent):void
		{
			if (isBadRequest == false)
			{
				dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_FAILED));
				dispatch(new InteractiveServiceEvent(InteractiveServiceEvent.STOP_INTERACTION));
			}
			retry();
		}
		
		private function retry():void
		{
			TweenLite.delayedCall(2, reconnect);
			isBadRequest = true;
		}
		
		private function reconnect():void
		{
			start();
		}
		
		private function on_complete_auth(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			var data:Object = JSON.parse(loader.data);
			
			if (data.success)
			{
				user.id = data.data.id;
				user.login = data.data.login;
				user.role_id = data.data.role_id;
				user.name = data.data.name;
				// trace("ERROR AUTH:::",   user.id	,  user.login);
				for each (var item:String in data.data.permissions)
					user.permissions.push(item);
				
				dispatch(new AuthenticationEvent(AuthenticationEvent.AUTH_SUCCESS));
				loader_success();
			}
			else
			{
				//  trace("ERROR AUTH:::",  data.error.code, data.error.message);
				if (isBadRequest == false)
					dispatch(new ServerErrorEvent(ServerErrorEvent.AUTH_FAILED, data.error.code, data.error.message));
				
				retry();
			}
		}
		
		private function loader_success():void
		{
			if (!isBadRequest)
				return;
			
			dispatch(new InteractiveServiceEvent(InteractiveServiceEvent.START_INTERACTION));
			TweenLite.killDelayedCallsTo(reconnect);
			
			dispatch(new ServerErrorEvent(ServerErrorEvent.REQUEST_COMPLETE));
			
			isBadRequest = false;
		}
	
	}
}
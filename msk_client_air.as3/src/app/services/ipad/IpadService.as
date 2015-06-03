package app.services.ipad
{
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.InteractiveRemoteEvent;
	import app.contoller.events.IpadEvent;
	import app.model.config.IConfig;
	import app.model.datauser.IUser;
	import app.model.datauser.Login;
	import app.model.datauser.Password;
	import app.model.materials.Fact;
	import app.model.materials.Material;
	import app.services.interactive.IInteractiveControlService;
	import app.view.utils.Tool;
	import com.greensock.TweenLite;
	import flash.events.NetStatusEvent;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import org.robotlegs.mvcs.Actor;
	
	public class IpadService extends Actor implements IIpadService
	{
		[Inject]
		public var config:IConfig;
		
		[Inject]
		public var user:IUser;
		
		[Inject]
		public var icontrolServeice:IInteractiveControlService;
		
		private var ipadConnector:IpadConnector
		private var isAllowReception:Boolean;
		
		
		private var _isPause:Boolean = false;	
		
		private const TIME_TO_BACK:int = 60 * 10;
		
		
		private var _isIpadConnect:Boolean = false;
		public function set isIpadConnect(value:Boolean):void 
		{
			_isIpadConnect = value;
		}
		public function get isIpadConnect():Boolean 
		{
			return _isIpadConnect;
		}
		
		public function set isPause(value:Boolean):void
		{
			_isPause = value;
			
			if (_isPause) setCountdownTimer();
			else killCountodwnTimer();
		}
		
		private function killCountodwnTimer():void 
		{			
			TweenLite.killDelayedCallsTo(removePause);
		}
		
		private function removePause():void 
		{
			if (user.is_active)
				setCountdownTimer();
			else
			{
				dispatch(new IpadEvent(IpadEvent.PLAY));
				pauseRemove();
			}			
		}
		
		private function setCountdownTimer():void 
		{
			TweenLite.delayedCall(TIME_TO_BACK, removePause);
		}
		
		public function get isPause():Boolean
		{
			return _isPause;
		}
		
		public function start():void
		{
			ipadConnector = new IpadConnector(tracer);
		}
		
		private function tracer(event:NetStatusEvent):void
		{
			switch (event.info.code)
			{
				case 'NetConnection.Connect.Success': 
					break;
				
				case 'NetGroup.Neighbor.Connect': 
				//	sendInitInfoMessage();
					//isAllowReception = true;
					break;
				
				case 'NetGroup.Connect.Success':					
					break;
					
				case 'NetGroup.Neighbor.Disconnect': 
					// isAllowReception = false;
					break;
				
				case 'NetGroup.Posting.Notify':
					
					if (!event.info.message) return;
					
					messageHandler(event.info.message);
					
					break;
			}
		}
		
		private function sendInitInfoMessage():void
		{
			var data:Object = new Object();
			data.type = "INIT INFO";
			data.primaryScreen = user.primaryScreen;
			data.currentLocation = config.currentLocation;
			data.rubric = user.getRubric();
			data.isInteraction = icontrolServeice.isInteraction;
			data.isIpadPause = _isPause;
			data.isHandActive = false;//!!!!#changeback user.isHandActive;
			data.isUserActive = false;//!!!!#changeback user.is_active;
			data.hash = getTimer();	
			data.idIpad = user.idIpad;
			ipadConnector.sendData(data);
		}
		
		public function pauseRemove():void
		{
			if (ipadConnector == null) return;
			
			var data:Object = new Object();
			data.type = "PAUSE_REMOVE";
			data.hash = getTimer();	
			ipadConnector.sendData(data);
		}
		
		public function handLost():void
		{
			if (ipadConnector == null) return;
			
			var data:Object = new Object();
			data.type = "HAND_LOST";
			data.hash = getTimer();	
			ipadConnector.sendData(data);
		}
		
		public function handActive():void
		{
			if (ipadConnector == null) return;
			
			var data:Object = new Object();
			data.type = "HAND_ACTIVE";	
			data.hash = getTimer();	
			ipadConnector.sendData(data);
		}	
		
		public function userLost():void
		{
			if (ipadConnector == null) return;
			
			var data:Object = new Object();
			data.type = "USER_LOST";
			data.hash = getTimer();	
			ipadConnector.sendData(data);
		}
		
		public function userActive():void
		{
			if (ipadConnector == null) return;
			
			var data:Object = new Object();
			data.type = "USER_ACTIVE";	
			data.hash = getTimer();	
			ipadConnector.sendData(data);
		}		
		
		public function changeLocation():void
		{
			if (ipadConnector == null) return;	
			
			trace("==================================== SEND TO IPAFD CHANGE LOCATION ===================================", config.currentLocation);
			
			var data:Object = new Object();
			data.type = "NAVIGATION";
			data.currentLocation = config.currentLocation;
			data.hash = getTimer();	
			ipadConnector.sendData(data);
		}
		
		public function symbolsBad():void
		{
			user.ipadTryingToConnect = false;
			
			if (ipadConnector == null) return;
			
			var data:Object = new Object();
			data.type = "SYMBOLS_BAD";
			data.hash = getTimer();	
			data.idIpad = user.idIpad;
			ipadConnector.sendData(data);			
		}
		
		public function symbolsOk():void
		{
			user.ipadTryingToConnect = false;
			
			if (ipadConnector == null) return;
			
			var data:Object = new Object();
			data.type = "SYMBOLS_OK";
			data.hash = getTimer();
			data.idIpad = user.idIpad;
			ipadConnector.sendData(data);	
			
			dispatch(new IpadEvent(IpadEvent.IPAD_CONNECTING));
			
			sendInitInfoMessage();
		}
		
		public function sendShapes(data:Object):void
		{
			//trace("SEND SHAPES ++" ,  data.firstNum, data.secondNum);			
			if (ipadConnector == null) return;
			
			var data:Object = new Object();
			data.type = "SEND_SHAPES";	
			data.firstNum = data.firstNum;
			data.secondNum = data.secondNum;
			data.hash = getTimer();	
			ipadConnector.sendData(data);
		}
		public function startCommunicate():void
		{
			if (ipadConnector == null) return;
			
			var data:Object = new Object();
			data.type = "START_COMMUNICATE";	
			data.hash = getTimer();	
			ipadConnector.sendData(data);
		}
		
		public function stopCommunicate():void
		{
			if (ipadConnector == null) return;
			
			var data:Object = new Object();
			data.type = "STOP_COMMUNICATE";	
			data.hash = getTimer();	
			ipadConnector.sendData(data);
		}
		
		private function messageHandler(message:Object):void
		{
			if (!message.type)
				return;
			trace("PPPPPPPPPPPPPPPP=======================",message.type);
			switch (message.type)
			{
				case "NAVIGATION": 
					trace("========================================   NAVIGATION         ============", message.id);
					if (message.id == undefined) return;
					menuChoose(message.id);
					break;
				
				case "MATERIAL_SHOW": 
					materialShow(message.mat);
					break;
				
				case "FACT_SHOW": 
					factShow(message.fact);
					break;
				
				case "PLAY":
					dispatch(new IpadEvent(IpadEvent.PLAY));
					break;
					
				case "PAUSE":
					dispatch(new IpadEvent(IpadEvent.PAUSE));
					break;
					
				case "VOLUME":
					dispatch(new IpadEvent(IpadEvent.VOLUME, true, false, message.volume));
					break;
				
				case "CHANGE CUSTOM SCREEN": 
					changeCustomScreen(message.rubric);
					break;
				
				case "CHANGE PRIMARY SCREEN": 
					changePrimaryScreen(message.screen);
					break;
					
				case "MATERIAL_CLOSE": 
					dispatch( new ChangeLocationEvent(ChangeLocationEvent.HIDE_IPAD_POPUP));
					break;
					
				case "TRY_CONNECT": 
					if (user.ipadTryingToConnect) 
					{
						var data:Object = new Object();
						data.type = "SYMBOLS_BAD";
						data.hash = getTimer();			
						ipadConnector.sendData(data);
						
						break;
					}
					user.idIpad = message.idIpad;
					user.ipadTryingToConnect = true;
					
					if (message.stendId == user.stendID)
					{
						dispatch( new DataLoadServiceEvent(DataLoadServiceEvent.SHOW_CONNECTION_SHAPES));						
					}
					break;
					
				case "CHECK_MATCH": 
					if (message.stendId == user.stendID)
					{
						dispatch( new DataLoadServiceEvent(DataLoadServiceEvent.CHECK_MATCH, true, false, -1, null, { firstNum:message.firstNum, secondNum:message.secondNum } ));						
						//break;
					}
					break;
					
				default: 
			}
			
			//setCoundownIpadTime();			
		}
		
		private function setCoundownIpadTime():void 
		{
			TweenLite.killDelayedCallsTo(returnToMainScreen);
			TweenLite.delayedCall(30, returnToMainScreen);
			user.ipadTryingToConnect = false;
		}
		
		private function returnToMainScreen():void 
		{
			dispatch( new ChangeLocationEvent(ChangeLocationEvent.MAIN_SCREEN));
		}
		
		private function changePrimaryScreen(screen:String):void
		{
			dispatch(new IpadEvent(IpadEvent.PRIMARY_SCREEN, true, false, screen));
		}
		
		private function changeCustomScreen(rubric:Object):void
		{
			dispatch(new IpadEvent(IpadEvent.SETTINGS_CHANGED, true, false, rubric.id));
		}
		
		private function factShow(fact:ByteArray):void
		{
			var _fact:Fact = createFact(fact.readObject());
			dispatch(new IpadEvent(IpadEvent.OPEN_POPUP, true, false,  { value:_fact, type:"Fact" }));
		}
		
		private function materialShow(mat:ByteArray):void
		{			
			var _mat:Material = createMaterial(mat.readObject());
			dispatch(new IpadEvent(IpadEvent.OPEN_POPUP, true, false, { value:_mat, type:"Material" } ));			
		}
		
		private function createFact(data:Object):Fact
		{			
			var material:Fact = new Fact();
			
			for (var k:int = 0; k < data.rubrics.length; k++)
				material.pushRubric(data.rubrics[k]);
			
			material.is_main = data.is_main;
			material.author_id = data.author_id;
			material.id = data.id;
			material.is_public = data.is_public;
			material.live_broadcast = data.live_broadcast;
			material.place = data.place;
			material.start_date = data.start_date;
			material.end_date = data.end_date;			
			material.text = data.text;
			material.title = data.title;
			
			return material;
		}
		
		private function createMaterial(data:Object):Material
		{
			var material:Material = new Material();
			
			material.author_id = data.author_id;
			material.important = data.important;
			material.modified = data.modified;
			
			material.published_at = data.published_at;
			material.text = data.text;
			material.type = data.type;
			material.id = data.id;
			material.title = data.title;
			material.theme = data.theme;
			material.publishedDate = Tool.timestapToDate(material.published_at);
			
			material.pushPoint(data.point);
			
			if (data.translations)
			{
				for (var p:int = 0; p < data.translations.length; p++)
					material.pushTranslations(data.translations[p]);
			}
			
			for (var k:int = 0; k < data.rubrics.length; k++)
				material.pushRubric(data.rubrics[k]);
			
			for (var j:int = 0; j < data.files.length; j++)
				material.pushFile(data.files[j]);
			
			for each (var tag:String in data.tags)
				material.tags.push(tag);
			
			return material;
		}
		
		private function menuChoose(id:int):void
		{
			var menuItem:String = "";
			
			switch (id)
			{
				case 0: 
					menuItem = ChangeLocationEvent.MAIN_SCREEN;
					break;
				case 1: 
					menuItem = ChangeLocationEvent.CUSTOM_SCREEN;
					break;
				case 2: 
					menuItem = ChangeLocationEvent.STORY_SCREEN;
					break;
				case 3: 
					menuItem = ChangeLocationEvent.NEWS_PAGE_DAY;
					break;
				case 4: 
					menuItem = ChangeLocationEvent.FACT_PAGE;
					break;
				case 5: 
					menuItem = ChangeLocationEvent.MAP_PAGE;
					break;
				case 6: 
					menuItem = ChangeLocationEvent.BROADCAST_PAGE;
					break;
				default: 
			}
			
			var event:ChangeLocationEvent = new ChangeLocationEvent(menuItem);
			event.mode = "MENU_MODE";
			dispatch(event);
		}	
	}
}
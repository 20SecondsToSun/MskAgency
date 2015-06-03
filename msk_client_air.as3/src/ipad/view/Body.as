package ipad.view
{
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.IpadEvent;
	import app.model.materials.Fact;
	import app.model.materials.Material;
	import app.services.ipad.IpadConnector;
	import app.view.utils.Tool;
	import com.adobe.crypto.MD5;
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import ipad.controller.IpadConstants;
	import ipad.view.locations.BroadcastPage;
	import ipad.view.locations.CustomPage;
	import ipad.view.locations.FactsPage;
	import ipad.view.locations.favorites.Favorites;
	import ipad.view.locations.MainPage;
	import ipad.view.locations.MapPage;
	import ipad.view.locations.NewsPage;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class Body extends Sprite
	{
		public  var ipadConnector:IpadConnector;
		private var menu:Menu;
		private var top:Top;
		private var slider:MainSlider;
		
		private var txt:TextField;
		private var txtf:TextFormat = new TextFormat(null, 15, 0xffffff);
		
		private var container:Sprite;
		private var data:Object = new Object();
		
		private var popup:Popup;
		public  var startPopup:StartPopup;		
		
		private var isConnected:Boolean = false;
		
		public function Body()
		{
			//start();
		}
		
		public function start():void
		{
			menu = new Menu();
			menu.y = IpadConstants.GameHeight - menu.height;
			addChild(menu);
			
			container = new Sprite();
			addChild(container);			
			
			//popup.visible = 
			container.visible = 
			menu.visible =  false;
			
			startPopup = new StartPopup();
			addChild(startPopup);			
			
			ipadConnector = new IpadConnector(tracer);	
		}
		
		public function hideKinectPopup():void
		{
			if (popup == null) return;
			popup.hideKinectPopup();
		}
		
		public function showKinectPopup():void
		{
			if (popup == null) return;
			popup.showKinectPopup();
		}
		
		public function hideBlockPopup():void
		{
			popup.hideBlockPopup();
		}
		
		public function showBlockPopup():void
		{
			popup.showBlockPopup();
			
		}
		
		public function sendClose():void
		{
			data.type = "MATERIAL_CLOSE";
			data.hash = Math.random();			
			data.stendId = stendId;		
			ipadConnector.sendData(data);			
		}
		
		private var stendId:String = "";
		private var idIpad:String = MD5.hash(Math.random().toString());
		
		public function idChoosed(e:IpadEvent = null):void
		{			
			//trace("HASH::::::::::", idIpad);
			data.type = "TRY_CONNECT";			
			data.hash = Math.random();
			data.idIpad = idIpad;
			stendId = data.stendId = startPopup.myTextField.text;//e.data.stendId;
			ipadConnector.sendData(data);	
			startPopup.waitingMode();			
		}
		
		public function sendChecked(num1:int, num2:int):void
		{
			data.type = "CHECK_MATCH";			
			data.hash = Math.random();
			data.firstNum = num1;
			data.secondNum = num2;
			ipadConnector.sendData(data);	
		}
		
		
		public function sendPlay(e:IpadEvent):void
		{
			data.type = "PLAY";			
			data.hash = Math.random();
			data.stendId = stendId;	
			ipadConnector.sendData(data);	
		}
		
		public function volChanged(e:IpadEvent):void
		{
			data.type = "VOLUME";	
			data.volume = e.data;
			data.stendId = stendId;	
			
			data.hash = Math.random();
			ipadConnector.sendData(data);
		}
		public function sendPause(e:IpadEvent):void
		{
			data.type = "PAUSE";			
			data.hash = Math.random();
			data.stendId = stendId;	
			ipadConnector.sendData(data);		
		}
		
		public function changeCustomScreen(obj:Object):void
		{
			data.type = "CHANGE CUSTOM SCREEN";
			data.rubric = obj;
			data.hash = Math.random();
			data.stendId = stendId;	
			ipadConnector.sendData(data);				
		}
		
		public function changePrimaryScreen(screen:String):void
		{
			data.type = "CHANGE PRIMARY SCREEN";
			data.screen = screen;
			data.hash = Math.random();
			data.stendId = stendId;	
			ipadConnector.sendData(data);
		}
		
		public function sendMaterial(mat:Material):void
		{
			data.type = "MATERIAL_SHOW";
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(mat);
			bytes.position = 0; 
			data.mat = bytes;
			data.hash = Math.random();	
			data.stendId = stendId;	
			ipadConnector.sendData(data);
		}
		public function sendFact(fact:Fact):void
		{
			data.type = "FACT_SHOW";
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(fact);
			bytes.position = 0; 
			data.fact = bytes;
			data.hash = Math.random();	
			data.stendId = stendId;	
			ipadConnector.sendData(data);
		}
		
		public function gotoPage(id:int):void
		{
			data.type = "NAVIGATION";
			data.id = id;
			data.hash = Math.random();
			data.stendId = stendId;	
			ipadConnector.sendData(data);	
			
			locationManager(Menu.getNameById(id));			
			sendClose();
		}
		
		private function tracer(event:NetStatusEvent):void
		{
			//trace( event.info.code + "\n");
			//txt.setTextFormat(txtf);
			switch (event.info.code)
			{
				case 'NetConnection.Connect.Success':
					
					break;
				
				case 'NetGroup.Neighbor.Connect': 
					//allowButtons();
					break;
				
				case 'NetGroup.Connect.Success': 
					 trace(event.info, event.info.peerID);
					// this.dispatchEvent(new AppEvent(AppEvent.P2P_INIT, {}));
					// sendPost({message: 'test'});
					break;
				case 'NetGroup.Neighbor.Disconnect': 
					//disconnectUser(event.info);
					
					break;
					
				case 'NetGroup.Posting.Notify':
					
					if (!event.info.message) return;
					messageHandler(event.info.message);
					break;
			}
		}
		private var communicateTime:Number = -1;
		private function messageHandler(message:Object):void 
		{
			if (!message.type)
				return;	
				
			///trace("MESSAGE INFO:::::::", message.type);
			
			switch (message.type)
			{
				case "INIT INFO":
					
					if (message.idIpad != idIpad) return;
					
					startPopup.visible = false;
					//popup.visible = true;
					////popup.alpha = 0.4;
					container.visible = 
					menu.visible =  true;
					
					popup= new Popup();
					addChild(popup);
					
					
					menu.setActiveButtonByName(message.currentLocation);				
					 
					dispatchEvent(new IpadEvent(IpadEvent.PRIMARY_SCREEN, true, false, message.primaryScreen));
					 
					if (message.rubric)
					{
						//trace("message.rubric", message.rubric.id);
						dispatchEvent(new IpadEvent(IpadEvent.CUSTOM_SCREEN_RUBRIC, true,false,  message.rubric));							
					}		
					
					locationManager(message.currentLocation);
					
					if (message.isUserActive!= undefined)
					{
						if (message.isUserActive)
							dispatchEvent(new IpadEvent(IpadEvent.USER_ACTIVE));	
						else 
							dispatchEvent(new IpadEvent(IpadEvent.USER_LOST));
					}
					 
					if (message.isHandActive!= undefined)
					{
						if (message.isHandActive)
							dispatchEvent(new IpadEvent(IpadEvent.HAND_ACTIVE));	
						else 
							dispatchEvent(new IpadEvent(IpadEvent.HAND_LOST));
					}
					
					if (message.isIpadPause!= undefined)
					{
						if (message.isIpadPause)
							dispatchEvent(new IpadEvent(IpadEvent.PAUSE));	
						else 
							dispatchEvent(new IpadEvent(IpadEvent.PLAY));
					}
					
					if (message.isInteraction!= undefined)
					{
						if (message.isInteraction)
							dispatchEvent(new IpadEvent(IpadEvent.START_INTERACTION));	
						else 
						{							
							dispatchEvent(new IpadEvent(IpadEvent.STOP_INTERACTION));
						}						
					}					 
					break;
				
				case "NAVIGATION": 
					trace("change location ==============================", message.currentLocation);
					menu.setActiveButtonByName(message.currentLocation);
					locationManager(message.currentLocation);
					break;
				
				case "START_COMMUNICATE":
					dispatchEvent(new IpadEvent(IpadEvent.START_INTERACTION));	
					communicateTime = message.hash;
					break;
				
				case "STOP_COMMUNICATE":
					if (communicateTime <= message.hash)
						dispatchEvent(new IpadEvent(IpadEvent.STOP_INTERACTION));
						communicateTime = message.hash;
					break;
					
				case "HAND_ACTIVE":
					dispatchEvent(new IpadEvent(IpadEvent.HAND_ACTIVE));
					break;
					
				case "HAND_LOST":
					dispatchEvent(new IpadEvent(IpadEvent.HAND_LOST));
					break;
					
				case "USER_ACTIVE":
					dispatchEvent(new IpadEvent(IpadEvent.USER_ACTIVE));	
					break;
					
				case "USER_LOST":
					dispatchEvent(new IpadEvent(IpadEvent.USER_LOST));
					break;
				
				case "PAUSE_REMOVE":
					   dispatchEvent(new IpadEvent(IpadEvent.PLAY));
					break;
					
				case "SEND_SHAPES":
						startPopup.rightNums(message.firstNum, message.secondNum);
					   //dispatchEvent(new IpadEvent(IpadEvent.PLAY));
					break;
				case "SYMBOLS_OK":
						/*startPopup.visible = false;
						popup.visible= true;
						container.visible = 
						menu.visible =  true;*/
						//startPopup.rightNums(message.firstNum, message.secondNum);
					   //dispatchEvent(new IpadEvent(IpadEvent.PLAY));
					break;
					
				case "SYMBOLS_BAD":
					// dispatchEvent(new IpadEvent(IpadEvent.SYMBOLS_BAD));
					startPopup.init();
					
					break;
					
				default: 
			}
		}
		private var currentLocation:String = "";
		private function locationManager(loc:String):void 
		{
			if (currentLocation == loc) return;
			
			var location:*;
			
			switch (loc)
			{
				case ChangeLocationEvent.MAIN_SCREEN:
					currentLocation = loc;
					location = new MainPage();
					break;
					
				case ChangeLocationEvent.CUSTOM_SCREEN:
					currentLocation = loc;
					location = new CustomPage();
					break;
					
				case ChangeLocationEvent.STORY_SCREEN:
					currentLocation = loc;
					location = new Favorites();
					break;
					
				case ChangeLocationEvent.NEWS_PAGE_DAY:
				case ChangeLocationEvent.NEWS_PAGE_HOUR:
				case ChangeLocationEvent.ONE_NEW_PAGE:
					if (currentLocation == "news") return;
					currentLocation = "news";
					location = new NewsPage();
					break;
					
				case ChangeLocationEvent.FACT_PAGE:
				case ChangeLocationEvent.ONE_NEW_FACT_PAGE:				
					if (currentLocation == "facts") return;
					currentLocation = "facts";
					location = new FactsPage();					
					break;
					
				case ChangeLocationEvent.BROADCAST_PAGE:
					currentLocation = loc;
					location = new BroadcastPage();
					break;
					
				case ChangeLocationEvent.MAP_PAGE:
					currentLocation = loc;
					location = new MapPage();
					break;
			}
			
			Tool.removeAllChildren(container);
			if (location) container.addChild(location);
			
		}		
	}
}
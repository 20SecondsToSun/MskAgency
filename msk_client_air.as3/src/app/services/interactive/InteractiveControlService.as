package app.services.interactive
{
	import app.AppSettings;
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.InteractiveRemoteEvent;
	import app.InteractiveStendContext;
	import app.services.ipad.IIpadService;
	import app.view.handsview.HandType;
	import flash.display.DisplayObjectContainer;
	import flash.ui.Mouse;
	import org.robotlegs.mvcs.Actor;
	
	public class InteractiveControlService extends Actor implements IInteractiveControlService
	{
		private var interactiveClient:*;
		
		[Inject]
		public var contextView:DisplayObjectContainer;		
		
		private var stopStack:int = 0;		
		private var _isInteraction:Boolean = false;		
		private var _isIpadConnect:Boolean = false;
		
		public function set isIpadConnect(value:Boolean):void 
		{
			_isIpadConnect = value;
		}
		
		public function get isIpadConnect():Boolean 
		{
			return _isIpadConnect;
		}
		
		public function get isInteraction():Boolean
		{
			return _isInteraction;
		}
		
		public function set isInteraction(value:Boolean):void
		{
			_isInteraction = value;
		}
		
		public function start():void
		{
			
			if (interactiveClient)
				return;
			
			if (AppSettings.CONTROLL_BY_KINECT)
			{
				interactiveClient = new KinectClient();
				interactiveClient.startListening(11000);
				Mouse.hide();
			}
			else if (AppSettings.CONTROLL_BY_LEAP)
			{
				interactiveClient = new LeapMotion(contextView.stage);
				dispatch(new InteractiveRemoteEvent(InteractiveRemoteEvent.USER_ACTIVE, true, true));
				dispatch(new InteractiveRemoteEvent(InteractiveRemoteEvent.ACTIVATE_HAND, true, true, 0, 0, 0, 0, 0, 0, HandType.LEFT, null));
			}
			else
			{
				interactiveClient = new MouseClient();
				contextView.stage.addChild(interactiveClient);
				interactiveClient.startListening();
				dispatch(new InteractiveRemoteEvent(InteractiveRemoteEvent.USER_ACTIVE, true, true));
				dispatch(new InteractiveRemoteEvent(InteractiveRemoteEvent.ACTIVATE_HAND, true, true, 0, 0, 0, 0, 0, 0, HandType.LEFT, null));
				
				startInteraction(); //!!!!!!!!
			}		
		}
		
		public function stopInteraction():void
		{
			stopStack++;
			
			_isInteraction = false;
			
			interactiveClient.removeEventListener(InteractiveRemoteEvent.HAND_DOWN, dispatch);
			interactiveClient.removeEventListener(InteractiveRemoteEvent.HAND_UP, dispatch);
			interactiveClient.removeEventListener(InteractiveRemoteEvent.HAND_PUSH, dispatch);
			interactiveClient.removeEventListener(InteractiveRemoteEvent.USER_ACTIVE, dispatch);
			interactiveClient.removeEventListener(InteractiveRemoteEvent.ACTIVATE_HAND, dispatch);
			interactiveClient.removeEventListener(InteractiveRemoteEvent.DEACTIVATE_HAND, dispatch);
			interactiveClient.removeEventListener(InteractiveRemoteEvent.FIGURE_GESTURE, gesture);
			interactiveClient.removeEventListener(InteractiveRemoteEvent.HAND_OVER_HEAD, sendToShowMenu);
			interactiveClient.removeEventListener(InteractiveRemoteEvent.USER_LOST, dispatch);
			
			interactiveClient.removeEventListener(InteractiveRemoteEvent.HAND_ONE_FINGER, dispatch);
			interactiveClient.removeEventListener(InteractiveRemoteEvent.HAND_TWO_FINGERS, dispatch);
			interactiveClient.removeEventListener(InteractiveRemoteEvent.HAND_THREE_FINGERS, dispatch);
			interactiveClient.removeEventListener(InteractiveRemoteEvent.CLICK, click);
		
		}
		
		public function startInteraction():void
		{
			if (--stopStack > 0)
				return;
			if (stopStack < 0)
				stopStack = 0;
			
			if (!interactiveClient)
				start();
			
			_isInteraction = true;
			
			interactiveClient.addEventListener(InteractiveRemoteEvent.HAND_UPDATE, dispatch1);
			interactiveClient.addEventListener(InteractiveRemoteEvent.HAND_DOWN, dispatch1);
			interactiveClient.addEventListener(InteractiveRemoteEvent.HAND_UP, dispatch1);
			interactiveClient.addEventListener(InteractiveRemoteEvent.HAND_PUSH, dispatch1);
			interactiveClient.addEventListener(InteractiveRemoteEvent.USER_ACTIVE, dispatch);
			interactiveClient.addEventListener(InteractiveRemoteEvent.USER_LOST, dispatch);
			interactiveClient.addEventListener(InteractiveRemoteEvent.ACTIVATE_HAND, dispatch);
			interactiveClient.addEventListener(InteractiveRemoteEvent.DEACTIVATE_HAND, dispatch);
			interactiveClient.addEventListener(InteractiveRemoteEvent.HAND_ONE_FINGER, dispatch1);
			interactiveClient.addEventListener(InteractiveRemoteEvent.HAND_TWO_FINGERS, dispatch1);
			interactiveClient.addEventListener(InteractiveRemoteEvent.HAND_THREE_FINGERS, dispatch1);
			
			interactiveClient.addEventListener(InteractiveRemoteEvent.FIGURE_GESTURE, gesture);
			interactiveClient.addEventListener(InteractiveRemoteEvent.HAND_OVER_HEAD, sendToShowMenu);
			
			interactiveClient.addEventListener(InteractiveRemoteEvent.CLICK, click);		
		}
		
		private function dispatch1(e:InteractiveRemoteEvent):void 
		{
			if (_isIpadConnect) return;		
			
			dispatch(e);
		}
		
		private function click(e:InteractiveRemoteEvent):void
		{
			dispatch(new InteractiveEvent(InteractiveEvent.CLICK));
		}
		
		private function gesture(e:InteractiveRemoteEvent):void
		{
			trace("gesture", e.gesture);
			switch (e.gesture)
			{
				case GestureID.GALKA: 
					dispatch(new ChangeLocationEvent(ChangeLocationEvent.STORY_SCREEN));
					break;
				default: 
					dispatch(new ChangeLocationEvent(ChangeLocationEvent.SHOW_FILTERS));
			}
		
		}
		
		private function oneFinger(e:InteractiveRemoteEvent):void
		{
			//var event:ChangeLocationEvent = new ChangeLocationEvent( ChangeLocationEvent.MAIN_SCREEN);
			//event.mode = "MENU_MODE";
			//dispatch(event);
		}
		
		private function twoFingers(e:InteractiveRemoteEvent):void
		{
			//var event:ChangeLocationEvent = new ChangeLocationEvent( ChangeLocationEvent.CUSTOM_SCREEN);
			//event.mode = "MENU_MODE";
			//dispatch(event);
		}
		
		private function threeFingers(e:InteractiveRemoteEvent):void
		{
			//var event:ChangeLocationEvent = new ChangeLocationEvent( ChangeLocationEvent.STORY_SCREEN);
			//event.mode = "MENU_MODE";
			//dispatch(event);
		}
		
		private function sendToShowMenu(e:InteractiveRemoteEvent):void
		{
			var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.SHOW_MENU);
			
			dispatch(event);
		}	
	}
}
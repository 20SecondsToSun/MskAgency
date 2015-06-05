package app.services.interactive 
{
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.InteractiveRemoteEvent;
	import app.view.handsview.HandType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class MouseClient extends Sprite
	{	
		public function startListening():void
		{			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, closeHand);			
			stage.addEventListener(MouseEvent.RIGHT_CLICK, pushHand);				
			stage.addEventListener(MouseEvent.CLICK, clickHand);				
			stage.addEventListener(MouseEvent.MOUSE_UP, openHand);	
			stage.addEventListener(Event.ENTER_FRAME, updateHand);		
		}	
		
		public function stopListening():void
		{			
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, closeHand);			
			stage.removeEventListener(MouseEvent.RIGHT_CLICK, pushHand);				
			stage.removeEventListener(MouseEvent.MOUSE_UP, openHand);	
			stage.removeEventListener(Event.ENTER_FRAME, updateHand);		
		}
		
		public function dispose():void
		{			
	
		}
		
		private function clickHand(e:MouseEvent):void 
		{
			var ie:InteractiveRemoteEvent = new InteractiveRemoteEvent(InteractiveRemoteEvent.CLICK);			
				ie.stageX = mouseX;
				ie.stageY = mouseY;
				ie.handType = HandType.LEFT;
			
			dispatchEvent(ie);	
		}
		
		private function openHand(e:MouseEvent):void 
		{
			var ie:InteractiveRemoteEvent = new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_UP);			
				ie.stageX = mouseX;
				ie.stageY = mouseY;
				ie.handType = HandType.LEFT;
			
			dispatchEvent(ie);
		}
		
		private function pushHand(e:MouseEvent):void 
		{
			
			var ie:InteractiveRemoteEvent = new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_PUSH);			
				ie.stageX = mouseX;
				ie.stageY = mouseY;
				ie.handType = HandType.LEFT;
			
			dispatchEvent(ie);
		}
		
		private function closeHand(e:MouseEvent):void 
		{			
			var ie:InteractiveRemoteEvent = new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_DOWN);				
				ie.stageX = mouseX;
				ie.stageY = mouseY;
				ie.handType = HandType.LEFT;
			
			dispatchEvent(ie);
		}
		
		private function updateHand(e:Event):void 
		{	
			var ie:InteractiveRemoteEvent = new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_UPDATE);		
				ie.stageX = mouseX;
				ie.stageY = mouseY;
				ie.handType = HandType.LEFT;
			
			dispatchEvent(ie);
		}		
	}
}
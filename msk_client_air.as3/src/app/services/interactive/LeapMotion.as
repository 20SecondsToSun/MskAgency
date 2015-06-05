package app.services.interactive
{
	import app.AppSettings;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.InteractiveRemoteEvent;
	import app.services.interactive.gestureDetector.DisplayListHelper;
	import app.view.baseview.io.InteractiveButton;
	import app.view.baseview.io.InteractiveObject;
	import app.view.handsview.HandType;
	import com.greensock.TweenLite;
	import com.leapmotion.leap.CircleGesture;
	import com.leapmotion.leap.Controller;
	import com.leapmotion.leap.events.LeapEvent;
	import com.leapmotion.leap.Gesture;
	import com.leapmotion.leap.KeyTapGesture;
	import com.leapmotion.leap.Pointable;
	import com.leapmotion.leap.ScreenTapGesture;
	import com.leapmotion.leap.Vector3;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author castor troy
	 */
	public class LeapMotion extends EventDispatcher
	{
		private var controller:Controller;
		private var lastSwipe:int;
		
		private var iel:InteractiveRemoteEvent = new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_UPDATE);
		private var stage:Stage;
		
		private var portX:int = 200;
		private var portY:int = 200;
		
		private var handState:String = "Grip";
		
		private var activeID:int=-1;
		private var catchCircle:Boolean = false;
		private var lastVec1:Vector3 = null;
		private var lastVec2:Vector3 = null;
		
		public function LeapMotion(stage:Stage)
		{
			this.stage = stage;
			controller = new Controller();
			controller.addEventListener(LeapEvent.LEAPMOTION_FRAME, leapmotionFrameHandler);
			controller.addEventListener(LeapEvent.LEAPMOTION_CONNECTED, leapmotionConnectedHandler);
		}
		
		private function leapmotionConnectedHandler(event:LeapEvent):void
		{
			controller.enableGesture(Gesture.TYPE_SWIPE);
			controller.enableGesture(Gesture.TYPE_CIRCLE);
			controller.enableGesture(Gesture.TYPE_KEY_TAP);
			controller.enableGesture(Gesture.TYPE_SCREEN_TAP);			
		}
		
		protected function leapmotionFrameHandler(event:LeapEvent):void
		{
			var now:int = getTimer();
			
			var numPointables:int = event.frame.pointables.length;
			
			if (now - lastSwipe > 10)
			{			
				if (numPointables)
				{
					if (numPointables > 1)					
					{
						checkZoomPlato(event.frame.pointables);
					}
					
					if (activeID == -1) activeID = event.frame.pointables[0].id;
					
					 var finger:Pointable =  getActiveFinger(event.frame.pointables);
				
					var nCoords:Point = normalize(finger.tipPosition.x, finger.tipPosition.y);
					
					iel.stageX = nCoords.x;
					iel.stageY = nCoords.y;
					iel.handType = HandType.LEFT;
					dispatchEvent(iel);
					
					if (finger.tipPosition.z < -80 && handState!="Grip")
					{
						handState = "Grip";
						dispatchGrip(finger.tipPosition.x, finger.tipPosition.y);
					}
					else if (finger.tipPosition.z > -80 && handState!="Release")					
					{
						handState = "Release";
						dispatchRelease(finger.tipPosition.x,finger.tipPosition.y);
						
					}
					
					var gestures:Vector.<Gesture> = event.frame.gestures();
					for each (var gesture:Gesture in gestures)
					{
						
						if (gesture is ScreenTapGesture&& gesture.state == Gesture.STATE_STOP)
						{
							
							var tap:ScreenTapGesture = gesture as ScreenTapGesture;
							checkPush(tap.position.x, tap.position.y);
						}
						
						if (gesture is CircleGesture  && !catchCircle/*&& gesture.state == Gesture.STATE_STOP*/)
						{
							var circle:CircleGesture = gesture as CircleGesture;
							if (circle.progress > 1.3 && circle.radius > 20 && circle.radius < 40)
							{
								catchCircle = true;
								dispatchCircle();
								TweenLite.killDelayedCallsTo(setCatch);
								TweenLite.delayedCall(3, setCatch);
							}							
						}
						
						if (gesture is KeyTapGesture && gesture.state == Gesture.STATE_STOP)						
							dispatchMenu();						
					}
					
				}
				else activeID = -1;
				lastSwipe = now;
			}		
		}	
		
		private function setCatch():void 
		{
			catchCircle = false;
		}
		
		private function getActiveFinger(pointables:Vector.<Pointable>):Pointable 
		{
			for (var i:int = 0; i <pointables.length ; i++) 
			{
				if (pointables[i].id == activeID)
				return pointables[i];
			}
			activeID = pointables[0].id;
			return pointables[0];
		}
		
		private function dispatchRelease(x:Number, y:Number):void
		{
			var point:Point = normalize(x, y);
			var ierr:InteractiveRemoteEvent = new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_UP);
			ierr.stageX = point.x;
			ierr.stageY = point.y;
			ierr.handType = HandType.LEFT;
			dispatchEvent(ierr);
		}
		
		private function dispatchGrip(x:Number, y:Number):void
		{
			var point:Point = normalize(x, y);
			var iehg:InteractiveRemoteEvent = new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_DOWN);
			iehg.stageX = point.x;
			iehg.stageY = point.y;
			iehg.handType = HandType.LEFT;
			dispatchEvent(iehg);
		}
		
		private function dispatchMenu():void
		{
			var ieHUP1:InteractiveRemoteEvent = new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_OVER_HEAD);
			dispatchEvent(ieHUP1);
			//trace("MENU!!!");
		}
		
		private function dispatchCircle():void
		{
			var interactiveGesture:InteractiveRemoteEvent = new InteractiveRemoteEvent(InteractiveRemoteEvent.FIGURE_GESTURE);
			interactiveGesture.handType = HandType.LEFT;
			interactiveGesture.gesture = 15;
			dispatchEvent(interactiveGesture);
		}
		
		private function normalize(x:Number, y:Number):Point
		{			
			var scale:Number = (x + 100) / portX;		
			var scale2:Number = 1 - (y) / portY;
			
			return new Point(AppSettings.WIDTH * scale, AppSettings.HEIGHT * scale2 * 2);
		}
		
		private function checkPush(x:Number, y:Number):void
		{
			var point:Point = normalize(x, y);
			var _pushButton:InteractiveButton = checkForInteractiveButton(point.x, point.y);
			
			if (_pushButton != null)
			{
				_pushButton.dispatchEvent(new InteractiveEvent(InteractiveEvent.HAND_PUSH, false, false));
			}
		}
		
		private function checkForInteractiveButton(x:Number, y:Number):InteractiveButton
		{
			var interactiveArray:Vector.<InteractiveObject> = DisplayListHelper.getTopDisplayButtonUnderPoint(new Point(x, y), stage);
			if (interactiveArray)
			{
				for (var i:int = 0; i < interactiveArray.length; i++)
				{
					if (interactiveArray[i] is InteractiveButton)
					{
						return interactiveArray[i] as InteractiveButton;
					}
				}
			}
			
			return null;
		}		
		
		private function checkZoomPlato(pointables:Vector.<Pointable>):Pointable 
		{
			var vec1:Vector3 = pointables[0].tipPosition;
			var vec2:Vector3 = pointables[1].tipPosition;
			
			var point:Point = normalize(vec1.x, vec2.y);
			var plato:InteractiveObject = checkForInteractiveStretch(point.x, point.y);			
			if (plato != null)
			{
				if (lastVec1 != null && lastVec2 != null)
				{				
					vec1 = vec1.minus(lastVec1);
					vec2 = vec2.minus(lastVec2);					
					var finalVector:Vector3 = vec1.minus(vec2);					
				}
				
				lastVec1 = vec1;
				lastVec2 = vec2;	
			
			}
			return null;
		}
		
		private function checkForInteractiveStretch(x:Number, y:Number):InteractiveObject
		{
			var interactiveArray:Vector.<InteractiveObject> = DisplayListHelper.getTopDisplayObjectUnderPoint(new Point(x, y), stage);
			if (interactiveArray)
			{
				for (var i:int = 0; i < interactiveArray.length; i++)
				{
					if (interactiveArray[i].isStretch)
					{
						return interactiveArray[i];
					}
				}
			}
			
			return null;
		}
	}
}
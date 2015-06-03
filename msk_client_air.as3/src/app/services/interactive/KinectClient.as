package app.services.interactive
{
	
	import app.AppSettings;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.InteractiveRemoteEvent;
	import app.model.datauser.IUser;
	import app.view.handsview.HandType;
	import com.greensock.TweenLite;
	import flash.events.DatagramSocketDataEvent;
	import flash.events.EventDispatcher;
	import flash.net.DatagramSocket;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class KinectClient extends EventDispatcher
	{
		//[Inject]
		public var userActive:Boolean = false;
		
		private var connection:DatagramSocket;
		private var ielg:InteractiveRemoteEvent = new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_DOWN);
		private var ielr:InteractiveRemoteEvent = new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_UP);
		
		private var ierg:InteractiveRemoteEvent = new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_DOWN);
		private var ierr:InteractiveRemoteEvent = new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_UP);
		
		private var iela:InteractiveRemoteEvent = new InteractiveRemoteEvent(InteractiveRemoteEvent.ACTIVATE_HAND);
		private var ielda:InteractiveRemoteEvent = new InteractiveRemoteEvent(InteractiveRemoteEvent.DEACTIVATE_HAND);
		
		private var iera:InteractiveRemoteEvent = new InteractiveRemoteEvent(InteractiveRemoteEvent.ACTIVATE_HAND);
		private var ierda:InteractiveRemoteEvent = new InteractiveRemoteEvent(InteractiveRemoteEvent.DEACTIVATE_HAND);
		
		private var iel:InteractiveRemoteEvent = new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_UPDATE);
		private var ier:InteractiveRemoteEvent = new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_UPDATE);
		
		public function KinectClient()
		{
			//User.instance.isActive = true;
		}
		
		public function startListening(port:uint):void
		{			
			stopListing();
			
			connection = new DatagramSocket();
			connection.addEventListener(DatagramSocketDataEvent.DATA, dataHandler, false, 0, true);
			connection.bind(port);
			connection.receive();
		}
		
		public function stopListing():void
		{
			if (connection != null)
			{
				if (connection.connected)
				{
					connection.close();
				}
				connection.removeEventListener(DatagramSocketDataEvent.DATA, dataHandler);
			}
			connection = null;
		}
		
		private function traceObject(o:Object):void
		{
			trace('\n');
			for (var val:*in o)
			{
				trace('   [' + typeof(o[val]) + '] ' + val + ' => ' + o[val]);
			}
			trace('\n');
		}
		
		private var previousWheelEvent:Number = 0;
		private var minMouseWheelInterval:Number = 100;
		
		private var handUPSavedY:Number = 0;
		private var handUPTYPE:String = "";
		
		
		private function dataHandler(event:DatagramSocketDataEvent):void
		{
			
			var data:String = event.data.readUTFBytes(event.data.bytesAvailable);
			var decoded:Object = JSON.parse(data);
			
			if (getTimer() - previousWheelEvent < minMouseWheelInterval)
				return;
			
			//traceObject(decoded);
			//return;
			
			/*if(decoded.Joints != null && decoded.Joints.length >= JointID.Count)
			   {
			   User.instance.isActive = true;
			
			   for each(var jointData:Object in decoded.Joints)
			   {
			   normalizeJointData(jointData);
			   }
			   handleJoint(decoded, JointID.HandLeft);
			   handleJoint(decoded, JointID.HandRight);
			 }*/
			
			//if (decoded.jointType != null)	
			if (decoded.isHandData)
			{
				//User.instance.isActive = true;
				handleJoint(decoded); // , decoded.jointType);
				
			}
			else
			{				
				switch (decoded.property)
				{
					
					case "userDetected":
						if (userActive) return;
						userActive = true;
						trace("userDetected");
						dispatchEvent(new InteractiveRemoteEvent(InteractiveRemoteEvent.USER_ACTIVE, true, true));
						break;
					
					case "userLost": 
						if (!userActive) return;
						userActive = false;
						trace("userLost");
						dispatchEvent(new InteractiveRemoteEvent(InteractiveRemoteEvent.USER_LOST, true, true));
						break;
					
					case "FIGURE_GESTURE": 
						if(isDelayedHandUP) return;
						sendFigureGesture(decoded.handType, decoded.gesture);
						
						//traceObject("FIGURE_GESTURE");
						//dispatchEvent(new InteractiveEvent(InteractiveEvent.USER_LOST, true, true));
						break;
					case "GESTURE": 
						//trace( decoded.gesture);
						if (decoded.gesture == "11" || decoded.gesture == "12")
						{
							//
							if (!isDelayedHandUP)
							{
								//trace("UP!!!!!!!!!!!!!!");
								if (decoded.gesture == "11")
								{
									handUPTYPE = "LEFT";
								}
								else if (decoded.gesture == "12")
								{
									handUPTYPE = "RIGHT";
								}
								
								isDelayedHandUP = true;
								TweenLite.delayedCall(0.5, delayForHandUp);
							}
						}
						if (decoded.gesture == "13" || decoded.gesture == "14")
						{							
							if (isDelayedHandUP)
							{	
								
								if (decoded.gesture == "13" && handUPTYPE == "LEFT")
								{
									trace("DOWN!!!!!!!!!!!!!!");
									TweenLite.killDelayedCallsTo(delayForHandUp);
									isDelayedHandUP = false;
								}
								if (decoded.gesture == "14" && handUPTYPE == "RIGHT")
								{
									trace("DOWN!!!!!!!!!!!!!!");
									TweenLite.killDelayedCallsTo(delayForHandUp);
									isDelayedHandUP = false;
								}
							
							}
						}
						
						break;
					
					case "FINGERS": 
						//trace( decoded.gesture, decoded.gesturePart);
						var ieHUP:InteractiveRemoteEvent;
						if (decoded.gesture == "20")
						{
							ieHUP = new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_ONE_FINGER);
							ieHUP.gesturePart = decoded.gesturePart;
							dispatchEvent(ieHUP);
						}
						if (decoded.gesture == "21")
						{
							ieHUP = new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_TWO_FINGERS);
							ieHUP.gesturePart = decoded.gesturePart;
							dispatchEvent(ieHUP);
						}
						if (decoded.gesture == "22")
						{
							ieHUP = new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_THREE_FINGERS);
							ieHUP.gesturePart = decoded.gesturePart;
							dispatchEvent(ieHUP);
						}
						
						break;
					
					default:
				
				}
			}
		}
		
		private function delayForHandUp():void
		{
			
			isDelayedHandUP = false;
			var ieHUP1:InteractiveRemoteEvent = new InteractiveRemoteEvent(InteractiveRemoteEvent.HAND_OVER_HEAD);
			dispatchEvent(ieHUP1);
		
		}
		
		private function sendFigureGesture(handType:int, gesture:int):void
		{
			switch (gesture)
			{
				case GestureID.CW_CIRCLE: 
				case GestureID.ACW_TRIANGLE: 
				case GestureID.ACW_CIRCLE: 
				case GestureID.CW_TRIANGLE: 
				case GestureID.GALKA: 	
					trace("GESTURE=====================",gesture);
					var interactiveGesture:InteractiveRemoteEvent = new InteractiveRemoteEvent(InteractiveRemoteEvent.FIGURE_GESTURE);
					interactiveGesture.handType = handType == HandID.LEFT ? HandType.LEFT : HandType.RIGHT;
					interactiveGesture.gesture = gesture;
					dispatchEvent(interactiveGesture);
					break;
				
				
				default: 
			}
		}
		
		private function normalizeJointData(jointData:Object):void
		{
			jointData.Position.X += 1;
			jointData.Position.Y *= -1;
			jointData.Position.Y += 1;
			jointData.Position.X *= .5;
			jointData.Position.Y *= .5;
			//trace("Position   " + jointData.Position.X + "  " + jointData.Position.Y + "  " + jointData.Position.Z);
		
		}
		private var xyz:Object = {x: 0, y: 0, z: 0};
		private var xyzRight:Object = {x: 0, y: 0, z: 0};
		private var xyzLeft:Object = {x: 0, y: 0, z: 0};
		private var lastLeftGrip:Boolean = false;
		private var lastRightGrip:Boolean = false;
		
		private var lastLeftActive:Boolean = false;
		private var lastRightActive:Boolean = false;
		private var isDelayedHandUP:Boolean = false;
		
		private function handleJoint(userData:Object):void //, jointID:uint):void
		{
			
			xyzLeft.x = userData.leftHand.x;
			xyzLeft.y = userData.leftHand.y;
			xyzLeft.z = userData.leftHand.z;
			
			iel.stageX = xyzLeft.x * AppSettings.WIDTH * 0.5;
			iel.stageY = xyzLeft.y * AppSettings.HEIGHT;
			iel.stageZ = xyzLeft.z;
			
			iel.handType = HandType.LEFT;
			dispatchEvent(iel);
			
			if (lastLeftGrip != userData.leftHand.isGrip)
			{
				lastLeftGrip = userData.leftHand.isGrip;
				if (userData.leftHand.isGrip)
				{
					ielg.stageX = xyzLeft.x;
					ielg.stageY = xyzLeft.y;
					ielg.handType = HandType.LEFT;
					dispatchEvent(ielg);
				}
				else
				{
					ielr.stageX = xyzLeft.x;
					ielr.stageY = xyzLeft.y;
					ielr.handType = HandType.LEFT;
					dispatchEvent(ielr);
				}
			}
			//trace("userData.leftHand.isTracked", userData.leftHand.isTracked);
			//trace("userData.rightHand.isTracked", userData.rightHand.isTracked);
			if (lastLeftActive != userData.leftHand.isTracked)
			{
				lastLeftActive = userData.leftHand.isTracked;
				if (userData.leftHand.isTracked)
				{
					iela.stageX = xyzLeft.x;
					iela.stageY = xyzLeft.y;
					iela.handType = HandType.LEFT;
					dispatchEvent(iela);
				}
				else
				{
					ielda.stageX = xyzLeft.x;
					ielda.stageY = xyzLeft.y;
					ielda.handType = HandType.LEFT;
					dispatchEvent(ielda);
				}
				
			}
			
			//trace("userData.leftHand.isTracked", userData.leftHand.isTracked,lastLeftActive,"               RIGHT  " +userData.rightHand.isTracked,lastRightActive);
			
			xyzRight.x = userData.rightHand.x;
			xyzRight.z = userData.rightHand.z;
			xyzRight.y = userData.rightHand.y;
			
			ier.stageX = xyzRight.x * AppSettings.WIDTH * 0.5;
			ier.stageY = xyzRight.y * AppSettings.HEIGHT;
			ier.stageZ = xyzRight.z;
			ier.handType = HandType.RIGHT;
			dispatchEvent(ier);
			
			if (lastRightGrip != userData.rightHand.isGrip)
			{
				lastRightGrip = userData.rightHand.isGrip;
				if (userData.rightHand.isGrip)
				{
					ierg.stageX = xyzRight.x;
					ierg.stageY = xyzRight.y;
					ierg.handType = HandType.RIGHT;
					dispatchEvent(ierg);
				}
				else
				{
					ierr.stageX = xyzRight.x;
					ierr.stageY = xyzRight.y;
					ierr.handType = HandType.RIGHT;
					dispatchEvent(ierr);
				}
			}
			
			if (lastRightActive != userData.rightHand.isTracked)
			{
				lastRightActive = userData.rightHand.isTracked;
				if (userData.rightHand.isTracked)
				{
					iera.stageX = xyzRight.x;
					iera.stageY = xyzRight.y;
					iera.handType = HandType.RIGHT;
					dispatchEvent(iera);
				}
				else
				{
					ierda.stageX = xyzRight.x;
					ierda.stageY = xyzRight.y;
					ierda.handType = HandType.RIGHT;
					dispatchEvent(ierda);
				}
				
			}
		
		}
	
	}

}
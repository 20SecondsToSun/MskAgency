package app.services.interactive.gestureDetector 
{
	import app.contoller.events.InteractiveEvent;
	import app.view.baseview.io.InteractiveObject;
	import flash.display.Stage;
	import flash.geom.Point;

	/**
	 * ...
	 * @author metalcorehero
	 */
	public class HandOverOutDetector 
	{
		
		private var lastInteractiveArray:Vector.<InteractiveObject> = new Vector.<InteractiveObject>;	
		private var currentInteractiveArray:Vector.<InteractiveObject> = new Vector.<InteractiveObject>;			
		public var isAllowed:Boolean = true;
		
		public function update(x:Number, y:Number, z:Number,stage:Stage) :void
		{
			sendEventToAllInteractiveObject(InteractiveEvent.HAND_UPDATE, x, y,z,stage);
			if (!isAllowed) return;
			
			currentInteractiveArray	= DisplayListHelper.getTopDisplayObjectUnderPoint( new Point (x,y ), stage) ;	
			
			if (lastInteractiveArray== null || lastInteractiveArray.length == 0)
			{
				if (currentInteractiveArray)
				{					
					for (var i:int = 0; i < currentInteractiveArray.length; i++) 
					{
						var ieOver1:InteractiveEvent = new InteractiveEvent(InteractiveEvent.HAND_OVER, false, false );							
						currentInteractiveArray[i].dispatchEvent(ieOver1);						
					}					
				}
			}
			else
			{
				if (currentInteractiveArray)
				{
					for (var j:int = 0; j < currentInteractiveArray.length; j++) 
					{
						if (!isLastInCurrenctList(currentInteractiveArray[j], lastInteractiveArray))
						{
							
							var ieOver2:InteractiveEvent = new InteractiveEvent(InteractiveEvent.HAND_OVER, false, false );
							currentInteractiveArray[j].dispatchEvent(ieOver2);								
						}
					}
					for (var k:int = 0; k < lastInteractiveArray.length; k++) 
					{
						if ( !isLastInCurrenctList(lastInteractiveArray[k], currentInteractiveArray))
						{
							/*if (lastInteractiveArray[k] as InteractiveButton == pushDetector.pushButton) 
							{
								pushDetector.stopInteract();
							}*/
							var ieOut1:InteractiveEvent = new InteractiveEvent(InteractiveEvent.HAND_OUT, false, false );							
							lastInteractiveArray[k].dispatchEvent(ieOut1);							
						}
					}
				}
				else 
				{
					for (var p:int = 0; p < lastInteractiveArray.length; p++) 
					{	
						//if (lastInteractiveArray[p] as InteractiveButton == pushDetector.pushButton) pushDetector.stopInteract();
						var ieOut2:InteractiveEvent = new InteractiveEvent(InteractiveEvent.HAND_OUT, false, false );	
						lastInteractiveArray[p].dispatchEvent(ieOut2);					
					}
				}
			}			
			lastInteractiveArray = currentInteractiveArray;	
			
			
		
		}
		private function sendEventToAllInteractiveObject(event:String, x:Number = 0, y:Number=0, z:Number = 0,stage:Stage = null ):void
		{
			var interactiveArray:Vector.<InteractiveObject> 
						= DisplayListHelper.getAllInteractiveObjects(stage) ;					
			if (interactiveArray)
			{
				for (var i:int = 0; i < interactiveArray.length; i++) 
				{		
					interactiveArray[i].dispatchEvent(new InteractiveEvent(event, false, false, x, y, z));					
				}
			}
		}
		private function isLastInCurrenctList(item:InteractiveObject, interactiveArray:Vector.<InteractiveObject>):Boolean 
		{
			for (var i:int = 0; i <interactiveArray.length ; i++) 
			{
				if (item == interactiveArray[i])
				{
					return true;
				}
			}	
			return false;			
		}
		
		
		
		private static var _instance:HandOverOutDetector = new HandOverOutDetector();	
		public function HandOverOutDetector() 
		{
			 if( _instance ) throw new Error( "Singleton and can only be accessed through Singleton.getInstance()" ); 
		}
		public static function getInstance():HandOverOutDetector 
		{  			
            return _instance;
        }
		
	}

}
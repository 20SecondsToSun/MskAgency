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
	public class HandDownDetector 
	{
		public var isAllowed:Boolean = true;
		
		
		public function update(x:Number, y:Number,stage:Stage) :void
		{
			if (!isAllowed ) return;
			sendEventToInteractiveObject(InteractiveEvent.HAND_DOWN, x, y,stage);
		}
		private function sendEventToInteractiveObject(event:String, x:Number=0, y :Number=0,stage:Stage = null):void 
		{			
			var interactiveArray:Vector.<InteractiveObject> 
						= DisplayListHelper.getTopDisplayObjectUnderPoint( new Point (x, y), stage, InteractiveEvent.HAND_DOWN) ;					
			
			if (interactiveArray)
			{
				//trace("======================");
				for (var i:int = 0; i < interactiveArray.length; i++) 
				{
					//trace(interactiveArray[i].name);
					interactiveArray[i].dispatchEvent(new InteractiveEvent(event, true, true, x, y));						
					
					/*if (event == InteractiveEvent.HAND_DOWN && interactiveArray[i] is InteractiveStretch )
					{
						stretchDetector.stretch = istretch;
						stretchDetector.interactive = true;
					}*/
				}				
			}
		}		
		
		private static var _instance:HandDownDetector = new HandDownDetector();	
		
		public function HandDownDetector() 
		{
			 if( _instance ) throw new Error( "Singleton and can only be accessed through Singleton.getInstance()" ); 
		}
		public static function getInstance():HandDownDetector 
		{  			
            return _instance;
        }		
	}
}
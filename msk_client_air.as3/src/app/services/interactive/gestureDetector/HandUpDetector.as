package app.services.interactive.gestureDetector
{
	import app.contoller.events.InteractiveEvent;
	import app.view.baseview.io.InteractiveObject;
	import flash.display.Stage;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class HandUpDetector
	{
		public var isAllowed:Boolean = true;
		private static var _instance:HandUpDetector = new HandUpDetector();
		
		public function update(x:Number, y:Number, stage:Stage):void
		{
			if (isAllowed)
				sendEventToAllInteractiveObject(InteractiveEvent.HAND_UP, x, y, stage);
		}
		
		private function sendEventToAllInteractiveObject(event:String, x:Number = 0, y:Number = 0, stage:Stage = null):void
		{
			var interactiveArray:Vector.<InteractiveObject> = DisplayListHelper.getAllInteractiveObjects(stage);
			if (interactiveArray)
				for (var i:int = 0; i < interactiveArray.length; i++)
					interactiveArray[i].dispatchEvent(new InteractiveEvent(event, true, false, x, y));		
		}
		
		public function HandUpDetector()
		{
			if (_instance) throw new Error("Singleton and can only be accessed through Singleton.getInstance()");
		}
		
		public static function getInstance():HandUpDetector
		{
			return _instance;
		}	
	}
}
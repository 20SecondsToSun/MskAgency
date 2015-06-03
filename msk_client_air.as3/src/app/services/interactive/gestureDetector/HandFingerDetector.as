package app.services.interactive.gestureDetector 
{
	import app.contoller.events.InteractiveEvent;
	import app.view.baseview.io.InteractiveObject;
	import flash.display.Stage;
/**
	 * ...
	 * @author metalcorehero
	 */
	public class HandFingerDetector 
	{	
		
		private var state:String = "NONE";
	
		public function update(type:String, gesturePart:String, callback:Function):void
		{
			if (waitForFinished) return;
			
			//trace("state==================", gesturePart, type);
			
			
			switch (gesturePart) 
			{
				case "START":
					//trace("state==================START");
					if (state != "CHARGING")
					{
						callback("CHARGING",type);
						state = "CHARGING";
						waitForFinished = false;
					}	
					
				break;
				
				case "INTERRUPT":
			    	//trace("state==================INTERRUPT");
					state = "NONE";
					waitForFinished = false;
					callback("INTERRUPT",type);
					
				break;
				
				case "FINISHED":
					if (state == "CHARGING")
						waitForFinished = true;
				break;
				
				default:
			}
			
			
		}
		public function finished():void
		{
			waitForFinished = false;
			state = "NONE";
			trace("!!!!! DONE");
		}
		
		
		private static var _instance:HandFingerDetector = new HandFingerDetector();	
		private var waitForFinished:Boolean;
		public function HandFingerDetector() 
		{
			 if( _instance ) throw new Error( "Singleton and can only be accessed through Singleton.getInstance()" ); 
		}
		public static function getInstance():HandFingerDetector 
		{  			
            return _instance;
        }	
		
	}

}
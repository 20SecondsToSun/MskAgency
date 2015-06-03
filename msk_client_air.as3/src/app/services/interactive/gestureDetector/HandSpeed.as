package app.services.interactive.gestureDetector 
{
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class HandSpeed 
	{		
		private static var _instance:HandSpeed = new HandSpeed();
		
		public var handSpeed:Object = { speedX:0, speedY:0 };
		public  var averageSpeed:Object = { speedX:500, speedY:500 };
		private var averageFrequencyCount:Number = 30;
		private var averageFrequency:Number = 30;
	
		private var newPosition:Object = { posX:0, posY:0 };
		private var oldPosition:Object = { posX:0, posY:0 };
		
		public var averageSpeedMax:Number;
		
		public function HandSpeed() 
		{
			if( _instance ) throw new Error( "Singleton and can only be accessed through Singleton.getInstance()" ); 
		}
		
		public static function getInstance():HandSpeed 
		{  			
            return _instance;
        }
  		
		public function calculateSpeed(x:Number,y:Number):void
		{
			if (averageFrequencyCount-- == 0)
			{
				averageSpeed.speedY = Math.abs(handSpeed.speedY / averageFrequency);
				averageSpeed.speedX = Math.abs(handSpeed.speedX / averageFrequency);
				averageSpeedMax = Math.max(averageSpeed.speedY , averageSpeed.speedX);
				handSpeed.speedY = 0;
				handSpeed.speedX = 0;
				averageFrequencyCount = averageFrequency;
			}
			
			newPosition.posY = y;
			handSpeed.speedY += newPosition.posY -  oldPosition.posY;
			oldPosition.posY = newPosition.posY;
			
			newPosition.posX = x;
			handSpeed.speedX += newPosition.posX -  oldPosition.posX;
			oldPosition.posX = newPosition.posX;
		}		
	}
}
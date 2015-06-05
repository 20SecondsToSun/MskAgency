package app.services.interactive 
{
	import app.AppSettings;
	public class KinectHand 
	{
		public  var active : Boolean = false;		
		public  var x : Number;	
		public  var y : Number;	
		public  var z : Number;	
		public  var type : String;		
		private var _isGrip: Boolean = false;
		
		public function KinectHand(handType:String)
		{
			type = handType;
		}
		
		public function setPosition(x:Number, y:Number, z:Number): void
		{
			this.x = x;
			this.y = y;
			this.z = z;		
		}	
		
		public function isTracked() :Boolean 
		{
			return (active && x > 0 && x < AppSettings.WIDTH && y > 0 && y < AppSettings.HEIGHT);
		}
		
		public function isGrip () :Boolean 
		{
			return _isGrip;
		}
		
		public function setGrip (value :Boolean) : void
		{
			_isGrip = value;
		}
		
		public function setActive(value:Boolean):void 
		{
			active = value;
		}
	}
}
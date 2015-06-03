package  app.view.utils.video 
{
	public class CuePointInfo
	{
		public var time:Number;
		public var type:String;
		
		public function CuePointInfo(time:Number = 0, type:String = ""):void
		{
			this.time = time;
			this.type = type;
		}
		
		public function toString():String
		{
			return "[time: "+time+", type: "+type+"]"
		}
	}

}
package app.services.trackers
{	
	import com.tastenkunst.airkinectv2.KV2Joint;
	public class Gesture
	{			
		public static const INVALID:int = -1;
		public static const ONE_FINGER:int = 1;
		public static const TWO_FINGERS_LEFT:int = 2;
		public static const THREE_FINGERS:int = 3;
		public static const UP_TO_TOP:int = 4;
		public static const HAND_OVER_HEAD:int = 5;
		public static const HAND_UNDER_HEAD:int = 6;
		public static const CIRCLE:int = 7;
		public static const CIRCLE_CW:int = 8;
		public static const CHECK:int = 9;
		public static const CHECK_CW:int = 10;
		public static const SQUARE:int = 11;
		public static const SQUARE_CW:int = 12;
		public static const TRIANGLE:int = 13;
		public static const TRIANGLE_CW:int = 14;
		public static const HAND_BLINK:int = 15;
		public static const FINGERS_ABORT:int = 16;
		public static const TWO_FINGERS:int = 17;		
		public static const DOUBLE_ELLIPSE:int = 18;		
		public static const DOWN_LINE:int = 19;		
		public static const HORIZONT_LINE:int = 20;		
		
		private var type:int  = INVALID;	
		private var prevResult:int  = INVALID;	
		private var handType:int  = KV2Joint.JointType_HandRight;			
		
		public function Gesture(type:int = INVALID) 
		{
			this.type = type;
		}
		
		public function setType(type:int):void 
		{
			this.type = type;
		}
		
		public function getType():int 
		{
			return type;
		}
		
		public function getPrevResult():int 
		{
			return prevResult;
		}
		
		public function setPrevResult(value:int):void
		{
			prevResult = value;
		}
		
		public function setHandType(value:int):void
		{
			handType = value;
		}	
		
		public function getHandType():int
		{
			return handType;
		}	
		
		public function getName():String 
		{
			var name:String = "invalid";
			
			switch (type) 
			{
				case CIRCLE:
				case CIRCLE_CW:
					name = "circle";
				break;
				
				case SQUARE:
				case SQUARE_CW:
					name = "Square";
				break;
				
				case TRIANGLE:
				case TRIANGLE_CW:
					name = "Triangle";
				break;
				
				case CHECK:
				case CHECK_CW:
					name = "Check";
				break;
				
				case HAND_OVER_HEAD:
					name = "HandOver";
				break;
				
				case TWO_FINGERS:
					name = "Twofingers";
				break;
				
				case HAND_BLINK:
					name = "handBlink";
				break;				
			}
			
			return name;
		}
	}
}
package app.services.interactive.gestureDetector
{
	import app.contoller.events.InteractiveEvent;
	import app.view.baseview.io.InteractiveObject;
	import app.view.baseview.io.InteractiveStretch;
	import flash.display.Stage;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class StretchOutDetector
	{
		public var percent:Number = 0;
		
		private var _stretch:InteractiveStretch;
		private var startZ:Number = 100000;
		private var lastZ:Number = 100000;
		
		private var maxDiffInMetters:Number = 0.20;
		private var minDiffInMetters:Number = 0.05;
		
		private var _interactive:Boolean = false;
		private var istretch:InteractiveObject;
		
		private var MIN_DISSTANCE:Number = 0.07;
		private var MAX_DISSTANCE:Number = 0.20;
		
		public function stretchOff():void
		{
			if (istretch)						
				istretch.dispatchEvent(new InteractiveEvent(InteractiveEvent.STRETCH_OFF));			
		}
		
		public function findStretch(x:Number, y:Number, z:Number, stage:Stage):void
		{
			startZ = z;
			istretch = checkForInteractiveStretch(x, y, stage);
			_isAllowed = true;
			//trace("ZZZZZZZZZZ=========", istretch);
		}
		
		public function update(x:Number, y:Number, z:Number, stage:Stage):void
		{
			if (!_isAllowed)
				return;
			
			if (istretch == null)
				return;
			
			if (Math.abs(startZ - z) > MIN_DISSTANCE)
			{
				var percent:Number = 1 - (MAX_DISSTANCE - Math.abs(startZ - z)) / (MAX_DISSTANCE - MIN_DISSTANCE);
				if (percent < 0)
					percent = 0;
					
				if (percent > 1)
				{
					percent = 1;					
					_isAllowed = false;					
				}
				var str:InteractiveEvent = new InteractiveEvent(InteractiveEvent.STRETCH);
				str.percent = percent;
				istretch.dispatchEvent(str);
				
			}
		}
		
		private function checkForInteractiveStretch(x:Number, y:Number, stage:Stage):InteractiveObject
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
		/*	public function set interactive(i:Boolean):void
		   {
		   _interactive = 	i;
		
		   if (!_interactive)
		   {
		   lastZ = startZ = 10000;
		   if (percent < 80 && _stretch && percent !=0)
		   {
		   _stretch.dispatchEvent(new GestureEvent(GestureEvent.STRETCH_OUT, false, false, 0));
		   _stretch.dispatchEvent(new GestureEvent(GestureEvent.STRETCH_OUT_HAND_UP, false, false, 0));
		   _stretch = null;
		   }
		   percent = 0;
		   }
		   }
		   public function get interactive():Boolean
		   {
		   return _interactive;
		   }
		
		   public function set stretch(strtch:InteractiveStretch):void
		   {
		   if (strtch != _stretch)
		   {
		   _stretch = strtch;
		   percent = 0;
		   }
		   }
		   public function get stretch():InteractiveStretch
		   {
		   return _stretch;
		   }
		   public function startInteract(z:Number):void
		   {
		   if (z < startZ)
		   {
		   lastZ = startZ = z;
		   return;
		   }
		   else
		   {
		   if (z -startZ  >= maxDiffInMetters )
		   {
		   percent = 100;
		   lastZ = startZ = 10000;
		   _stretch.dispatchEvent(new GestureEvent(GestureEvent.STRETCH_OUT, false, false, percent));
		   return;
		
		   }
		   else if  (z -startZ  <= minDiffInMetters ||  z < lastZ)
		   {
		   if (z < lastZ)
		   {
		   percent = 100 * (z -startZ - minDiffInMetters ) / maxDiffInMetters;
		   if (percent > 0 )
		   _stretch.dispatchEvent(new GestureEvent(GestureEvent.STRETCH_OUT, false, false, percent));
		   }
		   }
		   else
		   {
		   percent = 100 * (z -startZ - minDiffInMetters) / maxDiffInMetters;
		   _stretch.dispatchEvent(new GestureEvent(GestureEvent.STRETCH_OUT, false, false, percent));
		
		   }
		   lastZ = z;
		   }
		 }	*/
		
		private var _isAllowed:Boolean = true;
		
		public function get isAllowed():Boolean
		{
			return _isAllowed;
		}
		
		public function set isAllowed(allow:Boolean):void
		{
			_isAllowed = allow;
		
		}
		
		private static var _instance:StretchOutDetector = new StretchOutDetector();
		
		public function StretchOutDetector()
		{
			if (_instance)
				throw new Error("Singleton and can only be accessed through Singleton.getInstance()");
		}
		
		public static function getInstance():StretchOutDetector
		{
			return _instance;
		}
	}

}
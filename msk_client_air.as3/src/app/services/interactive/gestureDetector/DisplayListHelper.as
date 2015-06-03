package app.services.interactive.gestureDetector
{
	import app.contoller.events.InteractiveEvent;
	import app.view.baseview.io.InteractiveButton;
	import app.view.baseview.io.InteractiveChargeButton;
	import app.view.baseview.io.InteractiveObject;
	import app.view.baseview.io.InteractiveStretch;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**
	 * This class provides static functions for display list traversals and lookups which are used internally.
	 */
	public class DisplayListHelper
	{
		
		/**
		 * Finds the most top DisplayObject under a given point which is eanbled for user interaction.
		 */
		private static var interactiveArrayTopObj:Vector.<InteractiveObject>;
		
		public static function getTopDisplayObjectUnderPoint(point:Point, stage:Stage, evet:String = ""):Vector.<InteractiveObject>
		{
			var targets:Array = stage.getObjectsUnderPoint(point);
			//var childrenCheckArray:Array =  stage.getObjectsUnderPoint(point);
			var item:DisplayObject = (targets.length > 0) ? targets[targets.length - 1] : stage;
			interactiveArrayTopObj = new Vector.<InteractiveObject>();
			
			while (targets.length > 0)
			{
				item = targets.pop() as DisplayObject;
				
				if (item.parent != null && !(item is InteractiveObject))
					item = item.parent;
				
				if (item is InteractiveObject)
				{
					
					//if (!(item as InteractiveObject).enabled) continue;					
					if ((!(item as InteractiveObject).downEnabled && evet == InteractiveEvent.HAND_DOWN))
						continue;
					
					interactiveArrayTopObj.push(item);
					for (var i:int = 0; i < targets.length; i++)
					{
						var it:DisplayObject = targets[i] as DisplayObject;
						it = it.parent;
						
						if ((item as InteractiveObject).contains(it) && (it is InteractiveObject) && (it != item))
						{
							var fl:Boolean = false;
							for (var j:int = 0; j < interactiveArrayTopObj.length; j++)
							{
								if (it == interactiveArrayTopObj[j])
									fl = true;
							}
							if (!fl)
								interactiveArrayTopObj.push(it);
							
						}
						
					}
					
					for (var k:int = 0; k < interactiveArrayTopObj.length; k++)
					{
						//	trace(interactiveArrayTopObj[k].name);
					}
					
					return interactiveArrayTopObj;
				}
			}
			
			return null;
		
		}
		
		static private function sendToAllChildrenAlso(io:Sprite):void
		{
			for (var i:int = 0; i < io.numChildren; i++)
			{
				//trace(io.getChildAt(i).name);
				if (io.getChildAt(i) is InteractiveObject)
				{
					interactiveArrayTopObj.push(io.getChildAt(i));
				}
				if (!(io.getChildAt(i) is Sprite))
					continue;
				sendToAllChildrenAlso(io.getChildAt(i) as Sprite);
			}
		}
		
		public static function getTopDisplayButtonUnderPoint(point:Point, stage:Stage):Vector.<InteractiveObject>
		{
			var targets:Array = stage.getObjectsUnderPoint(point);
			
			var item:DisplayObject = (targets.length > 0) ? targets[targets.length - 1] : stage;
			var interactiveArray:Vector.<InteractiveObject> = new Vector.<InteractiveObject>();
			
			while (targets.length > 0)
			{
				item = targets.pop() as DisplayObject;
				
				if (item.parent != null && !(item is InteractiveObject))
					item = item.parent;
					
				if (item is InteractiveObject && (item as InteractiveObject).pushEnabled == false) return null;
				if (item is InteractiveButton && (item as InteractiveButton).pushEnabled == false) return null;
				
				if (item is InteractiveButton)
				{
					interactiveArray.push(item);
					return interactiveArray;
				}
			}
			
			return null;
		
		}
		
		public static function getTopDisplayChargeButtonUnderPoint(point:Point, stage:Stage):Vector.<InteractiveObject>
		{
			var targets:Array = stage.getObjectsUnderPoint(point);
			var item:DisplayObject = (targets.length > 0) ? targets[targets.length - 1] : stage;
			var interactiveArray:Vector.<InteractiveObject> = new Vector.<InteractiveObject>();
			while (targets.length > 0)
			{
				item = targets.pop() as DisplayObject;
				if (item.parent != null && !(item is InteractiveObject))
					item = item.parent;
					
					
				if (item is InteractiveObject && (item as InteractiveObject).chargeEnabled == false) return null;
				if (item is InteractiveChargeButton && (item as InteractiveChargeButton).chargeEnabled == false) return null;
				
				if (item is InteractiveChargeButton)
				{
					interactiveArray.push(item);
					return interactiveArray;
				}
			}
			
			return null;
		}
		
		public static function getTopDisplayInteractiveStretchUnderPoint(point:Point, stage:Stage):Vector.<InteractiveObject>
		{
			var targets:Array = stage.getObjectsUnderPoint(point);
			var item:DisplayObject = (targets.length > 0) ? targets[targets.length - 1] : stage;
			var interactiveArray:Vector.<InteractiveObject> = new Vector.<InteractiveObject>();
			while (targets.length > 0)
			{
				item = targets.pop() as DisplayObject;
				if (item.parent != null && !(item is InteractiveObject))
					item = item.parent;
				
				if (item is InteractiveStretch)
				{
					interactiveArray.push(item);
					return interactiveArray;
				}
			}
			
			return null;
		
		}
		
		public static function getAllInteractiveObjectsUnderPoint(point:Point, stage:Stage):Vector.<InteractiveObject>
		{
			var objects:Array = stage.getObjectsUnderPoint(point);
			//trace("interactiveArray  " + objects, point);	
			var interactiveArray:Vector.<InteractiveObject> = new Vector.<InteractiveObject>();
			
			for (var i:int = 0; i < objects.length; i++)
			{
				var p:* = objects[i];
				while (p)
				{
					if (p is InteractiveObject)
					{
						//trace(i, ">>", p.name, ": ", p);
						interactiveArray.push(p);
					}
					p = p.parent;
				}
			}
			if (interactiveArray.length == 0)
				return null;
			return interactiveArray;
		}
		
		public static function getAllInteractiveObjects(stage:Stage):Vector.<InteractiveObject>
		{
			allDisplayInteractiveArray.splice(0, allDisplayInteractiveArray.length);
			traceDisplayList(stage);
			
			if (allDisplayInteractiveArray.length == 0)
				return null;
			return allDisplayInteractiveArray;
		}
		public static var allDisplayInteractiveArray:Vector.<InteractiveObject> = new Vector.<InteractiveObject>();
		
		public static function traceDisplayList(container:DisplayObjectContainer):void
		{
			var child:DisplayObject;
			for (var i:uint = 0; i < container.numChildren; i++)
			{
				child = container.getChildAt(i);
				if (child is InteractiveObject)
					allDisplayInteractiveArray.push(child);
				
				if (child is DisplayObjectContainer)
				{
					traceDisplayList(DisplayObjectContainer(child));
				}
			}
		}
		
		public static function getChildrenOf(target:DisplayObjectContainer):Array
		{
			var children:Array = [];
			
			for (var i:uint = 0; i < target.numChildren; i++)
				children.push(target.getChildAt(i));
			
			return children;
		}
		
		public static function bubbleListCheck(obj:DisplayObject):Boolean
		{
			if (obj.parent != null)
			{
				return bubbleListCheck(obj.parent);
			}
			else
			{
				return false;
			}
		}
	}
}
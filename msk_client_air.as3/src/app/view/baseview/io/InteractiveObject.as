package app.view.baseview.io 
{
	import app.view.baseview.io.IInteractive;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class InteractiveObject extends Sprite implements IInteractive
	{		
		public var downEnabled:Boolean = true;
		public var pushEnabled:Boolean = true;
		public var chargeEnabled:Boolean = true;		
		public var isStretch:Boolean = false;
		public var enabled:Boolean = true;	
		
		public function remove():void
		{			
			removeAllChildren(this);	
		}
		
		public static function removeAllChildren(_do:Sprite):void 
		{			
			while ( _do.numChildren > 0) 			
			{				
				var child:Sprite =  _do.getChildAt(0) as Sprite;
				if (child)
				{
					removeAllChildren(child);				
					_do.removeChild(child);
					child = null;
				}
				else
				{
					var doChild:DisplayObject = _do.getChildAt(0);
					_do.removeChild(doChild);
					doChild = null;	
					
				}				
			}
		}		
	}
}
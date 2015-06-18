package  
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import ipad.InteractiveIpadContext;
	/**
	 * ...
	 * @author metalcorehero
	 */
	[SWF(backgroundColor = "#101114", width = "1024", height = "768", frameRate = "60")]
	
	public class Ipad extends Sprite 
	{
		private var _context:InteractiveIpadContext;
		
		public function Ipad():void 
		{				
			stage.scaleMode 	 = StageScaleMode.NO_SCALE;
			stage.align 	  	 = StageAlign.TOP_LEFT;			
			_context 			 = new InteractiveIpadContext(this);			
		}			
	}
}
package 
{
	import app.AppSettings;
	import app.InteractiveStendContext;
	import com.demonsters.debugger.MonsterDebugger;
	import flash.utils.setTimeout;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	
	[SWF(backgroundColor = "#000000", width = "1920", height = "1080", frameRate = "60")]
	
	public class Main extends Sprite 
	{
		private var _context:InteractiveStendContext;
		
		public function Main():void 
		{		
			stage.scaleMode 	 = StageScaleMode.EXACT_FIT;
			stage.align 	  	 = StageAlign.TOP_LEFT;
			
			stage.stageWidth 	 = AppSettings.WIDTH;
			stage.stageHeight	 = AppSettings.HEIGHT;
			stage.color			 = AppSettings.COLOR;
			stage.displayState   = AppSettings.FULL_SCREEN_MODE;		
			
			_context = new InteractiveStendContext(this);	
		}		
	}	
}
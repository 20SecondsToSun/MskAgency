package ipad
{
	import ipad.view.Menu;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.utils.AssetManager;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class App extends Sprite
	{
		
		public function App()
		{			
			//Starling.current.stage.stageWidth  = 1024;
           // Starling.current.stage.stageHeight = 768;
			Constants.GameHeight *= Starling.current.contentScaleFactor;
			Constants.GameWidth *= Starling.current.contentScaleFactor;
			
			trace("GO GO!!", Starling.current.contentScaleFactor, Constants.GameHeight);				
			loadGraphics();
			
			
		}
		
		private function loadGraphics():void 
		{			
			newsScreen();
		}
		
		private function newsScreen():void 
		{				
			var menu:Menu = new Menu();
			menu.y = Constants.GameHeight - menu.height;		
			addChild(menu);			
		}
		public static function get assets():AssetManager { return sAssets; }
	}

}
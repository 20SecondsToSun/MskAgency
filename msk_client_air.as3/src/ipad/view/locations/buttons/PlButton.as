package ipad.view.locations.buttons
{
	import app.view.utils.Tool;
	import flash.display.Shape;
	import flash.display.Sprite;
	import ipad.assets.Assets;
	import ipad.controller.IpadConstants;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class PlButton extends Sprite
	{
		private var playBtn:Sprite;
		private var pauseBtn:Sprite;
		private var man:Sprite;
		
		public function PlButton()
		{
			visible = false;
			
			playBtn = Assets.create("playBtn1");
			playBtn.scaleX = playBtn.scaleY = IpadConstants.contentScaleFactor;
			playBtn.mouseEnabled = false;
			addChild(playBtn);
			
			pauseBtn = Assets.create("pauseBtn1");
			pauseBtn.mouseEnabled = false;
			pauseBtn.scaleX = pauseBtn.scaleY = IpadConstants.contentScaleFactor;
			addChild(pauseBtn);		
			
			man = Assets.create("man");
			man.mouseEnabled = false;
			man.scaleX = man.scaleY = IpadConstants.contentScaleFactor;
			//addChild(man);	
			
			var splash:Shape = Tool.createShape(width, height, 0x000000);
			splash.alpha = 0;
			addChild(splash);
		}
		
		public function isPlaing(value:Boolean):void
		{
			playBtn.visible = !value;
			pauseBtn.visible = value;			
			visible = true;
		}
		
		public function kinectUserShow():void
		{
			playBtn.visible = false;
			pauseBtn.visible = false;	
			
			man.visible = true;
			visible = true;
		}
		
		public function kinectUserHide():void
		{
			man.visible = false;
		}		
	}
}
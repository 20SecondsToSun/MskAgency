package ipad.view.locations
{
	import app.view.utils.TextUtil;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ipad.controller.IpadConstants;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class StoryPage extends Sprite
	{
		private var textFormat:TextFormat = new TextFormat("TornadoL", 53, 0X494949);
		
		public function StoryPage()
		{
			var mainTitle:TextField = TextUtil.createTextField(0, 0);
			mainTitle.text = "ИЗБРАННОЕ";
			mainTitle.setTextFormat(textFormat);
			mainTitle.x = (IpadConstants.GameWidth - mainTitle.width) * 0.5;
			mainTitle.y = (IpadConstants.GameHeight - mainTitle.height - 290 * IpadConstants.contentScaleFactor) * 0.5;
			addChild(mainTitle);
			
			
			
			
			
			
		}
	
	}

}
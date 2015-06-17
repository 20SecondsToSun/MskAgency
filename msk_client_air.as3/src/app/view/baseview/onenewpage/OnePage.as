package app.view.baseview.onenewpage
{
	import app.AppSettings;
	import app.contoller.events.AnimationEvent;
	import app.model.types.AnimationType;
	import app.view.page.BasePage;
	import app.view.page.oneNews.Body.NewsBody;
	import app.view.page.oneNews.LeftPanelSlider;
	import app.view.utils.Tool;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class OnePage extends BasePage
	{
		protected var leftPanel:BaseLeftPanelSlider;
		protected var newsBody:BaseNewsBody;
		protected var splash:Shape;
		
		public function refreshData():void
		{
		
		}
		
		override public function flip():void
		{
		
		}
		
		public function stretch():void
		{
		
		}
		
		override public function expand():void
		{
			newsBody.x = AppSettings.WIDTH;
			leftPanel.x = -622;
			
			TweenLite.delayedCall(1.6, function():void
			{
				addChild(leftPanel);
				swapChildren(leftPanel, newsBody);
				
				TweenLite.to(leftPanel, 0.4, {x: 0, delay: 1, onComplete: animationInFinished()});
			});
			
			TweenLite.delayedCall(1.1, function():void
			{
				addChild(newsBody);
				TweenLite.to(newsBody, 0.4, {x: 622});
			})
		}
	}
}
package app.view.page
{
	import app.AppSettings;
	import app.contoller.events.AnimationEvent;
	import app.model.types.AnimationType;
	import app.view.page.oneNews.Body.NewsBody;
	import app.view.page.oneNews.LeftPanelSlider;
	import app.view.utils.Tool;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class OneNewPage extends BasePage
	{
		private var leftPanel:LeftPanelSlider;
		private var newsBody:NewsBody;
		protected var splash:Shape;
		
		public function OneNewPage()
		{
			splash = Tool.createShape(AppSettings.WIDTH, AppSettings.HEIGHT, 0x101114);
			splash.alpha = 0;
			addChild(splash);
			
			TweenLite.to(splash, 0.9, {delay: 0.4, alpha: 1});
		}
		
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
			var scale:Number = expand_rectangle.width / 1298;//0.2;
			var scale1:Number = expand_rectangle.height / 1080;
			scale = scale1 > scale ? scale1 : scale;
			if (scale > 0.5) scale = 0.3;
			newsBody = new NewsBody();
			
			newsBody.alpha = 0.3;
			newsBody.scaleX = scale;
			newsBody.scaleY = scale;
			
			newsBody.x = expand_rectangle.x + expand_rectangle.width * 0.5 + 622 * scale - 1298 * scale * 0.5;
			newsBody.y = expand_rectangle.y + expand_rectangle.height * 0.5 - 1080 * scale * 0.5;
			
			leftPanel = new LeftPanelSlider();
			leftPanel.x = -622;
			
			TweenLite.delayedCall(1.6, function():void
			{
				addChild(leftPanel);
				swapChildren(leftPanel, newsBody);
				TweenLite.to(leftPanel, 0.4, {x: 0, delay: 1.6, onComplete: animationInFinished()});
			});
					
			addChild(newsBody);
			TweenLite.to(newsBody, .7, {ease: Cubic.easeInOut, x: 622, y: 0, scaleX: 1, scaleY: 1});
			TweenLite.to(newsBody, .2, {delay: 0.05, ease: Cubic.easeInOut, alpha: 1});
		}
		
		override public function animationInFinished():void
		{
			dispatchEvent(new AnimationEvent(AnimationEvent.PAGE_ANIMATION_FINISHED, AnimationType.IN, this));
		}
		
		override public function animationOutFinished():void
		{
			dispatchEvent(new AnimationEvent(AnimationEvent.PAGE_ANIMATION_FINISHED, AnimationType.OUT, this));
		}
	}
}
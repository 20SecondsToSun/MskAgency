package app.view.page.fact
{
	import app.AppSettings;
	import app.view.baseview.onenewpage.OnePage;
	import app.view.page.fact.body.FactNewsBody;
	import app.view.page.fact.leftpanel.FactLeftPanelSlider;
	import app.view.utils.Tool;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class OneNewFactPage extends OnePage
	{
		public function OneNewFactPage()
		{
			splash = Tool.createShape(AppSettings.WIDTH, AppSettings.HEIGHT, 0x447631);
			addChild(splash);
			splash.alpha = 0;
			TweenLite.to(splash, 0.9, {delay: 0.4, alpha: 1});
		}
		
		override public function expand():void
		{
			var scale:Number = 0.2;
			newsBody = new FactNewsBody();
			
			newsBody.alpha = 0.6;
			newsBody.scaleX = scale;
			newsBody.scaleY = scale;
			
			newsBody.x = expand_rectangle.x + expand_rectangle.width * 0.5 + 622 * scale - 1298 * scale * 0.5;
			newsBody.y = expand_rectangle.y + expand_rectangle.height * 0.5 - 1080 * scale * 0.5;
			
			leftPanel = new FactLeftPanelSlider();
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
	}
}
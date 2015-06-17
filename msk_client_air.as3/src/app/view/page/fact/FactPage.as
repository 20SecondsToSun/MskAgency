package app.view.page.fact
{
	import app.AppSettings;
	import app.contoller.events.AnimationEvent;
	import app.model.types.AnimationType;
	import app.view.page.BasePage;
	import app.view.page.fact.factsslider.FactsAllSlider;
	import app.view.utils.Tool;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class FactPage extends BasePage
	{		
		private var splash:Shape;		
		private var slider:FactsAllSlider;
		
		public function FactPage():void
		{
			splash = Tool.createShape(AppSettings.WIDTH, AppSettings.HEIGHT, 0x101114);			
			addChild(splash);
			
			slider = new FactsAllSlider();
			slider.visible = false;
			addChild(slider);				
		}
	
		public function backFromOneNew():void
		{
			slider.visible = true;	
			animationInFinished();
		}		
		
		override public function flip():void
		{			
			splash.x = 0;
			splash.alpha = 0;
			animationInFinished();
		}
		
		override public function animationInFinished():void
		{
			slider.visible = true;	
			dispatchEvent(new AnimationEvent(AnimationEvent.PAGE_ANIMATION_FINISHED, AnimationType.IN, this));			
		}	
	}
}
package app.view.page.fact
{
	import app.AppSettings;
	import app.assets.Assets;
	import app.contoller.events.AnimationEvent;
	import app.model.datafact.DateInfo;
	import app.model.datafilters.FilterData;
	import app.model.materials.Fact;
	import app.model.materials.Material;
	import app.model.types.AnimationType;
	import app.view.page.BasePage;
	import app.view.page.fact.factsslider.FactsAllSlider;
	import app.view.utils.Tool;
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	
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
			//splash.x = AppSettings.WIDTH;			
			//TweenLite.to(splash, 0.8, { x: 0, ease: Expo.easeOut , onComplete: animationInFinished} );
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
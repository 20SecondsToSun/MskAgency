package app.view.page.day.hoursslider
{
	import app.AppSettings;
	import app.model.materials.Material;
	import app.view.baseview.slider.VerticalHorizontalSlider;
	import app.view.page.day.onehourslider.OneHourSlider;
	import app.view.utils.Tool;
	import com.greensock.easing.Circ;
	import com.greensock.TweenLite;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class HourSlider extends VerticalHorizontalSlider
	{
		public function HourSlider():void
		{
			super();
		}
		public function refreshData(allNewsList:Vector.<Vector.<Material>>):void
		{				
			sliders = new  Vector.<OneHourSlider>();
			this.y = 0;
			sliderContainer.y = 0;
			Tool.removeAllChildren(sliderContainer);
			TweenLite.killTweensOf(this);
			
			
			if (!allNewsList || allNewsList.length == 0) return;
			
			var offset:Number = 0;  
			
			for (var i:int = 0; i < allNewsList.length; i++)
			{
				var hourSlider:OneHourSlider = new OneHourSlider(allNewsList[i], i % 2 != 0);
						
				hourSlider.y = offset;
				offset += hourSlider.height;
				
				sliderContainer.addChild(hourSlider);		
				sliders.push(hourSlider);
				
				if (i < MIN_ROW_TO_INTERACT) hourSlider.x = AppSettings.WIDTH;
				
				if (hourSlider.holder.width < AppSettings.WIDTH) continue;
				
				hourSlider.startInteraction();
				hourSlider.isPause = true;					
			}						
		}
		
		public function startShowStretchIn():void 
		{
			var totalAnimate:int = sliders.length < MIN_ROW_TO_INTERACT? sliders.length:MIN_ROW_TO_INTERACT;			
			for ( var i:int = 0; i < totalAnimate; i++)	
			{
				sliders[i].x = 0;
				sliders[i].alpha = 0;
				TweenLite.to(sliders[i], 0.7, { delay:0.2 * i, alpha:1 , ease:Circ.easeInOut } );	
			}
		}
		public function startShowFlip():void 
		{
			var totalAnimate:int = sliders.length < MIN_ROW_TO_INTERACT? sliders.length:MIN_ROW_TO_INTERACT;			
			for ( var i:int = 0; i < totalAnimate; i++)						
				TweenLite.to(sliders[i], 0.6, { delay:0.2 * i, x:0 , ease:Circ.easeOut} );				
		}
		
		public function outLeftPanel():void
		{
			TweenLite.to(this, 0.3, { x:98 } );
		}
		public function overLeftPanel():void
		{
			TweenLite.to(this, 0.3, { x:182 } );
		}				
	}

}
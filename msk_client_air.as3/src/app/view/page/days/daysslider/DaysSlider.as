package app.view.page.days.daysslider
{
	import app.AppSettings;
	import app.contoller.events.DataLoadServiceEvent;
	import app.model.materials.Material;
	import app.view.baseview.slider.VerticalHorizontalSlider;
	import app.view.page.days.onedayslider.OneDaySlider;
	import app.view.utils.Tool;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class DaysSlider extends VerticalHorizontalSlider
	{
		private static const DAYS_BLOCK:int = 5;
		public var offset:int = 0;
		public var limit:int = DAYS_BLOCK;
		public var count:int = 0;
		public var isReload:Boolean = false;
		public var isFiltered:Boolean = false;
		
		public function reload():void
		{
			isReload = true;
			offset = 0;
			count = 0;
			limit = DAYS_BLOCK;
		}
		
		public function DaysSlider():void
		{
			super();
			dynamicLoad = true;
			sliders = new Vector.<OneDaySlider>();
			this.y = 0;
			Tool.removeAllChildren(sliderContainer);
		}
		
		public function refreshData(allNewsList:Vector.<Material>):void
		{
			if (!allNewsList || allNewsList.length == 0)
				return;
			
			isFiltered = false;
			
			if (isReload)
			{
				Tool.removeAllChildren(sliderContainer);
				sliders = new Vector.<OneDaySlider>();
				this.y = 0;
				isReload = false;
			}
			
			var daySlider:OneDaySlider = new OneDaySlider(allNewsList, count % 2 == 0, count);
			
			sliderContainer.addChild(daySlider);
			sliders.push(daySlider);
			
			daySlider.x = AppSettings.WIDTH;
			daySlider.y = OneDaySlider.HEIGHT * count++;
			daySlider.setY(daySlider.y);
			TweenLite.to(daySlider, 0.6, {delay: 0.2, x: 0, ease: Circ.easeOut, onComplete: daySlider.startInteraction});
			
			limit--;
			
			if (limit < 0)
				dispatchEvent(startInteractEvent);		
		}
		
		public function filterData(allNewsList:Vector.<Vector.<Material>>, isClearOld:Boolean = false):void
		{
			if (!allNewsList || allNewsList.length == 0)
				return;
			
			isFiltered = true;
			
			var startIndex:int = 0;
			
			if (isClearOld)
			{
				Tool.removeAllChildren(sliderContainer);
				sliders = new Vector.<OneDaySlider>();
				count = 0;
				this.y = 0;
			}
			else if (sliders && sliders.length)
			{
				var dayLastSlider:String = (sliders[sliders.length - 1] as OneDaySlider).day[0].getFormatDatePubl();
				var dayFirstUpComingSlider:String = allNewsList[0][0].getFormatDatePubl();
				if (dayLastSlider == dayFirstUpComingSlider)
				{
					(sliders[sliders.length - 1] as OneDaySlider).addElements(allNewsList[0]);
					startIndex = 1;
				}
			}
			
			for (var i:int = startIndex; i < allNewsList.length; i++)
			{
				
				var daySlider:OneDaySlider = new OneDaySlider(allNewsList[i], count % 2 == 0, count);
				sliderContainer.addChild(daySlider);
				sliders.push(daySlider);
				
				daySlider.x = AppSettings.WIDTH;
				daySlider.y = OneDaySlider.HEIGHT * count++;
				daySlider.setY(daySlider.y);
				TweenLite.to(daySlider, 0.6, {delay: 0.2 + i * 0.2, x: 0, ease: Circ.easeOut, onComplete: daySlider.startInteraction});
			}
			
			if (sliders.length < DAYS_BLOCK - 1)			
			{
				//trace("LOAD MORE!!!!!!!!");
				dispatchEvent(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_DAYS_DATA));
			}
			else
			{
				if (allNewsList.length - startIndex < 3)
				{
					animatetoFinishY();
				}
				
				dispatchEvent(startInteractEvent);
			}
		
		}
		
		override protected function loadNews(direction:String):Number
		{
			if (direction == "TO_FUTURE")
			{
				initListeners();
				animatetoStartY();
				return initY;
			}
			
			offset = -count;
			limit = DAYS_BLOCK;
			dispatchEvent(stopInteractEvent);
			dispatchEvent(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_DAYS_DATA));
			
			return -height + OneDaySlider.HEIGHT;		
		}
		
		/*public function startShowStretchIn():void
		   {
		   var totalAnimate:int = sliders.length < MIN_ROW_TO_INTERACT ? sliders.length : MIN_ROW_TO_INTERACT;
		   for (var i:int = 0; i < totalAnimate; i++)
		   {
		   sliders[i].x = 0;
		   sliders[i].alpha = 0;
		   TweenLite.to(sliders[i], 0.8, {delay: 0.2 * i, alpha: 1, ease: Expo.easeIn});
		   }
		   }
		
		   public function startShowFlip():void
		   {
		   var totalAnimate:int = sliders.length < MIN_ROW_TO_INTERACT ? sliders.length : MIN_ROW_TO_INTERACT;
		   for (var i:int = 0; i < totalAnimate; i++)
		   TweenLite.to(sliders[i], 0.6, {delay: 0.2 * i, x: 0, ease: Circ.easeOut});
		 }*/
		
		public function animateOut(id:int):void
		{
		/*sliderContainer.setChildIndex(sliders[id], sliderContainer.numChildren - 1);
		   var _scale:Number = 1.5;
		   TweenLite.to(sliders[id], 0.8, { scaleX:_scale, scaleY:_scale, y: sliders[id].y + (1 - _scale) * sliders[id].height * 0.5 + 400, x: -AppSettings.WIDTH  * (_scale-1) * 0.5 } );
		
		   var totalAnimate:int = sliders.length < MIN_ROW_TO_INTERACT? sliders.length:MIN_ROW_TO_INTERACT;
		   for ( var i:int = 0; i < totalAnimate; i++)
		   {
		   if (i == id) continue;
		   TweenLite.to(sliders[i], 0.6, {alpha:0, ease:Circ.easeOut } );
		 }*/
		}
	}

}
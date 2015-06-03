package app.view.page.fact.factsslider
{
	import app.AppSettings;
	import app.contoller.events.DataLoadServiceEvent;
	import app.model.datafact.DateInfo;
	import app.model.materials.Fact;
	import app.view.baseview.slider.VerticalHorizontalSlider;
	import app.view.page.fact.onedayfactslider.OneDayFactSlider;
	import app.view.utils.Tool;
	import com.greensock.easing.Circ;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * 
	 * @author metalcorehero
	 */
	
	public class FactsAllSlider extends VerticalHorizontalSlider
	{
		private var futureIndex:int = -1;
		private var pastIndex:int = 1;		
		private var state:String = "INIT";
		public var offset:int = 0;
		public var limit:int = 3;
		public var dir:String = "PRESENT";
		
		private var futureAllLoaded:Boolean = false;
		private var pastAllLoaded:Boolean = false;		
		private var isNeedClear:Boolean = true;		
		
		public function FactsAllSlider():void
		{
			super();			
			dynamicLoad = true;			
			init();		
		}
		
		public function prepareToClear(e:DataLoadServiceEvent = null):void
		{
			isNeedClear = true;
			isChangedDirection = true;
		}
		
		private function init():void
		{
			Tool.removeAllChildren(sliderContainer);
			if (contains(sliderContainer))removeChild(sliderContainer);	
			sliderContainer = new Sprite();			
			addChild(sliderContainer);	
			
			sliders = new Vector.<OneDayFactSlider>();
			this.y = AppSettings.HEIGHT - 2 * OneDayFactSlider.HEIGHT;
			
			dir = "PRESENT";
			state = "INIT";
			offset = 0;
			limit = 3;
			futureIndex = -1;
			pastIndex = 1;
			futureAllLoaded = false;
			pastAllLoaded = false;
			maxBorder = AppSettings.HEIGHT;			
			initY = 0;
			lastY = 0;			
			startXY = new Object;
			margin = 400;
			direction = "NONE";
			TRY_HEIGHT = -1;
		}		
		
		public function refreshData(allNewsList:Vector.<Fact>, dateInfo:DateInfo):void
		{
			if (!allNewsList || allNewsList.length == 0)
				return;
				
			if (isNeedClear) 
			{
				init();
				isNeedClear = false;
			}
			
			var daySlider:OneDayFactSlider = new OneDayFactSlider(allNewsList, dateInfo, dir);
			
			switch (dateInfo.futurePastCurrent)
			{
				case "CURRENT": 
					daySlider.y = 0;
					break;
					
				case "PAST": 
					daySlider.y = OneDayFactSlider.HEIGHT * pastIndex++;
					break;
					
				case "FUTURE": 
					initY = OneDayFactSlider.HEIGHT * futureIndex;
					daySlider.y = OneDayFactSlider.HEIGHT * futureIndex--;
					break;
				default: 
			}
			limit--;						
			daySlider.startInteraction();			
			addElement(daySlider);
			
			daySlider.x = AppSettings.WIDTH;
			TweenLite.to(daySlider, 0.6, {delay: 0.2, x: 0, ease: Circ.easeOut, onComplete: daySlider.startInteraction});
		
			//if (limit < 0)				
				dispatchEvent(startInteractEvent);		
			
		}		
		
		public function stopLoading():void
		{			
			var len:int = 3 - Math.abs(futureIndex);
			
			if (len > 0)
			{
				for (var i:int = 0; i < len; i++) 
				{
					var daySlider:OneDayFactSlider = new OneDayFactSlider(null, null, "",true);
					initY = OneDayFactSlider.HEIGHT * futureIndex;
					daySlider.y = OneDayFactSlider.HEIGHT * futureIndex--;
					addElement(daySlider);
				}
			}		
			
			limit = limit + futureIndex -1;		
			
			if (dir == "TO_FUTURE")
			{
				futureAllLoaded = true;					
				animatetoStartY();			
			}
			else if (dir == "TO_PAST")
			{
				pastAllLoaded = true;					
				animatetoFinishY();
			}
			
			isChangedDirection = true;			
			dispatchEvent(startInteractEvent);			
		}	
		
		public var isChangedDirection:Boolean = true;
		
		override protected function loadNews(direction:String):Number
		{
			var finalY:Number;
			var time:Number;
			var i:int;
			
			if (direction == "TO_PAST")
			{
				if (dir == "TO_FUTURE")
				{
					present();					
					return finalY;
				}
				else if (dir == "PRESENT" || dir == "TO_PAST")
				{
					dispatchEvent(stopInteractEvent);
					maxBorder = AppSettings.HEIGHT + 3 * OneDayFactSlider.HEIGHT;
					initY = OneDayFactSlider.HEIGHT;
					
					offset = -pastIndex;
					limit = 2;
					dir = direction;
					dispatchEvent(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_FACTS_DATA));
					
					for (var j:int = 0; j < sliders.length; j++) 				
					sliders[j].lightPast();	
					
					return maxBorder - _height() - 2 * OneDayFactSlider.HEIGHT - initY-/*ПОПРАВКА*/ (AppSettings.HEIGHT - OneDayFactSlider.HEIGHT * 3);
				}
			}
			
			if (direction == "TO_FUTURE")
			{
				if (dir == "TO_PAST")
				{
					present();						
					return finalY;					
				}
				else
				{
					if (futureAllLoaded) return NaN;
					dispatchEvent(stopInteractEvent);					
					dir = "TO_FUTURE"
					maxBorder = AppSettings.HEIGHT + 2 * OneDayFactSlider.HEIGHT;
					offset = -futureIndex;
					limit = 2;
					dispatchEvent(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_FACTS_DATA));					
					return -initY + 3 * OneDayFactSlider.HEIGHT;						
				}				
			}
			
			return NaN;
			
			function present():void
			{
				dispatchEvent(stopInteractEvent);
				
				futureAllLoaded = false;
				pastAllLoaded = false;
				
				initY = OneDayFactSlider.HEIGHT * -2;
				maxBorder = AppSettings.HEIGHT;
				
				for (i = sliders.length - 1; i >= 4; i--)
					removeElement(sliders.pop());	
					
				for (var j:int = 0; j < sliders.length; j++) 				
					sliders[j].darkPast();			
				
				pastIndex = 2;
				futureIndex = -3;
				dir = "PRESENT";
				isChangedDirection = true;
				
				dispatchEvent(startInteractEvent);
				finalY = AppSettings.HEIGHT - 2 * OneDayFactSlider.HEIGHT;								
			}		
		}	
	}
}
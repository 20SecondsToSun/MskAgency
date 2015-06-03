package ipad.view.slider 
{
	import app.contoller.events.ChangeTimeToShowEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.InteractiveEvent;
	import flash.events.MouseEvent;

	/**
	 * ...
	 * @author metalcorehero
	 */
	public class VerticalNewsSlider extends VerticalSlider 
	{
		private var lastIndex:int = 0;
		public var isTimeChanging:Boolean  = true;
		public var offDynamicLoad:Boolean  = false;
		
		public function VerticalNewsSlider() 
		{
			super();			
		}
		
		override protected function updateDragSlider(e:MouseEvent):void
		{
			super.updateDragSlider(e);
			if (isTimeChanging) 
				checkTimeToShow();
			
		}
		override protected function finishDraggingAnimation():void
		{
			super.finishDraggingAnimation();
			
			if (isTimeChanging) 
				checkTimeToShow();
		}
		protected function checkTimeToShow():void
		{			
			if (this.y + elemensArray[lastIndex].y + elemensArray[lastIndex].height - 50 < 0)
			{
				if (elemensArray[lastIndex].oneNewData.publishedDate.getHours() != elemensArray[lastIndex + 1].oneNewData.publishedDate.getHours())
				{
					dispatchEvent(new ChangeTimeToShowEvent(ChangeTimeToShowEvent.CHANGE_TIME, elemensArray[lastIndex + 1].oneNewData.publishedDate.getHours()));
				}
				
				lastIndex = lastIndex + 1;
				
			}
			if (lastIndex != 0 && this.y + elemensArray[lastIndex - 1].y > 0)
			{
				if (elemensArray[lastIndex].oneNewData.publishedDate.getHours() != elemensArray[lastIndex - 1].oneNewData.publishedDate.getHours())
				{
					dispatchEvent(new ChangeTimeToShowEvent(ChangeTimeToShowEvent.CHANGE_TIME, elemensArray[lastIndex - 1].oneNewData.publishedDate.getHours()));
				}
				
				lastIndex = lastIndex - 1;
			}
		}
		
		override protected function loadNews(direction:String):Number
		{			
			if (offDynamicLoad)
			{
				initListeners();
				animatetoFinishY();
				return startY;
			}
			if (direction == "TO_FUTURE")
			{
				initListeners();
				animatetoStartY();
				return startY;
			}
		
			stopInteraction();			
			dispatchEvent( new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_MATERIAL_NEAR_NEWS));	
			
			return startY;
		}		
	}
}
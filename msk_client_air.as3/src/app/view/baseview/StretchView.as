package app.view.BaseView 
{
	import stend.view.InteractiveObject.InteractiveStretch;
	import stend.service.gestureDetector.GestureEvent;
	/**
	 * ...
	 * @author metalcorehero
	 */	
	public class StretchView extends InteractiveStretch  implements IView
	{
		
		public function StretchView() 
		{
			addEventListener(GestureEvent.STRETCH_OUT, stretchPercentHandler);
		}
		public function mainViewStartAnimation():void 
		{
			
		}
		public function stretchPercentHandler(e:GestureEvent):void 
		{
			
		}
		
	}

}
package app.view.baseview 
{
	import app.contoller.events.InteractiveEvent;
	import app.model.config.ScreenShots;
	import app.model.datauser.IUser;
	import com.greensock.TweenLite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class MainScreenView extends BaseView
	{	
		protected var waitTimeToAnimt:int = 4;
		protected var startRotatorTimer:Timer = new Timer(4000, 1);
		
		public var isAutoAnimation:Boolean =  false;
		public var isAllowAnimation:Boolean = true;		
		public var config:ScreenShots;
		
		public function setScreen():void
		{
			
		}
		
		public function waitToAnim():void
		{
			if (isAllowAnimation && !isAutoAnimation) 
				TweenLite.delayedCall(waitTimeToAnimt, startAutoAnimation);
			
			if (!isAllowAnimation) 
			{
				startRotatorTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, completeTimer);
				startRotatorTimer.stop();
			}
		}
		
		public function setTimer(time:Number):void
		{			
			startRotatorTimer = new Timer(time, 1);
			startRotatorTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, completeTimer);
			startRotatorTimer.addEventListener(TimerEvent.TIMER_COMPLETE, completeTimer);
			startRotatorTimer.reset();
			startRotatorTimer.start();
		}
		
		public function MainScreenView()
		{			
			startRotatorTimer.addEventListener(TimerEvent.TIMER_COMPLETE, completeTimer);
			startRotatorTimer.reset();
			startRotatorTimer.start();	
		}
		
		public function kill():void
		{
			startRotatorTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, completeTimer);
			startRotatorTimer.stop();	
		}
		
		private function completeTimer(e:TimerEvent):void 
		{
			startAutoAnimation();
		}
		
		public function startRotator():void 
		{				
			if (!isAllowAnimation) return;// = true;
			if (isAutoAnimation) return;				
			startRotatorTimer.reset();
			startRotatorTimer.start();			
		}
		
		public function stopRotator():void 
		{
			isAllowAnimation = false;
			
			if (isAutoAnimation)
			{
				startRotatorTimer.stop();
				stopAutoAnimation();
			}			
		}
		
		override public function hideView():void
		{			
			super.hideView();			
			stopRotator();			
		}		
		
		protected function startAutoAnimation():void 
		{
			isAutoAnimation = true;
		}
		
		public function stopAutoAnimation():void 
		{
			isAutoAnimation = false;
		}		
	}
}
package app.view.page
{
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.ScreenshotEvent;
	import app.model.dataall.IAllNewsModel;
	import flash.geom.Rectangle;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class PageMediator extends Mediator
	{
		
		public var activeView:*;
		public var activeModel:*;
		[Inject]
		public var mainmodel:IAllNewsModel;
		
		override public function onRegister():void
		{
			//--------------------------------------------------------------------------
			//
			//  Page Animation
			//
			//--------------------------------------------------------------------------			
			addViewListener(AnimationEvent.PAGE_ANIMATION_FINISHED, pageAnimFinish, AnimationEvent);
			
			//--------------------------------------------------------------------------
			//
			//  Navigation
			//
			//--------------------------------------------------------------------------	
			
			addContextListener(ChangeLocationEvent.FLIP_MODE, flip, ChangeLocationEvent);
			addContextListener(ChangeLocationEvent.EXPAND_MODE, expand, ChangeLocationEvent);
			addContextListener(ChangeLocationEvent.STRETCH_MODE, stretch, ChangeLocationEvent);
			addContextListener(ChangeLocationEvent.STRETCH_IN, stretchIN, ChangeLocationEvent);
			addContextListener(ChangeLocationEvent.BACK_FROM_ONE_NEW_START, backFromOneNew, ChangeLocationEvent);
			addContextListener(ChangeLocationEvent.MAIN_SCREEN_MENU_MODE, flip, ChangeLocationEvent);
			addContextListener(ChangeLocationEvent.REMOVE_PAGE, removeAllListeners, ChangeLocationEvent);
		}
		
		protected function pageAnimFinish(e:AnimationEvent):void
		{
			dispatch(e.clone());
		}
		
		protected function stretchIN(e:ChangeLocationEvent):void
		{
		
		}
		
		protected function backFromOneNew(e:ChangeLocationEvent):void
		{
		
		}
		
		protected function stretch(e:ChangeLocationEvent):void
		{
		
		}
		
		protected function expand(e:ChangeLocationEvent):void
		{
			activeView.expand_rectangle = mainmodel.getChoosenField().rec;
			activeView.expand();
		}
		
		private function flip(e:ChangeLocationEvent):void
		{
			activeView.flip();
		}
		
		private function refreshData(e:DataLoadServiceEvent):void
		{
			activeView.refreshData();
		}
		
		protected function animateView(e:AnimationEvent):void
		{
			activeView.toMainScreen();
		}
		
		protected function removeAllListeners(e:ChangeLocationEvent):void
		{
			removeViewListener(AnimationEvent.PAGE_ANIMATION_FINISHED, dispatch, AnimationEvent);
			removeContextListener(ChangeLocationEvent.FLIP_MODE, flip, ChangeLocationEvent);
			removeContextListener(ChangeLocationEvent.EXPAND_MODE, expand, ChangeLocationEvent);
			removeContextListener(ChangeLocationEvent.STRETCH_MODE, stretch, ChangeLocationEvent);
			removeContextListener(ChangeLocationEvent.BACK_FROM_ONE_NEW_START, backFromOneNew, ChangeLocationEvent);
			removeContextListener(ChangeLocationEvent.MAIN_SCREEN_MENU_MODE, flip, ChangeLocationEvent);
			removeContextListener(ChangeLocationEvent.STRETCH_IN, stretchIN, ChangeLocationEvent);
		}
		
		override public function preRemove():void
		{
			activeView.remove();
		}
	}
}
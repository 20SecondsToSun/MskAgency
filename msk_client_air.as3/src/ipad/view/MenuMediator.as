package ipad.view
{
	import app.contoller.events.GraphicInterfaceEvent;
	import app.contoller.events.InteractiveEvent;
	import app.view.page.oneNews.Buttons.FavoritesButton;
	import flash.events.MouseEvent;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class MenuMediator extends Mediator
	{
		[Inject]
		public var view:Menu;
		
		override public function onRegister():void
		{
			//addViewListener(InteractiveEvent.CLICK, clickMenu, InteractiveEvent);	
			addViewListener(MouseEvent.MOUSE_DOWN, clickMenu, MouseEvent);
			addContextListener(GraphicInterfaceEvent.SELECT_ITEM, clickedMenu, GraphicInterfaceEvent);
		}	
		
		private function clickedMenu(e:GraphicInterfaceEvent):void 
		{
			view.setActiveButton(e.data);
		}
		
		private function clickMenu(e:MouseEvent):void 
		{
			//trace("PUSH!!", e.target,e.currentTarget);
			if (e.target is Button)
			{
				var btn:Button = e.target as Button;
				if (btn.active) return;
				
				dispatch(new GraphicInterfaceEvent(GraphicInterfaceEvent.SELECT_ITEM, null, btn.id));
			}
		}
	}
}
package ipad.services.state
{
	import app.view.MainView;
	import flash.display.DisplayObjectContainer;
	import ipad.view.Body;
	import org.robotlegs.mvcs.Actor;
	
	public class NavigationService extends Actor implements INavigationService
	{
		[Inject]
		public var contextView:DisplayObjectContainer;		
		
		private var view:Body;
		
		public function start():void
		{			
			view = (contextView.getChildByName("body") as Body);
			
			
			view.start();

		}		
		
	}
}
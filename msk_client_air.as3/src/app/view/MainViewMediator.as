package app.view
{
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class MainViewMediator extends Mediator
	{
		[Inject]
		public var view:MainView;
		
		override public function onRegister():void
		{
		
		}	
	}
}
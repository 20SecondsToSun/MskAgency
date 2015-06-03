package app.view.page
{
	import app.contoller.events.IpadEvent;
	import app.model.dataall.IAllNewsModel;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class BroadcastPageMediator extends PageMediator
	{
		[Inject]
		public var view:BroadcastPage;	
		
		[Inject]
		public var model:IAllNewsModel;
		
		override public function onRegister():void
		{
			activeView = view;
			activeModel = model;
			super.onRegister();	
			addContextListener(IpadEvent.VOLUME, volumeHandler, IpadEvent);
		}	
		
		private function volumeHandler(e:IpadEvent):void 
		{
			var vol:String  = Math.floor(e.data * 100).toString();
			view.setVolume(vol);
		}
	}

}


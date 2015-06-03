package ipad.view
{
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.GraphicInterfaceEvent;
	import app.contoller.events.IpadEvent;
	import app.model.materials.Fact;
	import app.model.materials.Material;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import ipad.model.IInfo;
	import ipad.model.ipad.IIpadNewsModel;
	import ipad.view.slider.Element;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class BodyMediator extends Mediator
	{
		[Inject]
		public var view:Body;
		
		[Inject]
		public var info:IInfo;
		
		override public function onRegister():void
		{
			addContextListener(GraphicInterfaceEvent.SELECT_ITEM, gotoPage, GraphicInterfaceEvent);
			addViewListener(IpadEvent.SHOW_MATERIAL, showMaterial, IpadEvent);
			addViewListener(IpadEvent.CUSTOM_SCREEN_RUBRIC, dispatch, IpadEvent);
			addViewListener(IpadEvent.PRIMARY_SCREEN, changePrimaryScreen, IpadEvent);
			addContextListener(GraphicInterfaceEvent.CHANGE_CUSTOM_SCREEN_RUBRIC, setRubric, GraphicInterfaceEvent);
			addContextListener(GraphicInterfaceEvent.CHANGE_PRIMARY_SCREEN, primaryScreen, GraphicInterfaceEvent);
			addContextListener(IpadEvent.CLOSE_MATERIAL, closeMaterial, IpadEvent);
			addContextListener(IpadEvent.PLAY, view.sendPlay, IpadEvent);
			addContextListener(IpadEvent.PAUSE, view.sendPause, IpadEvent);
			addContextListener(IpadEvent.VOLUME, view.volChanged, IpadEvent);
			
			addViewListener(IpadEvent.PLAY, changedParametres, IpadEvent);
			addViewListener(IpadEvent.PAUSE, changedParametres, IpadEvent);
			addViewListener(IpadEvent.USER_ACTIVE, changedParametres, IpadEvent);
			addViewListener(IpadEvent.USER_LOST, changedParametres, IpadEvent);
			addViewListener(IpadEvent.HAND_ACTIVE, changedParametres, IpadEvent);
			addViewListener(IpadEvent.HAND_LOST, changedParametres, IpadEvent);
			addViewListener(IpadEvent.START_INTERACTION, changedParametres, IpadEvent);
			addViewListener(IpadEvent.STOP_INTERACTION, changedParametres, IpadEvent);
			
			addViewListener(IpadEvent.SYMBOLS_BAD, symbolsBad, IpadEvent);
			
			addViewListener(IpadEvent.ID_CHOOSED, view.idChoosed, IpadEvent);
			//addViewListener(IpadEvent.SYMBOLS_CHOOSED, view.sendChecked, IpadEvent);		
			
			addViewListener(MouseEvent.MOUSE_DOWN, clickstart, MouseEvent);
		
		}
		
		private function symbolsBad(e:IpadEvent):void
		{
			clickNums = 0;
		}
		
		private var num1:int = 0;
		private var num2:int = 0;
		private var clickNums:int = 0;
		
		private function clickstart(e:MouseEvent):void
		{
			if (e.target.name == "startButton")
			{
				if (view.startPopup.myTextField.text == "")
					return;
					
				saveData(view.startPopup.myTextField.text);
				
				trace("TRY EEEEEEEEEEEEEEEE");
				view.idChoosed();
				
			}
			if (e.target.name == "butClose")
			{
				view.startPopup.init();
			}
		/*if ("circle" == e.target.name.slice( 0, -1 ))
		   {
		   //trace("e.target.name",  e.target.name.slice( -1 ));
		   clickNums++;
		   if (clickNums == 2)
		   {
		   num2 = e.target.name.slice( -1 );
		   view.sendChecked(num1, num2);
		   }
		   else if (clickNums == 1)
		   {
		   num1 = e.target.name.slice( -1 );
		   }
		 }		*/
		}
		
		private function saveData(text:String):void
		{
			var fs:FileStream = getSaveStream(true, false);
			fs.writeUTF(text);
			fs.close();
		}
		
		private function getSaveStream(write:Boolean, sync:Boolean = true):FileStream
		{
			// The data file lives in the app storage directory, per iPhone guidelines. 
			//var f:File = File.applicationStorageDirectory.resolvePath("myApp.dat");
			var f:File = File.desktopDirectory.resolvePath("myApp.dat");
			
			//if (f.exists == false)
			//	return null;
			
			// Try creating and opening the stream.
			var fs:FileStream = new FileStream();
			try
			{
				// If we are writing asynchronously, openAsync.
				if (write && !sync)
					fs.openAsync(f, FileMode.WRITE);
				else
				{
					// For synchronous write, or all reads, open synchronously.
					fs.open(f, write ? FileMode.WRITE : FileMode.READ);
				}
			}
			catch (e:Error)
			{
				// On error, simply return null.
				return null;
			}
			return fs;
		}
		
		private function changePrimaryScreen(e:IpadEvent):void
		{
			dispatch(e.clone());
		}
		
		private function changedParametres(e:IpadEvent):void
		{
			trace("INIT:::::::", e.type);
			switch (e.type)
			{
				case IpadEvent.PLAY:
					
					break;
				case IpadEvent.PAUSE:
					
					break;
				case IpadEvent.USER_ACTIVE: 
					info.isKinectUser = true;
					dispatch(new IpadEvent(IpadEvent.USER_ACTIVE));
					break;
				case IpadEvent.USER_LOST: 
					info.isKinectUser = false;
					dispatch(new IpadEvent(IpadEvent.USER_LOST));
					view.hideKinectPopup();
					break;
				case IpadEvent.HAND_ACTIVE: 
					info.isHandActive = true;
					view.showKinectPopup();
					dispatch(new IpadEvent(IpadEvent.HAND_ACTIVE));
					break;
				case IpadEvent.HAND_LOST: 
					info.isHandActive = false;
					view.hideKinectPopup();
					dispatch(new IpadEvent(IpadEvent.HAND_LOST));
					break;
				case IpadEvent.START_INTERACTION: 
					view.hideBlockPopup();
					dispatch(new IpadEvent(IpadEvent.START_INTERACTION));
					break;
				/*case IpadEvent.STOP_INTERACTION:
				   view.showBlockPopup();
				   dispatch(new IpadEvent(IpadEvent.STOP_INTERACTION));
				 break;*/ //IPAD!!!!!!!!!!!!!
				default: 
			}
		}
		
		private function closeMaterial(e:IpadEvent):void
		{
			view.sendClose();
		}
		
		private function primaryScreen(e:GraphicInterfaceEvent):void
		{
			view.changePrimaryScreen(e.data);
		}
		
		private function setRubric(e:GraphicInterfaceEvent):void
		{
			view.changeCustomScreen(e.data);
		}
		
		private function showMaterial(e:IpadEvent):void
		{
			if (e.data == null)
				return;
			
			if (e.data.type == "Material")
			{
				view.sendMaterial(e.data.element as Material);
			}
			else if (e.data.type == "Fact")
			{
				view.sendFact(e.data.element as Fact);
			}
		}
		
		private function gotoPage(e:GraphicInterfaceEvent):void
		{
			view.showBlockPopup();
			view.gotoPage(e.data);
		}
	}
}
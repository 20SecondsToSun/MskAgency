package ipad.view
{
	import app.AppSettings;
	import app.view.utils.BigCanvas;
	import com.greensock.plugins.ShortRotationPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenMax;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.ReturnKeyLabel;
	import flash.text.StageText;
	import flash.text.StageTextInitOptions;
	import ipad.assets.Assets;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ipad.controller.IpadConstants;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class StartPopup extends Sprite
	{
		private var shape:Shape;
		
		private var kinectPopup:Sprite;
		private var textFormat:TextFormat = new TextFormat("TornadoL", 72 * IpadConstants.contentScaleFactor, 0xffffff);
		private var textFormat1:TextFormat = new TextFormat("Tornado", 36 * IpadConstants.contentScaleFactor, 0xa4b1c0);
		
		private var handsIpad:Sprite;
		private var handsIpad1:Sprite;
		private var screenshotBottom:BigCanvas;
		private var screenshot:BigCanvas;
		private var overlay:Shape;
		public var myTextField:StageText;
		private var mainTitle1:TextField;
		private var mainTitle2:TextField;
		private var mainTitle3:TextField;
		private var mainTitle_promt:TextField;
		private var startButton:Sprite;
		
		public function StartPopup()
		{
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		
			//addEventListener(Event.ENTER_FRAME, animateHands);
			//addLayerOverlay();
		
			//kinectPopup.visible = false;
		}
		private var status:Sprite;
		private var crosserror:Sprite;
		
		private function getSaveStream(write:Boolean, sync:Boolean = true):FileStream
		{
			// The data file lives in the app storage directory, per iPhone guidelines. 
			//var f:File = File.applicationStorageDirectory.resolvePath("myApp.dat");
			var f:File = File.desktopDirectory.resolvePath("myApp.dat");
			
			if (f.exists == false)
				return null;
			
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
		
		public function init(e:Event = null):void
		{
			// Get the stream and read from it.
			var fs:FileStream = getSaveStream(false);
			var _id:String;
			if (fs)
			{
				try
				{
					_id = fs.readUTF();
					fs.close();
				}
				catch (e:Error)
				{
					trace("Couldn't load due to error: " + e.toString());
				}
			}
			
			trace("Loaded _id = " + _id);
			
			TweenLite.killDelayedCallsTo(errorMode);
			if (mainTitle2 && contains(mainTitle2))
				removeChild(mainTitle2);
			if (mainTitle3 && contains(mainTitle3))
				removeChild(mainTitle3);
			if (crosserror && contains(crosserror))
				removeChild(crosserror);
			if (butClose && contains(butClose))
				removeChild(butClose);
			
			mainTitle1 = TextUtil.createTextField(80, 80);
			mainTitle1.text = "Укажите ID стенда, к которому хотите подключиться";
			mainTitle1.setTextFormat(textFormat1);
			addChild(mainTitle1);
			
			status = Assets.create("statusbar");
			status.scaleX = status.scaleY = IpadConstants.contentScaleFactor;
			addChild(status);
			status.x = 0.5 * (IpadConstants.GameWidth - status.width);
			status.y = 0.5 * (IpadConstants.GameHeight - status.height) - status.height * 0.5;
			
			textFormat1.size = 54 * IpadConstants.contentScaleFactor;
			mainTitle_promt = TextUtil.createTextField(80, 80);
			mainTitle_promt.text = "ID Стенда";
			mainTitle_promt.setTextFormat(textFormat1);
			mainTitle_promt.x = 0.5 * (IpadConstants.GameWidth - 100 - mainTitle_promt.width)
			mainTitle_promt.y = status.y + 18;
			addChild(mainTitle_promt);
			textFormat1.size = 36 * IpadConstants.contentScaleFactor;
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var opt:StageTextInitOptions = new StageTextInitOptions(false);
			
			myTextField = new StageText(opt);
			myTextField.color = 0x828696;
			myTextField.fontSize = 54 * IpadConstants.contentScaleFactor;
			myTextField.text = _id != null?_id:"";
			
			myTextField.returnKeyLabel = ReturnKeyLabel.SEARCH;
			myTextField.addEventListener(KeyboardEvent.KEY_UP, keyUpEventHandler);
			myTextField.addEventListener(KeyboardEvent.KEY_DOWN, keyDownEventHandler);
			myTextField.stage = stage;
			myTextField.textAlign = "center";
			
			myTextField.viewPort = new Rectangle(status.x, status.y + 18, status.width - 100, 60);
			//myTextField.text = "";
			
			startButton = new Sprite();
			startButton.name = "startButton";
			addChild(startButton);
			
			var over:Shape = Tool.createShape(100, status.height, 0x5c9f42);
			startButton.addChild(over);
			startButton.alpha = 0;
			startButton.x = status.x + status.width - startButton.width;
			startButton.y = status.y;
			
			addEventListener(Event.ENTER_FRAME, checkStageText);
		
			//initfigures();
		
		}
		
		private function checkStageText(e:Event):void
		{
			if (myTextField.text.length)
			{
				mainTitle_promt.text = "";
			}
			else
			{
				mainTitle_promt.text = "ID Стенда";
				textFormat1.size = 54 * IpadConstants.contentScaleFactor;
				mainTitle_promt.setTextFormat(textFormat1);
				textFormat1.size = 36 * IpadConstants.contentScaleFactor;
			}
		}
		
		public function waitingMode():void
		{
			removeEventListener(Event.ENTER_FRAME, checkStageText);
			removeChild(startButton);
			myTextField.dispose();
			removeChild(mainTitle1);
			removeChild(mainTitle_promt);
			removeChild(status);
			
			mainTitle2 = TextUtil.createTextField(0, 0);
			mainTitle2.text = "Необходимо подтверждение...";
			mainTitle2.setTextFormat(textFormat);
			mainTitle2.x = 0.5 * (IpadConstants.GameWidth - mainTitle2.width);
			mainTitle2.y = 0.5 * (IpadConstants.GameHeight - mainTitle2.height) - 30;
			addChild(mainTitle2);
			
			mainTitle3 = TextUtil.createTextField(0, 0);
			mainTitle3.text = "Для синхронизации устройств нажмите на стенде кнопку «Разрешить доступ»";
			mainTitle3.setTextFormat(textFormat1);
			mainTitle3.x = 0.5 * (IpadConstants.GameWidth - mainTitle3.width);
			mainTitle3.y = mainTitle2.y + mainTitle2.height + 10;
			addChild(mainTitle3);
			
			TweenLite.delayedCall(AppSettings.IPAD_SYNCH_TIME, errorMode);
			//TweenLite.delayedCall(2, okMode);			
		}
		
		public function okMode():void
		{
			TweenLite.delayedCall(2, errorMode);
		}
		
		private var butClose:Sprite;
		
		private function errorMode():void
		{
			removeChild(mainTitle2);
			removeChild(mainTitle3);
			removeEventListener(Event.ENTER_FRAME, checkStageText);
			
			mainTitle2 = TextUtil.createTextField(0, 0);
			mainTitle2.text = "Ошибка!";
			mainTitle2.setTextFormat(textFormat);
			mainTitle2.x = 0.5 * (IpadConstants.GameWidth - mainTitle2.width);
			mainTitle2.y = 0.5 * (IpadConstants.GameHeight - mainTitle2.height) + 30;
			addChild(mainTitle2);
			
			mainTitle3 = TextUtil.createTextField(0, 0);
			textFormat1.align = "center";
			mainTitle3.text = "Убедитесь в правильности указанного ID\nили проверьте подключен ли ваш iPad к сети Интернет";
			mainTitle3.setTextFormat(textFormat1);
			textFormat1.align = "left";
			mainTitle3.x = 0.5 * (IpadConstants.GameWidth - mainTitle3.width);
			mainTitle3.y = mainTitle2.y + mainTitle2.height + 10;
			addChild(mainTitle3);
			
			crosserror = Assets.create("crosserror");
			crosserror.scaleX = crosserror.scaleY = IpadConstants.contentScaleFactor;
			crosserror.y = mainTitle2.y - crosserror.height - 50;
			crosserror.x = 0.5 * (IpadConstants.GameWidth - crosserror.width);
			addChild(crosserror);
			
			butClose = new Sprite();
			var over:Shape = Tool.createShape(IpadConstants.GameWidth, IpadConstants.GameHeight, 0x5c9f42);
			over.alpha = 0;
			butClose.addChild(over);
			butClose.name = "butClose";
			addChild(butClose);
		
		}
		
		private function keyDownEventHandler(e:KeyboardEvent):void
		{
		
		}
		
		private function keyUpEventHandler(e:KeyboardEvent):void
		{
		
		}
		
		public function rightNums(a1:String, a2:String):void
		{
			removeChild(startButton);
			myTextField.dispose();
			removeChild(mainTitle1);
			
			initfigures();
		}
		public var clickNums:int = 0;
		
		private function initfigures():void
		{
			/*for (var i:int = 0; i < 6; i++)
			   {
			
			   }
			 */
			for (var i:int = 0; i < 6; i++)
			{
				var circle:Sprite = new Sprite();
				/*if (i + 1 == firstNum || i + 1 == secondNum )
				   {
				   circle.graphics.beginFill(0xFFF000);
				   }
				 else*/
				circle.name = "circle" + (i + 1).toString();
				circle.graphics.beginFill(0xFF794B);
				circle.graphics.drawCircle(50, 50, 50);
				circle.graphics.endFill();
				addChild(circle);
				circle.x = 100 + 120 * i;
				circle.y = 0.5 * (IpadConstants.GameHeight - circle.height) + 150;
			}
		}
		
		private function animateHands():void
		{
			left();
		}
		
		private function left():void
		{
			TweenMax.to(handsIpad, 0.7, {shortRotation: {rotation: 10}, x: 0.5 * IpadConstants.GameWidth + 150, onComplete: right});
		}
		
		private function right():void
		{
			TweenMax.to(handsIpad, 0.7, {shortRotation: {rotation: -10}, x: 0.5 * IpadConstants.GameWidth - 150, onComplete: left});
		}
		
		public function addLayerOverlay():void
		{
			overlay = Tool.createShape(IpadConstants.GameWidth, IpadConstants.GameHeight, 0x465568);
			overlay.alpha = 0.68;
			//overlay.visible = false;
			
			addChildAt(overlay, 1);
		}
		
		public function makeScreenshotBottom(shot:BigCanvas):void
		{
			screenshotBottom = new BigCanvas(IpadConstants.GameWidth, IpadConstants.GameHeight);
			screenshotBottom.draw(shot);
		}
		
		public function makeScreenshotBlur(shot:DisplayObject):void
		{
			var jpgSource:BitmapData = new BitmapData(IpadConstants.GameWidth, IpadConstants.GameHeight);
			
			jpgSource.draw(shot);
			
			var BLUR_FILTER:BlurFilter = new BlurFilter(36, 36, 4);
			jpgSource.applyFilter(jpgSource, jpgSource.rect, new Point, BLUR_FILTER);
			
			screenshot = new BigCanvas(IpadConstants.GameWidth, IpadConstants.GameHeight);
			screenshot.draw(jpgSource);
		}
		
		public function hideBlockPopup():void
		{
			TweenLite.to(shape, 0.6, {alpha: 0, onComplete: function():void
				{
					shape.visible = false;
				}});
		}
		
		public function showBlockPopup(view:DisplayObject = null):void
		{
			shape.visible = true;
			TweenLite.to(shape, 0.6, {alpha: 0.6});
		
		}
		
		public function showKinectPopup():void
		{
			shape.visible = false;
			makeScreenshotBlur(parent);
			addLayerOverlay();
			addChildAt(screenshot, 0);
			kinectPopup.visible = true;
			handsIpad.x = 0.5 * IpadConstants.GameWidth;
			handsIpad.y = 668 * IpadConstants.contentScaleFactor;
			handsIpad.rotation = 0;
			animateHands();
		}
		
		public function hideKinectPopup():void
		{
			kinectPopup.visible = false;
			if (overlay && contains(overlay))
				removeChild(overlay);
			if (screenshot && contains(screenshot))
				removeChild(screenshot);
			TweenMax.killTweensOf(handsIpad);
		}
	}
}
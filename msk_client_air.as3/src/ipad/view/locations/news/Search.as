package ipad.view.locations.news
{
	import app.contoller.events.IpadEvent;
	import app.view.utils.TextUtil;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.text.ReturnKeyLabel;
	import flash.text.StageText;
	import flash.text.StageTextInitOptions;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ipad.assets.Assets;
	import ipad.controller.IpadConstants;
	
	/**
	 * ...
	 * @author yuri
	 */
	public class Search extends Sprite
	{
		private var splash:Sprite;
		private var lupa:Sprite;
		private var textFormat:TextFormat = new TextFormat("TornadoL", 54 * IpadConstants.contentScaleFactor, 0x828696);
		private var txt:TextField;
		public var myTextField:StageText;
		private var state:String = "INIT";
		private var saveSearch:String = "";
		
		public function Search()
		{
			splash = new Sprite();
			splash.graphics.beginFill(0xdfe2e8);
			splash.graphics.drawRoundRect(0, 0, 1749 * IpadConstants.contentScaleFactor, 156 * IpadConstants.contentScaleFactor, 10, 10);
			splash.graphics.endFill();
			addChild(splash);
			
			lupa = Assets.create("lupa");
			lupa.width= lupa.width*IpadConstants.contentScaleFactor;
			lupa.height= lupa.height*IpadConstants.contentScaleFactor;
			
			lupa.y = Math.floor((splash.height - lupa.height) * 0.5);
			lupa.x = lupa.y;
			splash.addChild(lupa);
			
			txt = TextUtil.createTextField(0, 0);
			txt.text = "Поиск по новостям";
			txt.setTextFormat(textFormat);
			txt.x = lupa.x * 2 + lupa.width;
			txt.y = (splash.height - txt.height) * 0.5;
			addChild(txt);
			
			if (stage)
				addedStage();
			else
				addEventListener(Event.ADDED_TO_STAGE, addedStage);
				
			addEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
		}
		
		private function removeHandler(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
			removeEventListener(Event.ENTER_FRAME , checkEnterFrame);
		}
		
		private function addedStage(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedStage);				
			createStageText();
			addEventListener(Event.ENTER_FRAME , checkEnterFrame);
		}
		
		private function checkEnterFrame(e:Event):void 
		{
			if (myTextField) 
			{
				if (myTextField.text == "") txt.visible = true;
				else txt.visible = false;
			}
		}
		
		private function createStageText():void 
		{
			var opt:StageTextInitOptions = new StageTextInitOptions(false);	
			
			myTextField = new StageText(opt);			
			myTextField.color = 0x828696;
			myTextField.fontSize =  54 * IpadConstants.contentScaleFactor;
			myTextField.text = "";
			myTextField.returnKeyLabel = ReturnKeyLabel.SEARCH;
			myTextField.addEventListener(KeyboardEvent.KEY_UP, keyUpEventHandler);
			myTextField.addEventListener(KeyboardEvent.KEY_DOWN, keyDownEventHandler);
			myTextField.stage = stage;
			
			var _x:Number =  0.5 * (IpadConstants.GameWidth - 1748 * IpadConstants.contentScaleFactor);
			var _y:Number =  406 * IpadConstants.contentScaleFactor;
			
			myTextField.viewPort = new Rectangle(_x + txt.x, _y + txt.y, splash.width - txt.x * 2 + 40, 60);	
			myTextField.text = saveSearch;
		}
	
		public function secondStateStageText():void 
		{
			state = "LAST";
			var opt:StageTextInitOptions = new StageTextInitOptions(false);
			
			myTextField = new StageText(opt);
			//myTextField.multiline= false;
			myTextField.color = 0x828696;
			myTextField.fontSize =  54 * IpadConstants.contentScaleFactor*scaleX;
			myTextField.text = saveSearch;
			myTextField.returnKeyLabel = ReturnKeyLabel.SEARCH;
			myTextField.addEventListener(KeyboardEvent.KEY_UP, keyUpEventHandler);
			myTextField.addEventListener(KeyboardEvent.KEY_DOWN, keyDownEventHandler);
			myTextField.stage = stage;			
			
			var _x:Number = 118 * IpadConstants.contentScaleFactor;
			var _y:Number = 60 * IpadConstants.contentScaleFactor;
			
			myTextField.viewPort = new Rectangle(_x + txt.x * scaleX, _y + txt.y * scaleY, splash.width * scaleX - txt.x * scaleX * 2 + 30, 60);	
			myTextField.text = saveSearch;
			
			splash.removeChild(lupa);
			lupa = Assets.create("lupa1");
			splash.addChild(lupa);
			lupa.x = 21;// Math.floor(lupa.width);
			lupa.y = 21;// Math.floor(lupa.height);
	
		}	
		
		public function stageTextSet(mode:String):void 
		{
			if (mode == "off")
			{
				myTextField.visible = false;
				/*if (myTextField) 
				{
					saveSearch = myTextField.text;
					myTextField.dispose();
				}*/
			}
			else if (mode == "on")
			{
				myTextField.visible = true;
				/*if (state == "INIT")
					createStageText();
				else
					secondStateStageText();*/
			}
		}
		
		private function keyDownEventHandler(e:KeyboardEvent):void 
		{
			txt.visible = false;
		}
		
		private function keyUpEventHandler(e:KeyboardEvent):void
		{			
			if (myTextField.text == "") txt.visible = true;
			var data:Object = { name: "criteria", filter: myTextField.text };
			//myTextField.dispose();
			dispatchEvent(new IpadEvent(IpadEvent.FILTER_CHANGED, true, false, data));
			saveSearch = myTextField.text;
			//dispatchEvent(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_ALL_DATA_FOR_IPAD,true,false,-1,null,data));
		}
	}

}
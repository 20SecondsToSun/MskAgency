package ipad 
{
	import app.services.ipad.IpadConnector;
	import app.view.utils.TextUtil;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author ...
	 */
	[SWF(backgroundColor = "#ffffff", width = "1024", height = "768", frameRate = "60")]	
	
	public class Main extends Sprite
	{
		private var ipadConnector:IpadConnector;
		private var txt:TextField;
		private var textFormat:TextFormat = new TextFormat("Tornado", 33, 0X000000);
		private var btnArray:Vector.<flash.display.Sprite>;
		
			public function Main() 
		{		
			if(stage) init()else
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//ipadConnector = new IpadConnector(tracer);
			
			 txt = TextUtil.createTextField(100, 300);
			txt.embedFonts = false;
			txt.border = true;
			//txt.width = 600;			
			addChild(txt);
			txt.setTextFormat(textFormat);
			
			
			btnArray = new Vector.<Sprite>();
			
			for (var i:int = 0; i < 4; i++) 
			{
				var btn:Sprite = menuButton();
				btn.name = (i+1).toString();
				addChild(btn);
				btn.y = 100;
				btn.x = (i) * 200+50;
				btnArray.push(btn);
			}
			
			//allowButtons()
			
		}
		public function menuButton():Sprite 
		{			
			var circleMC:Shape = new Shape();
			circleMC.graphics.beginFill(0x02a7df * Math.random());			
			circleMC.graphics.drawCircle(80, 80, 80);
			
			var spr:Sprite = new Sprite();
			spr.addChild(circleMC);
			
			return spr;
		}		
		private function tracer(event:NetStatusEvent):void 
		{			
			txt.appendText( event.info.code + "\n");
			
			switch ( event.info.code)
			{
				case 'NetConnection.Connect.Success': 
					
					break;
				
					case 'NetGroup.Neighbor.Connect': 					
					allowButtons();
					break;
			
			  case 'NetGroup.Connect.Success':
				 // trace(event.info, event.info.peerID);
			  // this.dispatchEvent(new AppEvent(AppEvent.P2P_INIT, {}));
			  // sendPost({message: 'test'});
			   break;
			   case 'NetGroup.Neighbor.Disconnect':
					//disconnectUser(event.info);
					disableButtons();
			   break;				
		}		
	}
	
	private function allowButtons():void 
	{	
		addEventListener(MouseEvent.MOUSE_DOWN, handler);		
	}
	private function disableButtons():void 
	{		
		removeEventListener(MouseEvent.MOUSE_DOWN, handler);	
	}
	private var obj:Object = new Object();
	private function handler(e:MouseEvent):void 
	{
		if (e.target is Sprite)
		{
			txt.appendText( "post" + e.target.name+"\n");
			obj.id = e.target.name;
			obj.id1 = new Date().time;
			ipadConnector.netGroup.post(obj);
			trace(e.target.name);
		}		
	}
	}

}
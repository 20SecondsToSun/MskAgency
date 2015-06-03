package app.view.popup 
{
	import app.AppSettings;
	import app.assets.Assets;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.IpadEvent;
	import app.contoller.events.ServerErrorEvent;
	import app.view.baseview.io.InteractiveObject;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class ServicePopup extends InteractiveObject
	{
		private var tint:Shape;
		private var popup:Sprite;
		private var maskLayer:Shape;
		private var serverError:Sprite;
		private var kinectError:Sprite;
		private var symbolsHolder:Sprite;		
		
		private var firstNum:int;
		private var secondNum:int;
		private var ipadPopup:Sprite = new Sprite();
		
		private var textFormat:TextFormat = new TextFormat("TornadoL", 48, 0xffffff);
		private var textFormat1:TextFormat = new TextFormat("Tornado", 24, 0x828696);
		public var isOpen:Boolean = false;
		
		public static const userWaiting:int = 15;
		public static var randArr:Array = [1, 2, 3, 4, 5, 6];
		
		public function ServicePopup() 
		{
			pushEnabled = false;
			chargeEnabled = false;
			visible = false;
			
			tint  = Tool.createShape(AppSettings.WIDTH, AppSettings.HEIGHT, 0x18191d);
			tint.alpha = 0;
			addChild(tint);			
			
			popup = new Sprite();
			addChild(popup);
			
			var popupFill:Shape = Tool.createShape(AppSettings.WIDTH, 462, 0xe6e8ed);				
			popup.addChild(popupFill);			
			
			var glass:Sprite = Assets.create("glasses");			
			glass.y = (popupFill.height - glass.height) * 0.5;
			glass.x = 503;
			
			popup.addChild(glass);				
			popup.y = 0.5 * (AppSettings.HEIGHT - popup.height);
			
			var textFormat:TextFormat = new TextFormat("TornadoL", 48, 0X101318);			
			var textTitle:TextField = TextUtil.createTextField(43, 386);
			
			textTitle.multiline = true;
			textTitle.wordWrap = true;
			textTitle.width = 600;
			textTitle.text = "По вашему запросу\nне найдено ни одного материала";	
			textTitle.setTextFormat(textFormat);
			popup.addChild(textTitle);
			
			textTitle.y = (popupFill.height - textTitle.height) * 0.5;
			textTitle.x = glass.x + glass.width + 100;
			
			maskLayer  = Tool.createShape(AppSettings.WIDTH, 462, 0xe6e8ed);
			maskLayer.y  = popup.y;
			popup.mask = maskLayer;
			addChild(maskLayer);			
			
			serverError = Assets.create("serverError");			
			serverError.visible = false;
			addChild(serverError);
			
			kinectError = Assets.create("kinectError");			
			kinectError.visible = false;
			addChild(kinectError);
			
			symbolsHolder = new Sprite();
			addChild(symbolsHolder);			
			
			addChild(ipadPopup);
			ipadPopup.visible = false;
			
			var titleTxt:String = "Обнаружен iPad. Подключить?";
			
			var title:TextField = TextUtil.createTextField(0, 0);
			title.text = titleTxt;
			textFormat.color = 0xffffff;			
			title.setTextFormat(textFormat);
			textFormat.color = 0X101318;
			title.x = 0.5 * (AppSettings.WIDTH -  title.width);
			title.y = 260;
			ipadPopup.addChild(title);			
			
			var titleTxt1:String = "Авторизуйте или отклоните подключаемое устройство";			
			var title1:TextField = TextUtil.createTextField(0, 0);
			title1.text = titleTxt1;
			title1.setTextFormat(textFormat1);
			title1.x = 0.5 * (AppSettings.WIDTH -  title1.width);
			title1.y = title.y +title.height + 10;
			ipadPopup.addChild(title1);
			
			
			var btnOk:ButtonIpad = new ButtonIpad();
			btnOk.name = "btnOk";
			var btnNot:ButtonIpad = new ButtonIpad("NO");
			btnNot.name = "btnNo";
			
			ipadPopup.addChild(btnOk);
			btnOk.x = AppSettings.WIDTH*0.5 - btnOk.width - 20;
			btnOk.y =  0.5 * (AppSettings.HEIGHT - btnOk.height) + 80;// - 20;
			
			ipadPopup.addChild(btnNot);
			btnNot.x = AppSettings.WIDTH*0.5 +  20;
			btnNot.y =  0.5 * (AppSettings.HEIGHT - btnOk.height) + 80;// - 20;	
		}
		
		public function checkMatch(e:DataLoadServiceEvent):void
		{
			if (e.data.secondNum == secondNum && e.data.firstNum == firstNum)
			{
				TweenLite.killDelayedCallsTo(finishSymbols);
				finishSymbols();
				dispatchEvent(new IpadEvent(IpadEvent.SYMBOLS_IS_OK));	
				isOpen = false;
				ipadPopup.visible = false;		
			}
			else
			{
				Tool.removeAllChildren(symbolsHolder);
				showShapes();
				dispatchEvent(new IpadEvent(IpadEvent.SYMBOLS_BAD));
				isOpen = false;
				ipadPopup.visible = false;		
			}
		}
		
		public function showShapes(e:DataLoadServiceEvent = null):void
		{
			if (isOpen) return;
			
			isOpen = true;
			tint.alpha = 0;	
			visible = true;
			popup.visible = false;
			TweenLite.to(tint, 0.5, { alpha:0.92 , ease: Expo.easeOut } );
			
			ipadPopup.visible = true;					
			
			TweenLite.killDelayedCallsTo(finishSymbols);
			TweenLite.delayedCall(userWaiting, finishSymbols);			
		}
		
		public function finishSymbols():void 
		{
			TweenLite.killDelayedCallsTo(finishSymbols);
			Tool.removeAllChildren(symbolsHolder);
			visible = false;
			isOpen = false;
			ipadPopup.visible = false;		
		}
		
		public function hideError(e:ServerErrorEvent):void
		{
			TweenLite.to(tint, 0.5, { alpha:0, onComplete:hidePopup , ease: Expo.easeOut } );			
		}
		
		public function showServerError(e:ServerErrorEvent):void
		{
			tint.alpha = 0;			
			visible = true;
			maskLayer.height = 1;
			maskLayer.y = AppSettings.HEIGHT * 0.5;			
			popup.visible = false;
			serverError.visible = true;
			kinectError.visible = false;
			serverError.y = AppSettings.HEIGHT;
			TweenLite.to(tint, 0.5, { alpha:0.6 , ease: Expo.easeOut} );
			TweenLite.to(serverError, 0.3, { y:AppSettings.HEIGHT - serverError.height, ease: Expo.easeOut} );	
		}
		
		public function showNoMat(e:DataLoadServiceEvent):void
		{			
			tint.alpha = 0;			
			visible = true;
			maskLayer.height = 1;
			maskLayer.y = AppSettings.HEIGHT * 0.5;
			popup.visible = true;
			serverError.visible = false;
			kinectError.visible = false;
			
			TweenLite.to(tint, 0.5, { alpha:0.6 , ease: Expo.easeOut} );
			TweenLite.to(maskLayer, 0.3, { height:462,y: popup.y, ease: Expo.easeOut} );			
			TweenLite.delayedCall(2, hideInfo);
		}
		
		private function hideInfo():void 
		{
			TweenLite.to(tint, 0.5, { alpha:0, onComplete:hidePopup , ease: Expo.easeOut} );
			TweenLite.to(maskLayer, 0.55, { height:1, y: AppSettings.HEIGHT * 0.5, ease: Expo.easeOut } );				
		}
		
		private function hidePopup():void 
		{
			visible = false;
		}		
	}
}
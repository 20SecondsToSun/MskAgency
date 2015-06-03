package ipad.view.locations
{
	import app.view.utils.TextUtil;
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ipad.controller.IpadConstants;
	import ipad.view.locations.buttons.PlButton;
	import ipad.view.locations.buttons.SetButton;

	public class Base2Page extends Sprite
	{
		private var textFormat:TextFormat = new TextFormat("TornadoL", 48 * IpadConstants.contentScaleFactor, 0Xe6e8ed);
		private var textFormat1:TextFormat = new TextFormat("TornadoL", 16, 0x828696);
		private var textFormat2:TextFormat = new TextFormat("TornadoItalic", 24 * IpadConstants.contentScaleFactor, 0xe6e8ed);
		
		public var locName:String = "";
		public var isKinectUser:Boolean = false;
		public var isPlaying:Boolean = false;
		
		public var TITLE1:String = "Страница «Главное» не является основным экраном";
		public var TITLE2:String = "Нажмите кнопку, если хотите, чтобы страница «Главное» автоматически\nтранслировалась когда вы не управляете стендом";
		public var TITLE3:String = "Нажмите на паузу, если хотите\nостановить ротацию контента на стенде";
		public var TITLE4:String = "Страница «Главное» выбрана как основной экран";
		public var TITLE5:String = "Она автоматически транслируется когда вы не управляете стендом";
		
		public var title1:String = TITLE1;
		public var title2:String = TITLE2;
		
		private var mainTitle:TextField;
		private var mainTitle1:TextField;
		private var helpPromt:TextField;
		private var setButton:SetButton;
		public var playButton:PlButton;
		
		public var playButtonCoords_x:Number =  0.5 * (IpadConstants.GameWidth - 429* IpadConstants.contentScaleFactor);
		public var playButtonCoords_y:Number =  0.5 * (IpadConstants.GameHeight - (429+290*0.5)* IpadConstants.contentScaleFactor);
		
		public var promtCoords_x:Number = IpadConstants.GameWidth - (460+144)* IpadConstants.contentScaleFactor ;
		public var promtCoords_y:Number = IpadConstants.GameHeight - (290 + 144 +20) * IpadConstants.contentScaleFactor;		
		
		public function init(screen:String, _isKinectUser:Boolean, _isPlaying:Boolean):void
		{			
			isKinectUser = _isKinectUser;
			isPlaying = _isPlaying;
			
			playButton = new PlButton();
			playButton.x = playButtonCoords_x;
			playButton.y = playButtonCoords_y;
			addChild(playButton);
			
			helpPromt = TextUtil.createTextField(156 * IpadConstants.contentScaleFactor, 0);
			helpPromt.text = TITLE3;
			helpPromt.setTextFormat(textFormat2);
			helpPromt.x = promtCoords_x;
			helpPromt.y = promtCoords_y;
			helpPromt.visible = false;
			addChild(helpPromt);			
			
			title1 = TITLE1;
			title2 = TITLE2;
	
			if (screen != locName)
			{
				setButton = new SetButton();
				addChild(setButton);
				
				setButton.x = 156 * IpadConstants.contentScaleFactor;
				setButton.y = 488 * IpadConstants.contentScaleFactor - 10;
				setButton.alpha = 0.4;
				
				TweenLite.to(setButton, 0.6, {y: 488 * IpadConstants.contentScaleFactor, alpha: 1, ease: Quad.easeInOut});
			}
			else
			{
				title1 = TITLE4;
				title2 = TITLE5;
				//trace("isKinectUser", isKinectUser);
				if (!isKinectUser)
				{
					playButton.kinectUserHide();	
					playButton.isPlaing(isPlaying);
					helpPromt.visible = isPlaying;
					playButton.alpha = 0;
					TweenLite.to(playButton, 0.6, {alpha: 1, ease: Quad.easeInOut});		
				}	
				else
				{
					playButton.kinectUserShow();
					playButton.alpha = 0;
					TweenLite.to(playButton, 0.6, {alpha: 1, ease: Quad.easeInOut});		
				}
			}
			
			mainTitle = TextUtil.createTextField(156 * IpadConstants.contentScaleFactor, 136 * IpadConstants.contentScaleFactor);
			mainTitle.text = title1;
			mainTitle.setTextFormat(textFormat);
			addChild(mainTitle);
			
			mainTitle1 = TextUtil.createTextField(156 * IpadConstants.contentScaleFactor, 0);
			mainTitle1.text = title2;			
			mainTitle1.setTextFormat(textFormat1);
			addChild(mainTitle1);
			
			textAnimation();
		}
		public function kinectUserChanged(_isKinectUser:Boolean, _isPlaying:Boolean):void
		{			
			isKinectUser = _isKinectUser;
			isPlaying = _isPlaying;
			
			if (setButton && setButton.visible == true) return;
			
			if (isKinectUser)
			{
				playButton.kinectUserShow();	
			}
			else
			{
				playButton.kinectUserHide();	
				playButton.isPlaing(isPlaying);
				helpPromt.visible = isPlaying;
			}
		}
		private function textAnimation():void
		{
			mainTitle.y = 136 * IpadConstants.contentScaleFactor - 20;
			mainTitle.alpha = 0.4;
			
			mainTitle1.y = mainTitle.y + mainTitle1.height - 20;
			mainTitle1.alpha = 0.4;
			
			TweenLite.to(mainTitle, 0.5, {y: 136 * IpadConstants.contentScaleFactor, alpha: 1, ease: Quad.easeInOut});
			TweenLite.to(mainTitle1, 0.5, {y: 136 * IpadConstants.contentScaleFactor + mainTitle.height + 5, alpha: 1, ease: Quad.easeInOut});
		}
		
		public function setActive():void
		{
			title1 = TITLE4;
			title2 = TITLE5;
			
			mainTitle.text = title1;
			mainTitle1.text = title2;
			
			mainTitle.setTextFormat(textFormat);
			mainTitle1.setTextFormat(textFormat1);
			
			textAnimation();
			
			setButton.visible = false;
			
			if (isKinectUser)
			{
				playButton.kinectUserShow();	
				return;
			}
			
			playButton.kinectUserHide();	
			playButton.alpha = 0.3;
			playButton.isPlaing(isPlaying);
			TweenLite.to(playButton, 0.6, {alpha: 1, ease: Quad.easeInOut});
			
			helpPromt.visible = isPlaying;
			helpPromt.alpha = 0.3;
			TweenLite.to(helpPromt, 0.6, {alpha: 1, ease: Quad.easeInOut});
		}
		
		public function setPlayPause(value:Boolean):void
		{
			isPlaying = value;
			playButton.isPlaing(value);
			
			helpPromt.visible = isPlaying;
			
			if (isPlaying)
			{
				helpPromt.alpha = 0.3;
				TweenLite.to(helpPromt, 0.6, {alpha: 1, ease: Quad.easeInOut});
			}
		}	
	}
}
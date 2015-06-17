package app.view.page.day.leftpanelhour
{
	import app.AppSettings;
	import app.assets.Assets;
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.FilterEvent;
	import app.contoller.events.InteractiveEvent;
	import app.model.materials.Material;
	import app.view.allnews.OneHourBlockNews;
	import app.view.baseview.io.InteractiveButton;
	import app.view.baseview.io.InteractiveChargeButton;
	import app.view.baseview.io.InteractiveObject;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class LeftPanel extends InteractiveObject
	{
		private static const MAX_WIDTH:int = 182;
		
		private var billet:InteractiveObject;
		private var fon:Shape;
		
		private var _all:Sprite;
		private var _allIcon:Sprite;
		
		private var _video:Sprite;
		private var _videoIcon:Sprite;
		
		private var _photo:Sprite;
		private var _photoIcon:Sprite;
		
		private var _live:Sprite;
		private var _liveIcon:Sprite;
		
		private var dateInitX:Number = 0;
		private var dateInitY:Number = 0;
		
		private var sortBy:String = "all";
		
		private var buttonArray:Array = new Array();
		private var allButton:InteractiveChargeButton;
		private var photoButton:InteractiveChargeButton;
		private var videoButton:InteractiveChargeButton;
		private var backButton:InteractiveChargeButton;		
		private var liveButton:InteractiveChargeButton;		
		
		private var _backToDates:Sprite;
		
		private var line1:Shape;
		private var line2:Shape;
		private var line3:Shape;
		private var line4:Shape;
		
		private var allNewsTitle:TextField;
		private var photoNewsTitle:TextField;
		private var videoNewsTitle:TextField;
		private var liveNewsTitle:TextField;
		
		private var _backToDatesTitle:TextField;
		private var textTitle:TextField;
		private var monthTitle:TextField;
		private var textFormat:TextFormat;
		
		private var allCount:TextField;
		private var videoCount:TextField;
		private var photoCount:TextField;
		private var liveCount:TextField;
		
		private var allCountClip:Sprite;
		private var videoCountClip:Sprite;
		private var photoCountClip:Sprite;
		private var liveCountClip:Sprite;
		private var dateClip:Sprite;
		
		private var oneHourNewsList:Vector.<OneHourBlockNews>;
		private var isOverStarting:Boolean = false;	
		
		
		public function LeftPanel()
		{
			fon = Tool.createShape(98, AppSettings.HEIGHT, 0x02a7df);
			addChild(fon);				
			
			_all = new Sprite();
			_allIcon = Assets.create("allIcon");
			_all.addChild(_allIcon);
			
			_allIcon.width = 30;
			_allIcon.height = 21;
			
			_video = new Sprite();
			_videoIcon = Assets.create("videoIcon");
			_video.addChild(_videoIcon);
			
			_videoIcon.width = 34;
			_videoIcon.height = 34;
			
			_photo = new Sprite();
			_photoIcon = Assets.create("photoIcon");
			_photo.addChild(_photoIcon);
			
			_photoIcon.width = 36;
			_photoIcon.height = 31;			
			
			_live = new Sprite();
			_liveIcon = Assets.create("liveIcon");
			_live.addChild(_liveIcon);
			
			_liveIcon.width = 36;
			_liveIcon.height = 31;			
			
			_all.x = 33;
			_all.y = 180;
			
			_video.x = 33;
			_video.y = 302;
			
			_photo.x = 33;
			_photo.y = 425;
			
			_live.x = 33;
			_live.y = 547;
			
			addChild(_all);
			addChild(_video);
			addChild(_photo);
			addChild(_live);			
			
			dateClip = new Sprite();
			addChild(dateClip);
			
			textFormat = new TextFormat("TornadoL", 49, 0Xffffff);
			
			textTitle = TextUtil.createTextField(0, 0);
			textTitle.multiline = false;
			textTitle.wordWrap = false;
			textTitle.autoSize = TextFieldAutoSize.LEFT;
			
			dateClip.addChild(textTitle);
			dateClip.x = 45;
			dateClip.y = 28;
			
			monthTitle = TextUtil.createTextField(0, 0);
			monthTitle.multiline = false;
			monthTitle.wordWrap = false;
			monthTitle.autoSize = TextFieldAutoSize.LEFT;
			
			dateClip.addChild(monthTitle);
			monthTitle.y = textTitle.height + 10;
			
			textFormat = new TextFormat("TornadoMedium", 49, 0Xffffff);
			
			allCountClip = new Sprite();
			videoCountClip = new Sprite();
			photoCountClip = new Sprite();
			liveCountClip = new Sprite();
			addChild(allCountClip);
			addChild(videoCountClip);
			addChild(photoCountClip);
			addChild(liveCountClip);
			
			allCount = TextUtil.createTextField(0, 0);
			allCount.multiline = false;
			allCount.wordWrap = false;
			allCount.width = 20;
			allCount.autoSize = TextFieldAutoSize.CENTER;			
			allCountClip.y = 215;
			
			videoCount = TextUtil.createTextField(0, 0);
			videoCount.multiline = false;
			videoCount.wordWrap = false;
			videoCount.width = 20;
			videoCount.autoSize = TextFieldAutoSize.CENTER;			
			videoCountClip.y = 348;
			videoCountClip.addChild(videoCount);		
			
			photoCount = TextUtil.createTextField(0, 0);
			photoCount.multiline = false;
			photoCount.wordWrap = false;
			photoCount.width = 20;
			photoCount.autoSize = TextFieldAutoSize.CENTER;			
			photoCountClip.addChild(photoCount);			
			photoCountClip.y = 472;
			
			liveCount = TextUtil.createTextField(0, 0);
			liveCount.multiline = false;
			liveCount.wordWrap = false;
			liveCount.width = 20;
			liveCount.autoSize = TextFieldAutoSize.CENTER;			
			liveCountClip.addChild(liveCount);			
			liveCountClip.y =596;
			
			
			line1 = new Shape();
			line1.graphics.lineStyle(1, 0x000000, 0.19);
			line1.graphics.moveTo(0, 0);
			line1.graphics.lineTo(60, 0);
			addChild(line1);
			
			line2 = new Shape();
			line2.graphics.lineStyle(1, 0x000000, 0.19);
			line2.graphics.moveTo(0, 0);
			line2.graphics.lineTo(60, 0);
			addChild(line2);
			
			line3 = new Shape();
			line3.graphics.lineStyle(1, 0x000000, 0.19);
			line3.graphics.moveTo(0, 0);
			line3.graphics.lineTo(60, 0);
			addChild(line3);
			
			line4 = new Shape();
			line4.graphics.lineStyle(1, 0x000000, 0.19);
			line4.graphics.moveTo(0, 0);
			line4.graphics.lineTo(60, 0);
			addChild(line4);
			
			line1.y = 140;
			line2.y = 265;
			line3.y = 390;
			line4.y = 515;
			
			line1.x = 19;
			line2.x = 19;
			line3.x = 19;
			line4.x = 19;
			
			textFormat.size = 24;
			textFormat.color = 0xffffff;
			textFormat.font = "TornadoL";
			
			allNewsTitle = TextUtil.createTextField(0, 0);
			allNewsTitle.multiline = false;
			allNewsTitle.wordWrap = false;
			allNewsTitle.width = 20;
			allNewsTitle.autoSize = TextFieldAutoSize.LEFT;
			allNewsTitle.text = "ВСЕ";
			allNewsTitle.setTextFormat(textFormat);
			addChild(allNewsTitle);
			allNewsTitle.y = 260;
			allNewsTitle.x = 52;
			
			videoNewsTitle = TextUtil.createTextField(0, 0);
			videoNewsTitle.multiline = false;
			videoNewsTitle.wordWrap = false;
			videoNewsTitle.width = 20;
			videoNewsTitle.autoSize = TextFieldAutoSize.LEFT;
			videoNewsTitle.text = "ВИДЕО";
			videoNewsTitle.setTextFormat(textFormat);
			addChild(videoNewsTitle);
			videoNewsTitle.y = 430;
			videoNewsTitle.x = 52;
			
			photoNewsTitle = TextUtil.createTextField(0, 0);
			photoNewsTitle.multiline = false;
			photoNewsTitle.wordWrap = false;
			photoNewsTitle.width = 20;
			photoNewsTitle.autoSize = TextFieldAutoSize.LEFT;
			photoNewsTitle.text = "ФОТО";
			photoNewsTitle.setTextFormat(textFormat);
			addChild(photoNewsTitle);
			photoNewsTitle.y = 590;
			photoNewsTitle.x = 52;
			
			liveNewsTitle = TextUtil.createTextField(0, 0);
			liveNewsTitle.multiline = false;
			liveNewsTitle.wordWrap = false;
			liveNewsTitle.width = 20;
			liveNewsTitle.autoSize = TextFieldAutoSize.LEFT;
			liveNewsTitle.text = "LIVE";
			liveNewsTitle.setTextFormat(textFormat);
			addChild(liveNewsTitle);
			liveNewsTitle.y = 750;
			liveNewsTitle.x = 52;			
			
			photoNewsTitle.alpha = 0;
			videoNewsTitle.alpha = 0;
			allNewsTitle.alpha = 0;
			liveNewsTitle.alpha = 0;			
			
			_backToDates = Assets.create("backToDates");
			addChild(_backToDates);
			_backToDates.x = (182 - _backToDates.width) * 0.5;
			_backToDates.y = AppSettings.HEIGHT - _backToDates.height - 125;
			
			textFormat.size = 18;
			textFormat.color = 0xffffff;
			textFormat.font = "TornadoL";
			
			_backToDatesTitle = TextUtil.createTextField(0, 0);
			_backToDatesTitle.multiline = true;
			_backToDatesTitle.wordWrap = true;
			_backToDatesTitle.width = 120;
			_backToDatesTitle.autoSize = TextFieldAutoSize.LEFT;
			_backToDatesTitle.text = "К СПИСКУ \nДАТ";
			_backToDatesTitle.setTextFormat(textFormat);
			 addChild(_backToDatesTitle);
			_backToDatesTitle.y = _backToDates.y + _backToDates.height + 33;
			_backToDatesTitle.x = _backToDates.x;
			
			_backToDatesTitle.alpha = 0;
			_backToDates.alpha = 0;			
		
			allButton = new InteractiveChargeButton();
			allButton.name = "all";
			allButton.visible = false;
			allButton.enabled = false;
			allButton.y = 174;
			addChild(allButton);
			
			var splash1:Shape = Tool.createShape(MAX_WIDTH, 320 - 174, 0xffff00);			
			allButton.addChild(splash1);
			
			
			photoButton = new InteractiveChargeButton();
			photoButton.name = "photo";
			photoButton.visible = false;
			photoButton.y =  320+ (320-174);
			addChild(photoButton);
			
			var splash2:Shape = Tool.createShape(MAX_WIDTH, 320 - 174, 0xff0000);			
			photoButton.addChild(splash2);
			
			
			videoButton = new InteractiveChargeButton();
			videoButton.name = "video";
			videoButton.visible = false;
			videoButton.y = 320;
			addChild(videoButton);
			
			var splash3:Shape = Tool.createShape(MAX_WIDTH, 320 - 174, 0xff0000);			
			videoButton.addChild(splash3);		
			
			
			liveButton = new InteractiveChargeButton();
			liveButton.name = "broadcast";
			liveButton.visible = false;
			liveButton.y = 355+ 2*(320-174);;//!!!
			addChild(liveButton);
			
			var splash5:Shape = Tool.createShape(MAX_WIDTH, 320 - 174, 0xff0000);			
			liveButton.addChild(splash5);	
			
			
			backButton = new InteractiveChargeButton();
			backButton.name = "back";
			backButton.visible = false;
			backButton.y = _backToDates.y-50;
			addChild(backButton);
			
			var splash4:Shape = Tool.createShape(MAX_WIDTH, 320 - 174+50, 0xff0000);			
			backButton.addChild(splash4);
			
			splash1.alpha = 0;
			splash2.alpha = 0;
			splash3.alpha = 0;
			splash4.alpha = 0;
			splash5.alpha = 0;
			
			var _billet:Shape = Tool.createShape(98, AppSettings.HEIGHT, 0x02a7df);			
			_billet.alpha = 0;			
			billet = new InteractiveObject();
			billet.addChild(_billet);
			addChild(billet);	
			
			buttonArray.push(photoButton);
			buttonArray.push(videoButton);
			buttonArray.push(allButton);
			buttonArray.push(backButton);
			buttonArray.push(liveButton);
		}
		
		public function init(allNewsList:Vector.<Vector.<Material>>, all:Number, phl:Number, vl:Number, lv:Number):void
		{
			if (!allNewsList || allNewsList.length == 0)
				return;			
			
			setDayTitle(allNewsList[0][0].publishedDate);
			
			textFormat.size = 14;
			textFormat.color = 0x101114;
			textFormat.font = "TornadoMedium";
			
			allCount.text = all.toString();			
			allButton.enabled = false;//all != 0 ;			
			allCount.setTextFormat(textFormat);
			allCountClip.addChild(allCount);			
			allCountClip.x = (98 - allCountClip.width) * 0.5;
			
			videoCount.text = vl.toString();
			videoButton.enabled = vl != 0 ;			
			videoCount.setTextFormat(textFormat);			
			videoCountClip.x = (98 - videoCountClip.width) * 0.5;
			
			photoCount.text = phl.toString();
			photoButton.enabled = phl!= 0 ;	
			photoCount.setTextFormat(textFormat);
			photoCountClip.x = (98 - photoCountClip.width) * 0.5;
			
			liveCount.text = lv.toString();
			liveButton.enabled = lv!= 0 ;	
			liveCount.setTextFormat(textFormat);
			liveCountClip.x = (98 - liveCountClip.width) * 0.5;
		}	
		
		public function pushPanelBtn(e:InteractiveEvent):void
		{
			if (sortBy == e.target.name) return;
			
			videoButton.enabled = videoCount.text != "0";	
			allButton.enabled = allCount.text != "0";	
			photoButton.enabled = photoCount.text != "0";	
			liveButton.enabled = liveCount.text != "0" ;		
			
			var event:FilterEvent;	
			
			switch (e.target.name) 
			{
				case "all":					
					event =  new FilterEvent(FilterEvent.SORT_ONE_DAY_NEWS, false, false, { type:"all" } );
					dispatchEvent(event);
					allButton.enabled = false;
					sortBy = "all";
				break;
				
				case "photo":
					event =  new FilterEvent(FilterEvent.SORT_ONE_DAY_NEWS, false, false, { type:"photo" } );
					dispatchEvent(event);
					photoButton.enabled = false;
					sortBy = "photo";
				break;
				
				case "video":
					event =  new FilterEvent(FilterEvent.SORT_ONE_DAY_NEWS, false, false, { type:"video" } );	
					dispatchEvent(event);
					videoButton.enabled = false;
					sortBy = "video";
				break;
				
				case "broadcast":
					event =  new FilterEvent(FilterEvent.SORT_ONE_DAY_NEWS, false, false, { type:"broadcast" } );	
					dispatchEvent(event);
					liveButton.enabled = false;
					sortBy = "broadcast";
				break;
				
				case "back":									
					var eventChng:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.NEWS_PAGE_DAY);
					eventChng.mode = "STRETCH_IN";	
					backButton.enabled = false;
					dispatchEvent(eventChng);						
				break;
				
				default:
			}		
		}				
		
		public function refreshData(allNewsList:Vector.<Vector.<Material>>, all:Number, phl:Number, vl:Number, lv:Number):void
		{
			if (allNewsList == null || allNewsList.length == 0)
				return;
			init(allNewsList, all, phl, vl, lv);
			setDayTitle(allNewsList[0][0].publishedDate);
		}
		
		private function setDayTitle(date:Date):void
		{
			textFormat = new TextFormat("TornadoL", 49, 0Xffffff);
			textFormat.color = 0Xffffff;
			textFormat.size = 49;
			
			textTitle.text = TextUtil.getFormatDay(date);
			textTitle.setTextFormat(textFormat);
			textFormat.size = 13;
			monthTitle.text = TextUtil.month[date.getMonth()];
			monthTitle.setTextFormat(textFormat);
			
			monthTitle.y = textTitle.height - 30;
			
			if (textTitle.width > monthTitle.width)
			{
				monthTitle.x = (textTitle.width - monthTitle.width) * 0.5;
			}
			else
			{
				textTitle.x = (monthTitle.width - textTitle.width) * 0.5;
			}
			dateInitX = dateClip.x = (98 - dateClip.width) * 0.5;
			dateInitY = dateClip.y;
			
			dateClip.removeChildren(0, dateClip.numChildren - 1);
			
			dateClip.addChild(TextUtil.textFieldToBitmap(textTitle, 1.5));
			dateClip.addChild(TextUtil.textFieldToBitmap(monthTitle, 1.5));
		}
		
		public function overState():void
		{
			TweenLite.delayedCall(0.3, startOver);
		}	
		
		public function startOver():void
		{
			dispatchEvent(new AnimationEvent(AnimationEvent.LEFT_PANEL_OVER));
			isOverStarting = true;
			TweenLite.to(fon, 0.3, {width: MAX_WIDTH});
			TweenLite.to(billet, 0.3, {width: MAX_WIDTH});
			
			allCountClip.alpha = 0;
			videoCountClip.alpha = 0;
			photoCountClip.alpha = 0;
			liveCountClip.alpha = 0;
			
			allCountClip.x = 103;
			videoCountClip.x = 103;
			photoCountClip.x = 103;
			liveCountClip.x = 103;
			
			allCountClip.y = 218;
			videoCountClip.y = 370;
			photoCountClip.y = 525;
			liveCountClip.y = 680;
			
			TweenLite.killTweensOf(allCountClip);
			TweenLite.killTweensOf(videoCountClip);
			TweenLite.killTweensOf(photoCountClip);
			TweenLite.killTweensOf(liveCountClip);
			
			TweenLite.killTweensOf(photoNewsTitle);
			TweenLite.killTweensOf(videoNewsTitle);
			TweenLite.killTweensOf(allNewsTitle);
			TweenLite.killTweensOf(liveNewsTitle);
			TweenLite.killTweensOf(_backToDatesTitle);
			TweenLite.killTweensOf(_backToDates);
			
			TweenLite.to(line1, 0.5, {width: 147, height: 0.2, y: 174});
			TweenLite.to(line2, 0.5, {width: 147, height: .2, y: 320});
			TweenLite.to(line3, 0.5, {width: 147, height: .2, y: 484});
			TweenLite.to(line4, 0.5, {width: 147, height: .2, y: 648});
			
			TweenLite.to(dateClip, 0.5, {scaleX: 1.5, scaleY: 1.5, x: (182 - dateClip.width * 1.5) * 0.5, y: 20});
			
			TweenLite.to(_all, 0.5, {width: 37, height: 25, x: 52, y: 222});
			TweenLite.to(_video, 0.5, {width: 42, height: 42, x: 52, y: 368, onComplete: onCompleteText});
			TweenLite.to(_photo, 0.5, {width: 46, height: 39, x: 52, y: 530, onComplete: onCompleteNums});
			TweenLite.to(_live, 0.5, {width: 46, height: 39, x: 52, y: 690/*, onComplete: onCompleteNums*/});
		}
		
		private function onCompleteText():void
		{
			TweenLite.to(photoNewsTitle, .5, {alpha: 1});
			TweenLite.to(videoNewsTitle, .5, {alpha: 1});
			TweenLite.to(allNewsTitle, .5, {alpha: 1});
			TweenLite.to(liveNewsTitle, .5, {alpha: 1});
			
			TweenLite.to(_backToDatesTitle, .5, {alpha: 1});
			TweenLite.to(_backToDates, .5, { alpha: 1 } );
			
			allButton.visible = true;
			videoButton.visible = true;
			photoButton.visible = true;
			liveButton.visible = true;
			backButton.visible =  true;
		}
		
		private function onCompleteNums():void
		{
			TweenLite.to(allCountClip, .5, {alpha: 1});
			TweenLite.to(videoCountClip, .5, {alpha: 1});
			TweenLite.to(photoCountClip, .5, {alpha: 1});
			TweenLite.to(liveCountClip, .5, {alpha: 1});
		}
		
		public function outState():void
		{
			TweenLite.killDelayedCallsTo(startOver);
			if (!isOverStarting)
				return;
			isOverStarting = false;
			
			TweenLite.killTweensOf(allCountClip);
			TweenLite.killTweensOf(videoCountClip);
			TweenLite.killTweensOf(photoCountClip);
			TweenLite.killTweensOf(liveCountClip);
			
			TweenLite.killTweensOf(photoNewsTitle);
			TweenLite.killTweensOf(videoNewsTitle);
			TweenLite.killTweensOf(allNewsTitle);
			TweenLite.killTweensOf(liveNewsTitle);
			
			TweenLite.killTweensOf(_backToDatesTitle);
			TweenLite.killTweensOf(_backToDates);
			
			TweenLite.to(fon, 0.3, {width: 98});
			TweenLite.to(billet, 0.3, { width: 98 } );
			
			allButton.visible = false;
			videoButton.visible = false;
			photoButton.visible = false;
			liveButton.visible = false;
			backButton.visible = false;
			
			allCountClip.alpha = 0;
			videoCountClip.alpha = 0;
			photoCountClip.alpha = 0;
			liveCountClip.alpha = 0;
			
			photoNewsTitle.alpha = 0;
			videoNewsTitle.alpha = 0;
			allNewsTitle.alpha = 0;
			liveNewsTitle.alpha = 0;
			
			_backToDatesTitle.alpha = 0;
			_backToDates.alpha = 0;
			
			photoCountClip.x = (98 - photoCountClip.width) * 0.5;
			videoCountClip.x = (98 - videoCountClip.width) * 0.5;
			allCountClip.x = (98 - allCountClip.width) * 0.5;
			liveCountClip.x = (98 - liveCountClip.width) * 0.5;
			
			allCountClip.y = 215;
			videoCountClip.y = 348;
			photoCountClip.y = 472;
			liveCountClip.y = 590;
			
			TweenLite.to(dateClip, 0.5, {scaleX: 1, scaleY: 1, x: dateInitX, y: dateInitY});
			
			TweenLite.to(line1, 0.5, {width: 60, y: 140});
			TweenLite.to(line2, 0.5, {width: 60, y: 265});
			TweenLite.to(line3, 0.5, {width: 60, y: 390});
			TweenLite.to(line4, 0.5, {width: 60, y: 510});
			
			TweenLite.to(_all, 0.5, {width: 30, height: 21, x: 33, y: 180});
			TweenLite.to(_video, 0.5, {width: 34, height: 34, x: 33, y: 302});
			TweenLite.to(_photo, 0.5, {width: 36, height: 31, x: 33, y: 425, onComplete: onCompleteNums});
			TweenLite.to(_live, 0.5, {width: 36, height: 31, x: 33, y: 547});
		}
	}
}
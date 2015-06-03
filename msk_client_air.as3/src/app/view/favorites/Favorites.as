package app.view.favorites
{
	import app.AppSettings;
	import app.assets.Assets;
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.model.materials.Fact;
	import app.model.materials.Material;
	import app.model.types.AnimationType;
	import app.view.baseview.BaseView;
	import app.view.baseview.MainScreenView;
	import app.view.baseview.slider.VerticalSlider;
	import app.view.page.fact.leftpanel.OneFactPreviewGraphic;
	import app.view.page.oneNews.OneNewPreview;
	import app.view.page.oneNews.VerticalNewsSlider;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class Favorites extends MainScreenView
	{
		private var services:Sprite;
		
		private var colors:Vector.<uint> = new Vector.<uint>();
		private var textFormat1:TextFormat = new TextFormat("TornadoL", 60, 0x748ba1);
		private var textFormat2:TextFormat = new TextFormat("Tornado", 18, 0xc9e0e7);
		
		private var imgEvent:Sprite;
		private var imgPhoto:Sprite;
		private var imgVideo:Sprite;
		private var statPhoto:Sprite;
		
			
		private var txtCount:TextField;
		private var photoCount:TextField;
		private var videoCount:TextField;
		private var eventsCount:TextField;
		
		private var hintTxt:Sprite;
		private var hintPhV:Sprite;
		private var hintEvnt:Sprite;
		private var sliderTxt:VerticalNewsSlider;
		private var sliderPhotoVideo:VerticalNewsSlider;		
		
		
		public function Favorites()
		{
			visible = false;
			//services = Assets.create("fav");
			//addChild(services);
			
			colors.push(0x1a1b1f);
			colors.push(0x0f0f12);
			colors.push(0x509338);
			
			
			for (var i:int = 0; i < 3; i++) 
			{
				var splash:Shape = Tool.createShape(AppSettings.WIDTH /3, AppSettings.HEIGHT, colors[i]);
				splash.x = AppSettings.WIDTH/3 * i;
				addChild(splash);
			}			
			textFormat1.letterSpacing =-1.6;
			var eventText:TextField = TextUtil.createTextField(0, 0);
				eventText.multiline = false;
				eventText.text = "Статьи";	
				eventText.setTextFormat(textFormat1);			
				addChild(eventText);
				
			eventText.x = 206;
			eventText.y = 87;		
			
			imgEvent = Assets.create("statfav");
			imgEvent.x = 92;
			imgEvent.y = 110;
			addChild(imgEvent);			
			
			var photoVideoText:TextField = TextUtil.createTextField(0, 0);
				photoVideoText.multiline = false;
				photoVideoText.text = "Фото и видео";	
				photoVideoText.setTextFormat(textFormat1);			
				addChild(photoVideoText);
				
			photoVideoText.x = 840;
			photoVideoText.y = 87;
			
			imgPhoto = Assets.create("photofav");
			imgPhoto.x = AppSettings.WIDTH / 3 + 77;
			imgPhoto.y = 101;
			addChild(imgPhoto);
			
			imgVideo = Assets.create("videofav");
			imgVideo.x = AppSettings.WIDTH / 3 + 79;
			imgVideo.y = 220;
			addChild(imgVideo);
			
			textFormat1.color = 0x9dcb8d;
			var statText:TextField = TextUtil.createTextField(0, 0);
				statText.multiline = false;
				statText.text = "События";	
				statText.setTextFormat(textFormat1);			
				addChild(statText);
				
			statText.x = 2 * AppSettings.WIDTH / 3 + ( AppSettings.WIDTH / 3 - statText.width) * 0.5;			
			statText.y = 87;
			
			statPhoto = Assets.create("eventsfav");
			statPhoto.x = 2*AppSettings.WIDTH / 3 + 88;
			statPhoto.y = 110;
			addChild(statPhoto);		
			
			
			txtCount = TextUtil.createTextField(0, 0);
			txtCount.multiline = false;					
			txtCount.y = 160;					
			addChild(txtCount);
			
			
			photoCount = TextUtil.createTextField(0, 0);
			photoCount.multiline = false;					
			photoCount.y = 160;					
			addChild(photoCount);
			
			
			videoCount = TextUtil.createTextField(0, 0);
			videoCount.multiline = false;					
			videoCount.y = 276;					
			addChild(videoCount);
			
			
			eventsCount = TextUtil.createTextField(0, 0);
			eventsCount.multiline = false;					
			eventsCount.y = 160;					
			addChild(eventsCount);
			
			
			hintTxt = new Sprite();
			createSplash(hintTxt, 0x121316, "СОХРАНЯЙТЕ СТАТЬИ", 0xffffff, "Добавьте статью в избранное,\nнажав на иконку звездочки\nна странице материала", 0x748ba1);			
			hintTxt.x  = (AppSettings.WIDTH / 3 - hintTxt.width) * 0.5 +20;
			
			hintPhV = new Sprite();
			createSplash(hintPhV, 0x000000, "СОХРАНЯЙТЕ ФОТО И ВИДЕО", 0xffffff, "Добавьте фото или видео в избранное,\nнажав на иконку звездочки\nна странице материала", 0x748ba1);			
			hintPhV.x  = AppSettings.WIDTH / 3 + (AppSettings.WIDTH / 3 - hintPhV.width) * 0.5 +65;
			
			hintEvnt = new Sprite();
			createSplash(hintEvnt, 0x498a32, "СОХРАНЯЙТЕ СОБЫТИЯ", 0xffffff, "Добавьте событие в избранное,\nнажав на иконку звездочки\nна странице материала", 0xaeda9f);			
			hintEvnt.x  = 2 * AppSettings.WIDTH / 3 +(AppSettings.WIDTH / 3 - hintEvnt.width) * 0.5+28;
			
			setTxtCount(0);
			setPhotoCount(0);
			setVideoCount(0);
			setEventsCount(0);
			
			
			//var s:Sprite = Assets.create("screenshot3");
			//addChild(s);
			//s.alpha = 0.3;
		}
		
		private function createSplash(hintTxt:Sprite,starColor:uint,txt1:String,color1:uint,txt2:String,color2:uint):void
		{			
			addChild(hintTxt);
			hintTxt.y = 340;
			
			var star:Sprite = Assets.create("starfav");
			Tool.changecolor(star, starColor);
			hintTxt.addChild(star);			
			
			
			var titleFormat:TextFormat = new TextFormat("Tornado", 21, color1);
			titleFormat.letterSpacing = 0.5;
			var hinttxt:TextField= TextUtil.createTextField(0, 0);
			hinttxt.multiline = false;					
			hinttxt.y = 376;					
			hinttxt.text = txt1;		
			hinttxt.setTextFormat(titleFormat);
			hinttxt.x = (star.width - hinttxt.width) * 0.5;
			hintTxt.addChild(hinttxt);
			
			
			var hinttxt1:TextField = TextUtil.createTextField(0, 0);
			hinttxt1.multiline = true;					
			hinttxt1.y = 428;	
			titleFormat.color = color2;
			titleFormat.size = 21;
			titleFormat.align = TextFormatAlign.CENTER;
			titleFormat.leading = 5;
			hinttxt1.text = txt2;		
			hinttxt1.setTextFormat(titleFormat);
			hinttxt1.x = (star.width - hinttxt1.width) * 0.5-1;
			hintTxt.addChild(hinttxt1);	
			
			
			sliderTxt = new VerticalNewsSlider();
			sliderTxt.name = "sliderTxt";
			//sliderTxt.dynamicLoad = true;
			sliderTxt.x = 205;
			sliderTxt.y = 254;
			addChild(sliderTxt);	
			sliderTxt.startY = 254;
			
			
			_maskTxt = Tool.createShape(1, AppSettings.HEIGHT - 200,0xffffff);
			_maskTxt.y = 200;
			sliderTxt.mask = _maskTxt;
			addChild(_maskTxt);
			_maskTxt.width = AppSettings.WIDTH / 3;	
			
			
			sliderPhotoVideo = new VerticalNewsSlider();
			sliderPhotoVideo.name = "sliderPhotoVideo";
			//sliderTxt.dynamicLoad = true;
			sliderPhotoVideo.x = AppSettings.WIDTH / 3 + 200;	
			sliderPhotoVideo.y = 254;
			addChild(sliderPhotoVideo);	
			sliderPhotoVideo.startY = 254;
			
			
			_maskVideo = Tool.createShape(1, AppSettings.HEIGHT - 200,0xffffff);
			_maskVideo.y = 200;
			sliderPhotoVideo.mask = _maskVideo;
			addChild(_maskVideo);
			_maskVideo.width = AppSettings.WIDTH / 3;	
			_maskVideo.x = AppSettings.WIDTH / 3;		
			
			
			sliderEvents = new VerticalSlider();
			sliderEvents.name = "FactFavLeftPanelSlider"
			//sliderTxt.dynamicLoad = true;
			sliderEvents.x =   2 * AppSettings.WIDTH / 3 + 200;				
			sliderEvents.y = 254;
			addChild(sliderEvents);	
			sliderEvents.startY = 254;	
			
			
			_maskEvents = Tool.createShape(1, AppSettings.HEIGHT - 200,0xffffff);
			_maskEvents.y = 200;
			sliderEvents.mask = _maskEvents;
			addChild(_maskEvents);
			_maskEvents.width = AppSettings.WIDTH / 3;	
			_maskEvents.x =   2 * AppSettings.WIDTH / 3;			
			
			animationInFinished();			
		}
		
		private var _maskTxt:Shape;
		private var _maskVideo:Shape;
		private var _maskEvents:Shape;
		private const shift:int = 90;
		private var photoCountInt:int;
		private var videoCountInt:int;
		private var eventsCountInt:int;
		private var sliderEvents:VerticalSlider;
		
		public function setTexts(list:Vector.<Material>):void
		{
			if (list == null || list.length == 0 ) return;

			setTxtCount(list.length);
			
			var offset:Number = 0;	
			list = list.reverse();
			for (var i:int = 0; i < list.length; i++)
			{
				var hn:Material = new Material();
				hn = list[i];			
				
				var oneHour:FavPreview = new FavPreview(hn, i == 0, true, true);
				oneHour.y = offset;
				offset += oneHour.height + shift;
				
				sliderTxt.addElement(oneHour);
			}
			sliderTxt.dragZoneFix();
			
			sliderTxt.startInteraction();				
		}
		
		public function setPhotoVideo(list:Vector.<Material>, _photoCount:int, _videoCount:int):void
		{
			if (list == null || list.length == 0 ) return;
			
			photoCountInt = _photoCount;
			videoCountInt = _videoCount;

			setPhotoCount(photoCountInt);
			setVideoCount(videoCountInt);
			
			var offset:Number = 0;	
			list = list.reverse();
			for (var i:int = 0; i < list.length; i++)
			{
				var hn:Material = new Material();
				hn = list[i];			
				
				var oneHour:FavPreview = new FavPreview(hn, i == 0, true, true);
				oneHour.y = offset;
				offset += oneHour.height + shift;
				
				sliderPhotoVideo.addElement(oneHour);
			}
			sliderPhotoVideo.dragZoneFix();
			
			sliderPhotoVideo.startInteraction();	
		}
		public function setEvents(list:Vector.<Fact>):void
		{
			if (list == null || list.length == 0 ) return;
			eventsCountInt = list.length;
			setEventsCount(eventsCountInt);
			
			
			var offset:Number = 0;	
			list = list.reverse();
			for (var i:int = 0; i < list.length; i++)
			{
				var hn:Fact = new Fact();
				hn = list[i];			
				
				var oneHour:FavFactGraphic = new FavFactGraphic(hn);
				oneHour.y = offset;
				offset += oneHour.height ;
				
				sliderEvents.addElement(oneHour);
			}
			sliderEvents.dragZoneFix();
			
			sliderEvents.startInteraction();			
			
		}
		
		private function setTxtCount(value:int):void
		{
			txtCount.text = value.toString();
			textFormat2.color = 0xc9e0e7;
			txtCount.setTextFormat(textFormat2);
			txtCount.x = imgEvent.x + 0.5 * (imgEvent.width - txtCount.width);
			
			if (value != 0) TweenLite.to(hintTxt, 0.4, { alpha:0 } );	
			else TweenLite.to(hintTxt, 0.4, { alpha:1 } );	
			
			if (value < 4)
			{
			//	sliderTxt.container.y = 0; 
				sliderTxt.y = 254; 
				sliderTxt.stopInteraction();
			}		
		}
		
		private function setPhotoCount(value:int):void
		{
			photoCount.text = value.toString();	
			textFormat2.color = 0xc9e0e7;
			photoCount.setTextFormat(textFormat2);
			photoCount.x = imgPhoto.x + 0.5 * (imgPhoto.width - photoCount.width);	
			
			if (value != 0) TweenLite.to(hintPhV, 0.4, { alpha:0 } );	
			else TweenLite.to(hintPhV, 0.4, { alpha:1 } );	
			
			if (photoCountInt +videoCountInt < 4)
			{
				//sliderPhotoVideo.container.y = 0; 
				sliderPhotoVideo.y = 254; 
				sliderPhotoVideo.stopInteraction();
			}
			if (photoCountInt + videoCountInt  != 0) TweenLite.to(hintPhV, 0.4, { alpha:0 } );	
			else TweenLite.to(hintPhV, 0.4, { alpha:1 } );	
		}
		
		private function setVideoCount(value:int):void
		{
			videoCount.text = value.toString();	
			textFormat2.color = 0xc9e0e7;
			videoCount.setTextFormat(textFormat2);
			videoCount.x = imgVideo.x + 0.5 * (imgVideo.width - videoCount.width);	
			
			if (photoCountInt + videoCountInt < 4)
			{
				//sliderPhotoVideo.container.y = 0; 
				sliderPhotoVideo.y = 254; 
				sliderPhotoVideo.stopInteraction();
			}
			if (photoCountInt + videoCountInt  != 0) TweenLite.to(hintPhV, 0.4, { alpha:0 } );	
			else TweenLite.to(hintPhV, 0.4, { alpha:1 } );	
		}
		private function setEventsCount(value:int):void
		{
			eventsCount.text = value.toString();	
			textFormat2.color = 0xc9e0e7;
			eventsCount.setTextFormat(textFormat2);
			eventsCount.x = statPhoto.x + 0.5 * (statPhoto.width - eventsCount.width);	
			
			if (value != 0) TweenLite.to(hintEvnt, 0.4, { alpha:0 } );	
			else TweenLite.to(hintEvnt, 0.4, { alpha:1 } );	
		}
	
		
		public function deleteById(id:int, sliderName:String, type:String):void
		{	
			switch (type) 
			{
				case "photo":
					photoCountInt--;
				break;
				case "video":
					videoCountInt--;
				break;
				case "fact":
					eventsCountInt--;
				break;
				default:
			}
			
			var slider:*;
			switch (sliderName) 
			{
				case "sliderPhotoVideo":
					slider = sliderPhotoVideo;
				break;
				
				case "sliderTxt":
					slider = sliderTxt;
				break;
				
				case "FactFavLeftPanelSlider":
					slider = sliderEvents;
				break;
				
				default:
			}
			for (var i:int = 0; i < slider.elemensArray.length; i++) 
			{
				if (id == slider.elemensArray[i].id)
				{
					slider.container.removeChild(slider.elemensArray[i]);
					slider.elemensArray.splice(i, 1);
					break;
				}
			}
			
			switch (sliderName) 
			{
				case "sliderPhotoVideo":
					setPhotoCount(photoCountInt);
					setVideoCount(videoCountInt);
				break;
				
				case "sliderTxt":
					setTxtCount(slider.elemensArray.length);
				break;
				
				case "FactFavLeftPanelSlider":
					setEventsCount(slider.elemensArray.length);
				break;
				
				default:
			}
			
			
			var offset:Number = 0;		
			for (var j:int = 0; j < slider.elemensArray.length; j++)
			{				
				slider.elemensArray[j].y = offset;
				if (type == "fact")
					offset +=  slider.elemensArray[j].height;		
				else
					offset +=  slider.elemensArray[j].height + shift;				
			}
			slider.dragZoneFix(offset);
			
		}
		public function refreshData():void
		{
		
		}
		
		public function toMainScreen():void
		{
			x = 0;
			y = AppSettings.HEIGHT;
			visible = true;
			animateToXY(0, AppSettings.HEIGHT - this.height, 1.0);
		}
		
		public function show():void
		{			
			visible = true;
			y = 0;
			x = 0;
			animationInFinished();
		}			
		
		public function gotoNewsDay():void
		{
			animateOutXY(this.x, AppSettings.HEIGHT, anim.MainScreen1AllNews.animOutSpeed, anim.MainScreen1AllNews.animOutEase);
		}
		
		override public function animationInFinished():void
		{	
			
			dispatchEvent(new AnimationEvent(AnimationEvent.FAVORITES_ANIMATION_FINISHED, AnimationType.IN, this));
		}
		
		override public function animationOutFinished():void
		{
			dispatchEvent(new AnimationEvent(AnimationEvent.FAVORITES_ANIMATION_FINISHED, AnimationType.OUT, this));
		}		
	}
}
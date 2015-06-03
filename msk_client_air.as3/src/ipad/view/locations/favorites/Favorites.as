package ipad.view.locations.favorites
{
	import app.AppSettings;
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.IpadEvent;
	import app.model.materials.Fact;
	import app.model.materials.Material;
	import app.model.types.AnimationType;
	import app.services.interactive.gestureDetector.HandSpeed;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.getTimer;
	import ipad.assets.Assets;
	import ipad.controller.IpadConstants;
	import ipad.view.OneFactIpad;
	import ipad.view.slider.ElementFact;
	import ipad.view.slider.VerticalNewsSlider;
	import ipad.view.slider.VerticalSlider;
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.TapGesture;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class Favorites extends Sprite
	{
		private var services:Sprite;
		
		private var colors:Vector.<uint> = new Vector.<uint>();
		private var textFormat1:TextFormat = new TextFormat("TornadoL", 48*IpadConstants.contentScaleFactor, 0x748ba1);
		private var textFormat2:TextFormat = new TextFormat("Tornado", 20*IpadConstants.contentScaleFactor, 0xc9e0e7);
		
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
		
		private var offsetY:Number = 290 * IpadConstants.contentScaleFactor;
		public function Favorites()
		{
			/*var doubleTap:TapGesture = new TapGesture(this);
			doubleTap.numTapsRequired = 2;
			doubleTap.addEventListener(GestureEvent.GESTURE_RECOGNIZED, onDoubleTap);*/
			
			
			//mouseChildren = false
		}
		/*private function onDoubleTap(event:GestureEvent):void
		{
			trace( "handle double tap !");
		}	*/
		
		public function init():void
		{
			//visible = false;
			//services = Assets.create("fav");
			//addChild(services);
			
			colors.push(0x1a1b1f);
			colors.push(0x0f0f12);
			colors.push(0x509338);
			
			
			for (var i:int = 0; i < 3; i++) 
			{
				var splash:Shape = Tool.createShape(IpadConstants.GameWidth /3, IpadConstants.GameHeight - offsetY, colors[i]);
				splash.x = IpadConstants.GameWidth/3 * i;
				addChild(splash);
			}
			
			var yText:Number = 86 * IpadConstants.contentScaleFactor;	
			
			var eventText:TextField = TextUtil.createTextField(0, 0);
				eventText.multiline = false;
				eventText.text = "Статьи";	
				eventText.setTextFormat(textFormat1);			
				addChild(eventText);
				
			eventText.x = 98* IpadConstants.contentScaleFactor;
			eventText.y = yText;	
			
			imgEvent = Assets.create("statIpadFavs");
			imgEvent.scaleX = imgEvent.scaleY = IpadConstants.contentScaleFactor;
			imgEvent.x = 564* IpadConstants.contentScaleFactor;	
			imgEvent.y = 110* IpadConstants.contentScaleFactor;		
			addChild(imgEvent);			
			
			
			var photoVideoText:TextField = TextUtil.createTextField(0, 0);
				photoVideoText.multiline = false;
				photoVideoText.text = "Фото и видео";	
				photoVideoText.setTextFormat(textFormat1);			
				addChild(photoVideoText);
				
			photoVideoText.x = 762 * IpadConstants.contentScaleFactor;			
			photoVideoText.y = yText;
			
			imgPhoto = Assets.create("photoIpadFav");
			imgPhoto.scaleX = imgPhoto.scaleY = IpadConstants.contentScaleFactor;
			imgPhoto.x = 1138 * IpadConstants.contentScaleFactor;		
			imgPhoto.y  = 100* IpadConstants.contentScaleFactor;	
			addChild(imgPhoto);
			// 
			imgVideo = Assets.create("videoIpadFav");
			imgVideo.scaleX = imgVideo.scaleY = IpadConstants.contentScaleFactor;
			imgVideo.x = 1260 * IpadConstants.contentScaleFactor;	
			imgVideo.y  = 100 * IpadConstants.contentScaleFactor;	
			addChild(imgVideo);
			
			textFormat1.color = 0x9dcb8d;
			var statText:TextField = TextUtil.createTextField(0, 0);
				statText.multiline = false;
				statText.text = "События";	
				statText.setTextFormat(textFormat1);			
				addChild(statText);
				
			statText.x = 1462 * IpadConstants.contentScaleFactor;				
			statText.y = yText;
			
			statPhoto = Assets.create("factsIpadFavs");
			statPhoto.scaleX = statPhoto.scaleY = IpadConstants.contentScaleFactor;
			statPhoto.x = 1916* IpadConstants.contentScaleFactor;	
			statPhoto.y   = 106 * IpadConstants.contentScaleFactor;		
			addChild(statPhoto);		
			
			
			txtCount = TextUtil.createTextField(0, 0);
			txtCount.multiline = false;					
			txtCount.y = 108 * IpadConstants.contentScaleFactor;				
			addChild(txtCount);
			
			
			photoCount = TextUtil.createTextField(0, 0);
			photoCount.multiline = false;					
			photoCount.y = 108 * IpadConstants.contentScaleFactor;			
			addChild(photoCount);
			
			
			videoCount = TextUtil.createTextField(0, 0);
			videoCount.multiline = false;					
			videoCount.y = 108 * IpadConstants.contentScaleFactor;			
			addChild(videoCount);
			
			
			eventsCount = TextUtil.createTextField(0, 0);
			eventsCount.multiline = false;					
			eventsCount.y = 108 * IpadConstants.contentScaleFactor;				
			addChild(eventsCount);
			
			hintTxt = new Sprite();
			createSplash(hintTxt, 0x121316, "СОХРАНЯЙТЕ СТАТЬИ", 0xffffff, "Добавьте статью в избранное,\nнажав на иконку звездочки\nна странице материала", 0x748ba1);			
			hintTxt.x  = (IpadConstants.GameWidth / 3 - hintTxt.width) * 0.5;
			
			hintPhV = new Sprite();
			createSplash(hintPhV, 0x000000, "СОХРАНЯЙТЕ ФОТО И ВИДЕО", 0xffffff, "Добавьте фото или видео в избранное,\nнажав на иконку звездочки\nна странице материала", 0x748ba1);			
			hintPhV.x  = IpadConstants.GameWidth / 3 + (IpadConstants.GameWidth / 3 - hintPhV.width ) * 0.5 +50*IpadConstants.contentScaleFactor;
			
			hintEvnt = new Sprite();
			createSplash(hintEvnt, 0x498a32, "СОХРАНЯЙТЕ СОБЫТИЯ", 0xffffff, "Добавьте событие в избранное,\nнажав на иконку звездочки\nна странице материала", 0xaeda9f);			
			hintEvnt.x  = 2 * IpadConstants.GameWidth / 3 +(IpadConstants.GameWidth / 3 - hintEvnt.width) * 0.5+50*IpadConstants.contentScaleFactor;
			
			
			setTxtCount(0);			
			setPhotoCount(0);			
			setVideoCount(0);
			setEventsCount(0);
			
			dispatchEvent(new AnimationEvent(AnimationEvent.FAVORITES_ANIMATION_FINISHED, AnimationType.IN));
		}
		
		private function createSplash(hintTxt:Sprite,starColor:uint,txt1:String,color1:uint,txt2:String,color2:uint):void
		{			
			addChild(hintTxt);
			hintTxt.y = 384 * IpadConstants.contentScaleFactor;
			
			
			var star:Sprite = Assets.create("starIpadFav");
			star.scaleX = star.scaleY = IpadConstants.contentScaleFactor;
			Tool.changecolor(star, starColor);
			hintTxt.addChild(star);			
			
			
			var titleFormat:TextFormat = new TextFormat("Tornado", 24*IpadConstants.contentScaleFactor, color1);
			var hinttxt:TextField= TextUtil.createTextField(0, 0);
			hinttxt.multiline = false;					
			hinttxt.y = 370* IpadConstants.contentScaleFactor;					
			hinttxt.text = txt1;		
			hinttxt.setTextFormat(titleFormat);
			hinttxt.x = (star.width - hinttxt.width) * 0.5;
			hintTxt.addChild(hinttxt);
			
			
			var hinttxt1:TextField = TextUtil.createTextField(0, 0);
			hinttxt1.multiline = true;					
			hinttxt1.y = 430* IpadConstants.contentScaleFactor;	
			titleFormat.color = color2;
		//	titleFormat.size = 21;
			titleFormat.align = TextFormatAlign.CENTER;
			hinttxt1.text = txt2;		
			hinttxt1.setTextFormat(titleFormat);
			hinttxt1.x = (star.width - hinttxt1.width) * 0.5;
			hintTxt.addChild(hinttxt1);	
			
			
			sliderTxt = new VerticalNewsSlider();
			sliderTxt.name = "sliderTxt";
			//sliderTxt.dynamicLoad = true;
			sliderTxt.x = 94 * IpadConstants.contentScaleFactor;			
			sliderTxt.y  = 256 * IpadConstants.contentScaleFactor;	
			addChild(sliderTxt);	
			sliderTxt.startY = 256 * IpadConstants.contentScaleFactor;	
			
			
			_maskTxt = Tool.createShape(1, IpadConstants.GameHeight - 490* IpadConstants.contentScaleFactor, 0xffffff);			
			_maskTxt.y = 200 * IpadConstants.contentScaleFactor;	
			sliderTxt.mask = _maskTxt;
			addChild(_maskTxt);
			_maskTxt.width = IpadConstants.GameWidth / 3;	
			
			
			sliderPhotoVideo = new VerticalNewsSlider();
			sliderPhotoVideo.name = "sliderPhotoVideo";
			//sliderTxt.dynamicLoad = true;
			sliderPhotoVideo.x = IpadConstants.GameWidth / 3 + 94 * IpadConstants.contentScaleFactor;	
			sliderPhotoVideo.y = 256 * IpadConstants.contentScaleFactor;				
			addChild(sliderPhotoVideo);	
			sliderPhotoVideo.startY = 256* IpadConstants.contentScaleFactor;	
			
			
			_maskVideo  = Tool.createShape(1, IpadConstants.GameHeight - 490* IpadConstants.contentScaleFactor, 0xffffff);		
			_maskVideo.y = 200* IpadConstants.contentScaleFactor;	
			sliderPhotoVideo.mask = _maskVideo;
			addChild(_maskVideo);
			_maskVideo.width = IpadConstants.GameWidth / 3;	
			_maskVideo.x = IpadConstants.GameWidth / 3;		
			
			
			sliderEvents = new VerticalSlider();
			sliderEvents.name = "FactFavLeftPanelSlider"
			//sliderTxt.dynamicLoad = true;
			sliderEvents.x =   2 * IpadConstants.GameWidth / 3 + 40 * IpadConstants.contentScaleFactor;				
			sliderEvents.y =  256 * IpadConstants.contentScaleFactor;
			addChild(sliderEvents);	
			sliderEvents.startY =  256 * IpadConstants.contentScaleFactor;
			
			
			_maskEvents = Tool.createShape(1, IpadConstants.GameHeight - 490* IpadConstants.contentScaleFactor, 0xffffff);	
			_maskEvents.y = 200* IpadConstants.contentScaleFactor;	
			sliderEvents.mask = _maskEvents;
			addChild(_maskEvents);
			_maskEvents.width = IpadConstants.GameWidth / 3;	
			_maskEvents.x =   2 * IpadConstants.GameWidth / 3;			
			
			addChild(spriteDrag);
			//animationInFinished();			
		}
		
		private var _maskTxt:Shape;
		private var _maskVideo:Shape;
		private var _maskEvents:Shape;
		private const shift:int = 90;
		private var photoCountInt:int;
		private var videoCountInt:int;
		private var eventsCountInt:int;
		private var sliderEvents:VerticalSlider;
		private var candidateOk:Boolean;
		
		public function setTexts(list:Vector.<Material>):void
		{
			if (list == null || list.length == 0 ) return;

			setTxtCount(list.length);
	
			var offset:Number = 0;		
			for (var i:int = 0; i < list.length; i++)
			{
				var hn:Material = new Material();
				hn = list[i];			
				
				var oneHour:FavPreview = new FavPreview(hn, i == 0, true, true);
				oneHour.y = offset;
				offset += oneHour.height + 30;
				
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
			
			var offset:Number = -50;		
			for (var i:int = 0; i < list.length; i++)
			{
				var hn:Fact = new Fact();
				hn = list[i];			
				
				var oneHour:ElementFact = new ElementFact(hn);
				oneHour.scaleY = oneHour.scaleX = 0.9;
				oneHour.y = offset;
				offset += oneHour.height +30;
				
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
			txtCount.x = imgEvent.x -txtCount.width - 20 * IpadConstants.contentScaleFactor;// 0.5 * (imgEvent.width - txtCount.width);
			
			if (value != 0) TweenLite.to(hintTxt, 0.4, { alpha:0 } );	
			else TweenLite.to(hintTxt, 0.4, { alpha:1 } );	
			
			if (value < 4)
			{
				//sliderTxt.y = 254; 
				//sliderTxt.stopInteraction();
			}		
		}
		
		private function setPhotoCount(value:int):void
		{
			photoCount.text = value.toString();	
			textFormat2.color = 0xc9e0e7;
			photoCount.setTextFormat(textFormat2);
			photoCount.x = imgPhoto.x -photoCount.width - 20 * IpadConstants.contentScaleFactor;
			
			if (value != 0) TweenLite.to(hintPhV, 0.4, { alpha:0 } );	
			else TweenLite.to(hintPhV, 0.4, { alpha:1 } );	
			
			if (photoCountInt +videoCountInt < 4)			
			{				
				//sliderPhotoVideo.y = 254; 
				//sliderPhotoVideo.stopInteraction();
			}
			if (photoCountInt + videoCountInt  != 0) TweenLite.to(hintPhV, 0.4, { alpha:0 } );	
			else TweenLite.to(hintPhV, 0.4, { alpha:1 } );	
		}
		
		private function setVideoCount(value:int):void
		{
			videoCount.text = value.toString();	
			textFormat2.color = 0xc9e0e7;
			videoCount.setTextFormat(textFormat2);
			videoCount.x = imgVideo.x -videoCount.width - 20 * IpadConstants.contentScaleFactor;
			
			if (photoCountInt + videoCountInt < 4)
			{				
				//sliderPhotoVideo.y = 254; 
				//sliderPhotoVideo.stopInteraction();
			}
			if (photoCountInt + videoCountInt  != 0) TweenLite.to(hintPhV, 0.4, { alpha:0 } );	
			else TweenLite.to(hintPhV, 0.4, { alpha:1 } );	
		}
		private function setEventsCount(value:int):void
		{
			eventsCount.text = value.toString();	
			textFormat2.color = 0xc9e0e7;
			eventsCount.setTextFormat(textFormat2);
			eventsCount.x = statPhoto.x - eventsCount.width - 20 * IpadConstants.contentScaleFactor;
			
			if (value != 0) TweenLite.to(hintEvnt, 0.4, { alpha:0 } );	
			else TweenLite.to(hintEvnt, 0.4, { alpha:1 } );	
		}
	
		
		public function deleteById(id:int, sliderName:String, type:String):void
		{	
			var _shift:Number = shift;
			var offset:Number = 0;		
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
					_shift = 30;
					offset = -50;
				break;
				
				case "text":
					_shift = 30;					
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
			
			
			
			for (var j:int = 0; j < slider.elemensArray.length; j++)
			{				
				slider.elemensArray[j].y = offset;
				/*if (type == "fact")
					offset +=  slider.elemensArray[j].height;		
				else*/
					offset +=  slider.elemensArray[j].height + _shift;				
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
			//animateToXY(0, AppSettings.HEIGHT - this.height, 1.0);
		}
		
		public function show():void
		{			
			visible = true;
			y = 0;
			x = 0;
			//animationInFinished();
		}			
		
		/*public function gotoNewsDay():void
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
		}	*/
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public  var showingMat:*;
		public  var candidate:*;
		private var spriteDrag:Sprite = new Sprite();		
		private var activeElement:*;
		private var activeObj:*;
		private var saveCoords:Point;	
		private var startY:Number = 0;
		private var startTime:Number = 0;
		
		public function setCandidate(elem:*):void
		{
			candidate = elem;
			saveCoords = new Point(mouseX, mouseY);// candidate.parent.parent.parent.localToGlobal(new Point(candidate.x, candidate.y));
		}
		
		public function checkSwipe():Boolean
		{
			var newCoords:Point =  new Point(mouseX, mouseY);
			if (Math.abs(saveCoords.x - newCoords.x) > 50 && Math.abs(saveCoords.x - newCoords.x) < 300 && Math.abs(saveCoords.y - newCoords.y) < 10)
			{
				trace("SWIPE::::::::", saveCoords, newCoords);
		
				return true;
			}
			return false;
		}
		public function checkCandidate():Boolean
		{		
			var newCoords:Point =  new Point(mouseX, mouseY);//candidate.parent.parent.parent.localToGlobal(new Point(candidate.x, candidate.y));
			
			
			if (Math.abs(saveCoords.x - newCoords.x) < 10 && Math.abs(saveCoords.y - newCoords.y) < 10)
			{
				candidateOk = true;
				setDragElement(candidate, newCoords.x, newCoords.y);
				parent.setChildIndex(this, parent.numChildren - 1);
				return true;
			}
			
			return false;
		}
		
		public function setDragElement(obj:*, _x:Number, _y:Number):void
		{
			obj.down();
			activeElement = obj.mat;
			activeObj = obj;
			startTime = getTimer();
			startY = _y;
			var hh:Number = obj.height;
			if (obj is ElementFact) hh = obj.height + 30;
			
			
			var bd:BitmapData = new BitmapData(obj.width, hh, true, 0xffffff);
			var mat:Matrix = new Matrix();
			var scale:Number = 0.8;
			if (obj is ElementFact)
			{
				scale = 0.9; 
				mat.scale(scale, scale);
			}
			else
			{
				scale = 0.8; 
				mat.scale(scale, scale);
				mat.translate( 13 * scale, 13 * scale);	
			}
			
			
			bd.draw(obj, mat);
			
			spriteDrag.addChild(new Bitmap(bd));
	
			spriteDrag.x = mouseX - spriteDrag.width * 0.5;
			spriteDrag.y = mouseY  - spriteDrag.height * 0.5;
			obj.state2();
		}
		
		public function updateDragElement(e:MouseEvent):void
		{			
			spriteDrag.x = e.stageX - spriteDrag.width * 0.5;
			spriteDrag.y = e.stageY - y - spriteDrag.height * 0.5;
			HandSpeed.getInstance().calculateSpeed(spriteDrag.x, spriteDrag.y);
		}
		
		public function stopSlidersInteraction():void
		{
			sliderTxt.stopInteraction();
			sliderPhotoVideo.stopInteraction();
			sliderEvents.stopInteraction();
		}
		
		public function startSlidersInteraction():void
		{
			sliderTxt.startInteraction();
			sliderPhotoVideo.startInteraction();
			sliderEvents.startInteraction();
		}
		
		public function removeDragElement(_x:Number, _y:Number):void
		{
			if (!candidateOk)
				return;
			
			if (HandSpeed.getInstance().handSpeed.speedY < -100)
			{
				clearAllChoosenMats();
				
				showingMat = activeObj;
				showingMat.isActive = true;
				showingMat.state2();
				
				TweenLite.to(spriteDrag, 0.3, {y: this.y - spriteDrag.height - 300, onComplete: function():void
					{
						var data:Object = new Object();
						data.element = activeElement;
						
						if (showingMat is FavPreview)
							data.type = "Material";
						else if (showingMat is ElementFact)
							data.type = "Fact";
						
						dispatchEvent(new IpadEvent(IpadEvent.SHOW_MATERIAL, true, false, data));
						Tool.removeAllChildren(spriteDrag);
					}});
			}
			else
			{
				showingMat = null;
				Tool.removeAllChildren(spriteDrag);
			}
			
			if (showingMat == null)
			{
				activeObj.up();
				activeObj.isActive = false;
			}
			
			candidateOk = false;
		}
		
		private function clearAllChoosenMats():void 
		{
			for (var i:int = 0; i < sliderTxt.elemensArray.length; i++)
			{
				if (sliderTxt.elemensArray[i] is FavPreview)
				{
					(sliderTxt.elemensArray[i] as FavPreview).up();
					(sliderTxt.elemensArray[i] as FavPreview).isActive = false;
				}
			}
			
			for (var j:int = 0; j < sliderPhotoVideo.elemensArray.length; j++)
			{
				if (sliderPhotoVideo.elemensArray[j] is FavPreview)
				{
					(sliderPhotoVideo.elemensArray[j] as FavPreview).up();
					(sliderPhotoVideo.elemensArray[j] as FavPreview).isActive = false;
				}
			}	
			
			for (j = 0; j < sliderEvents.elemensArray.length; j++)
			{
				if (sliderEvents.elemensArray[j] is ElementFact)
				{
					(sliderEvents.elemensArray[j] as ElementFact).up();
					(sliderEvents.elemensArray[j] as ElementFact).isActive = false;
				}
			}	
		}			
	}
}
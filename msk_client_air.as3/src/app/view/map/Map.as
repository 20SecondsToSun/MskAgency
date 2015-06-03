package app.view.map
{
	import app.AppSettings;
	import app.assets.Assets;
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.InteractiveEvent;
	import app.contoller.events.ServerUpdateEvent;
	import app.model.materials.Material;
	import app.model.types.AnimationType;
	import app.view.baseview.io.InteractiveButton;
	import app.view.baseview.MainScreenView;
	import app.view.page.map.GeoMarker;
	import app.view.page.map.GeoObject;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Quart;
	import com.greensock.TweenLite;
	import com.modestmaps.events.MapEvent;
	import com.modestmaps.geo.Location;
	import com.modestmaps.mapproviders.yandex.YandexMapProvider;
	import com.modestmaps.TweenMap;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class Map extends MainScreenView
	{		
		private static const WIDTH:int = 410;
		private static const HEIGHT:int = 500;
		
		private static var START_Y:int = -1011;
		
		public  static const ANIMATION_DELAY_TIME:int = 25;
		public  static const MAP_WIDTH:int = 410;
		public  static const MAP_HEIGHT:int = 230;
		public  static const MAX_LINES:int = 4;
		
		private var isFresh:Boolean = false;
		private var isAnimate:Boolean = false;		
		private var index:int = 0;
		private var numPrev:int;		
		private var timeFormat:TextFormat = new TextFormat("TornadoL", 33, 0X000000);
		private var timeFormat1:TextFormat = new TextFormat("TornadoMedium", 14, 0xa5a5a5);
		private var newFormat:TextFormat = new TextFormat("TornadoL", 21, 0X494949);
		private var placeFormat:TextFormat = new TextFormat("TornadoL", 11.6, 0X494949);
		private var timeText:TextField;
		private var newText:TextField;
		private var placeText:TextField;
		private var dateTitle:TextField;		
		private var geoList:Vector.<Material>;
		private var billet:Shape;
		
		public var initX:Number = 1100;
		public var shiftX:Number = 690;		
		
		public var mapButton:InteractiveButton;
		public var newsButton:InteractiveButton;		
		
		private var _initialLat:Number = 55.55;
		private var _initialLong:Number = 37.58;
		private var _initialZoom:Number = 16;
		private var map:TweenMap;
		
		private var bkShape:Shape;
		private var bkMapShape:Shape;
		private var _overMap:Sprite;
		private var __mask:Shape;
		
		private var geotimer:Timer;
		public var mat:Material;
		
		private var mainHolder:Sprite;
		private var screenShot:Sprite;	
		
		private var freshUpdating:Boolean = false;
		private var preview:Sprite;
		
		public function Map()
		{
			visible = true;
			
			mainHolder = new Sprite();
			addChild(mainHolder);
			
			screenShot = new Sprite();
			addChild(screenShot);
			
			bkMapShape = Tool.createShape(MAP_WIDTH, MAP_HEIGHT, 0xf7edd1);
			mainHolder.addChild(bkMapShape);
			
			bkShape = Tool.createShape(MAP_WIDTH, 500 - MAP_HEIGHT, 0xFFFFFF);
			bkShape.y = MAP_HEIGHT;
			mainHolder.addChild(bkShape);
			
			newsButton = new InteractiveButton();
			addChild(newsButton);
			
			x = initX;
			
			map = new TweenMap(MAP_WIDTH, MAP_HEIGHT, false, new YandexMapProvider(3, 13));
			map.setCenterZoom(new Location(_initialLat, _initialLong), _initialZoom);
			map.addEventListener(MapEvent.STOP_PANNING, stopPanning);
			mainHolder.addChild(map);
			
			setTexts();
			
			mapButton = new InteractiveButton();
			addChild(mapButton);
			addMapOver();
			
			billet = Tool.createShape(width, MAP_HEIGHT, 0x0e9ac2);
			billet.alpha = 0;
			mapButton.addChild(billet);
			
			billet = Tool.createShape(width, height - MAP_HEIGHT + 77, 0x0e9ac2);
			billet.alpha = 0;
			newsButton.y = MAP_HEIGHT;
			newsButton.addChild(billet);
			
			addFooter();
		}		
		
		override public function setScreen():void
		{
			preview = config.getScreenShot("MAP_NEWS");	
			preview.visible = true;
			addChild(preview);
			preview.x = 0;
			preview.y = 0;
			visible = true;			
		}			
		
		private function addMapOver():void
		{
			_overMap = new Sprite();
			mainHolder.addChild(_overMap);
			
			var fill:Shape = Tool.createShape(width, MAP_HEIGHT, 0x0080ad);
			fill.blendMode = BlendMode.MULTIPLY;
			_overMap.addChild(fill);
			
			fill = Tool.createShape(width, MAP_HEIGHT, 0x0080ad);
			fill.alpha = 0.64;
			_overMap.addChild(fill);
			
			var icon:Sprite = Assets.create("mapOver");
			_overMap.addChild(icon);
			icon.y = 0.5 * (MAP_HEIGHT - icon.height);
			icon.x = 113;
			
			var textFormat:TextFormat = new TextFormat("Tornado", 16, 0Xffffff);
			
			var watch:TextField = TextUtil.createTextField(0, 0);
			watch.text = "ПЕРЕЙТИ К КАРТЕ";
			watch.setTextFormat(textFormat);
			
			watch.y = 0.5 * (MAP_HEIGHT - watch.height);
			watch.x = icon.x + icon.width + 15;
			
			_overMap.addChild(watch);
			_overMap.alpha = 0;
			
			__mask = Tool.createShape(MAP_WIDTH, 500, 0xf4f4f4);
			mainHolder.addChild(__mask);
			mainHolder.mask = __mask;		
		}
		
		private function addFooter():void
		{
			var footer:Shape = Tool.createShape(this.width, 77, 0x02a7df);
			footer.y = 500;
			mainHolder.addChild(footer);
			
			var icon:Sprite = Assets.create("readOver");
			mainHolder.addChild(icon);
			icon.y = 0.5 * (77 - icon.height) + 500;
			icon.x = 0.5 * (77 - icon.height);
			
			var textFormat:TextFormat = new TextFormat("Tornado", 16, 0Xffffff);
			
			var watch:TextField = TextUtil.createTextField(0, 0);
			watch.text = "ЧИТАТЬ НОВОСТЬ";
			watch.setTextFormat(textFormat);
			
			watch.y = 0.5 * (77 - watch.height) + 500;
			watch.x = icon.x + icon.width + 15;
			mainHolder.addChild(watch);
		}
		
		private function setTexts():void
		{
			timeText = TextUtil.createTextField(52, 272);
			mainHolder.addChild(timeText);
			
			dateTitle = TextUtil.createTextField(timeText.x + timeText.width + 13, 275);
			mainHolder.addChild(dateTitle);
			
			newText = TextUtil.createTextField(52, 302);
			newText.width = 320;
			newText.multiline = true;
			newText.wordWrap = true;
			mainHolder.addChild(newText);
			
			placeText = TextUtil.createTextField(52, 302);
			placeText.y = 445;
			placeText.width = 320;
			placeText.multiline = true;
			placeText.wordWrap = true;
			mainHolder.addChild(placeText);
		}
		
		public function expand():void
		{
			map.setSize(AppSettings.WIDTH, AppSettings.HEIGHT);
		}
		
		public function addPoints(matList:Vector.<Material>):void
		{			
			if (isListNull(matList))
				return;
				
			index = 0;
			if (map)   map.removeAllMarkers();
			
			geoList = matList;			
			
			for (var i:int = 0; i < geoList.length; i++)			
				addMarker(geoList[i]);			
			
			setMap();			
			flipNew();			
			waitToAnim();
		}
		
		public function addMarker(mat:Material):void
		{
			var gObjArray:Vector.<GeoObject>;
			gObjArray = new Vector.<GeoObject>();
			gObjArray.push(new GeoObject(mat));
			
			var geoObject:GeoMarker = new GeoMarker(gObjArray, false);
			geoObject.name = mat.id.toString();
			map.putMarker(new Location(mat.point.lat, mat.point.long), geoObject);
			
			map.getMarker(geoObject.name).alpha = 0;
		}
		
		override protected function startAutoAnimation():void
		{
			if (isListNull(geoList))
				return;
			
			if (geoList.length < 2 || !isAllowAnimation)
				return;
			
			startGeoAutoAnimation();
		}
		
		private function startGeoAutoAnimation():void
		{
			isAutoAnimation = true;
			
			if (!isAnimate)
			{
				TweenLite.killDelayedCallsTo(changeSlide);
				TweenLite.delayedCall(ANIMATION_DELAY_TIME, changeSlide);
			}
		}
		
		override public function stopAutoAnimation():void
		{			
			isAutoAnimation = false;
			TweenLite.killDelayedCallsTo(changeSlide);
		}
		
		private function changeSlide():void
		{
			if (!geoList || geoList.length == 0) return;
			isAnimate = true;
			
			index = nextIndex();
			numPrev = prevIndex();
			
			var geoPointCurrent:Material = geoList[index];
			var geoPointPrev:Material = geoList[numPrev];		
			
			var pointCurrent:Point = map.locationPoint(new Location(geoList[index].point.lat, geoList[index].point.long));
			var pointPrev:Point = map.locationPoint(new Location(geoList[numPrev].point.lat, geoList[numPrev].point.long));
			
			var distance:Number = Point.distance(pointCurrent, pointPrev);
			
			var time:Number = (distance / 5000) * 7;
			if (time < 2)
				time = 2;
			if (time > 20)
				time = 10;
				
			map.panDuration = time;
			
			setMap();
			changeTexts(mat.publishedDate, mat.title, mat.point.address);
		}
		
		private function setMap():void
		{
			mat = geoList[index];	
			map.getMarker(mat.id.toString()).alpha = 1;
			map.panTo(new Location(mat.point.lat, mat.point.long), true);
			changeTexts(mat.publishedDate, mat.title, mat.point.address);				
		}
		
		private function stopPanning(e:MapEvent):void
		{
			isAnimate = false;
			for (var i:int = 0; i < geoList.length; i++)
			{
				if (geoList[i].id == geoList[index].id)
					continue;
				map.getMarker(geoList[i].id.toString()).alpha = 0;
			}		
		
			if (isFresh)
			{
				flipNew();
				return;
			}
			if (!isAutoAnimation)
				return;
			
			TweenLite.killDelayedCallsTo(changeSlide);
			TweenLite.delayedCall(ANIMATION_DELAY_TIME, changeSlide);
		}
		
		private function changeTexts(publishedDate:Date, title:String, address:String):void
		{
			timeText.visible = false;
			newText.visible = false;
			placeText.visible = false;
			dateTitle.visible = false;
			
			timeText.text = TextUtil.getFormatTime(publishedDate);
			timeText.setTextFormat(timeFormat);
			
			dateTitle.text = TextUtil.formatDate1(publishedDate);
			dateTitle.setTextFormat(timeFormat1);
			dateTitle.x = timeText.x + timeText.width + 13;
			
			newText.text = title;
			newText.setTextFormat(newFormat);
			TextUtil.truncate(newText, MAX_LINES);
			newText.setTextFormat(newFormat);
			newText.y = timeText.y + timeText.height + 20;
			
			placeText.text = address.toUpperCase();
			placeText.setTextFormat(placeFormat);
			
			timeText.alpha = 0;
			newText.alpha = 0;
			placeText.alpha = 0;
			dateTitle.alpha = 0;
			
			timeText.visible = true;
			newText.visible = true;
			placeText.visible = true;
			dateTitle.visible = true;
			
			TweenLite.to([timeText, placeText, newText, dateTitle], 0.8, { alpha: 1 } );	
		}
		
		public function updater(e:ServerUpdateEvent):void
		{
			if (e.mat == null)
				return;		
		
			geoList = geoList.reverse();
			geoList.push(e.mat);
			geoList = geoList.reverse();
			geoList.pop();
			
			addMarker(geoList[0]);		
			
			if (freshUpdating) return;
			
			isFresh = true;
			
			if (!isAnimate)
				flipNew();
		}	
		
		private function flipNew():void
		{	
			freshUpdating = true;
			isFresh = false;
			TweenLite.killDelayedCallsTo(changeSlide);
			
			var pp:PerspectiveProjection = new PerspectiveProjection();
			pp.projectionCenter = new Point(WIDTH * 0.5, HEIGHT * 0.5);
			transform.perspectiveProjection = pp;
			
			var angle:Number = 90;
			var isSwap:Boolean = false;
			
			var screenshotBD:BitmapData = new BitmapData(WIDTH, HEIGHT);
			screenshotBD.draw(this);
			
			if (contains(preview)) removeChild(preview);
			index = 0;
			setMap();
			
			screenShot.x = 0;
			screenShot.y = 0;
			mainHolder.x = 0;
			timeText.alpha = 1;
			newText.alpha = 1;
			placeText.alpha = 1;
			dateTitle.alpha = 1;
			
			var anim:Sprite = new Sprite();
			addChild(anim);			
			
			var bitmapData:BitmapData = new BitmapData(WIDTH, HEIGHT);
			bitmapData.drawWithQuality(mainHolder, null, null, null, null, true, StageQuality.BEST);			
			var cur:Bitmap = new Bitmap(bitmapData);	
			mainHolder.visible = false;		
			
			bitmapData = new BitmapData(WIDTH, HEIGHT);
			bitmapData.draw(screenshotBD);
			var prev:Bitmap = new Bitmap(bitmapData);			
		
			anim.addChild(cur);
			anim.addChild(prev);
			
			
			cur.y = -HEIGHT;			
			
			TweenLite.to(cur, 1, { y: 0 , ease: Quart.easeInOut} );
			TweenLite.to(prev, 1, { y: prev.height, ease: Quart.easeInOut , onComplete:function ():void 
			{				
				mainHolder.visible = true;
				bitmapData.dispose();
				screenshotBD.dispose();
				anim.removeChild(cur);
				anim.removeChild(prev);
				removeChild(anim);	
				freshUpdating = false;				
			}} );
		}	
		
		public  function setScreenShot():void
		{
			var bitmapData:BitmapData = new BitmapData(WIDTH, HEIGHT);
			bitmapData.drawWithQuality(mainHolder, null, null, null, null, true, StageQuality.BEST);			
			
			config.setScreenShot(new Bitmap(bitmapData), "MAP_NEWS");
		}
		
		private function showingNewGeo():void
		{
			Tool.removeAllChildren(screenShot);
			
			screenShot.y = screenShot.x = screenShot.z = 0;
			mainHolder.y = mainHolder.x = mainHolder.z = 0;
			
			screenShot.rotationY = 0;
			mainHolder.rotationY = 0;
			
			swapChildren(screenShot, mainHolder);
			
			freshUpdating = false;		
		}
		
		public function toMainScreen():void
		{
			y = 0;// START_Y;
			visible = true;
			animateToXY(initX, 0, anim.MainScreen1.animInSpeed, anim.MainScreen1.animInEase);
		}
		
		public function gotoNewsDay():void
		{
			animateOutXY(this.x, -this.height, anim.MainScreen1AllNews.animOutSpeed, anim.MainScreen1AllNews.animOutEase);
		}
		
		public function show():void
		{
			visible = true;
			y = 0;
			x = initX;
			dispatchEvent(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_MAIN_GEO_DATA));
		}
		
		override public function animationInFinished():void
		{
			dispatchEvent(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_MAIN_GEO_DATA));
			dispatchEvent(new AnimationEvent(AnimationEvent.MAP_ANIMATION_FINISHED, AnimationType.IN, this));
		}
		
		override public function animationOutFinished():void
		{
			dispatchEvent(new AnimationEvent(AnimationEvent.MAP_ANIMATION_FINISHED, AnimationType.OUT, this));
		}
		
		public function overMap(e:InteractiveEvent):void
		{
			TweenLite.to(_overMap, 0.2, {alpha: 1, ease: Cubic.easeInOut});
		}
		
		public function outMap(e:InteractiveEvent):void
		{
			TweenLite.to(_overMap, 0.2, {alpha: 0, ease: Cubic.easeInOut});
		}
		
		public function overNews(e:InteractiveEvent):void
		{
			TweenLite.delayedCall(0.3, readyToOverNews);
		}
		
		public function outNews(e:InteractiveEvent):void
		{
			TweenLite.killDelayedCallsTo(readyToOverNews);
			TweenLite.to(this, 0.5, {y: 0, ease: Cubic.easeInOut});
			TweenLite.to(__mask, 0.5, {y: 0, ease: Cubic.easeInOut});
		}
		
		private function readyToOverNews():void
		{
			if (this)
			{
				TweenLite.to(this, 0.5, {y: -77, ease: Cubic.easeInOut});
				TweenLite.to(__mask, 0.5, {y: 77, ease: Cubic.easeInOut});
			}
		}
		
		override public function kill():void
		{
			super.kill();
		
			if (screenShot) TweenLite.killTweensOf(screenShot);
			if (mainHolder) TweenLite.killTweensOf(mainHolder);
			
			TweenLite.killTweensOf(timeText);
			TweenLite.killTweensOf(placeText);
			TweenLite.killTweensOf(newText);
			TweenLite.killTweensOf(dateTitle);
			
			TweenLite.killTweensOf(_overMap);
			TweenLite.killTweensOf(this);
			TweenLite.killTweensOf(__mask);
			TweenLite.killDelayedCallsTo(changeSlide);
			TweenLite.killDelayedCallsTo(readyToOverNews);
			
			if (map == null)	return;
			map.removeEventListener(MapEvent.STOP_PANNING, stopPanning);
			map.removeAllMarkers();
			map = null;
		}
		
		public function getMapRec():Rectangle
		{
			var point:Point = parent.localToGlobal(new Point(x, y));
			return new Rectangle(point.x, point.y, width, MAP_HEIGHT);
		}
		
		public function getNewRec():Rectangle
		{
			var point:Point = parent.localToGlobal(new Point(x, MAP_HEIGHT));
			return new Rectangle(point.x, point.y, width, height - MAP_HEIGHT);
		}
		
		private function nextIndex():int
		{
			return (index + 1) % geoList.length;
		}
		
		private function prevIndex():int
		{
			return (index - 1) < 0 ? geoList.length - 1 : index - 1;
		}
	}
}
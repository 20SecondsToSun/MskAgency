package app.view.page.map
{
	import app.assets.Assets;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.GraphicInterfaceEvent;
	import app.contoller.events.InteractiveEvent;
	import app.model.materials.Material;
	import app.view.baseview.io.InteractiveButton;
	import app.view.baseview.io.InteractiveObject;
	import app.view.utils.DrawingShapes;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import com.modestmaps.geo.Location;
	import flash.display.CapsStyle;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class GeoMarker extends InteractiveObject
	{
		private var textTitle:TextField;
		private var clusters:Vector.<GeoObject>;
		public var bullet:Sprite;
		public var clusterShadow:Sprite;
		
		static public const BULLET_WIDTH:int = 70;
		static public const BULLET_HEIGHT:int = 70;
		
		private var canvas:Sprite;
		
		private var accident:Object = {count: 0, percent: 0, color: 0x5bccf7};
		private var city:Object = {count: 0, percent: 0, color: 0xa0dc4f};
		private var power:Object = {count: 0, percent: 0, color: 0xec4173};
		private var dosug:Object = {count: 0, percent: 0, color: 0x9582ba};
		private var none:Object = {count: 0, percent: 0, color: 0xebebeb};
		
		private var typeVector:Vector.<Object>;
		private var circleMC:Shape;
		
		private var interactive:Boolean = true;
		
		public var location:Location;		
		
		private var startDegree:Number = 0;
		private var endDegree:Number = 0;
		private var progressDegree:Number = 8;
		private var progressClip:Sprite;
		private var point:Point = new Point(0, 0);
		
		private var popup:InteractiveButton;
		private var isPopupOpen:Boolean = false;		
		private var footerOver:Sprite;
		private var popupMask:Shape;
		
		public function get isCluster():Boolean
		{
			return clusters.length > 1;
		}
		
		public function get mat():Material
		{
			return clusters[0].mat;
		}
		
		public function get getSelfRec():Rectangle
		{
			var point:Point = localToGlobal(new Point(popup.x, popup.y));
			return new Rectangle(point.x, point.y, popup.width, popup.height);
		}
		
		public function GeoMarker(_clusters:Vector.<GeoObject>, _interactive:Boolean = true, animationToShowCluster:Boolean = false)
		{
			interactive = _interactive;
			clusters = _clusters;
			
			downEnabled = false;
			
			if (clusters.length > 1)
			{
				clusterShadow = Assets.create("clusterShadow");
				addChild(clusterShadow);
				clusterShadow.y = -75;
				clusterShadow.x = -23;
				
				circleMC = new Shape();
				circleMC.graphics.beginFill(0xFFFFFF);
				circleMC.graphics.drawCircle(35, 35, 35);
				addChild(circleMC);
				circleMC.y = -84;
				circleMC.x = -35;
				
				var textFormat:TextFormat = new TextFormat("TornadoBold", 29.7, 0X1e1e1e);
				
				textTitle = TextUtil.createTextField(0, 0);
				textTitle.multiline = false;
				textTitle.wordWrap = false;
				textTitle.text = clusters.length.toString();
				textTitle.setTextFormat(textFormat);
				addChild(textTitle);
				textTitle.x = 0.5 * (BULLET_WIDTH - textTitle.width) - 35;
				textTitle.y = 0.5 * (BULLET_HEIGHT - textTitle.height) - 84;
				
				canvas = new Sprite();
				addChild(canvas);
				canvas.y = -49;
				canvas.x = 30;
				
				calculateTypes();
				
				if (animationToShowCluster)
				{
					scaleX = scaleY = 0.1;
					TweenLite.to(this, 0.2, { delay:Math.random()*0.5, scaleX: 1, scaleY: 1 } );				
				}				
			}
			else
			{
				switch (clusters[0].group_id)
				{
					case 1: 					
						bullet = Assets.create("cityIcon");
						break;
						
					case 3: 
						bullet = Assets.create("accidentIcon");
						break;
						
					case 4: 				
						bullet = Assets.create("dosugIcon");
						break;
						
					case 2:
						bullet = Assets.create("powerIcon");
						break;
						
					default: 
						bullet = Assets.create("defaultIcon");
				}
				addChild(bullet);
				bullet.y = -84;
				bullet.x = -35;
			}
			
			var over:Shape = Tool.createShape(width, height, 0x000000);
			addChild(over);
			over.y = -84;
			over.x = -35;
			over.alpha = 0;
			
			progressClip = new Sprite();
			addChild(progressClip);
			progressClip.y = -49;
			progressClip.x = 60;		
		}
		
		public function over():void
		{
			if (!interactive || isPopupOpen)
				return;
			
			TweenLite.delayedCall(0.5, progressCircle);
		}
		
		private function progressCircle():void
		{
			startDegree = 0;
			endDegree = 0;
			point = new Point(0, 0);
			
			addEventListener(Event.ENTER_FRAME, drawCircle);
		}
		
		private function drawCircle(e:Event):void
		{
			endDegree += progressDegree;
			progressClip.graphics.lineStyle(5, 0x02a7df, 1, false, "normal", CapsStyle.NONE);
			point = DrawingShapes.drawArc(progressClip.graphics, point.x, point.y, 60, progressDegree, startDegree, 60);
			startDegree = endDegree;
			if (endDegree == 360)
			{
				removeEventListener(Event.ENTER_FRAME, drawCircle);
				chooseCompleted();
			}
		}
		
		private function chooseCompleted():void
		{
			if (clusters.length > 1)
			{
				//trace("zoom map");		
				var zoomEvent:GraphicInterfaceEvent = new GraphicInterfaceEvent(GraphicInterfaceEvent.ZOOM_MAP);
				dispatchEvent(zoomEvent);
			}
			else			
				showPopup();			
		}
		
		private function showPopup():void
		{
			progressClip.graphics.clear();			
			popup = new InteractiveButton();				
			
			var fillPopup:Shape = Tool.createShape(518, 279, 0xf4f5f7);
			popup.addChild(fillPopup);
			popup.y = -popup.height - 50;
			popup.x = -60;
			
			var textFormat:TextFormat = new TextFormat("TornadoL", 33, 0X02a7df);
			var timeTitle:TextField = TextUtil.createTextField(50, 40);
			timeTitle.text = TextUtil.getFormatTime(mat.publishedDate);
			timeTitle.setTextFormat(textFormat);
			popup.addChild(timeTitle)
			
			textFormat.color = 0x2b2b2b;
			textFormat.size = 24;
			
			var textTitle:TextField = TextUtil.createTextField(52, 90);
			textTitle.width = 400;
			textTitle.multiline = true;
			textTitle.wordWrap = true;
			textTitle.text = mat.title;
			TextUtil.truncate(textTitle, 5, textFormat);
			textTitle.setTextFormat(textFormat);
			popup.addChild(textTitle)
			
			isPopupOpen = true;
			
			popup.alpha = 0;
			popup.y = 0 ;
			
			addFooter();		
			
			var billet:Shape = Tool.createShape(popup.width, popup.height +footerOver.height, 0xff0000);		
			billet.alpha = 0;
			popup.addChild(billet);			
			
			addChild(popup);
			setChildIndex(popup, 0);
			
			TweenLite.to(popup, 0.4, { alpha:1, y: -329 , ease:Expo.easeInOut } );				
			
			popupMask = Tool.createShape(popup.width, popup.height-footerOver.height, 0x000000);			
			popupMask.x = popup.x;
			popupMask.y = -379;			
			popup.mask = popupMask;
			popupMask.alpha  = 0.5;			
			addChild(popupMask);
			
			
			var zoomEvent:GraphicInterfaceEvent = new GraphicInterfaceEvent(GraphicInterfaceEvent.POPUP_MAP);
			dispatchEvent(zoomEvent);
			
			popup.addEventListener(InteractiveEvent.HAND_PUSH, gotoNewPage);
			popup.addEventListener(InteractiveEvent.HAND_OVER, overPopup);
			popup.addEventListener(InteractiveEvent.HAND_OUT, outPopup);
		}
		
		private function outPopup(e:InteractiveEvent):void 
		{
			TweenLite.to(popup, 0.3, { y: -329  } );
		}
		
		private function overPopup(e:InteractiveEvent):void 
		{			
			TweenLite.to(popup, 0.3, { y: -379} );
		}
		
		public function hidePopup():void
		{
			if (popup)
			{
				removeChild(popup);
				removeChild(popupMask);
				popup.removeEventListener(InteractiveEvent.HAND_PUSH, gotoNewPage);
				popup.removeEventListener(InteractiveEvent.HAND_OVER, overPopup);
				popup.removeEventListener(InteractiveEvent.HAND_OUT, outPopup);
			}
			
			isPopupOpen = false;		
		}		
		
		private function addFooter():void 
		{
			footerOver = new Sprite();
			var footer:Shape = Tool.createShape(popup.width, 50, 0x02a7df);
			footer.y = popup.height - footer.height;			
			footerOver.addChild(footer);
			
			popup.addChild(footerOver);
			
			var icon:Sprite = Assets.create("readOver");
			footerOver.addChild(icon);
			icon.y = footer.y + 0.5 * (50 - icon.height) ;			
			icon.x = 310;			
			
			var textFormat:TextFormat = new TextFormat("Tornado", 16, 0Xffffff);
			
			var watch:TextField = TextUtil.createTextField(0, 0);				
			watch.text = "ЧИТАТЬ НОВОСТЬ";			
			watch.setTextFormat(textFormat);
			
			watch.y = footer.y+ 0.5 * (50 - watch.height);
			watch.x = icon.x + icon.width +15;
			footerOver.addChild(watch);	
			
			footerOver.y = footerOver.height;
			footerOver.visible = true;	
		}		
		
		private function gotoNewPage(e:InteractiveEvent):void
		{
			var event:ChangeLocationEvent = new ChangeLocationEvent(ChangeLocationEvent.ONE_NEW_PAGE);
			event.mode = "EXPAND_MODE";
			dispatchEvent(event);
		}
		
		public function out():void
		{
			if (!interactive || isPopupOpen)
				return;
			
			if (endDegree != 360)
			{
				removeEventListener(Event.ENTER_FRAME, drawCircle);
				progressClip.graphics.clear();
			}
			
			TweenLite.killDelayedCallsTo(progressCircle);
		}
		
		private function calculateTypes():void
		{
			nullValues();
			for (var i:int = 0; i < clusters.length; i++)
			{
				switch (clusters[i].group_id)
				{
					case 1:
						city.count++;
						break;
					case 3: 
						accident.count++;
						break;
					case 4:
						dosug.count++;
						break;
					case 2:
						power.count++;
						break;
					default: 
						none.count++;
				}
			}
			
			accident.percent = accident.count / clusters.length;
			city.percent = city.count / clusters.length;
			power.percent = power.count / clusters.length;
			dosug.percent = dosug.count / clusters.length;
			none.percent = none.count / clusters.length;
			
			typeVector = new Vector.<Object>();
			
			typeVector.push(accident);
			typeVector.push(city);
			typeVector.push(power);
			typeVector.push(dosug);
			typeVector.push(none);
			
			drawArcs();
		}
		
		private function drawArcs():void
		{
			
			var startDegree:Number = 0;
			var endDegree:Number = 0;
			var point:Point = new Point(0, 0);
			
			for (var i:int = 0; i < typeVector.length; i++)
			{
				if (typeVector[i].percent == 0)
					continue;
				
				endDegree = typeVector[i].percent * 360;
				
				canvas.graphics.lineStyle(10, typeVector[i].color, 1, false, "normal", CapsStyle.NONE);
				point = DrawingShapes.drawArc(canvas.graphics, point.x, point.y, 30, endDegree, startDegree, 30);
				startDegree += endDegree;
			}
		}
		
		private function nullValues():void
		{
			accident.count = accident.percent = city.count = city.percent = power.count = power.percent = dosug.count = dosug.percent = none.count = none.percent = 0;
		}	
	}
}
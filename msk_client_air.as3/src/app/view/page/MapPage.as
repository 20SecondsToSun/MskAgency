package app.view.page
{
	import app.AppSettings;
	import app.contoller.events.GraphicInterfaceEvent;
	import app.contoller.events.InteractiveEvent;
	import app.model.materials.Material;
	import app.services.interactive.gestureDetector.HandSpeed;
	import app.view.page.map.GeoCluster;
	import app.view.page.map.GeoMarker;
	import app.view.page.map.GeoObject;
	import app.view.page.map.LeftPanelMap;
	import app.view.utils.Tool;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import com.modestmaps.core.MapExtent;
	import com.modestmaps.events.MapEvent;
	import com.modestmaps.geo.Location;
	import com.modestmaps.Map;
	import com.modestmaps.mapproviders.yandex.YandexMapProvider;
	import com.modestmaps.TweenMap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class MapPage extends BasePage
	{
		private var map:TweenMap;
		private const PADDING:int = 0;
		private var img:Sprite;
		
		//private var splash:Shape;
		private var holder:Sprite;
		private var leftPanel:Sprite;
		
		private var INITIAL_LAT:Number = 55.55;
		private var INITIAL_LONG:Number = 37.58;
		private var INITIAL_ZOOM:int = 11;
		
		private var _initialLat:Number = 55.55;
		private var _initialLong:Number = 37.58;
		private var _initialZoom:int = 11;
		
		private const MAX_ZOOM:int = 17;
		
		private var mat:Material;
		
		static public const MAP_WIDTH:int = 410;
		static public const MAP_HEIGHT:int = 230;
		
		private var markerList:Vector.<GeoObject> = new Vector.<GeoObject>();
		
		protected var distance:Number = 160;
		protected var clusters:Vector.<GeoCluster>;
		protected var clustering:Boolean;
		protected var resolution:Number;
		
		private var animateType:String = "None";
		private var splash:Shape = Tool.createShape(AppSettings.WIDTH, AppSettings.HEIGHT, 0xD9E1D6);
		private var lastZ:Number = 0; //Infinity;
		private var delta:Number = 0;
		private var firstXY:Object = {x: 0, y: 0};
		private var isNeedUpdate:Boolean = true;
		private var lastCluster:GeoMarker;
		
		public function MapPage()
		{
			isStretch = true;
			holder = new Sprite();
			addChild(holder);
			
			leftPanel = new LeftPanelMap();
			addChild(leftPanel);
			
			leftPanel.x = -365;
			TweenLite.to(leftPanel, 0.8, {delay: 1.6, x: 0, ease: Cubic.easeInOut});
		}
		
		public function refreshData():void
		{
		
		}
		
		override public function flip():void
		{
			animateType = "FLIP";
			holder.addChild(splash);
			
			var _initialLocation:Location = new Location(_initialLat, _initialLong)
			map = new TweenMap(stage.stageWidth, stage.stageHeight, true, new YandexMapProvider(3, MAX_ZOOM));
			
			map.setCenterZoom(_initialLocation, _initialZoom);
			holder.addChild(map);
			holder.y = AppSettings.HEIGHT;
			TweenLite.to(holder, 0.8, {delay:0.8, y: 0, ease: Expo.easeOut, onComplete: animationInFinished()});
		}
		
		public function backFromOneNew():void
		{
			animateType = "BACK_FROM_ONE_NEW";
			holder.addChild(splash);
			
			var _initialLocation:Location = new Location(_initialLat, _initialLong)
			map = new TweenMap(stage.stageWidth, stage.stageHeight, true, new YandexMapProvider(3, MAX_ZOOM));
			
			map.setCenterZoom(_initialLocation, _initialZoom);
			
			holder.addChild(map);
			animationInFinished();
		}
		
		public function expandMap(_mat:Material):void
		{
			animateType = "EXPAND";
			holder.addChild(splash);
			splash.visible = false;
			
			TweenLite.delayedCall(1, function():void
				{
					if (splash)
						splash.visible = true;
				})
			
			mat = _mat;
			
			if (mat)
			{
				_initialLat = mat.point.lat;
				_initialLong = mat.point.long;
				_initialZoom = 13;
				
			}
			
			var _initialLocation:Location = new Location(_initialLat, _initialLong)
			map = new TweenMap(stage.stageWidth, stage.stageHeight, true, new YandexMapProvider(3, MAX_ZOOM));
			map.setCenterZoom(_initialLocation, _initialZoom);
			holder.addChild(map);
			
			if (mat)
			{
				TweenLite.delayedCall(0.7, function():void
					{
						addOneMarkerOnMap(mat);
						map.addEventListener(MouseEvent.MOUSE_WHEEL, map.onMouseWheel);
					});
			}
			
			map.panBy((1100 + 410 * 0.5 - AppSettings.WIDTH * 0.5), -(AppSettings.HEIGHT * 0.5 - 230 * 0.5));
			
			var layermask:Shape = Tool.createShape(MAP_WIDTH, MAP_HEIGHT, 0xFF0000);
			layermask.x = 1100;
			layermask.y = 0;
			holder.mask = layermask;
			addChild(layermask);
			
			TweenLite.delayedCall(0.2, function():void
				{
					map.panAndZoomDuration = 3;
					map.panAndZoomIn(_initialLocation);
					TweenLite.to(layermask, 1, {x: 0, y: 0, height: AppSettings.HEIGHT, width: AppSettings.WIDTH, ease: Expo.easeInOut, onComplete: function():void
						{
							removeChild(layermask);
							animationInFinished();
						}});
				});
		}
		
		public function over(e:InteractiveEvent):void
		{
			var geoMarker:GeoMarker = e.target as GeoMarker;
			if (geoMarker)
			{
				map.markerClip.setChildIndex(geoMarker, map.markerClip.numChildren - 1);
				geoMarker.over();
			}
		}
		
		public function out(e:InteractiveEvent):void
		{
			var geoMarker:GeoMarker = e.target as GeoMarker;
			if (geoMarker)
				geoMarker.out();
		}
		
		public function mapPopupOpen(e:GraphicInterfaceEvent):void
		{
			var geoMarker:GeoMarker = e.target as GeoMarker;
			if (geoMarker)
			{
				if (lastCluster)
					lastCluster.hidePopup();
				
				isNeedUpdate = false;
				lastCluster = geoMarker;
				map.panTo(geoMarker.location, true);
			}
		}
		
		public function zoomMapByCluster(e:GraphicInterfaceEvent):void
		{
			var geoMarker:GeoMarker = e.target as GeoMarker;
			if (geoMarker)
				map.panAndZoomBy(3, geoMarker.location, null, 1);
		}
		
		public function kill():void
		{
			if (map != null)
			{
				map.removeAllMarkers();
				map.removeEventListener(MouseEvent.MOUSE_WHEEL, map.onMouseWheel);
				map.removeEventListener(MapEvent.STOP_ZOOMING, cluster);
				map.removeEventListener(MapEvent.STOP_PANNING, cluster);
				map = null;
			}
			
			TweenLite.killTweensOf(leftPanel);
			TweenLite.killTweensOf(holder);
			TweenLite.killTweensOf(map);
		}
		
		public function refreshPoints(matList:Vector.<Material>):void
		{
			if (map == null) return;
			
			map.setCenterZoom(new Location(INITIAL_LAT, INITIAL_LONG), INITIAL_ZOOM);
			markerList = new Vector.<GeoObject>();
			map.markerClip.removeAllMarkers();
			
			
			if (matList.length == 1) 
			{
				addOneMarkerOnMap(matList[0]);
				return;
			}
			
			for (var i:int = 0; i < matList.length; i++)
			{
				var geoObject:GeoObject = new GeoObject(matList[i]);
				markerList.push(geoObject);
				map.putMarker(new Location(geoObject.lat, geoObject.long), geoObject);
			}
			
			cluster(null);
		}
		
		public function addOneMarkerOnMap(mat:Material):void
		{
			markerList = new Vector.<GeoObject>();
			markerList.push(new GeoObject(mat));
			var marker:GeoMarker = new GeoMarker(markerList, true, true);
			marker.location = MapExtent.fromLocationProperties(Tool.toArray(markerList)).center;
			map.putMarker(marker.location, marker);
		}
		
		public function addPoints(matList:Vector.<Material>):void
		{
			if (animateType != "EXPAND")
				map.setCenterZoom(new Location(INITIAL_LAT, INITIAL_LONG), INITIAL_ZOOM);
			markerList = new Vector.<GeoObject>();
			map.markerClip.removeAllMarkers();			
			map.addEventListener(MouseEvent.MOUSE_WHEEL, map.onMouseWheel);
			map.addEventListener(MapEvent.STOP_ZOOMING, cluster);
			map.addEventListener(MapEvent.STOP_PANNING, cluster);
			
			if (!matList || matList.length == 0) return;
			
			if (matList.length == 1) 
			{
				addOneMarkerOnMap(matList[0]);
				return;
			}
			
			for (var i:int = 0; i < matList.length; i++)
			{
				var geoObject:GeoObject = new GeoObject(matList[i]);
				markerList.push(geoObject);
				map.putMarker(new Location(geoObject.lat, geoObject.long), geoObject);
			}
			
			cluster(null);
		}		
		
		public function setCenterPoint(x:Number, y:Number, z:Number):void
		{
			firstXY.x = x;
			firstXY.y = y;
			lastZ = z;
		}
		
		public function setDraggble():void
		{
			map.onKinectWheelOff();
		}
		
		public function sendZoom(x:Number, y:Number, z:Number):void
		{			
			if (HandSpeed.getInstance().averageSpeedMax > 3)
				return;
			
			if (Math.abs(lastZ - z) <= 0.04)
				return;
			delta = lastZ - z;
			lastZ = z;
			
			if (isNaN(delta))
				return;
			delta = -delta;
			
			map.onKinectWheel(firstXY.x, firstXY.y, delta);
		}
		
		protected function cluster(event:MapEvent):void
		{			
			if (isNeedUpdate == false)
			{
				isNeedUpdate = true;
				return;
			}
			
			var animationToShowCluster:Boolean = (event && event.type == MapEvent.STOP_ZOOMING);
			
			if (markerList && markerList.length > 1)
			{
				var resolution:int = map.getZoom();
				var extent:MapExtent = map.getExtent();
				
				if (resolution != this.resolution || !clustersExist())
				{
					this.resolution = resolution;
					var clusters:Vector.<GeoCluster> = new Vector.<GeoCluster>();
					
					var feature:GeoObject;
					var clustered:Boolean;
					var cluster:GeoCluster;
					
					for (var i:int = 0; i < markerList.length; ++i)
					{
						feature = markerList[i];
						
						if (!extent.contains(feature.location))
							continue;
						
						clustered = false;
						
						for (var j:int = 0; j < clusters.length; ++j)
						{
							cluster = clusters[j];
							
							if (shouldCluster(cluster, feature))
							{
								addToCluster(cluster, feature);
								clustered = true;
								break;
							}
						}
						if (!clustered)
						{
							clusters.push(createCluster(markerList[i]));
						}
						
					}
					map.markerClip.removeAllMarkers();
					
					if (clusters.length > 0)
					{
						
						clustering = true;
						// A legitimate feature addition could occur during this
						// addFeatures call.  For clustering to behave well, features
						// should be removed from a layer before requesting a new batch.
						for each (cluster in clusters)
						{
							if (MAX_ZOOM == resolution)
							{
								if (cluster.cluster.length > 1)
								{
									
									for (var k:int = 0; k < cluster.cluster.length; k++)
									{
										var tempVector:Vector.<GeoObject> = new Vector.<GeoObject>();
										tempVector.push(cluster.cluster[k]);
										var _marker:GeoMarker = new GeoMarker(tempVector, true, animationToShowCluster);
										var center:Location = MapExtent.fromLocationProperties(Tool.toArray(cluster.cluster)).center;
										_marker.location = new Location(center.lat, center.lon + k * 0.0008)
										map.putMarker(_marker.location, _marker);
									}
									
									continue;
								}
							}
							var marker:GeoMarker = new GeoMarker(cluster.cluster, true, animationToShowCluster);
							marker.location = MapExtent.fromLocationProperties(Tool.toArray(cluster.cluster)).center;
							map.putMarker(marker.location, marker);
						}
						clustering = false;
					}
					this.clusters = clusters;
				}
			}
		}
		
		/**
		 * Method: clustersExist
		 * Determine whether calculated clusters are already on the layer.
		 *
		 * Returns:
		 * {Boolean} The calculated clusters are already on the layer.
		 */
		protected function clustersExist():Boolean
		{
			var exist:Boolean = false;
			if (clusters && clusters.length > 0 && clusters.length == map.markerClip.getMarkerCount())
			{
				exist = true;
				
				for (var i:int = 0; i < this.clusters.length; ++i)
				{
					if (map.markerClip.getMarker(clusters[i].name) == null)
					{
						exist = false;
						break;
					}
				}
			}
			return exist;
		}
		
		/**
		 * Method: shouldCluster
		 * Determine whether to include a feature in a given cluster.
		 *
		 * Parameters:
		 * cluster - {<OpenLayers.Feature.Vector>} A cluster.
		 * feature - {<OpenLayers.Feature.Vector>} A feature.
		 *
		 * Returns:
		 * {Boolean} The feature should be included in the cluster.
		 */
		protected function shouldCluster(cluster:Object, feature:GeoObject):Boolean
		{
			var cc:Point = map.locationPoint(cluster.location);
			var fc:Point = map.locationPoint(feature.location);
			var distance:Number = Point.distance(cc, fc);
			return (distance <= this.distance);
		}
		
		/**
		 * Method: addToCluster
		 * Add a feature to a cluster.
		 *
		 * Parameters:
		 * cluster - {<OpenLayers.Feature.Vector>} A cluster.
		 * feature - {<OpenLayers.Feature.Vector>} A feature.
		 */
		protected function addToCluster(cluster:Object, feature:GeoObject):void
		{
			cluster.cluster.push(feature);
			cluster.count += 1;
		}
		
		/**
		 * Method: createCluster
		 * Given a feature, create a cluster.
		 *
		 * Parameters:
		 * feature - {<OpenLayers.Feature.Vector>}
		 *
		 * Returns:
		 * {<OpenLayers.Feature.Vector>} A cluster.
		 */
		protected function createCluster(feature:GeoObject):GeoCluster
		{
			var cluster:GeoCluster = new GeoCluster();
			cluster.location = feature.location;
			cluster.count = 1;
			cluster.name = "cluster-" + Math.random().toString();
			cluster.cluster.push(feature);
			
			return cluster;
		}	
	}
}
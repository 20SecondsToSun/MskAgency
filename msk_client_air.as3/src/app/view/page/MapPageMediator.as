package app.view.page
{
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.ChangeLocationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.FilterEvent;
	import app.contoller.events.GraphicInterfaceEvent;
	import app.contoller.events.InteractiveEvent;
	import app.model.dataall.IAllNewsModel;
	import app.model.datageo.IGeoModel;
	import app.model.types.AnimationType;
	import app.view.page.map.GeoMarker;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class MapPageMediator extends PageMediator
	{
		[Inject]
		public var pageView:MapPage;
		
		[Inject]
		public var model:IGeoModel;
		
		[Inject]
		public var allModel:IAllNewsModel;
		
		override public function onRegister():void
		{
			activeView = pageView;
			activeModel = model;
			super.onRegister();		
		}
		
		override protected function pageAnimFinish(e:AnimationEvent):void 
		{
			addContextListener(FilterEvent.GEO_NEWS_SORTED, refreshSorted, FilterEvent);			
			addContextListener(DataLoadServiceEvent.RELOAD_DATA, reloadData, DataLoadServiceEvent);
			controlMapPageAnimFinish();
		}
		
		private function reloadData(e:DataLoadServiceEvent):void 
		{			
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_GEO_DATA));
		}
		
		
		private function refreshSorted(e:FilterEvent):void 
		{			
			pageView.refreshPoints(model.newsListSorted);
		}
		
		override protected function backFromOneNew(e:ChangeLocationEvent):void 
		{			
			pageView.backFromOneNew();
		}
		
		override protected function expand(e:ChangeLocationEvent):void
		{
			pageView.expandMap(model.activeMaterial);
		}
		
		private function controlMapPageAnimFinish():void
		{
			dispatch(new AnimationEvent(AnimationEvent.PAGE_ANIMATION_FINISHED, AnimationType.IN, pageView));
			
			addContextListener(DataLoadServiceEvent.LOAD_COMPLETED_GEO_NEWS, addPoints, DataLoadServiceEvent);
			dispatch(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_GEO_DATA));
		}
		
		private function addPoints(e:DataLoadServiceEvent):void
		{
			pageView.addPoints(model.newsList);
			
			addViewListener(GraphicInterfaceEvent.ZOOM_MAP, pageView.zoomMapByCluster, GraphicInterfaceEvent, true);
			addViewListener(GraphicInterfaceEvent.POPUP_MAP, pageView.mapPopupOpen, GraphicInterfaceEvent, true);
			
			addViewListener(ChangeLocationEvent.ONE_NEW_PAGE, gotoOnePage, ChangeLocationEvent, true);
			addViewListener(InteractiveEvent.HAND_OVER, pageView.over, InteractiveEvent, true);
			addViewListener(InteractiveEvent.HAND_OUT, pageView.out, InteractiveEvent, true);			
			
			addViewListener(InteractiveEvent.HAND_DOWN, startCheckZ, InteractiveEvent, true);
			addViewListener(InteractiveEvent.HAND_UP, stopCheckZ, InteractiveEvent, true);			
		}
		
		private function startCheckZ(e:InteractiveEvent):void 
		{
			pageView.setCenterPoint(e.stageX,e.stageY,e.stageZ);
			addViewListener(InteractiveEvent.HAND_UPDATE, update, InteractiveEvent, true);			
		}
		
		private function stopCheckZ(e:InteractiveEvent):void 
		{	
			pageView.setDraggble();
			removeViewListener(InteractiveEvent.HAND_UPDATE, update, InteractiveEvent, true);
		}
		
		private function update(e:InteractiveEvent):void 
		{			
			pageView.sendZoom(e.stageX, e.stageY, e.stageZ);
		}
		
		private function gotoOnePage(e:ChangeLocationEvent):void
		{
			var geoMarker:GeoMarker = e.target as GeoMarker;
			
			allModel.activeMaterial = geoMarker.mat;
			allModel.setChoosenField({rec: geoMarker.getSelfRec, color: 0xf4f5f7});
			
			dispatch(e);
		}
		
		override protected function removeAllListeners(e:ChangeLocationEvent):void
		{
			pageView.kill();
			
			removeViewListener(AnimationEvent.PAGE_ANIMATION_FINISHED, controlMapPageAnimFinish, AnimationEvent);
			removeContextListener(DataLoadServiceEvent.LOAD_COMPLETED_GEO_NEWS, addPoints, DataLoadServiceEvent);
			removeContextListener(DataLoadServiceEvent.RELOAD_DATA, reloadData, DataLoadServiceEvent);
			removeViewListener(ChangeLocationEvent.REMOVE_PAGE, removeAllListeners, ChangeLocationEvent);
			
			removeViewListener(ChangeLocationEvent.ONE_NEW_PAGE, gotoOnePage, ChangeLocationEvent, true);
			removeViewListener(GraphicInterfaceEvent.ZOOM_MAP, pageView.zoomMapByCluster, GraphicInterfaceEvent);
			removeViewListener(InteractiveEvent.HAND_OVER, pageView.over, InteractiveEvent, true);
			removeViewListener(InteractiveEvent.HAND_OUT, pageView.out, InteractiveEvent, true);
			removeViewListener(InteractiveEvent.HAND_DOWN, startCheckZ, InteractiveEvent, true);
			removeViewListener(InteractiveEvent.HAND_UP, stopCheckZ, InteractiveEvent, true);
			
			removeViewListener(GraphicInterfaceEvent.POPUP_MAP, pageView.mapPopupOpen, GraphicInterfaceEvent, true);
			
			super.removeAllListeners(e);
		}
	}
}
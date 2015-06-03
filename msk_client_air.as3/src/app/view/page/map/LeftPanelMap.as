package app.view.page.map
{
	import app.AppSettings;
	import app.assets.Assets;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.FilterEvent;
	import app.contoller.events.InteractiveEvent;
	import app.view.baseview.io.InteractiveButton;
	import app.view.baseview.io.InteractiveChargeButton;
	import app.view.utils.Tool;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class LeftPanelMap extends Sprite
	{
		public static const BUTTONS_COUNT:int = 5;
		public static const IMPORTANT:int = 5;
		
		private var _refresh:InteractiveChargeButton;
		private var dic:Dictionary = new Dictionary();
		public var active_group_id:int = -1;
		public var active_type_id:int = -1;
		public var lastSelect:int = -1;
		private var activeSlider:int;	
		
		public var buttons:Array = [{img: "city_Icon", group: "Город", group_id: 1, group_color: 0x81b03f, type_color: 0x72a334, types: [{type: "Работа Власти", type_id: 1}, {type: "Планы", type_id: 2}, {type: "Новая Москва", type_id: 3}, {type: "Транспорт", type_id: 4}, {type: "Авто", type_id: 5}, {type: "ЖКХ", type_id: 6}, {type: "Строительство", type_id: 7}]},
			
			{img: "dtp_Icon", group: "Происшествия", group_id: 3, group_color: 0x4396c9, type_color: 0x3b8abe, types: [{type: "ДТП", type_id: 10}, {type: "ЧП", type_id: 11}, {type: "Криминал", type_id: 12}]},
			
			{img: "power_Icon", group: "Власть", group_id: 2, group_color: 0xc22b57, type_color: 0xb4244c, types: [{type: "Официальная Москва", type_id: 8}, {type: "Мэр Москвы", type_id: 9}]},
			
			{img: "dosug_Icon", group: "Досуг", group_id: 4, group_color: 0x7b699f, type_color: 0x705e92, types: [{type: "Культура", type_id: 13}, {type: "Спорт", type_id: 14}, {type: "Развлечения", type_id: 15}]},
			
			{img: "main_Icon", group: "Важное", group_id: 5, group_color: 0xaa0000}];
		
		public function LeftPanelMap()
		{
			var offset:int = 0;
			for (var i:int = 0; i < BUTTONS_COUNT; i++)
			{
				var btnBlock:ButtonBlock = new ButtonBlock(buttons[i]);
				btnBlock.y = offset;
				offset += btnBlock.height;
				addChild(btnBlock);
				dic[buttons[i].group_id] = btnBlock;
			}
			
			var refreshBtn:Sprite = Assets.create("refreshBtn");
			_refresh = new InteractiveChargeButton();
			_refresh.color = 0x02a7df;
			addChild(_refresh);
			_refresh.addChild(refreshBtn);
			
			var fon:Shape = Tool.createShape(_refresh.width, _refresh.height, 0x1a1b1f);
			fon.alpha = 0;
			_refresh.addChild(fon);
			
			_refresh.x = AppSettings.WIDTH - _refresh.width - 60;
			_refresh.y = AppSettings.HEIGHT - _refresh.height - 60;
			_refresh.name = "refresh";
			_refresh.alpha = 0;
			
			TweenLite.to(_refresh, 0.5, {alpha: 1, delay: 2.2});		
		}
		
		public function charged(e:InteractiveEvent):void
		{
			if (e.target.name == "refresh")
			{			
				for (var i:int = 1; i <= IMPORTANT; i++)
					dic[i].select = false;
				
				active_group_id = -1;
				active_type_id = -1;	
	
				dispatchEvent(new FilterEvent(FilterEvent.SET_NULL));				
				dispatchEvent(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_GEO_DATA));				
			}
		}
		
		public function push(e:InteractiveEvent):void
		{
			if (e.target is ButtonBlock)
			{
				
			}
			else if (e.target is MapButton)
			{
				
				var mapButton:MapButton = e.target as MapButton;
				dic[mapButton.group_id].close();
				selectBlock(mapButton.group_id, mapButton.type_id);
			}
			else if (e.target.name == "own")
			{
				var btn:ButtonBlock = e.target.parent as ButtonBlock;
				if (btn.group_id != IMPORTANT)
					selectBlock(btn.group_id, -1);
				else
				{
					var obj:Object = {group_id: active_group_id, type_id: active_type_id, important: !btn.select};
					var event:FilterEvent = new FilterEvent(FilterEvent.SORT_GEO_NEWS, true, false, obj);
					dispatchEvent(event);
				}	
			}
		}
		
		public function changeButtonsSorted(e:FilterEvent):void
		{
			for (var i:int = 1; i < IMPORTANT; i++)
				dic[i].select = false;
				
			active_group_id	= e.data.group_id;
			active_type_id	= e.data.type_id;			
			
			if (active_group_id != -1) dic[active_group_id].select = true;				
			dic[IMPORTANT].select = e.data.important;
		}
		
		private function selectBlock(_group_id:int, _type_id:int):void
		{	
			var obj:Object = {group_id: _group_id, type_id: _type_id, important: int(dic[IMPORTANT].select)};
			var event:FilterEvent = new FilterEvent(FilterEvent.SORT_GEO_NEWS, true, false, obj);
			dispatchEvent(event);	
		}		
			
		public function over(e:InteractiveEvent):void
		{
			if (e.target is ButtonBlock)
			{
				var btn:ButtonBlock = e.target as ButtonBlock;
				btn.open();
				activeSlider = btn.group_id;
				addEventListener(InteractiveEvent.HAND_UPDATE, checkSlider, true);
			}
			else if (e.target is MapButton)
			{
				var btnMap:MapButton = e.target as MapButton;
				btnMap.over();
				activeSlider = btnMap.group_id;
				addEventListener(InteractiveEvent.HAND_UPDATE, checkSlider, true);
			}		
		}
		
		public function out(e:InteractiveEvent):void
		{
			if (e.target is ButtonBlock)
			{
				var btn:ButtonBlock = e.target as ButtonBlock;
				btn.close();
				removeEventListener(InteractiveEvent.HAND_UPDATE, checkSlider, true);
			}
			else if (e.target is MapButton)
			{
				var btnMap:MapButton = e.target as MapButton;
				btnMap.out();
			}
		}
		
		public function checkSlider(e:InteractiveEvent):void
		{
			try
			{
				if (dic[activeSlider].slider.width < 1920 - 365)
					return;
				
				if (e.stageX > 380 && e.stageX < 750)
					dic[activeSlider].moveRight();
				
				if (e.stageX > 1500 && e.stageX < AppSettings.WIDTH)
					dic[activeSlider].moveLeft();
			}
			catch (err:Error)
			{
				
			}	
		}	
	}
}
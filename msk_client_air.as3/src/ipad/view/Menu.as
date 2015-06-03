package ipad.view 
{
	import app.contoller.events.ChangeLocationEvent;
	import app.view.utils.Tool;
	import flash.display.Shape;
	import flash.display.Sprite;
	import ipad.controller.IpadConstants;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class Menu extends Sprite
	{		
		public static const ICONS_NUM:int = 7;		
		private var activeID:int = -1;		
		private var btnsArray:Vector.<Button>;		
		
		public function Menu() 
		{
			var shape:Shape = Tool.createShape(IpadConstants.GameWidth, 290 * IpadConstants.contentScaleFactor, 0xe6e8ed);				
			addChild(shape);
			
			btnsArray = new Vector.<Button>();
			
			var offset:Number = 0;
			
			for (var i:int = 0; i < ICONS_NUM; i++) 
			{
				var btn:Button = new Button(i);
				addChild(btn);
				btn.x = offset;
				offset += btn.width;				
				btnsArray.push(btn);
			}			
		}
		public function setActiveButton(id:int):void
		{
			for (var i:int = 0; i < ICONS_NUM; i++) 			
				btnsArray[i].click(id);			
		}
		
		public function setActiveButtonByName(name:String):void
		{
			var id:int = getIdByName(name);
			for (var i:int = 0; i < ICONS_NUM; i++) 			
				btnsArray[i].click(id);			
		}
		
		public static function getIdByName(name:String):int 
		{		
			var menuItem:int = -1;
			
			switch (name)
			{
				case ChangeLocationEvent.MAIN_SCREEN: 
					menuItem = 0;
					break;
				case ChangeLocationEvent.CUSTOM_SCREEN: 
					menuItem = 1;					
					break;
				case  ChangeLocationEvent.STORY_SCREEN: 
					menuItem =2;
					break;
				case ChangeLocationEvent.NEWS_PAGE_DAY:
				case ChangeLocationEvent.NEWS_PAGE_HOUR:
				case ChangeLocationEvent.ONE_NEW_PAGE:
					menuItem = 3;
					break;
				case ChangeLocationEvent.FACT_PAGE:
				case ChangeLocationEvent.ONE_NEW_FACT_PAGE:		
					menuItem = 4;
					break;
				case ChangeLocationEvent.MAP_PAGE: 
					menuItem = 5;
					break;
				case ChangeLocationEvent.BROADCAST_PAGE: 
					menuItem = 6;
					break;
				default: 
			}	
			return menuItem;
		}
		
		
		public static function getNameById(id:int):String
		{
			var menuItem:String = "";
			
			switch (id)
			{
				case 0: 
					menuItem = ChangeLocationEvent.MAIN_SCREEN;
					break;
				case 1: 
					menuItem = ChangeLocationEvent.CUSTOM_SCREEN;					
					break;
				case 2: 
					menuItem = ChangeLocationEvent.STORY_SCREEN;
					break;
				case 3: 
					menuItem = ChangeLocationEvent.NEWS_PAGE_DAY;
					break;
				case 4: 
					menuItem = ChangeLocationEvent.FACT_PAGE;
					break;
				case 5: 
					menuItem = ChangeLocationEvent.MAP_PAGE;
					break;
				case 6: 
					menuItem = ChangeLocationEvent.BROADCAST_PAGE;
					break;
				default: 
			}
			
			return menuItem;
		}
		
		
		
	}

}
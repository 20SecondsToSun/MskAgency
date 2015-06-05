package app.model.config
{
	import app.assets.Assets;
	import app.contoller.events.DataChangedEvent;
	import app.model.StringVO;
	import app.services.state.INavigationService;
	import app.view.utils.TextUtil;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class Config extends Actor implements IConfig
	{
		protected var _currentScreen:String = "MAIN_SCREEN";
		protected var _currentLocation:String = "";
		protected var _currentDate:String = "21.09.2003";
		protected var __currentDate:Date;
		protected var _previousDate:String = "21.09.2003";
		protected var _nextDate:String = "21.09.2003";
		public static const rubrics:Array = [{name: "Общество", id: "7"}, {name: "Политика", id: "5"}, {name: "Экономика", id: "3"}, {name: "Происшествия", id: "11"}, {name: "Культура", id: "10"}, {name: "Спорт", id: "9"}];
		public static const mapRrubrics:Array = [{name: "Город", id: "01", group_id: 1}, {name: "Происшествия", id: "02", group_id: 3}, {name: "Власть", id: "03", group_id: 2}, {name: "Досуг", id: "04", group_id: 4}, {name: "Важное", id: "05", group_id: 5}];
		
		public function Config()
		{
			var curDate:Date = new Date();
			__currentDate = curDate;
			_currentDate = TextUtil.getFormatDatePubl(curDate);
			
			TextUtil.currentDate = __currentDate;
		}
		
		public function init(initDate:Date):void
		{
			var curDate:Date = initDate;
			__currentDate = curDate;
			_currentDate = TextUtil.getFormatDatePubl(curDate);
			
			TextUtil.currentDate = __currentDate;
			
			var date2:Date = new Date(curDate.fullYear, curDate.getMonth(), curDate.getDate(), curDate.getHours(), curDate.getMinutes(), curDate.getSeconds(), curDate.getMilliseconds());
			
			date2.date += 1;
			date2.setHours(0, 0, 0);
			
			var millisecondDifference:int = date2.valueOf() - curDate.valueOf();
			var seconds:int = millisecondDifference / 1000 + 1;
			
			TweenLite.delayedCall(seconds, reloadDayChanges);
		}
		
		private function reloadDayChanges():void
		{
			__currentDate.date += 1;
			init(__currentDate);
			dispatch(new DataChangedEvent(DataChangedEvent.DATA_CHANGED));
		}
		
		public function get currentLocation():String
		{
			return _currentLocation;
		}
		
		public function set currentLocation(value:String):void
		{
			_currentLocation = value;
		}
		
		public function get currentScreen():String
		{
			return _currentScreen;
		}
		
		public function set currentScreen(value:String):void
		{
			_currentScreen = value;
		}
		
		public function get currentDate():String
		{
			return _currentDate;
		}
		
		public function set currentDate(value:String):void
		{
			_currentDate = value;
		}
		
		public function get previousDate():String
		{
			var prev:Date = new Date(__currentDate.fullYear, __currentDate.getMonth(), __currentDate.getDate());
			prev.date -= 1;
			return TextUtil.getFormatDatePubl(prev);
		}
		
		public function set previousDate(value:String):void
		{
			_previousDate = value;
		}
		
		public function get nextDate():String
		{
			var prev:Date = new Date(__currentDate.fullYear, __currentDate.getMonth(), __currentDate.getDate());
			prev.date += 1;
			return TextUtil.getFormatDatePubl(prev);
		}
		
		public function getShiftDate(value:int):String
		{
			var date:Date = new Date(__currentDate.fullYear, __currentDate.getMonth(), __currentDate.getDate());
			date.date += value;
			return TextUtil.getFormatDatePubl(date);
		}
		
		public function getprevDate(value:Date):String
		{
			var date:Date = new Date(value.fullYear, value.getMonth(), value.getDate());
			date.date -= 1;
			return TextUtil.getFormatDatePubl(date);
		}
		
		public function getnextDate(value:Date):String
		{
			var date:Date = new Date(value.fullYear, value.getMonth(), value.getDate());
			date.date += 1;
			return TextUtil.getFormatDatePubl(date);
		}
		
		public function compareDate(value:String):String
		{
			var dateArr:Array = value.split(".");
			var date:Date = new Date(dateArr[2], dateArr[1] - 1, dateArr[0]);
			
			date.setHours(0, 0, 0, 0);
			__currentDate.setHours(0, 0, 0, 0);
			
			if (date > __currentDate) return "FUTURE";
			if (date < __currentDate) return "PAST";
			
			return "CURRENT";
		}
		
		public function set nextDate(value:String):void
		{
			_nextDate = value;
		}
	}
}
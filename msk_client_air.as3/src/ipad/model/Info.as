package ipad.model
{
	import app.model.materials.MaterialModel;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class Info  implements IInfo
	{		
		protected var _primaryScreen:String =  "CUSTOM_SCREEN";
		protected var _customScreenRubric:Object;
		protected var _isKinectUser:Boolean = false;
		protected var _isHandActive:Boolean = false;
		protected var _playState:Boolean  = true;
		protected var _volume:Number  = 0.8;
		
		
		public function get volume():Number
		{
			return _volume;
		}
		
		public function set volume(value:Number):void
		{
			_volume = value;
		}	
		
		public function get primaryScreen():String
		{
			return _primaryScreen;
		}
		
		public function set primaryScreen(value:String):void
		{
			_primaryScreen = value;
		}		
		
		public function get customScreenRubric():Object
		{
			return _customScreenRubric;
		}
		
		public function set customScreenRubric(value:Object):void
		{
			_customScreenRubric = value;
		}
		
		public function get isKinectUser():Boolean
		{
			return _isKinectUser;
		}
		
		public function set isKinectUser(value:Boolean):void
		{
			_isKinectUser = value;
		}
		
		public function get isHandActive():Boolean
		{
			return _isHandActive;
		}
		
		public function set isHandActive(value:Boolean):void
		{
			_isHandActive = value;
		}
		
		public function get playState():Boolean
		{
			return _playState;
		}
		
		public function set playState(value:Boolean):void
		{
			_playState = value;
		}
	}
}
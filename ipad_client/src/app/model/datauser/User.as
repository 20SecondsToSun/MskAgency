package app.model.datauser 
{
	import app.contoller.events.ChangeLocationEvent;
	import app.model.config.IConfig;
	import app.model.materials.Filters;
	import flash.media.VideoStatus;
	import flash.utils.Dictionary;
	import org.robotlegs.mvcs.Actor;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class User extends Actor implements IUser
	{		
		[Inject]
		public var config:IConfig;	
		
		protected var _name:String;
		protected var _id:String;
		protected var _login:String;
		protected var _role_id:String;		
		protected var _password:String;		
		protected var _permissions:Vector.<String> = new Vector.<String>;	
		protected var _is_active:Boolean = false;
		
		protected var _isHandActive:Boolean = false;
		protected var _ipadTryingToConnect:Boolean = false;		
		protected var _stendID:String = "12";
		protected var _idIpad:String = "";		
		protected var _primaryScreen:String = ChangeLocationEvent.MAIN_SCREEN;		
		protected var userFilters:Filters = new Filters();		
		protected var screenFilters:Filters = new Filters();		
		
		public function get ipadTryingToConnect():Boolean
        {
            return _ipadTryingToConnect;
        }
		
        public function set ipadTryingToConnect(value:Boolean):void
        {
            _ipadTryingToConnect = value;
        }		
		
		public function get idIpad():String
        {
            return _idIpad;
        }
        public function set idIpad(value:String):void
        {
            _idIpad = value;
        }
		
		public function get stendID():String
        {
            return _stendID;
        }
        public function set stendID(value:String):void
        {
            _stendID = value;
        }
		
		public function get password():String
        {
            return _password;
        }
        public function set password(value:String):void
        {
            _password = value;
        }
		
		public function User()
        {			
			removeAllUserFilters();		//	[7, 5, 9, 10, 11, 3];		
			addUserFilter("rubric", "3");// "7");				
		}
		
		public function get isHandActive():Boolean
        {
            return _isHandActive;
        }

        public function set isHandActive(value:Boolean):void
        {
            _isHandActive = value;
        }
		
		
		public function get is_active():Boolean
        {
            return _is_active;
        }

        public function set is_active(value:Boolean):void
        {
            _is_active = value;
        }		
	
		public function get name():String
        {
            return _name;
        }

        public function set name(value:String):void
        {
            _name = value;
        }
		
		public function get id():String
        {
            return _id;
        }

        public function set id(value:String):void
        {			
            _id = value;
        }
		
		public function get login():String
        {
            return _login;
        }

        public function set login(value:String):void
        {
            _login = value;
        }
		public function get role_id():String
        {
            return _role_id;
        }

        public function set role_id(value:String):void
        {
            _role_id = value;
        }
		
		public function get permissions():Vector.<String>
        {
            return _permissions;
        }

        public function set permissions(value:Vector.<String>):void
        {
            _permissions = value;
        }		
		
		public function set primaryScreen(value:String):void
		{
			_primaryScreen = value;
		}
		public function get primaryScreen():String
		{
			return _primaryScreen;
		}
		
		
		public function getRubric():Object
		{
			return { name:"some", id:userFilters.rubric } ;
		}
		
		public function getfilters():Filters
		{
			if ( config.currentScreen == "MAIN_SCREEN")
				return screenFilters;
				
			return userFilters;
		}
		
		public function addUserFilter(name:String, value:String):void
		{
			userFilters.addFilter(name, value);
		}
		
		public function removeUserFilter(name:String):void
		{
			userFilters.removeFilter(name);
		}
		
		public function removeAllUserFilters():void
		{
			userFilters.removeAllFilters();
		}
		
		public function addScreenFilter(name:String, value:String):void
		{
			screenFilters.addFilter(name, value);
		}
		
		public function removeScreenFilter(name:String):void
		{
			screenFilters.removeFilter(name);
		}
		
		public function removeAllScreenFilters():void
		{
			screenFilters.removeAllFilters();
		}			
	}
}
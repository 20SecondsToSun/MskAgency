package app.contoller.events
{

    import flash.events.Event;

    public class AuthenticationEvent extends Event
    {

        public static const AUTH_SUCCESS:String = "AuthenticationEvent.AUTH_SUCCESS";
        public static const AUTH_FAILED:String = "AuthenticationEvent.AUTH_FAILED";
  
        /**
         *    @constructor
         */
        public function AuthenticationEvent(type:String)
        {
            super(type);
        }

        override public function clone():Event
        {
            return new AuthenticationEvent(type);
        }

    }
}

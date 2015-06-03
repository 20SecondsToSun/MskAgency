package app.contoller.commadns
{
   
	import app.services.auth.IAuthService;
	import org.robotlegs.mvcs.Command;

    public class AuthenticationDataCommand extends Command
    {		
        [Inject]
        public var authService:IAuthService;
		
		
		
        override public function execute():void
        {			
			authService.start();		
        }
    }
}
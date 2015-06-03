package app.services.dataloading 
{
	public interface ISocketService
    {
        function start():void;
        function stop():void;
        function resume():void;
	}

}
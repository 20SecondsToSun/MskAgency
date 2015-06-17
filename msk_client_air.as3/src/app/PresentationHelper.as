package app 
{
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class PresentationHelper 
	{		
		public static var num :int 	=  0;
		
		public static function getNum(): int 
		{
			num++;
			if (num > 30) num = 1;
			return num;
		}		
	}
}
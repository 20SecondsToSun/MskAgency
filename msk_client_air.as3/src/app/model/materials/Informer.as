package app.model.materials 
{
	import app.contoller.commadns.StopInteractiveCommand;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class Informer 
	{
		public var eur_current:String;
		public var usd_current:String;
		public var usd_change:String;
		public var eur_change:String;
		
		public var probki_city:int;	
		
		public var arr:Array = ["Дороги свободны", 
								"Дороги почти свободны", 
								"Местами затруднения",
								"Местами затруднения",
								"Движение плотное", 
								"Движение затруднено",
								"Серьезные пробки",
								"Многокилометровые пробки",
								"Город стоит",
								"Пешком быстрее",
								];
		
		public function getRoadText():String 
		{
			if (probki_city == 0 ) return arr[0];
			else if (probki_city >= arr.length ) return arr[arr.length - 1];			
			else return arr[probki_city - 1];
			
			return "";
		}
		public function getBallText():String 
		{
			if (probki_city == 0 || probki_city == 5 || probki_city == 6 || probki_city == 7 || probki_city == 8 || probki_city == 9) return probki_city.toString() + " баллов";
			else if(probki_city == 1) return probki_city.toString() + " балл";
			else if (probki_city == 2 || probki_city == 3 || probki_city == 4) return probki_city.toString() + " балла";
			
			return "";
		}
		public function getUsdChangeImg():String 
		{
			if (int(usd_change) < 0) return "__down";
			else  return "__top";
		}
		
		public function getEuroChangeImg():String 
		{
			if (int(usd_change) < 0) return "__down";
			else  return "__top";
		}
		
		public function geImage():String 
		{
			if (probki_city < 3) return "probki1";
			else if (probki_city <= 6) return "probki2";
			else return "probki3";
		}
	}

}
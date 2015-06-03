package app.contoller.constants
{
	/**
	 * ...
	 * @author metalcorehero
	 */
	import com.greensock.easing.Ease;
	
	public class Anim
	{
		public var animInSpeed:Number;
		public var animOutSpeed:Number;
		
		public var animInEase:Ease;
		public var animOutEase:Ease;
		
		public function Anim(isp:Number, osp:Number, iea:Ease, oea:Ease):void
		{
			animInSpeed = isp;
			animOutSpeed = osp;
			
			animInEase = iea;
			animOutEase = oea;
		}
	
	}
}
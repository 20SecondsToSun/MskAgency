package app.model.materials
{
	import flash.display.Bitmap;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class MaterialFile
	{
		public var thumbnail:String;
		public var name:String;
		public var duration:String;
		public var author:String;
		public var type:String;
		public var id:Number;
		public var description:String;
		public var host:String;
		public var previewBitmap:Bitmap;
		public var fullsizeBitmap:Bitmap;
		public var pathToSource:String;
		public var pathToSource1:String;
		public var pathToSource2:String;
		public var thumbPath:String;
		
		public function getPathToSourceWithScale(scale:Number):String
		{
			return pathToSource1 + scale.toString() + pathToSource2;
		}
	}
}
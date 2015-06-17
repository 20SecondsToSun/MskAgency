package app.view.mainnew.types 
{
	import app.assets.Assets;
	import app.model.materials.Material;
	import app.model.materials.MaterialFile;
	import app.view.baseview.io.InteractiveButton;
	import app.view.baseview.io.InteractiveObject;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class MainType extends InteractiveButton
	{
		protected static const WIDTH:int = 690;
		protected static const HEIGHT:int = 500;
		protected static const FRAME_SIZE:int = 17;
		
		protected var important:Sprite = new Sprite();
		
		private var _great:Boolean = false;
		
		public var mat:Material;
		public var color:uint = 0xf4f4f4;	

		public function MainType()
		{		
			createFrame();
		}		
		
		override public function getSelfRec():Rectangle
		{	
			return new Rectangle(410, 0, WIDTH, HEIGHT);	
		}
		
		public function show(mat:Material):void
		{
			
		}
		
		public function set great(value:Boolean):void 
		{

		}
		
		public function get great():Boolean 
		{
			return _great;
		}
	
		protected function createFrame():void 
		{		
			var frameWidth:int = FRAME_SIZE;
			var frameHeight:int = FRAME_SIZE;
			var s1:Shape = Tool.createShape(WIDTH, frameHeight, 0xffdd1d);
			important.addChild(s1);
			
			var s2:Shape = Tool.createShape(WIDTH, frameHeight, 0xffdd1d);
			s2.y = HEIGHT - frameHeight;
			important.addChild(s2);
			
			var s3:Shape = Tool.createShape(frameWidth, HEIGHT, 0xffdd1d);
			important.addChild(s3);			
			
			var s4:Shape = Tool.createShape(frameWidth, HEIGHT, 0xffdd1d);
			s4.x = WIDTH - frameWidth;
			important.addChild(s4);
			
			addChild(important);	
			important.visible = false;					
		}		
		
		public function over():void
		{
			TweenLite.delayedCall(0.3, readyToOver);	
		}
		
		public function out():void
		{
			TweenLite.killDelayedCallsTo( readyToOver);
			TweenLite.to(this, 0.5, { y: 0 , ease:Cubic.easeInOut } );		
		}	
		
		public function readyToOver():void 
		{
			if(this)
			TweenLite.to(this, 0.5, { y: -77 , ease:Cubic.easeInOut} );
		}
		
		public function addFooter():void 
		{
			var footer:Shape = Tool.createShape(this.width, 77, 0x02a7df);
			footer.y = 500;			
			addChild(footer);
			
			var icon:Sprite = Assets.create("readOver");
			addChild(icon);
			icon.y = 0.5 * (77 - icon.height) + 500;
			icon.x = 0.5 * (77 - icon.height);
			
			var textFormat:TextFormat = new TextFormat("Tornado", 16, 0Xffffff);
			
			var watch:TextField = TextUtil.createTextField(0, 0);				
			watch.text = "ЧИТАТЬ НОВОСТЬ";			
			watch.setTextFormat(textFormat);
			
			watch.y = 0.5 * (77 - watch.height) + 500;
			watch.x = icon.x + icon.width +15;
			addChild(watch);			
		}
		
		public function stop():void
		{
			
		}	
		
		public function kill():void
		{
			
		}
	}
}
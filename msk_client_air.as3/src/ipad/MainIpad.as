package ipad
{
	import app.services.ipad.IpadConnector;
	import app.view.utils.TextUtil;
	import flash.desktop.NativeApplication;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.StageOrientationEvent;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import starling.core.Starling;
	/**
	 * ...
	 * @author ...
	 */
	[SWF(backgroundColor="#ffffff",width="1024",height="768",frameRate="60")]
	
	public class MainIpad extends Sprite
	{
		private var mStarling:Starling;
		
		public function MainIpad()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			var myOS:String = Capabilities.os;
			var myOSLowerCase:String = myOS.toLowerCase();
			
			if (myOSLowerCase.indexOf("ipad3,", 0) >= 0)
			{
				Constants.IPAD_V = 3;
				Constants.GameHeight = 1536;
				Constants.GameWidth = 2048;
			}
			else if (myOSLowerCase.indexOf("ipad2,", 0) >= 0)
			{
				Constants.IPAD_V = 2;
				Constants.GameHeight = 768;
				Constants.GameWidth = 1024;
			}
			else
			{
				Constants.IPAD_V = 1;
				Constants.GameHeight = 768;
				Constants.GameWidth = 1024;
			}
			
			Constants.IPAD_V = 1;
			//Constants.GameHeight = 1536;
			//Constants.GameWidth = 2048;
			
			Starling.multitouchEnabled = false; // useful on mobile devices
			Starling.handleLostContext = false; // deactivate on mobile devices (to save memory)  	
			
			mStarling = new Starling(App, stage);
			mStarling.simulateMultitouch = true;
			mStarling.enableErrorChecking = false;
			mStarling.start();
			
			mStarling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
			
			var startOrientation:String = stage.orientation;
			if (startOrientation == StageOrientation.DEFAULT || startOrientation == StageOrientation.UPSIDE_DOWN)
				stage.setOrientation(StageOrientation.ROTATED_RIGHT);
			else
				stage.setOrientation(startOrientation);
			
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGING, orientationChangeListener);
			
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExit);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//addEventListener(Event.DEACTIVATE, saveConfigs);
		}
		
		private function onExit(e:Event):void
		{
		
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//splash = new AssetEmbeds_1x.Preloader();
			//addChild(splash);
		}
		
		private function orientationChangeListener(e:StageOrientationEvent):void
		{
			if (e.afterOrientation == StageOrientation.DEFAULT || e.afterOrientation == StageOrientation.UPSIDE_DOWN)
				e.preventDefault();
		}
		
		private function onContextCreated(event:Event):void
		{
			///removeChild(splash);			
			
			if (Starling.context.driverInfo.toLowerCase().indexOf("software") != -1)
				Starling.current.nativeStage.frameRate = 30;
		}
	}

}
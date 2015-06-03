package app.view.facts
{
	import app.AppSettings;
	import app.assets.Assets;
	import app.contoller.events.AnimationEvent;
	import app.contoller.events.DataLoadServiceEvent;
	import app.contoller.events.SliderEvent;
	import app.model.datafact.DateInfo;
	import app.model.materials.Fact;
	import app.model.types.AnimationType;
	import app.view.baseview.MainScreenView;
	import app.view.utils.Tool;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class Facts extends MainScreenView
	{
		private static var START_Y:int = -1011;
		private static var WIDTH:int = 410;
		private static var HEIGHT:int = 500;
		
		private var factsGraphicList:Vector.<FactsGraphic>;
		private var slider:FactsSlider;
		private var splash:Shape;
		
		private var yellowLine:Shape;
		private var factBackground:Sprite;
		private var billet:Shape;
		
		private var factList:Vector.<Fact>;
		private var factAnimator:FactAnimator;
		
		private var isInitPosition:Boolean = true;
		private var initScreenShot:Sprite;
		
		public function Facts()
		{
			factBackground = Assets.create("eventsBckrng");
			factBackground.x = AppSettings.WIDTH - WIDTH;
			addChild(factBackground);
			
			visible = false;
			
			slider = new FactsSlider(); // new Rectangle(0, 0, AppSettings.WIDTH, 500));
			addChild(slider);
			
			addYellowLine();
		}
		
		public function setScreenShot():void
		{
			if (factsGraphicList && factsGraphicList.length)
			{
				var bitmapData:BitmapData = new BitmapData(WIDTH, HEIGHT);
				/*var mat:Matrix = new Matrix();
				mat.translate(-AppSettings.WIDTH + WIDTH, 0);
				mat.identity();*/
				bitmapData.drawWithQuality(factsGraphicList[0], null, null, null, null, true, StageQuality.BEST);
				config.setScreenShot(new Bitmap(bitmapData), "FACT_NEWS");
			}		
		}
		
		override public function setScreen():void
		{
			initScreenShot = config.getScreenShot("FACT_NEWS");
			initScreenShot.visible = true;
			addChild(initScreenShot);
			initScreenShot.x = AppSettings.WIDTH - WIDTH;
			visible = true;
		}
		
		public function refreshData(matList:Vector.<Fact>, info:DateInfo, currScreen:String, notema:Boolean = false):void
		{
			if (isListNull(matList))
				return;
			
			factsGraphicList = new Vector.<FactsGraphic>();
			
			factList = matList.reverse();
			if (!isInitPosition)
				slider.initFactSliderPosition();
			slider.clearSlider();
			
			var len:int = factList.length > 10?10:factList.length;
			
			for (var i:int = 0; i < len; i++)
			{
				var oneFactGraphic:FactsGraphic;
				
				if (i == factList.length - 1)
					oneFactGraphic = new FactsGraphic(i, factList[i], null, currScreen, notema);
				else
					oneFactGraphic = new FactsGraphic(i, factList[i], factList[i + 1], currScreen, notema);
				oneFactGraphic.currentDate = info.currentDate;
				i++;
				factsGraphicList.push(oneFactGraphic);
			}
			
			slider.init(factsGraphicList);
			slider.startInteraction();
			
			if (factBackground && contains(factBackground))
				removeChild(factBackground);
			if (initScreenShot && contains(initScreenShot))
				removeChild(initScreenShot);
			
			waitToAnim();
		}
		
		private function addYellowLine():void
		{
			yellowLine = Tool.createShape(17, 500, 0xffdd1d);
			yellowLine.x = 0;
			yellowLine.visible = false;
			addChild(yellowLine);
		}
		
		public function hideYellowLine(e:SliderEvent):void
		{
			yellowLine.visible = false;
			isInitPosition = true;
		}
		
		public function showYellowLine(e:SliderEvent):void
		{
			yellowLine.visible = true;
			isInitPosition = false;
		}
		
		public function toMainScreen():void
		{
			y = 0; //START_Y;
			visible = true;
			animateToXY(0, 0, anim.MainScreen1.animInSpeed, anim.MainScreen1.animInEase);
		}
		
		public function show():void
		{
			visible = true;
			y = 0;
			dispatchEvent(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_FACTS_DATA));
		}
		
		override protected function startAutoAnimation():void
		{
			if (isListNull(factList))
				return;
			if (factList.length < 2 || !isAllowAnimation)
				return;
			
			if (!isInitPosition)
				slider.initFactSliderPosition(startFactAutoAnimation);
			else
				startFactAutoAnimation();
		}
		
		private function startFactAutoAnimation():void
		{
			if (isAutoAnimation)
				return;
			isAutoAnimation = true;
			
			factAnimator = new FactAnimator(factsGraphicList);
			addChild(factAnimator);
		}
		
		override public function stopAutoAnimation():void
		{
			isAutoAnimation = false;
			
			if (factAnimator && contains(factAnimator))
				removeChild(factAnimator);
		}
		
		override public function animationInFinished():void
		{
			slider.startInteraction();
			dispatchEvent(new DataLoadServiceEvent(DataLoadServiceEvent.LOAD_FACTS_DATA));
			dispatchEvent(new AnimationEvent(AnimationEvent.FACTS_ANIMATION_FINISHED, AnimationType.IN, this));
		}
		
		override public function animationOutFinished():void
		{
			dispatchEvent(new AnimationEvent(AnimationEvent.FACTS_ANIMATION_FINISHED, AnimationType.OUT, this));
		}
		
		override public function kill():void
		{
			super.kill();
			
			if (factAnimator && contains(factAnimator))
				removeChild(factAnimator);
		}
	}
}
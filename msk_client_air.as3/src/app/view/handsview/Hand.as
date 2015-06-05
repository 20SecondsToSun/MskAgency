package app.view.handsview
{
	import app.assets.Assets;
	import app.contoller.bootstraps.BootstrapClasses;
	import app.services.interactive.gestureDetector.GestureEvent;
	import app.view.utils.DrawingShapes;
	import app.view.utils.Tool;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.CapsStyle;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class Hand extends Sprite
	{
		private var hand:Sprite;
		private var openHand:Sprite;
		private var maskHand:Sprite;
		private var openHand_coutur:Sprite;
		private var closeHand:Sprite;
		private var fingerHand:Sprite;
		
		public var X:Number;
		public var Y:Number;		
		public var _z:Number;
		
		private var fingerMode:Boolean = false;
		private var fingerState:String = "";
		private var fingerHand1:Sprite = Assets.create("finger1");
		private var fingerHand2:Sprite = Assets.create("finger2");
		private var fingerHand3:Sprite = Assets.create("finger3");
		private var fingerType:String;
		private var fingerPercent:Number = 0;
		
		public var _handType:String;
		private var _isTracked:Boolean;
		
		private var progressClip:Sprite;
		private var point:Point = new Point(0, 0);
		
		private var fill:Shape = Tool.createShape(125, 137, 0xc22b57);
		private var tween:TweenMax = new TweenMax(this, 0.2, {colorTransform: {tint: 0xff0000, tintAmount: 0}});
		private var tween_blue:TweenMax = new TweenMax(fill, 0.2, {height: 0, y: 0});
		
		private var saveX:Number;
		private var saveY:Number;
		
		private var endDegree:Number = 0;
		
		public function Hand()
		{
			hand = new Sprite();
			hand.scaleX = 0.6;
			hand.scaleY = 0.6;
			addChild(hand); 			
			
			progressClip = new Sprite();
			addChild(progressClip);
			var progressClipfon:Shape = Tool.createShape(150, 150, 0xffffff);
			progressClipfon.alpha = 0;
			progressClip.addChild(progressClipfon);
		
			point = new Point(0, 0);			
			visible = false;
			
			hand.x = 40;// 0.5 * (progressClipfon.width) - hand.width * hand.scaleX;
			hand.y = 35;// 0.5 * (progressClipfon.height) - hand.height * hand.scaleY;
		}
		
		public function fingerUpdate(state:String, type:String):void
		{
			if (state == "INTERRUPT")
			{
				stopFillFinger();				
				return;
			}
			if (fingerMode == true)
				return;
			switch (type)
			{
				case "HAND_ONE_FINGER": 
					if (fingerState == "HAND_ONE_FINGER")
						return;					
					clear();
					hand.addChild(fingerHand1);;
					beignFillFinger();
					break;
					
				case "HAND_TWO_FINGERS":					
					if (fingerState == "HAND_TWO_FINGERS")
						return;
					
					clear();
					hand.addChild(fingerHand2);					
					beignFillFinger();
					break;
					
				case "HAND_THREE_FINGERS": 
					if (fingerState == "HAND_THREE_FINGERS")
						return;				
					clear();
					hand.addChild(fingerHand3);				
					beignFillFinger();
					break;
			}
			fingerType = type;
			fingerState = state;
			fingerMode = true;		
		}
		
		private function stopFillFinger():void 
		{	
			dispatchEvent(new GestureEvent(GestureEvent.FINGER_FAILED));
			fingerShowFinished();
		}
		
		private function beignFillFinger():void 
		{
			//TweenLite.to(hand, 0.5, { removeTint:true } );
			//TweenLite.to(hand, 1, { colorTransform: { tint:0xff0000, tintAmount:1 }, onComplete:fingerShowFinished }	);
			fingerPercent = 0;
			addEventListener(Event.ENTER_FRAME, fillFinger);			
		}
		
		public function changeColor():void
		{
			
		}
		
		private function fillFinger(e:Event):void 
		{
			progressClip.graphics.clear();		
			endDegree = 360 * fingerPercent * 0.01;			
			progressClip.graphics.lineStyle(5, 0xb4244c, 1, false, "normal", CapsStyle.NONE);
			point = DrawingShapes.drawArc(progressClip.graphics,145, 75, 70, endDegree, 0, 70);
			
			if (endDegree == 360)		
			{			
				dispatchEvent(new GestureEvent(fingerType));
				fingerShowFinished();
				progressClip.graphics.clear();
			}
			fingerPercent++;
		}
		
		private function fingerShowFinished():void 
		{
			removeEventListener(Event.ENTER_FRAME, fillFinger);	
			progressClip.graphics.clear();		
			//TweenLite.to(hand, 0.5, { removeTint:true } );			
			
			//trace("DONE!!!!!!!");
			open();
			fingerMode = false;
			fingerState = "";
		}	
		
		public function set isTracked(track:Boolean):void
		{
			_isTracked = track;
			if (!_isTracked)
				hide();
		}
		
		public function get isTracked():Boolean
		{
			return _isTracked;
		}
		
		public function get handType():String
		{
			return _handType;
		}
		
		public function set handType(ht:String):void
		{			
			_handType = ht;
		
			if (_handType == HandType.NONE)
			{
				clear();
				return;
			}
			if (_handType == HandType.LEFT)
			{
				openHand = Assets.create("leftHand");
				maskHand = Assets.create("leftHand");
				openHand_coutur = Assets.create("left_countur");
				closeHand = Assets.create("leftHandClose");
			}
			else if (_handType == HandType.RIGHT)
			{				
				openHand = Assets.create("rightHand");
				maskHand = Assets.create("rightHand");
				openHand_coutur = Assets.create("right_countur");
				closeHand = Assets.create("rightHandClose");
			}
			//if (fingerState != "") return;
			
			clear();			
			hand.addChild(openHand_coutur);
			openHand_coutur.x = -5;
			openHand_coutur.y = -5;
			hand.addChild(openHand);
			hand.addChild(fill);
			hand.addChild(maskHand);
			
			maskHand.cacheAsBitmap = true;
			fill.cacheAsBitmap = true;
			
			fill.mask = maskHand;			
		}		
		
		public function pushProgressCircle(percent:Number, color:uint):void
		{		
			progressClip.graphics.clear();		
			endDegree = 360 * percent * 0.01;			
			progressClip.graphics.lineStyle(5, color, 0.5, false, "normal", CapsStyle.NONE);			
			point = DrawingShapes.drawArc(progressClip.graphics, 145, 75, 70, endDegree, 0, 70);			
			
			if (endDegree >= 360)			
				progressClip.graphics.clear();			
		}	
		
		public function pushProgress(percent:Number):void
		{
			var per:Number = percent / 100;
			
			if (percent < 100)
			{
				//tween.updateTo( { colorTransform: { tint:0xff0000, tintAmount:percent / 100 }}, false	);	
				if(openHand)
				tween_blue.updateTo({height: openHand.height * per, y: openHand.height * (1 - per)}, false);				
				//TweenMax.to(this, 0.2, {colorTransform:{tint:0xff0000, tintAmount:percent/100}});
			}
			else if (percent >= 100 && percent < 120)			
			{
				saveX = x;
				saveY = y;
				
				Tool.changecolor(fill, 0x02a7df);
				
				fill.y = 0;
				fill.height = openHand.height;
				
				var scalePer:Number = (percent - 100) / 100;
				
				TweenMax.to(this, 0.2, { scaleX:1 - scalePer, scaleY:1 - scalePer } );				
				//TweenMax.to(this, 0.2, { delay:0.4, scaleX:1, scaleY:1, x:saveX, y:saveY } );				
				//tween_blue.updateTo( { height: openHand.height , y: openHand.height*0  }, false);
				
				
				//TweenMax.to(this, 0.2, {colorTransform:{tint:0xff0000, tintAmount:100},onComplete:initHand});
			}
			else if (percent == 200 )			
			{
				fill.y = 0;
				fill.height = 0;
				Tool.changecolor(fill, 0xc22b57);
				TweenMax.to(this, 0.2, { scaleX:1, scaleY:1 } );
			}
		}
		
		private function initHand():void
		{
			TweenMax.to(this, 0.8, {colorTransform: {tint: 0xff0000, tintAmount: 0}});
		}
		
		public function show():void
		{			
			visible = _handType != HandType.NONE;
		}
		
		public function hide():void
		{
			x = - 100;
			y = - 100;
			visible = false;
		}
		
		public function open():void
		{			
			clear();
			if (_handType == HandType.NONE)
				return;
			
			hand.addChild(openHand_coutur);
			hand.addChild(openHand);
			openHand_coutur.x = -5;
			openHand_coutur.y = -5;
			
			hand.addChild(fill);
			hand.addChild(maskHand);
			
			maskHand.cacheAsBitmap = true;
			fill.cacheAsBitmap = true;
			
			fill.mask = maskHand;
			fill.height = 0.1;
			fill.y = openHand.height;		
		}
		
		public function close():void
		{
			clear();
			if (_handType != HandType.NONE)				
				hand.addChild(closeHand);		
		}
		
		public function clear():void
		{			
			hand.removeChildren();
			progressClip.graphics.clear();
		}
	}
}
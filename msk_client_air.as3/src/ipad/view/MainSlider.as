package ipad.view
{
	import app.contoller.events.IpadEvent;
	import app.model.materials.Fact;
	import app.model.materials.Filters;
	import app.model.materials.Material;
	import app.services.interactive.gestureDetector.HandSpeed;
	import app.view.utils.TextUtil;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.engine.ElementFormat;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ipad.view.slider.ElementFact;
	import ipad.view.slider.Slider;
	import app.view.utils.Tool;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import ipad.controller.IpadConstants;
	import ipad.view.slider.Element;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class MainSlider extends Sprite
	{
		public var slider:Slider;
		
		private var _width:int = 628;
		private var _height:int = 415;
		
		private var spriteDrag:Sprite;
		private var startY:Number = 0;
		private var startTime:Number = 0;
		private var activeElement:*;
		private var activeObj:*;
		public var _filters:Filters = new Filters();
		public var isNeedToClear:Boolean = true;
		private var textFormat:TextFormat = new TextFormat("TornadoL", 30 * IpadConstants.contentScaleFactor, 0X828696);
		
		private var mainTitle:TextField;
		private var offset:Number = 20;
		private var lastIndex:int = 0;
		
		private var candidate:*;
		private var saveCoords:Point;
		private var candidateOk:Boolean = false;
		
		public var type:String;
		public var showingMat:*;
		public var oneLoadCounter:int = 0;
		public var line:Shape;
		public function MainSlider(_type:String = "main")
		{
			type = _type;
			y = 300 * IpadConstants.contentScaleFactor;
			_width = _width * IpadConstants.contentScaleFactor;
			_height = _height * IpadConstants.contentScaleFactor;
			
			slider = new Slider(new Rectangle(0, 0, IpadConstants.GameWidth, IpadConstants.GameHeight - 270));
			addChild(slider);
			
			spriteDrag = new Sprite();
			addChild(spriteDrag);
			
			_filters.limit = 20;
			_filters.offset = 0;
			
			if (type == "fact")
			{
				y = 304 * IpadConstants.contentScaleFactor;
				textFormat.color = 0x9dcb8d;
				line = new Shape();
				line.graphics.lineStyle(1, 0xffffff, .55);
				line.graphics.moveTo(0, 0.5 * 958 * IpadConstants.contentScaleFactor);
				line.graphics.lineTo(IpadConstants.GameWidth, 0.5 * 958 * IpadConstants.contentScaleFactor);
				line.alpha = 0.4;
				slider.addChild(line);
				line.visible = false;
				
				
			}
			
			mainTitle = TextUtil.createTextField(0, 0);
			mainTitle.text = "ПО ВАШЕМУ ЗАПРОСУ НИЧЕГО НЕ НАЙДЕНО";
			mainTitle.setTextFormat(textFormat);
			mainTitle.x = (IpadConstants.GameWidth - mainTitle.width) * 0.5;
			mainTitle.y = (IpadConstants.GameHeight - mainTitle.height) * 0.5 - 380 * IpadConstants.contentScaleFactor; //- 290 * IpadConstants.contentScaleFactor;
			mainTitle.visible = false;
			addChild(mainTitle);
			
			visible = false;
		}
		
		public function nomaterials(data:Event):void
		{
			//trace("NO MATS", isNeedToClear);
			if (isNeedToClear)
			{
				visible = true;
				slider.clearSlider();
				mainTitle.visible = true;
			}
			else
			{
				slider.isCanLoad = false;
				if (slider.childList.length > 6)
				{
					slider.animatetoFinishX();
					slider.startInteraction();
				}
				else
				{
					slider.stopInteraction();
				}
			}
		}
		
		public function setdata(data:Vector.<Material>):void
		{
			visible = true;
			
			if (!data || data.length == 0)
				return;
			
			slider.isCanLoad = true;
			mainTitle.visible = false;
			
			if (isNeedToClear)
			{
				lastIndex = 0;
				offset = 20;
				slider.clearSlider();
				slider.holder.x = 0;
				slider.x = 0;
			}
			
			for (var i:int = 0; i < data.length; i++)
			{
				var clip:Element = new Element(data[i]);
				slider.addElement(clip);
				clip.x = offset;
				clip.y = (_height + 20) * (lastIndex % 2);
				offset += (lastIndex % 2) ? _width + 20 : 0;
				lastIndex++;
			}
			
			slider.startInteraction();
		}
		
		public function clearSlider():void
		{
			slider.clearSlider();
			slider.holder.x = 0;
			slider.x = 0;
			lastIndex = 0;
			offset = 20;
		}
		
		public function setFactData(data:Vector.<Fact>):void
		{
			line.visible = true;
			y = 240 * IpadConstants.contentScaleFactor;
			
			visible = true;
			
			if (!data)
				return;
			
			if (data.length == 0)
			{
				dispatchEvent(new IpadEvent(IpadEvent.LOAD_MORE));
				return;
			}
			
			slider.isCanLoad = true;
			mainTitle.visible = false;
			
			if (isNeedToClear)
			{
				lastIndex = 0;
				offset = 20;
				slider.clearSlider();
				slider.holder.x = 0;
				slider.x = 0;
			}
			
			for (var i:int = 0; i < data.length; i++)
			{
				var clip:ElementFact = new ElementFact(data[i]);
				slider.addElement(clip);
				clip.x = offset;
				clip.y = (0.5 * 958 * IpadConstants.contentScaleFactor+48*IpadConstants.contentScaleFactor) * (lastIndex % 2);
				offset += (lastIndex % 2) ? _width + 20 : 0;
				lastIndex++;
			}
			oneLoadCounter += data.length;
			
			if (oneLoadCounter >= 6)
			{
				oneLoadCounter = 0;
				slider.startInteraction();
			}
			else
			{
				dispatchEvent(new IpadEvent(IpadEvent.LOAD_MORE));
			}
		}
		
		public function setDragElement(obj:*, _x:Number, _y:Number):void
		{
			obj.down();
			activeElement = obj.mat;
			activeObj = obj;
			startTime = getTimer();
			startY = _y;
			var hh:Number =  obj.height;
			if (obj is ElementFact) hh = obj.height + 30;			
			var bd:BitmapData = new BitmapData(obj.width, hh, true, 0xffffff);
			bd.draw(obj);
			spriteDrag.addChild(new Bitmap(bd));
			spriteDrag.x = _x; // - _width * 0.5;
			spriteDrag.y = _y - y; // - _height * 0.5;
			obj.state2();
		}
		
		public function updateDragElement(e:MouseEvent):void
		{
			spriteDrag.x = e.stageX - _width * 0.5;
			spriteDrag.y = e.stageY - y - _height * 0.5;
			HandSpeed.getInstance().calculateSpeed(spriteDrag.x, spriteDrag.y);
		}
		
		public function removeDragElement(_x:Number, _y:Number):void
		{
			if (!candidateOk)
				return;
			
			if (HandSpeed.getInstance().handSpeed.speedY < -100)
			{
				for (var i:int = 0; i < slider.childList.length; i++)
				{
					if (slider.childList[i] is Element)
					{
						(slider.childList[i] as Element).up();
						(slider.childList[i] as Element).isActive = false;
					}
					else if (slider.childList[i] is ElementFact)
					{
						(slider.childList[i] as ElementFact).up();
						(slider.childList[i] as ElementFact).isActive = false;
					}
				}
				
				showingMat = activeObj;
				showingMat.isActive = true;
				showingMat.state2();
				
				TweenLite.to(spriteDrag, 0.3, {y: this.y - spriteDrag.height - 300, onComplete: function():void
					{
						var data:Object = new Object();
						data.element = activeElement;
						
						if (slider.childList[0] is Element)
							data.type = "Material";
						else if (slider.childList[0] is ElementFact)
							data.type = "Fact";
						
						dispatchEvent(new IpadEvent(IpadEvent.SHOW_MATERIAL, true, false, data));
						Tool.removeAllChildren(spriteDrag);
					}});
			}
			else
			{
				showingMat = null;
				Tool.removeAllChildren(spriteDrag);
			}
			
			if (showingMat == null)
			{
				activeObj.up();
				activeObj.isActive = false;
			}
			
			candidateOk = false;
		}
		
		public function setCandidate(elem:*):void
		{
			candidate = elem;
			saveCoords = slider.holder.localToGlobal(new Point(candidate.x, candidate.y));
		}
		
		public function checkCandidate():Boolean
		{
			var newCoords:Point = slider.holder.localToGlobal(new Point(candidate.x, candidate.y));
			
			if (Math.abs(saveCoords.x - newCoords.x) < 100)
			{
				candidateOk = true;
				setDragElement(candidate, newCoords.x, newCoords.y);
				parent.setChildIndex(this, parent.numChildren - 1);
				return true;
			}
			
			return false;
		}
		
		public function kill():void
		{
			removeAllChildren(this);
		}
		
		private function removeAllChildren(_do:Sprite):void
		{
			while (_do.numChildren > 0)
			{
				var child:Sprite = _do.getChildAt(0) as Sprite;
				if (child)
				{
					removeAllChildren(child);
					_do.removeChild(child);
					child = null;
				}
				else
				{
					var doChild:DisplayObject = _do.getChildAt(0);
					_do.removeChild(doChild);
					doChild = null;
				}
			}
		}
	}
}
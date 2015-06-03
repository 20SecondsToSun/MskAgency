package ipad.view.locations
{
	import app.model.config.Config;
	import app.view.utils.TextUtil;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ipad.controller.IpadConstants;
	import ipad.view.locations.buttons.RubricButton;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class CustomPage extends Base2Page
	{
		private var textFormat:TextFormat = new TextFormat("TornadoL", 53, 0X494949);
		
	/*	public var menu_1:RubricButton;
		public var menu_2:RubricButton;
		public var menu_3:RubricButton;
		public var menu_4:RubricButton;
		public var menu_5:RubricButton;
		public var menu_6:RubricButton;*/
		
		private var btnsArray:Vector.<RubricButton> = new Vector.<RubricButton>();
		
		public function CustomPage()
		{
			locName = "CUSTOM_SCREEN";
			super();
		}
		
		private var title2Format:TextFormat = new TextFormat("TornadoL", 48 * IpadConstants.contentScaleFactor, 0Xe6e8ed);
		private var subtitle2Format:TextFormat = new TextFormat("TornadoL", 30 * IpadConstants.contentScaleFactor, 0x828696);
		
		private var rtitle2:String = "Настройте отображение\nконтента на странице";
		private var rsubtitle2:String = "Выберите одну из рубрик ниже и все новости,\nотображаемые на странице, будут фильтроваться\nпо этой тематике ";
		private var _title2:TextField;
		private var _subtitle2:TextField;
		
		private var offsetY:Number = (IpadConstants.GameHeight - 998 * IpadConstants.contentScaleFactor) * 0.5 - IpadConstants.contentScaleFactor * 290 * 0.5;
		
		override public function init(screen:String, _isKinectUser:Boolean, _isPlaying:Boolean):void
		{
			locName = "CUSTOM_SCREEN";
			TITLE1 = "Страница «По теме» не является\nосновным экраном";
			TITLE2 = "Нажмите кнопку, если хотите, чтобы страница\n«По теме» автоматически транслировалась когда вы\nне управляете стендом";
			TITLE3 = "Нажмите на паузу, если хотите\nостановить ротацию контента на стенде";
			TITLE4 = "Страница «По теме» выбрана\nкак основной экран";
			TITLE5 = "Она автоматически транслируется когда\nвы не управляете стендом";
			playButtonCoords_x = 0.5 * (IpadConstants.GameWidth * 0.5 - 429*IpadConstants.contentScaleFactor);		
			promtCoords_x = 156 * IpadConstants.contentScaleFactor;
			
			super.init(screen, _isKinectUser, _isPlaying);
		}
		
		public function initRub(initRub:Object):void
		{			
			var line:Shape = new Shape();
			line.graphics.lineStyle(1, 0x828696, 0.68);
			line.graphics.moveTo(IpadConstants.GameWidth * 0.5, 0);
			line.graphics.lineTo(IpadConstants.GameWidth * 0.5, 998 * IpadConstants.contentScaleFactor);
			addChild(line);
			
			line.y = offsetY;
			line.alpha = 0;
			
			TweenLite.to(line, 0.6, {alpha: 1, ease: Quad.easeInOut});
			
			_title2 = TextUtil.createTextField(IpadConstants.GameWidth * 0.5 + 155 * IpadConstants.contentScaleFactor, line.y);
			_title2.text = rtitle2;
			_title2.setTextFormat(title2Format);
			addChild(_title2);
			
			_subtitle2 = TextUtil.createTextField(0, 0);
			_subtitle2.text = rsubtitle2;
			_subtitle2.setTextFormat(subtitle2Format);
			_subtitle2.x = _title2.x;
			addChild(_subtitle2);
			
			/*var mainTitle:TextField = TextUtil.createTextField(0, 0);
			   mainTitle.text = "ПО ТЕМЕ";
			   mainTitle.setTextFormat(textFormat);
			   mainTitle.x = (IpadConstants.GameWidth - mainTitle.width) * 0.5;
			   mainTitle.y = 100; // (IpadConstants.GameHeight - mainTitle.height - 590 * IpadConstants.contentScaleFactor) * 0.5;
			 addChild(mainTitle);*/
			
			var rubrics:Array = Config.rubrics;
			for (var i:int = 0; i < rubrics.length; i++)
			{
				var rubBtn:RubricButton = new RubricButton(rubrics[i], initRub, i != rubrics.length - 1,0x5c9f42, i);
				
				//var btn:RubricButton = this["menu_" + (i + 1).toString()];
				addChild(rubBtn);
				rubBtn.x = _title2.x;
				rubBtn.y = 470 * IpadConstants.contentScaleFactor + (rubBtn.height) * i;
				rubBtn.alpha = 0;
				btnsArray.push(rubBtn);
				
				TweenLite.to(rubBtn, 0.2, {alpha: 1, delay: i * 0.05, ease: Cubic.easeInOut});
			}
			for (var j:int = 0;j < btnsArray.length; j++)
					btnsArray[j].click(initRub);
					
			textAnimation();
		}
		
		private function textAnimation():void
		{
			_title2.y = offsetY - 10;
			_title2.alpha = 0.4;
			
			_subtitle2.y = _title2.y + _title2.height - 10;
			_subtitle2.alpha = 0.4;
			
			TweenLite.to(_title2, 0.5, {y: offsetY, alpha: 1, ease: Quad.easeInOut});
			TweenLite.to(_subtitle2, 0.5, {y: offsetY + _title2.height + 5, alpha: 1, ease: Quad.easeInOut});
		}
		
		public function setActiveButton(rub:Object):void
		{
			for (var i:int = 0; i < btnsArray.length; i++)
				btnsArray[i].click(rub);
		}
	
	}

}
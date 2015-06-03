package app.view.page.oneNews.Body
{
	import app.AppSettings;
	import app.assets.Assets;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.easing.Quart;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * @author metalcorehero
	 */
	
	public class TextContainer extends Sprite
	{
		private var _textTitle:TextField;
		private var textTitleFormat:TextFormat = new TextFormat("Tornado", 48, 0x1a1b1f);
		
		private var _textMain:TextField;
		private var textNewsFormat:TextFormat = new TextFormat("Helvetica", 20, 0x1a1b1f);
		
		private var _rubrics:TextField;
		private var rubricsNewsFormat:TextFormat = new TextFormat("Helvetica", 16, 0x8ca8c0);
		
		private var _timeTitle:TextField;
		private var timeTitleFormat:TextFormat = new TextFormat("Tornado", 31, 0x02a7df);
		
		private var _dateTitle:TextField;
		private var dateTitleFormat:TextFormat = new TextFormat("TornadoMedium", 16, 0x02a7df);
		private var textTitleY:Number;
		
		private var slider:VerticalSliderText;
		private var sliderMask:Shape;
		
		private var bmpTitle:Bitmap;
		private var bmpMain:Bitmap;
		private var arrows:Sprite;
		private var arrow:Sprite;
		
		private var isSliderInteractive:Boolean = false;
		private var factTime:Sprite;
		private var f11:TextField;
		private var f22:TextField;
		private var f33:TextField;
		private var f44:TextField;
		private var f55:TextField;
		private var f66:TextField;
		
		public var id:String = "";
		
		public function TextContainer()
		{
			slider = new VerticalSliderText();
			addChild(slider);
			slider.x = 206;
			
			textTitleFormat.letterSpacing = 1;
			
			_textTitle = TextUtil.createTextField(0, 166);
			_textTitle.multiline = true;
			_textTitle.wordWrap = true;
			_textTitle.width = 935;
			//slider.addChild(_textTitle);
			
			_textMain = TextUtil.createTextField(0, 372);
			_textMain.multiline = true;
			_textMain.wordWrap = true;
			_textMain.width = 810;
			_textMain.y = _textTitle.y + _textTitle.height + 100;
			//slider.addChild(_textMain);
			
			_rubrics = TextUtil.createTextField(76, 87);
			_rubrics.multiline = false;
			_rubrics.wordWrap = false;
			_rubrics.x = 206;
			_rubrics.y = slider.y - 80;
			
			_timeTitle = TextUtil.createTextField(76, 169);
			_timeTitle.multiline = false;
			_timeTitle.wordWrap = false;
			addChild(_timeTitle);
			
			_dateTitle = TextUtil.createTextField(76, 166);
			_dateTitle.multiline = false;
			_dateTitle.wordWrap = false;
			_dateTitle.y = slider.y + _timeTitle.height - 4;
			_dateTitle.x = slider.x + 0.5 * (_timeTitle.width - _dateTitle.width);
			addChild(_dateTitle);
			
			addChild(_rubrics);
			
			arrows = Assets.create("arrows");
			arrows.x = AppSettings.WIDTH - 622 - 198;
			arrows.y = AppSettings.HEIGHT - 137;
			arrows.visible = false;
			addChild(arrows);
			
			arrow = Assets.create("arrows");
			arrow.x = 463;
			arrow.y = AppSettings.HEIGHT - 137;
			arrow.x = 206 + 1000 - 376;
			arrow.visible = false;
			addChild(arrow);
			
			sliderMask = Tool.createShape(AppSettings.WIDTH - 622 - 206, AppSettings.HEIGHT, 0x000000);
			addChild(sliderMask);
			sliderMask.alpha = 0;
			slider.mask = sliderMask;
			sliderMask.x = 206;		
		}
		
		public function set textTitle(value:String):void
		{
			_textTitle.text = value;
			_textTitle.setTextFormat(textTitleFormat);
		}
		
		public function set textMain(value:String):void
		{
			_textMain.text = value.split("\n").join(""); //"Москва. 11 сентября. INTERFAX.RU – Решением Мосгоризбиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании збиркома, принятым на его заседании в среду, врио столичного градоначальника Сергей Собянин зарегистрирован избранным мэром Москвы.Этому предшествовало официальное утверждение итогов голосования по выборам мэра Москвы, согласно которым Собянин получил 51,37% голосов избирателей. Всего за Собянина проголосовали 1 млн 193 тыс. 178 москвичей, пришедших 8 сентября на избирательные участки.За решение о регистрации Собянина избранным мэром проголосовали практически все члены МГИК, против - только представитель с правом решающего голоса от КПРФ.Обстоятельств, препятствующих регистрации Сергея Семеновича Собянина избранным мэром, нет, - сказал на заседании глава Мосгоризбиркома Валентин Горбунов.Как ожидается, церемония инаугурации Собянина состоится 12 сентября. Он будет считаться официально вступившим в должность мэра после принесения присяги. Предполагается, что удостоверение ему будет вручено в ходе инаугурации.Тем временем ближайший соперник Собянина оппозиционер Алексей Навальный, получивший 27,24% голосов москвичей, в среду потребовал Мосгорсуд отменить результаты выборов мэра столицы. Свое требование он обосновал тем, что во время избирательной кампании был нарушен принцип равного доступа кандидатов к СМИ. Я думаю, в этом пункте сомнений ни у кого не возникнет, - сказал Навальный журналистам в среду. Также он заявил еще об одном нарушении: раздаче продуктовых наборов пенсионерам в территориальных избирательных комиссиях и составление списков голосования на дому. Мы знаем, что все реестры голосования на дому составлены с нарушениями, - заявил он.По его словам, помимо заявления в Мосгорсуд через городской суд в районные будет также подан 951 иск. Там речь идет о процедурных нарушениях, - сказал Навальный. По его словам, речь в жалобах подчистую идет о нарушениях на участках с аномально высоким уровнем голосования на дому. Навальный отметил, что в районных судах будут обжаловаться результаты на конкретных участках, где выявлены нарушения.Мы знаем точно и докажем, что Сергей Собянин набрал не более 49%, - сказал он.Как сообщалось, в начале июня текущего года Сергей Собянин подал Владимиру Путину заявление о добровольной отставке в пользу проведения в столице досрочных прямых выборов мэра. Президент согласился с предложением и выразил надежду, что Собянин продолжит эффективную работу. Мы работаем с вами давно, — напомнил он.Первые с 2003 г. выборы градоначальника состоялись в единый день голосования 8 сентября.Смотрите оригинал материала на http://www.interfax.ru/russia/txt.asp?id=328358";
			_textMain.setTextFormat(textNewsFormat);
		}
		
		public function set rubrics(value:*):void
		{
			_rubrics.text = "";
			if (value.length != 0)
			{
				for (var i:int = 0; i < value.length; i++)
				{
					_rubrics.appendText(value[i].title);
					if (i !== value.length - 1)
						_rubrics.appendText(", ");
				}
			}
			_rubrics.setTextFormat(rubricsNewsFormat);
		}
		
		public function set timeTitle(value:Date):void
		{
			_timeTitle.text = TextUtil.formatTime(value);
			_timeTitle.setTextFormat(timeTitleFormat);
		}
		
		public function set dateTitle(value:Date):void
		{
			_dateTitle.text = TextUtil.formatDate(value);
			_dateTitle.setTextFormat(dateTitleFormat);
		}
		
		public function refresh():void
		{
			TweenLite.killTweensOf(_textTitle);
			TweenLite.killTweensOf(_textMain);
		}
		
		public function animate(cur:String, last:String):void
		{
			slider.mask = null;
			slider.stopInteraction();
			textTitleY = 166;
			
			if (slider.y < 166)
				slider.y = 166;
			
			if (cur == "text")
			{
				textTitleFormat.size = 48;
				textTitleY = 166;
				_textTitle.width = 935;
				_textMain.width = 810;
			}
			else if (cur == "video" || cur == "broadcast")
			{
				textTitleFormat.size = 36;
				textTitleY = 694; //: videoContainer.height + 123;			
				_textTitle.width = 206 + 1000 - 376 - 206 - 40;
				_textMain.width = _textTitle.width - 18;
				_textMain.y = _textTitle.y + _textTitle.height + 45;
			}
			else if (cur == "photo")
			{
				textTitleFormat.size = 36;
				_textTitle.setTextFormat(textTitleFormat);
				textTitleY = 794;
				_textTitle.width = 206 + 1000 - 376 - 206 - 40;
				_textMain.width = _textTitle.width - 18;
				_textMain.y = _textTitle.y + _textTitle.height;
			}
			
			_textTitle.setTextFormat(textTitleFormat);
			_textMain.x = _textTitle.x;
			_timeTitle.x = slider.x - 130;
			_rubrics.x = slider.x;
			_dateTitle.x = _timeTitle.x + 0.5 * (_timeTitle.width - _dateTitle.width);
			
			if (bmpTitle)
			{
				slider.removeChild(bmpTitle);
				bmpTitle.bitmapData.dispose();
			}
			if (bmpMain)
			{
				slider.removeChild(bmpMain);
				bmpMain.bitmapData.dispose();
			}
			
			var bdTitle:BitmapData = new BitmapData(_textTitle.width, _textTitle.height, true, 0x00000000);
			bdTitle.draw(_textTitle);
			bmpTitle = new Bitmap(bdTitle);
			
			var bdMain:BitmapData = new BitmapData(_textMain.width, _textMain.height, true, 0x00000000);
			bdMain.draw(_textMain);
			bmpMain = new Bitmap(bdMain);
			bmpMain.y = bmpTitle.height + 40;
			
			slider.addChild(bmpTitle);
			slider.addChild(bmpMain);
			sliderMask.y = textTitleY - 10;
			
			isSliderInteractive = false;
			
			if ((bmpTitle.y + bmpTitle.height + 40 + bmpMain.height > AppSettings.HEIGHT - textTitleY) && cur == "text")
			{
				arrows.visible = true;
				arrow.visible = false;
				isSliderInteractive = true;
			}
			else
			{
				slider.stopInteraction();
				arrows.visible = false;
				arrow.visible = false;
			}
			
			if ((textTitleY + slider.height > AppSettings.HEIGHT) && cur != "text")
			{
				arrows.visible = false;
				arrow.visible = true;
				isSliderInteractive = true;
					//slider.startInteraction();	
			}
			else if (cur != "text")
			{
				slider.stopInteraction();
				arrows.visible = false;
				arrow.visible = false;
			}
			
			if (last == "text" && cur == "text")
			{
				_textTitle.y = 0;
				_textMain.y = _textTitle.height + 40;
				_timeTitle.y = textTitleY + 3;
				_rubrics.y = textTitleY - 60;
				_dateTitle.y = textTitleY + 3 + _timeTitle.height - 4;
				
				var finYTextTitle:Number = _textTitle.y;
				var finYTextNews:Number = _textMain.y;
				
				bmpTitle.y = _textTitle.y;
				bmpMain.y = _textMain.y;
				
				_textTitle.y += 200;
				_textMain.y += 220;
				
				bmpTitle.y += 200;
				bmpMain.y += 200;
				
				TweenLite.to(bmpTitle, 0.7, {y: finYTextTitle, alpha: 1, ease: Quart.easeOut});
				TweenLite.to(bmpMain, 0.9, {y: finYTextNews, alpha: 1, ease: Quart.easeOut});
				TweenLite.to(slider, 0.9, {y: textTitleY, ease: Quart.easeOut, onComplete: setMaska});
				
			}
			else
			{
				animateTitles();
			}
		}
		
		public function changedTitlePosition(_height:Number, id:String):void
		{
			if (this.id != id)
				return;
			
			TweenLite.killTweensOf(slider);
			var finalY:Number = _height + 117 + 10;
			
			TweenLite.to(slider, 0.7, {y: finalY, onComplete: setMaska, ease: Quart.easeOut});
			TweenLite.to(_timeTitle, 0.7, {y: finalY + 3, alpha: 1, ease: Quart.easeOut});
			TweenLite.to(_rubrics, 0.7, {y: finalY - 60, alpha: 1, ease: Quart.easeOut});
			TweenLite.to(_dateTitle, 0.7, {y: finalY + 3 + _timeTitle.height - 4, alpha: 1, ease: Quart.easeOut});
		}
		
		private function setMaska():void
		{
			slider.startY = textTitleY;
			slider.margin = slider.startY + 500;
			sliderMask.height = AppSettings.HEIGHT - textTitleY
			slider.mask = sliderMask;
			if (isSliderInteractive)
				slider.startInteraction();
		}
		
		private function animateTitles():void
		{
			TweenLite.killTweensOf(slider);
			TweenLite.to(slider, 0.7, {y: textTitleY, onComplete: setMaska, ease: Quart.easeOut});
			
			TweenLite.to(bmpTitle, 0.7, {y: 0, alpha: 1, ease: Quart.easeOut});
			TweenLite.to(_timeTitle, 0.7, {y: textTitleY + 3, alpha: 1, ease: Quart.easeOut});
			TweenLite.to(_rubrics, 0.7, {y: textTitleY - 60, alpha: 1, ease: Quart.easeOut});
			TweenLite.to(_dateTitle, 0.7, {y: textTitleY + 3 + _timeTitle.height - 4, alpha: 1, ease: Quart.easeOut});
		}
		
		public function kill():void
		{
			if (bmpTitle)
				bmpTitle.bitmapData.dispose();
			if (bmpMain)
				bmpMain.bitmapData.dispose();
		}
		
		private var textFormatFact1:TextFormat = new TextFormat("Tornado", 16, 0X509338);
		private var textFormatFact2:TextFormat = new TextFormat("Tornado", 31, 0X509338);
		private var textFormatFact3:TextFormat = new TextFormat("TornadoMedium", 16, 0X515255);
		
		public function addFactTime(start_date:Date, end_date:Date):void
		{
			var month:String;
			
			if (factTime == null)
			{
				factTime = new Sprite();
				factTime.x = 176;
				factTime.y = 169;
				addChild(factTime);
				
				for (var i:int = 1; i < 7; i++)
				{
					this["f" + i.toString() + i.toString()] = TextUtil.createTextField(0, 0);
					factTime.addChild(this["f" + i.toString() + i.toString()]);
				}
				
			}
			if (TextUtil.isEqualDayDate(start_date, end_date))
			{
				f66.visible = false;
				
				var startTime:String = TextUtil.getFormatTime(start_date);
				var endTime:String = TextUtil.getFormatTime(end_date);
				
				f11.text = "с";
				f11.setTextFormat(textFormatFact1);
				
				f22.text = startTime;
				f22.setTextFormat(textFormatFact2);
				f22.x = -f22.width;
				f11.x = f22.x - f11.width - 5;
				f22.y = 0;
				f11.y = f22.height - f11.height - 3;
				
				f33.text = "до";
				f33.setTextFormat(textFormatFact1);
				
				f44.text = endTime;
				f44.setTextFormat(textFormatFact2);
				
				f44.x = -f44.width;
				f33.x = f44.x - f33.width - 5;
				f44.y = f11.y + f11.height - 1;
				
				f33.y = f44.y + f44.height - f33.height - 3;
				
				f55.text = TextUtil.getFormatDay1(start_date) + " ";
				month = TextUtil.month[start_date.getMonth()].toUpperCase();
				f55.appendText(month);
				f55.setTextFormat(textFormatFact3);
				
				f55.x = -f55.width;
				f55.y = f44.y + f44.height + 10;
			}
			else
			{
				f66.visible = true;
				
				f11.text = "с";
				f11.setTextFormat(textFormatFact1);
				
				f22.text = start_date.getDate().toString();
				f22.setTextFormat(textFormatFact2);
				f22.x = -f22.width;
				f11.x = f22.x - f11.width - 5;
				f22.y = 0;
				f11.y = f22.height - f11.height - 3;
				
				month = TextUtil.month[start_date.getMonth()].toUpperCase();
				f55.text = month;
				f55.setTextFormat(textFormatFact3);
				
				f55.x = -f55.width;
				f55.y = f22.y + f22.height + 1;
				
				f33.text = "по";
				f33.setTextFormat(textFormatFact1);
				
				f44.text = end_date.getDate().toString();
				f44.setTextFormat(textFormatFact2);
				
				f44.x = -f44.width;
				f33.x = f44.x - f33.width - 5;
				
				f44.y = f55.y + f55.height + 10;
				f33.y = f44.y + f44.height - f33.height - 3;
				
				month = TextUtil.month[end_date.getMonth()].toUpperCase();
				f66.text = month;
				f66.setTextFormat(textFormatFact3);
				
				f66.x = -f66.width;
				f66.y = f44.y + f44.height + 1;
			}
		}
	}
}
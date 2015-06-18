package app.view.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author castor troy
	 */
	public class TextUtil
	{
		
		public static function truncate(textfield:TextField, maxLines:int, format:TextFormat = null):void
		{
			if (format)
				textfield.setTextFormat(format);
			// the alternative text
			var alt:String = "...";
			
			// if the text displayed has more lines than wished
			if (textfield.numLines > maxLines)
			{
				// index of the last char of the last line to display
				var char:int = textfield.getLineOffset(maxLines) - 1;
				
				// remove the length of the alternative text
				char -= alt.length;
				
				// get the last non space char index
				char = textfield.text.substring(0, char + 1).search(/\S\s*$/);
				
				// set the new text into the textfield
				textfield.text = textfield.text.substring(0, char) + alt;
			}
			
			if (format)
				textfield.setTextFormat(format);
		
		}
		
		public static function createTextField(x:Number, y:Number):TextField
		{
			var tf:TextField = new TextField();
			
			tf.embedFonts = true;
			tf.selectable = false;
			tf.mouseEnabled = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.gridFitType = GridFitType.SUBPIXEL;
			tf.x = x;
			tf.y = y;
			//tf.sharpness = 100;
			return tf;
		}
		
		public static function getFormatDatePubl(date:Date):String
		{
			var day:String = date.getDate().toString();
			if (day.length < 2)
				day = "0" + day;
			var month:String = (date.getMonth() + 1).toString();
			if (month.length < 2)
				month = "0" + month;
			
			var year:String = date.getFullYear().toString();
			
			return day + "." + month + "." + year;
		
		}
		
		public static function getFormatDateNext(date:String):String
		{
			var dateArr:Array = date.split(".");
			var next:Date = new Date(dateArr[2],dateArr[1], dateArr[0]);
			next.date += 1;
			return  getFormatDatePubl(next);
		
		}
		public static function isEqualDayDate(date1:Date, date2:Date):Boolean
		{
			if (date1.fullYear == date2.fullYear && date1.month == date2.month && date1.day == date2.day)
			{
				return true;
			}			
			return false;		
		}		
		
		
		
		public static function getFormatDay(date:Date):String
		{
			var day:String = date.getDate().toString();
			if (day.length < 2)
				day = "0" + day;
			return day;
		}
		
		public static function getFormatDay1(date:Date):String
		{
			var day:String = date.getDate().toString();			
			return day;
		}
		
		public static function getFormatTime(date:Date):String
		{
			var startHour:String = date.hours.toString();
			if (startHour.length == 1)
				startHour = "0" + startHour;
			
			var startMinutes:String = date.minutes.toString();
			if (startMinutes.length == 1)
				startMinutes = "0" + startMinutes;
			
			return startHour + ":" + startMinutes;
		}
		
		public static function getFormatHours(hours:int):String
		{
			var startHour:String = hours.toString();
			if (startHour.length == 1)
				startHour = "0" + startHour;
			return startHour;
		
		}
		
		public static function getFormatMinutes(hours:int):String
		{
			var startHour:String = hours.toString();
			if (startHour.length == 1)
				startHour = "0" + startHour;
			return startHour;
		
		}
		
		public static function hourInRussian(hour:String):String
		{
			var hourtext:String = "ЧАСОВ";
			if (hour == "21" || hour == "01" || hour == "1")
			{
				hourtext = "ЧАС";
			}
			else if (hour == "22" || hour == "23" || hour == "24" || hour == "04" || hour == "4" || hour == "03" || hour == "3" || hour == "02" || hour == "2" || hour == "01" || hour == "1")
			{
				hourtext = "ЧАСА";
			}
			
			return hourtext;
		}
		
		public static function formatCaseFoto(num:String):String
		{
			var numString:String = "";
			
			if (num == "1")
				numString = "ФОТОГРАФИЯ";
			else if (num.length == 1 && (num.charAt(num.length - 1) == "2" || num.charAt(num.length - 1) == "3" || num.charAt(num.length - 1) == "4"))
				numString = "ФОТОГРАФИИ";
			else if (num.charAt(0) != "1" && (num.charAt(num.length - 1) == "2" || num.charAt(num.length - 1) == "3" || num.charAt(num.length - 1) == "4"))
				numString = "ФОТОГРАФИИ";
			else
				numString = "ФОТОГРАФИЙ";
			
			return numString;
		}
		
		public static function formatTime(date:Date):String
		{
			var hours:String = date.getHours().toString();
			if (hours.length < 2)
			{
				hours = "0" + hours;
			}
			var minutes:String = date.getMinutes().toString();
			if (minutes.length < 2)
			{
				minutes = "0" + minutes;
			}
			return hours + ":" + minutes;
		}
		public static const month:Array = ["ЯНВАРЯ", "ФЕВРАЛЯ", "МАРТА", "АПРЕЛЯ", "МАЯ", "ИЮНЯ", "ИЮЛЯ", "АВГУСТА", "СЕНТЯБРЯ", "ОКТЯБРЯ", "НОЯБРЯ", "ДЕКАБРЯ"];
		
		
		
		
		
		public static var currentDate:Date;
		public static function formatDate(date:Date):String
		{				
			return date.getDate() + " " + month[date.getMonth()];
		}
		
		public static function formatDate1(date:Date):String
		{				
			date.getMilliseconds()
			var tempYesterday:Date = new Date();
			tempYesterday.setMilliseconds(date.getMilliseconds());			
			tempYesterday.date -= 1;
			
			if (currentDate.getFullYear() == date.getFullYear() &&
				currentDate.getMonth() == date.getMonth() &&
				currentDate.getDate() == date.getDate()
			)					
			return "";
			
			else if (tempYesterday.getFullYear() == date.getFullYear() &&
				tempYesterday.getMonth() == date.getMonth() &&
				tempYesterday.getDate() == date.getDate()
			)		
				return "ВЧЕРА";	
										
			return date.getDate() + " " + month[date.getMonth()];
		}		
		
		
		public static function calculateTimeFormat(_sec:Number):String
		{
			//trace("::::::::::::::  ",Math.round(46 / 60));
			var min:String = (Math.floor(_sec / 60)).toString();
			min = min.length <= 1 ? "0" + min : min;
			
			var sec:String = (Math.floor(_sec % 60)).toString();
			sec = sec.length <= 1 ? "0" + sec : sec;
			
			return min + ":" + sec;
		}
		
		public static function textFieldToBitmap(txt:TextField, maxScale:Number = 0):Bitmap
		{
			var mat:Matrix = new Matrix();
			mat.identity();
			
			if (maxScale != 0)
			{
				txt.scaleY = txt.scaleX = maxScale;
				mat.scale(maxScale, maxScale);
			}
			
			var textToBD:BitmapData = new BitmapData(txt.width, txt.height, true, 0x00000000);
			textToBD.draw(txt, mat);
			
			var bmpText:Bitmap = new Bitmap(textToBD);
			bmpText.smoothing = true;
			bmpText.x = txt.x;
			bmpText.y = txt.y;
			
			if (maxScale != 0)
			{
				bmpText.scaleY = bmpText.scaleX = 1 / maxScale;
			}
			
			return bmpText;
		
		}
		
		public static function convertStringToDate(dateStr:String):Date
		{
			var arrayDate:Array = dateStr.split(".");
			return new Date(arrayDate[2], arrayDate[1] - 1, arrayDate[0]);
		}
		
		public static function convertDateToString(date:Date):String
		{
			return date.getDate() + "." + (date.getMonth() + 1).toString() + "." + date.getFullYear();
		}
	
	}

}
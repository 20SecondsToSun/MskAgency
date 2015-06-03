package ipad.view
{
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ipad.controller.IpadConstants;
	import ipad.view.locations.news.DateChoose;
	import ipad.view.locations.news.RubricChoose;
	import ipad.view.locations.news.Search;
	import ipad.view.locations.news.TypeChoose;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class Top extends Sprite
	{
		private var polosa:Sprite;
		public var initText:String = "Поиск";
		private var textPromtFormat:TextFormat = new TextFormat("Tornado", 30 * IpadConstants.contentScaleFactor, 0x828696);
		private var search:Sprite;
		private var lupa:Sprite;
		private var searchNews:Search;
		private var typeChoose:TypeChoose;
		private var rubricChoose:RubricChoose;
		private var dateChoose:DateChoose;
		private var promt:TextField;
		
		private var state:String = "INIT";
		private var splash:Shape;
		private var type:String;
		public var changeFonCallback:Function = null;
		
		public function Top(_type:String = "main")
		{
			type = _type;
			splash = Tool.createShape(IpadConstants.GameWidth, IpadConstants.contentScaleFactor * 190, 0x1a1b1f);
			splash.visible = false;
			addChild(splash);
			
			searchNews = new Search();
			var numberSearch_y:Number =  405 * IpadConstants.contentScaleFactor;
			searchNews.x = 0.5 * (IpadConstants.GameWidth - searchNews.width);
			searchNews.y = numberSearch_y - 150;
			searchNews.alpha = 0;
			TweenLite.to(searchNews, 1.9, {alpha: 1, y:numberSearch_y, ease: Expo.easeOut});
			addChild(searchNews);
			
			promt = TextUtil.createTextField(0, 0);
			promt.text = "Вы можете искать материалы в разделе Новости";
			promt.setTextFormat(textPromtFormat);
			promt.x = searchNews.x;
			var promt_y:Number = 128 * IpadConstants.contentScaleFactor;
			promt.y = promt_y - 150;
			addChild(promt);
			
			promt.alpha = 0;
			TweenLite.to(promt, 0.5, {alpha: 1, y:promt_y, ease: Expo.easeOut});
			
			if (type != "fact")
			{
				typeChoose = new TypeChoose();
				typeChoose.callbackStageText = searchNews.stageTextSet;
				typeChoose.alpha = 0;
				typeChoose.y = - 150;
				TweenLite.to(typeChoose, 0.5, {alpha: 1, y :0, ease: Expo.easeOut});
				addChild(typeChoose);
			}
			
			rubricChoose = new RubricChoose(type);
			rubricChoose.callbackStageText = searchNews.stageTextSet;
			rubricChoose.alpha = 0;
			rubricChoose.y = - 150;
			TweenLite.to(rubricChoose, 0.5, {alpha: 1, y :0, ease: Expo.easeOut});
			addChild(rubricChoose);
			
			dateChoose = new DateChoose(type);
			dateChoose.callbackStageText = searchNews.stageTextSet;
			dateChoose.alpha = 0;
			dateChoose.y = - 150;
			TweenLite.to(dateChoose, 0.5, {alpha: 1, y :0, ease: Expo.easeOut});
			addChild(dateChoose);
		}
		
		public function bringTargetFront(target:Object):void
		{
			if (target is TypeChoose)
				setChildIndex(target as TypeChoose, numChildren - 1);
				
			if (target is RubricChoose)
				setChildIndex(target as RubricChoose, numChildren - 1);
				
			if (target is DateChoose)
				setChildIndex(target as DateChoose, numChildren - 1);
		}
		
		public function changeState():void
		{
			if (state != "INIT")
				return;
			
			state = "LAST";
			TweenLite.delayedCall(0.3, changeView);
		}
		
		private function changeView():void
		{
			TweenLite.to(promt, 0.2, {alpha: 0, ease: Expo.easeOut, onComplete: function():void
				{
					promt.visible = false;
				}});
			
			TweenLite.to(searchNews, 0.2, {alpha: 0, ease: Expo.easeOut, onComplete: function():void
				{
				
				}});
			
			if (type != "fact")
				TweenLite.to(typeChoose, 0.2, {alpha: 0, ease: Expo.easeOut, onComplete: function():void
					{
					
					}});
			
			TweenLite.to(rubricChoose, 0.2, {alpha: 0, ease: Expo.easeOut, onComplete: function():void
				{
				
				}});
			
			TweenLite.to(dateChoose, 0.2, {alpha: 0, ease: Expo.easeOut, onComplete: function():void
				{
					searchNews.stageTextSet("off");
					startFinView();
				}});
		}
		
		private function startFinView():void
		{
			splash.visible = true;
			splash.y -= splash.height;
			TweenLite.to(splash, 0.5, {y: 0, ease: Expo.easeOut});
			
			searchNews.width = 868 * IpadConstants.contentScaleFactor;
			searchNews.scaleY = searchNews.scaleX;
			searchNews.height = Math.floor(searchNews.height);
			
			searchNews.x = 118 * IpadConstants.contentScaleFactor;
			searchNews.y = 60 * IpadConstants.contentScaleFactor;
			TweenLite.to(searchNews, 0.5, {alpha: 1, ease: Expo.easeOut});
			searchNews.secondStateStageText();
			
			if (type != "fact")
			{
				typeChoose.secondState();
				typeChoose.alpha = 1;
			}
			
			rubricChoose.secondState();
			dateChoose.secondState();
			
			rubricChoose.alpha = 1;
			dateChoose.alpha = 1;
			
			if (changeFonCallback != null)
				changeFonCallback();
		}
		
		public function txtVisible():void 
		{
			if (searchNews.myTextField)
				searchNews.myTextField.visible = true;
		}
		
		public function txtInvisible():void 
		{
			if (searchNews.myTextField)
				searchNews.myTextField.visible = false;
		}
		
		public function kill():void
		{
			try
			{
				if (searchNews.myTextField)
				searchNews.myTextField.dispose();
			}
			catch (err:Error)
			{
				
			}
			
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
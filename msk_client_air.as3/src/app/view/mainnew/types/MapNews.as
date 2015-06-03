package app.view.mainnew.types 
{
	import app.assets.Assets;
	import app.model.materials.GeoPoint;
	import app.model.materials.Material;
	import app.view.utils.TextUtil;
	import app.view.utils.Tool;
	import com.modestmaps.geo.Location;
	import com.modestmaps.mapproviders.yandex.YandexMapProvider;
	import com.modestmaps.TweenMap;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * ...
	 * @author metalcorehero
	 */
	public class MapNews extends MainType
	{
		private var map:TweenMap;
		private var mapbullet:Sprite;
		
		private var titleFormat:TextFormat = new TextFormat("TornadoL", 36, 0xFFFFFF);
		private var adressFormat:TextFormat = new TextFormat("Tornado", 18, 0xfcff00);
		
		private var titleText:TextField;
		private var adressText:TextField;
		
		public function MapNews() 
		{
			map = new TweenMap(WIDTH, HEIGHT, false, new YandexMapProvider(3, 12));	
			addChild(map);
			
			var multi:Shape = Tool.createShape(WIDTH, HEIGHT, 0x8a001a);
			addChild(multi);
			multi.blendMode = BlendMode.MULTIPLY;
			
			mapbullet = Assets.create("mapbullet");
			mapbullet.x = mapbullet.y = 80;
			addChild(mapbullet);
			
			titleText = TextUtil.createTextField(100, 20);			
			titleText.x = mapbullet.x +mapbullet.width + 40;
			titleText.y = mapbullet.y  + 10;
			titleText.width = 320;
			titleText.multiline = true;
			titleText.wordWrap = true;	
			
			addChild(titleText);	
			
			adressText = TextUtil.createTextField(100, 20);			
			adressText.x = titleText.x;
			adressText.y = mapbullet.y  + 10;
			adressText.width = WIDTH - 80;
			adressText.multiline = true;
			adressText.wordWrap = true;	
			
			addChild(adressText);			
			addFooter();			
		}
		
		override public function show( mat:Material):void 
		{	
			this.mat = mat;
			var point:GeoPoint = mat.point;
			var title:String = mat.title;
			great = true;
			
			map.setCenterZoom(new Location(point.lat, point.long), 15);		
			
			titleText.text = title;
			titleText.setTextFormat(titleFormat);
			TextUtil.truncate(titleText, 7);
			titleText.setTextFormat(titleFormat);
			
			adressText.text = point.address.toUpperCase();
			adressText.setTextFormat(adressFormat);
			TextUtil.truncate(adressText, 2);
			adressText.setTextFormat(adressFormat);
			adressText.y = HEIGHT - adressText.textHeight - 80;
		}		
	}
}
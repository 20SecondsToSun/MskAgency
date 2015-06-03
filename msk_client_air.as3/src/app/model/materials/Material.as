package app.model.materials
{
	import app.view.utils.TextUtil;
	
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class Material
	{
		public var author_id:String;
		
		public var rubrics:Vector.<MaterialRubric> = new Vector.<MaterialRubric>();
		public var files:Vector.<MaterialFile> = new Vector.<MaterialFile>();
		public var translations:Vector.<MaterialBroadcast> = new Vector.<MaterialBroadcast>();
		
		public var important:String;
		public var tags:Vector.<String> = new Vector.<String>();
		public var modified:String;
		public var published_at:String;
		public var publishedDate:Date;
		public var text:String;
		public var type:String;
		public var id:Number;
		public var title:String;
		public var theme:String;
		public var point:GeoPoint;
		
		public function getObject():Object
		{			
			var mat:Object = new Object();			
			mat.id = id;
			mat.title = title;
			return mat;
		}
		
		private var standartScaleThumb:int = 232;
		
		public function getFormatDatePubl():String
		{
			return TextUtil.getFormatDatePubl(publishedDate);
		}
		
		public function pushFile(_file:Object):void
		{
			if (_file != null)
			{
				var file:MaterialFile = new MaterialFile();
				file.author = _file.author;
				file.description = _file.description;
				file.duration = _file.duration;
				file.host = _file.host;
				file.id = _file.id;
				file.name = _file.name;
				file.thumbnail = _file.thumbnail;
				file.type = _file.type;
				file.previewBitmap = null;
				file.fullsizeBitmap = null;
				
				if (this.type == "photo")
				{
					file.pathToSource = "http://" + file.host + ".mskagency.ru/c/" + file.id + ".jpg";	
					file.pathToSource1 = "http://" + file.host + ".mskagency.ru/c/" +file.thumbnail + ".x";
					file.pathToSource2 = "p.jpg";
					file.thumbPath = file.pathToSource1 + standartScaleThumb +file.pathToSource2;	
					
				}
				else if (this.type == "video" || this.type == "broadcast")
				{
					file.pathToSource = "http://" + file.host + ".mskagency.ru/c/" + file.id + ".1.mp4";
					file.thumbPath= "http://" + file.host + ".mskagency.ru/c/" + file.id + "." + file.thumbnail + ".jpg";
				}
				
				files.push(file);
			}
		}		
		public function pushTranslations(_translations:Object):void
		{
			if (_translations != null)
			{
				var broadcast:MaterialBroadcast = new MaterialBroadcast();
				
				broadcast.channel_src = _translations.channel_src;
				broadcast.channel_name = _translations.channel_name;
				broadcast.description = _translations.description;
				broadcast.created = _translations.created;
				broadcast.type = _translations.type;
				broadcast.views = _translations.views;
				broadcast.media_path = _translations.media_path;
				broadcast.allow_downloads = _translations.allow_downloads;
				broadcast.live = _translations.live;
				broadcast.fav = _translations.fav;
				broadcast.img_src = _translations.img_src;
				broadcast.id = _translations.id;
				broadcast.thumb_src = _translations.thumb_src;
				broadcast.title = _translations.title;
				broadcast.user_id = _translations.user_id;
				broadcast.subscription = _translations.subscription;
				
				trace("BROADCAST", broadcast.channel_src, broadcast.channel_name, broadcast.media_path );
				
					
				translations.push(broadcast);
			}
		}
		
		public function pushPoint(_point:Object):void
		{
			point = new GeoPoint();
			
			if (_point != null)
			{
				//trace("========================");
				point.icon = _point.icon;
				
				point.type = _point.type;
				point.group = _point.group;
				
				point.type_id = _point.type_id;
				point.group_id = _point.group_id;
				
				point.address = _point.address;
				point.long = _point.long;
				point.lat = _point.lat  - 0.1792;// смещение для тайлов яндекса;*/				
			}
			else
			{
				point = null;
			}
		}
		
		public function pushRubric(_rubric:Object):void
		{
			if (_rubric != null)
			{
				var rubric:MaterialRubric = new MaterialRubric();
				rubric.id = _rubric.id;
				rubric.title = _rubric.title;
				
				rubrics.push(rubric);
			}
		
		}
	}

}


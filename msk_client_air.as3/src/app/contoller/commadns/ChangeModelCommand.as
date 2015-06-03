package app.contoller.commadns
{
	import app.contoller.events.ChangeModelOut;
	import app.model.dataall.IAllNewsModel;
	import app.model.dataemploy.IEmployModel;
	import app.model.datafact.IFactsModel;
	import app.model.datageo.IGeoModel;
	import app.model.datahotnews.IHotNewsModel;
	import app.model.dataphoto.IPhotoNewsModel;
	import app.model.datavideo.IVideoNewsModel;
	import org.robotlegs.mvcs.Command;
	
	public class ChangeModelCommand extends Command
	{
		[Inject]
		public var photoNewsModel:IPhotoNewsModel;
		[Inject]
		public var allnewsModel:IAllNewsModel;
		[Inject]
		public var videoNewsModel:IVideoNewsModel;
		[Inject]
		public var factModel:IFactsModel;		
		[Inject]
		public var employModel:IEmployModel;
		[Inject]
		public var hotNewsModel:IHotNewsModel;		
		[Inject]
		public var geoModel:IGeoModel;		
		[Inject]
		public var evt:ChangeModelOut;
		
		override public function execute():void
		{			
			allnewsModel.setModel(evt);
			photoNewsModel.setModel(evt);
			videoNewsModel.setModel(evt);
			factModel.setModel(evt);
			geoModel.setModel(evt);
			hotNewsModel.setModel(evt);
			employModel.setModel(evt);
		}
	}
}
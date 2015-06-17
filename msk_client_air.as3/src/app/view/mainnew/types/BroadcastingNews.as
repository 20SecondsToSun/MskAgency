package app.view.mainnew.types 
{
	import app.model.materials.Material;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class BroadcastingNews extends MainType
	{
		override  public function show(mat:Material):void
		{
			this.mat = mat;
		}		
	}
}
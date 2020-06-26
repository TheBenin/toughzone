package timewave.levels 
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxTilemap;
	import timewave.core.assets.Images;
	/**
	 * ...
	 * @author ...
	 */
	public class Details extends FlxGroup
	{
		
		[Embed(source = '../../../../Design/Release/levels/level0/layer2.txt', mimeType = "application/octet-stream")] public var detail0:Class;
		[Embed(source = '../../../../Design/Release/levels/level1/layer2.txt', mimeType = "application/octet-stream")] public var detail1:Class;
		[Embed(source = '../../../../Design/Release/levels/level2/layer2.txt', mimeType = "application/octet-stream")] public var detail2:Class;
		[Embed(source = '../../../../Design/Release/levels/level3/layer2.txt', mimeType = "application/octet-stream")] public var detail3:Class;
		[Embed(source = '../../../../Design/Release/levels/level4/layer2.txt', mimeType = "application/octet-stream")] public var detail4:Class;
		[Embed(source = '../../../../Design/Release/levels/level5/layer2.txt', mimeType = "application/octet-stream")] public var detail5:Class;
		[Embed(source = '../../../../Design/Release/levels/level6/layer2.txt', mimeType = "application/octet-stream")] public var detail6:Class;
		[Embed(source = '../../../../Design/Release/levels/level7/layer2.txt', mimeType = "application/octet-stream")] public var detail7:Class;
		[Embed(source = '../../../../Design/Release/levels/level8/layer2.txt', mimeType = "application/octet-stream")] public var detail8:Class;
		[Embed(source = '../../../../Design/Release/levels/level9/layer2.txt', mimeType = "application/octet-stream")] public var detail9:Class;
		[Embed(source = '../../../../Design/Release/levels/level10/layer2.txt', mimeType = "application/octet-stream")] public var detail10:Class;
		[Embed(source = '../../../../Design/Release/levels/level11/layer2.txt', mimeType = "application/octet-stream")] public var detail11:Class;
		[Embed(source = '../../../../Design/Release/levels/level12/layer2.txt', mimeType = "application/octet-stream")] public var detail12:Class;
		[Embed(source = '../../../../Design/Release/levels/level13/layer2.txt', mimeType = "application/octet-stream")] public var detail13:Class;
		[Embed(source = '../../../../Design/Release/levels/level14/layer2.txt', mimeType = "application/octet-stream")] public var detail14:Class;
		[Embed(source = '../../../../Design/Release/levels/level15/layer2.txt', mimeType = "application/octet-stream")] public var detail15:Class;
		
		private const arrayDetail:Array = [detail0,detail1,detail2,detail3,detail4,detail5,detail6,detail7,detail8,detail9,detail10,detail11,detail12,detail13,detail14,detail15];
		
		private const layer1:FlxTilemap = new FlxTilemap();
		
		public function Details(level:uint = 0) 
		{
			layer1.loadMap(new arrayDetail[level], Images.ImgTiles, 32, 32);
			add(layer1, true);
		}
		
		public function loadMap(stage:uint):void {
			layer1.reset(0, 0);
			layer1.loadMap(new arrayDetail[stage], Images.ImgTiles, 32, 32);
		}
		
	}

}
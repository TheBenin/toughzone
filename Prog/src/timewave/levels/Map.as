package timewave.levels 
{
	import org.flixel.*;
	import timewave.core.assets.Images;
	/**
	 * ...
	 * @author ...
	 */
	public class Map extends FlxGroup
	{
		[Embed(source = '../../../../Design/Release/levels/level0/layer0.txt', mimeType = "application/octet-stream")] private static var Map0Layer1:Class;
		[Embed(source = '../../../../Design/Release/levels/level0/layer1.txt', mimeType = "application/octet-stream")] private static var Map0Layer2:Class;
		
		[Embed(source = '../../../../Design/Release/levels/level1/layer0.txt', mimeType = "application/octet-stream")] private static var Map1Layer1:Class;
		[Embed(source = '../../../../Design/Release/levels/level1/layer1.txt', mimeType = "application/octet-stream")] private static var Map1Layer2:Class;
		
		[Embed(source = '../../../../Design/Release/levels/level2/layer0.txt', mimeType = "application/octet-stream")] private static var Map2Layer1:Class;
		[Embed(source = '../../../../Design/Release/levels/level2/layer1.txt', mimeType = "application/octet-stream")] private static var Map2Layer2:Class;
		
		[Embed(source = '../../../../Design/Release/levels/level3/layer0.txt', mimeType = "application/octet-stream")] private static var Map3Layer1:Class;
		[Embed(source = '../../../../Design/Release/levels/level3/layer1.txt', mimeType = "application/octet-stream")] private static var Map3Layer2:Class;
		
		[Embed(source = '../../../../Design/Release/levels/level4/layer0.txt', mimeType = "application/octet-stream")] private static var Map4Layer1:Class;
		[Embed(source = '../../../../Design/Release/levels/level4/layer1.txt', mimeType = "application/octet-stream")] private static var Map4Layer2:Class;
		
		[Embed(source = '../../../../Design/Release/levels/level5/layer0.txt', mimeType = "application/octet-stream")] private static var Map5Layer1:Class;
		[Embed(source = '../../../../Design/Release/levels/level5/layer1.txt', mimeType = "application/octet-stream")] private static var Map5Layer2:Class;
		
		[Embed(source = '../../../../Design/Release/levels/level6/layer0.txt', mimeType = "application/octet-stream")] private static var Map6Layer1:Class;
		[Embed(source = '../../../../Design/Release/levels/level6/layer1.txt', mimeType = "application/octet-stream")] private static var Map6Layer2:Class;
		
		[Embed(source = '../../../../Design/Release/levels/level7/layer0.txt', mimeType = "application/octet-stream")] private static var Map7Layer1:Class;
		[Embed(source = '../../../../Design/Release/levels/level7/layer1.txt', mimeType = "application/octet-stream")] private static var Map7Layer2:Class;
		
		[Embed(source = '../../../../Design/Release/levels/level8/layer0.txt', mimeType = "application/octet-stream")] private static var Map8Layer1:Class;
		[Embed(source = '../../../../Design/Release/levels/level8/layer1.txt', mimeType = "application/octet-stream")] private static var Map8Layer2:Class;
		
		[Embed(source = '../../../../Design/Release/levels/level9/layer0.txt', mimeType = "application/octet-stream")] private static var Map9Layer1:Class;
		[Embed(source = '../../../../Design/Release/levels/level9/layer1.txt', mimeType = "application/octet-stream")] private static var Map9Layer2:Class;
		
		[Embed(source = '../../../../Design/Release/levels/level10/layer0.txt', mimeType = "application/octet-stream")] private static var Map10Layer1:Class;
		[Embed(source = '../../../../Design/Release/levels/level10/layer1.txt', mimeType = "application/octet-stream")] private static var Map10Layer2:Class;
		
		[Embed(source = '../../../../Design/Release/levels/level11/layer0.txt', mimeType = "application/octet-stream")] private static var Map11Layer1:Class;
		[Embed(source = '../../../../Design/Release/levels/level11/layer1.txt', mimeType = "application/octet-stream")] private static var Map11Layer2:Class;
		
		[Embed(source = '../../../../Design/Release/levels/level12/layer0.txt', mimeType = "application/octet-stream")] private static var Map12Layer1:Class;
		[Embed(source = '../../../../Design/Release/levels/level12/layer1.txt', mimeType = "application/octet-stream")] private static var Map12Layer2:Class;
		
		[Embed(source = '../../../../Design/Release/levels/level13/layer0.txt', mimeType = "application/octet-stream")] private static var Map13Layer1:Class;
		[Embed(source = '../../../../Design/Release/levels/level13/layer1.txt', mimeType = "application/octet-stream")] private static var Map13Layer2:Class;
		
		[Embed(source = '../../../../Design/Release/levels/level14/layer0.txt', mimeType = "application/octet-stream")] private static var Map14Layer1:Class;
		[Embed(source = '../../../../Design/Release/levels/level14/layer1.txt', mimeType = "application/octet-stream")] private static var Map14Layer2:Class;
		
		[Embed(source = '../../../../Design/Release/levels/level15/layer0.txt', mimeType = "application/octet-stream")] private static var Map15Layer1:Class;
		[Embed(source = '../../../../Design/Release/levels/level15/layer1.txt', mimeType = "application/octet-stream")] private static var Map15Layer2:Class;
		
		private static const arrayLayers1:Array = [Map0Layer1,Map1Layer1,Map2Layer1,Map3Layer1,Map4Layer1,Map5Layer1,Map6Layer1,Map7Layer1,Map8Layer1,Map9Layer1,Map10Layer1,Map11Layer1,Map12Layer1,Map13Layer1,Map14Layer1,Map15Layer1];
		private const arrayLayers2:Array = [Map0Layer2,Map1Layer2,Map2Layer2,Map3Layer2,Map4Layer2,Map5Layer2,Map6Layer2,Map7Layer2,Map8Layer2,Map9Layer2,Map10Layer2,Map11Layer2,Map12Layer2,Map13Layer2,Map14Layer2,Map15Layer2];
		
		/** Para, no comeco do aplicativo, usar para sortear onde que aparecera' a metrica "Hello! ..." */
		static public const NMaps:uint = arrayLayers1.length;
		
		private const layer1:FlxTilemap = new FlxTilemap();
		private const layer2:FlxTilemap = new FlxTilemap();
		
		public function Map(stage:uint = 0) 
		{
			layer1.loadMap(new arrayLayers1[stage], Images.ImgTiles, 32, 32);
			layer1.drawIndex = 1;
			layer1.collideIndex	= 168;
			layer1.fixed = true;
			add(layer1, true);
			
			layer2.loadMap(new arrayLayers2[stage], Images.ImgTiles, 32, 32);
			layer2.drawIndex = 1;
			layer2.collideIndex = 168;
			layer2.fixed = true;
			add(layer2, true);
		}
		
		public function get mapHeight():Number {
			return layer1.height;
		}
		
		public function get mapWidth():Number {
			return layer1.width;
		}
		
		public function loadMap(stage:uint):void {
			layer1.reset(0, 0);
			layer2.reset(0, 0);
			layer1.loadMap(new arrayLayers1[stage], Images.ImgTiles, 32, 32);
			layer2.loadMap(new arrayLayers2[stage], Images.ImgTiles, 32, 32);
		}
		
	}

}
package timewave.utils.pointburst 
{
	import org.flixel.FlxG;
	import org.flixel.FlxText;
	import timewave.core.globals.TopLevel;
	import timewave.states.Playstate;
	/**
	 * ...
	 * @author Wolff
	 */
	public class PointBurst
	{
		
		public function PointBurst() 
		{
			
		}
		
		public static function createBigText(text:String,posX:uint,posY:uint):void {
			(TopLevel.actualState as Playstate).groupParticles.add(new pointText(text,posX,posY,1000, 0xffffff));
		}
		
		public static function createTimeText(text:String,posX:uint,posY:uint):void {
			(TopLevel.actualState as Playstate).groupParticles.add(new pointText(text,posX,posY,1000, 0xffff00, 20));
		}
		
	}

}
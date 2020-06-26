package timewave.levels 
{
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import timewave.core.assets.Images;
	import timewave.player.PlayerTank;
	
	/**
	 * ...
	 * @author Wolff
	 */
	public class PowerUpObject extends FlxSprite
	{
		private var powerType:uint;
		public var pointsGive:Boolean = false;
		
		public static const SPEED_UP:uint = 0;
		public static const LIFE_UP:uint = 1;
		public static const TRY_UP:uint = 2;
		public static const WEAPON_UP:uint = 3;
		public static const BOMB_UP:uint = 4;
		
		public function PowerUpObject(type:uint) 
		{
			this.powerType = type;
			this.loadGraphic(Images.POWERUP_IMGS_ARRAY[type], false, false, Images.POWERUP_IMGS_ARRAY[type].width, Images.POWERUP_IMGS_ARRAY[type].height);
		}
		
		public function get type():uint {
			return this.powerType;
		}
		
	}

}
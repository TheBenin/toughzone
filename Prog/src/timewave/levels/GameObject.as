package timewave.levels 
{
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Wolff
	 */
	public class GameObject extends FlxSprite
	{
		private var type:Number;
		
		public function GameObject(type:Number,img:Class) 
		{
			if (type == 25) {
				this.health = 1;
			}else if (type == 26) {
				this.health = 3;
			}
			this.loadGraphic(img, false, false,img.width,img.height);
		}
		
		override public function hurt(Damage:Number):void 
		{
			this.flicker(0.2);
			super.hurt(Damage);
		}
		
	}

}
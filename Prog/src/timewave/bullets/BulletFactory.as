package timewave.bullets 
{
	import timewave.core.assets.Images;
	/**
	 * ...
	 * @author ...
	 */
	public class BulletFactory
	{
		  
		// nao instanciar
		public function BulletFactory() 
		{
			
		}
		
		public static function createPlayerBullet():Bullet {
			return new Bullet(500,600, 1,12,6,Images.ImgBullet); 
		}
		
		public static function createPlayerBulletBuff():Bullet {
			return new Bullet(500,600, 1,12,6,Images.ImgBulletPowerUp,10,10,true,20); 
		}
		
		public static function createEnemyBullet(speed:uint, damage:uint):Bullet {
			return new Bullet(speed,speed + 100, damage,12,6,Images.ImgBulletEnemy);
		}
		
		public static function createPlayerBomb():Bomb {
			return new Bomb(600,1,75);
		}
		
	}

}
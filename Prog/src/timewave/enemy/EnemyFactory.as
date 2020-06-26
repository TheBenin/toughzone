package timewave.enemy 
{
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import timewave.core.assets.Images;
	import timewave.core.globals.TopLevel;
	/**
	 * ...
	 * @author Wolff
	 */
	public class EnemyFactory
	{
		
		public function EnemyFactory() 
		{
			
		}
		
		public static function createBasicEnemy(number:uint):SmallTank {
			var newTank:SmallTank;
			// imagem, hp, speed, delay entre tiros, reward, bullet speed
			
			switch(number) {
				case 1:
				newTank = new SmallTank(Images.ImgObjectsEnemyTank, 1, 100, 1000, 250, 300);
				break;
				
				case 2:
				newTank = new SmallTank(Images.ImgObjectsEnemyTank1, 3, 100, 600, 500, 300);
				break;
				
				case 3:
				newTank = new SmallTank(Images.ImgObjectsEnemyTank2, 2, 120, 800, 500, 310);
				break;
				
				case 4:
				newTank = new SmallTank(Images.ImgObjectsEnemyTank3, 3, 150, 1000, 750, 310);
				break;
				
				case 5:
				newTank = new SmallTank(Images.ImgObjectsEnemyTank4, 5, 100, 800, 1000, 310);
				break;
				
				case 6:
				newTank = new SmallTank(Images.ImgObjectsEnemyTank5, 5, 120, 600, 1250, 300);
				break;
				
				case 7:
				newTank = new SmallTank(Images.ImgObjectsEnemyTank6, 5, 150, 600, 1500, 300);
				break;
				
				case 8:
				newTank = new SmallTank(Images.ImgObjectsEnemyRiverRaid1, 1, 100, 600, 25, 310,0,false,true,15);
				break;
				
				case 9:
				newTank = new SmallTank(Images.ImgObjectsEnemyRiverRaid2, 1, 50, 600, 1000, 320,1);
				break;
				
				
			}
			
			return newTank;
		}
		
		public static function createBasicTurret(number:uint):Turret {
			var newTurret:Turret;
			// imagem, hp, damage, speed, delay entre tiros, reward
			switch(number) {
				case 1:
				newTurret = new Turret(Images.ImgObjectsEnemyTurret, 3, 1, 100, 1000, 750);
				break;
				
				case 2:
				newTurret = new Turret(Images.ImgObjectsEnemyTurret2, 3, 1, 120, 1000, 1000);
				break;
				
				case 3:
				newTurret = new Turret(Images.ImgObjectsEnemyTurret3, 3, 1, 150, 1000, 1250);
				break;
				
				case 4:
				newTurret = new Turret(Images.ImgObjectsEnemyTurret4, 4, 1, 150, 500, 1500);
				break;
				
				case 5:
				newTurret = new Turret(Images.ImgObjectsEnemyTurret5, 5, 1, 150, 500, 1500);
				break;
			}
			return newTurret;
		}
		
		public static function createBasciEnemyBrown():SmallTank {
			return null;
		}
		
	}

}
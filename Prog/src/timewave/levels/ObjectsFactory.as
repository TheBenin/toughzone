﻿package timewave.levels 
{
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import timewave.core.assets.Images;
	import timewave.enemy.EnemyFactory;
	import timewave.enemy.Turret;
	/**
	 * ...
	 * @author Wolff
	 */
	public class ObjectsFactory
	{
		include "../../../../Design/Release/levels/level0/objects.as";
		include "../../../../Design/Release/levels/level1/objects.as";
		include "../../../../Design/Release/levels/level2/objects.as";
		include "../../../../Design/Release/levels/level3/objects.as";
		include "../../../../Design/Release/levels/level4/objects.as";
		include "../../../../Design/Release/levels/level5/objects.as";
		include "../../../../Design/Release/levels/level6/objects.as";
		include "../../../../Design/Release/levels/level7/objects.as";
		include "../../../../Design/Release/levels/level8/objects.as";
		include "../../../../Design/Release/levels/level9/objects.as";
		include "../../../../Design/Release/levels/level10/objects.as";
		include "../../../../Design/Release/levels/level11/objects.as";
		include "../../../../Design/Release/levels/level12/objects.as";
		include "../../../../Design/Release/levels/level13/objects.as";
		include "../../../../Design/Release/levels/level14/objects.as";
		include "../../../../Design/Release/levels/level15/objects.as";
		
		public static const allArrays:Array = [ObjectsFactory.arrayObjects0, ObjectsFactory.arrayObjects1, ObjectsFactory.arrayObjects2, ObjectsFactory.arrayObjects3,
											   ObjectsFactory.arrayObjects4, ObjectsFactory.arrayObjects5, ObjectsFactory.arrayObjects6, ObjectsFactory.arrayObjects7,
											   ObjectsFactory.arrayObjects8, ObjectsFactory.arrayObjects9, ObjectsFactory.arrayObjects10, ObjectsFactory.arrayObjects11,
											   ObjectsFactory.arrayObjects12,ObjectsFactory.arrayObjects13,ObjectsFactory.arrayObjects14,ObjectsFactory.arrayObjects15];
		
		public function ObjectsFactory()
		{
		}
		
		public static function createObjects(type:uint):FlxSprite {
			var newObject:FlxSprite;
			switch(type) {
				
				case 4:
				newObject = EnemyFactory.createBasicEnemy(8);
				break;
				
				case 5:
				newObject = EnemyFactory.createBasicEnemy(9);
				break;
				
				case 6:
				newObject = EnemyFactory.createBasicEnemy(1);
				break;
				
				case 7:
				newObject = EnemyFactory.createBasicEnemy(2);
				break;
				
				case 8:
				newObject = EnemyFactory.createBasicEnemy(3);
				break;
				
				case 9:
				newObject = EnemyFactory.createBasicEnemy(4);
				break;
				
				case 10:
				newObject = EnemyFactory.createBasicEnemy(5);
				break;
				
				case 11:
				newObject = EnemyFactory.createBasicEnemy(6);
				break;
				
				case 12:
				newObject = EnemyFactory.createBasicEnemy(7);
				break;
				
				case 13:
				newObject = EnemyFactory.createBasicTurret(1);
				break;
				
				case 14:
				newObject = EnemyFactory.createBasicTurret(2);
				break;
				
				case 15:
				newObject = EnemyFactory.createBasicTurret(3);
				break;
				
				case 16:
				newObject = EnemyFactory.createBasicTurret(4);
				break;
				
				case 17:
				newObject = EnemyFactory.createBasicTurret(5);
				break;
				
				case 18:
				newObject = new PowerUpObject(PowerUpObject.LIFE_UP);
				break;
				
				case 19:
				newObject = new PowerUpObject(PowerUpObject.SPEED_UP);
				break;
				
				case 20:
				newObject = new PowerUpObject(PowerUpObject.TRY_UP);
				break;
				
				case 21:
				newObject = new PowerUpObject(PowerUpObject.WEAPON_UP);
				break;
				
				case 22:
				newObject = new PowerUpObject(PowerUpObject.BOMB_UP);
				break;
				
				case 30:
				newObject = new BoxObject(Images.ImgObjectsBreakBoxOne,Images.ImgParticleBox, 1);
				break;
				
				case 31:
				newObject = new BoxObject(Images.ImgObjectsBreakBoxTwo,Images.ImgParticleBox, 3);
				break;
				
				case 33:
				newObject = new BoxObject(Images.ImgObjectsBreakWallYellow,Images.ImgParticleParede, 3);
				break;
				
				case 34:
				newObject = new BoxObject(Images.ImgObjectsBreakWallBlue,Images.ImgParticleParede, 3);
				break;
				
				case 35:
				newObject = new BoxObject(Images.ImgObjectsBreakGate,Images.ImgParticleTank, 3);
				break;
				
				case 36:
				newObject = new BoxObject(Images.arrayVerUpCar[Math.round((Images.arrayVerUpCar.length - 1) * Math.random())],Images.ImgParticleParede, 2);
				break;
				
				case 37:
				newObject = new BoxObject(Images.arrayVerDownCar[Math.round((Images.arrayVerDownCar.length  - 1) * Math.random())],Images.ImgParticleParede, 2);
				break;
				
				case 38:
				newObject = new BoxObject(Images.arrayHorzRightCar[Math.round((Images.arrayHorzRightCar.length  - 1) * Math.random())],Images.ImgParticleParede, 2);
				break;
				
				case 39:
				newObject = new BoxObject(Images.arrayHorzLeftCar[Math.round((Images.arrayHorzLeftCar.length  - 1) * Math.random())],Images.ImgParticleParede, 2);
				break;
				
			}
			return newObject;
		}
		
		public static function createBasicTurretBase(number:uint):FlxSprite {
			var newTurret:FlxSprite;
			// imagem, hp, damage, speed, delay entre tiros, reward
			switch(number) {
				case 13:
				newTurret = new FlxSprite(0, 0, Images.ImgObjectsEnemyTurretBody);
				break;
				
				case 14:
				newTurret = new FlxSprite(0, 0, Images.ImgObjectsEnemyTurret2Body);
				break;
				
				case 15:
				newTurret = new FlxSprite(0, 0, Images.ImgObjectsEnemyTurret3Body);
				break;
				
				case 16:
				newTurret = new FlxSprite(0, 0, Images.ImgObjectsEnemyTurret4Body);
				break;
				
				case 17:
				newTurret = new FlxSprite(0, 0, Images.ImgObjectsEnemyTurret5Body);
				break;
			}
			
			return newTurret;
		}
		
		
	}

}
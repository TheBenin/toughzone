package  timewave.states
{
	/**
	 * ...
	 * @author Timewave Games
	 */
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import org.flixel.*;
	import timewave.bullets.Bomb;
	import timewave.bullets.Bullet;
	import timewave.bullets.BulletFactory;
	import timewave.core.assets.Images;
	import timewave.core.assets.Sounds;
	import timewave.core.globals.ScoreTable;
	import timewave.core.globals.TopLevel;
	import timewave.enemy.SmallTank;
	import timewave.enemy.Turret;
	import timewave.levels.BoxObject;
	import timewave.levels.Details;
	import timewave.levels.Map;
	import timewave.levels.ObjectsFactory;
	import timewave.levels.PowerUpObject;
	import timewave.math.SimpleVector;
	import timewave.math.TWMath;
	import timewave.math.Vector2D;
	import timewave.player.PlayerTank;
	import timewave.player.SecondPlayer;
	import timewave.player.TankBody;
	import timewave.utils.pointburst.PointBurst;
	
	public class CoopState extends FlxState
	{
		// timer related
		private var timer:Number;
		private const extraTimeArray:Array = [];
		
		// screen draw
		private const drawMovieClip:MovieClip = new MovieClip();
		
		// hud related
		private const hudGroup:FlxGroup = new FlxGroup();
		private const timerText:FlxText = new FlxText(5, 5, 100, "teste");
		private const scoreText:FlxText = new FlxText(70, 5, 100, "0");
		private const healthText:FlxText = new FlxText(150, 5, 100, "0");
		private const tryText:FlxText = new FlxText(200,5,100,"0");
		private const levelText:FlxText = new FlxText(412, 5, 100, "Level");
		private const bombText:FlxText = new FlxText(300, 5, 50, "0");
		
		// score related
		
		// level related
		public var levels:Map = new Map();
		private var details:Details = new Details();
		private var actualLevel:uint = 0;
		private var gameMode:String;
		
		// player related
		public const player:PlayerTank = new PlayerTank();
		public const secoundPlayer:SecondPlayer = new SecondPlayer();
		private const cameraPlayer:FlxObject = new FlxObject();
		private const PLAYER_MAX_SCREEN_BULLETS:uint = 4;
		private const PLAYER_MAX_SCREEN_BULLETS_POWERUP:uint = 5;
		private const PLAYER_MAX_SCREEN_BOMBS:uint = 1;
		private const PLAYER_AUTO_DELAY:Number = 0.1;
		private const PLAYER_BOMB_DELAY:Number = 0.3;
		private var timerDelayShoot:Number = 0;
		private var timerDelayBomb:Number = 0;
		
		// objects related
		private var groupBullet:FlxGroup = new FlxGroup();
		private var groupBomb:FlxGroup = new FlxGroup();
		private var groupEnemyBullet:FlxGroup = new FlxGroup();
		private var groupTurretBullet:FlxGroup = new FlxGroup();
		private var groupBoxes:FlxGroup = new FlxGroup();
		private var groupPowerUps:FlxGroup = new FlxGroup();
		
		// enemies related
		private var groupEnemies:FlxGroup = new FlxGroup();
		private var groupTurrets:FlxGroup = new FlxGroup();
		public var groupDeadEnemies:FlxGroup = new FlxGroup();
		private const ENEMY_DISTANCE_TO_SHOOT:Number = 500;
		
		// particles related
		public const groupParticles:FlxGroup = new FlxGroup();
		
		// objects to be cleaned
		private const objectsGroupArray:Array = [groupBullet,groupBomb,groupEnemyBullet,groupBoxes,groupPowerUps,groupEnemies,groupParticles,groupDeadEnemies,groupTurrets,groupTurretBullet];
		
		public function CoopState() 
		{
			player.body.x = levels.mapWidth >> 1;
			player.body.y = levels.mapHeight - 100;
			
			secoundPlayer.x = levels.mapWidth >> 1;
			secoundPlayer.y = levels.mapHeight - 40;
			
			cameraPlayer.y = player.y + 100;
			cameraPlayer.x = player.x;
			
			this.gameMode = TopLevel.gameMode;
			
			FlxG.stage.addChild(drawMovieClip);
		}
		
		override public function create():void 
		{
			//TopLevel.actualState = this;
			
			loadMap(actualLevel);
			
			add(levels);
			
			add(groupEnemies);
			add(groupPowerUps);
			add(groupBoxes);
			add(groupDeadEnemies);
			add(groupTurrets);
			add(groupEnemyBullet);
			add(groupTurretBullet);
			add(groupParticles);
			add(groupBullet);
			add(groupBomb);
			
			add(player);
			add(secoundPlayer);
			
			add(details);
			
			FlxG.mouse.show();
			FlxG.mouse.load(Images.ImgCrossHair, 7, 7);
			
			moveCamera();
			createObjects();
			
			FlxG.followBounds(0, 0, levels.mapWidth, levels.mapHeight - 32);
			
			timer = 1;
			
			TopLevel.bombs = 10;
			
			createHud();
			
			switch(gameMode) {
				case "normal":
					TopLevel.trys = 3;
					player.health = 3;
				break;
				
				case "survival":
					TopLevel.trys = 1;
					player.health = 3;
				break;
				
				case "survival+":
					TopLevel.trys = 1;
					player.health = 1;
				break;
			}
			
			timerDelayShoot = PLAYER_AUTO_DELAY;
			timerDelayBomb = PLAYER_BOMB_DELAY;
			
			super.create();
		}
		
		override public function update():void 
		{
			moveCamera();
			checkForExtraTime();
			changeTexts();
			
			player.collide(groupBoxes);
			player.collide(groupEnemies);
			player.collide(groupTurrets);
			
			groupEnemies.collide(groupBoxes);
			groupEnemyBullet.collide(groupBoxes);
			
			FlxU.overlap(groupEnemies, groupBullet, overlaps);
			FlxU.overlap(groupTurrets, groupBullet, overlapsTurretBullet);
			FlxU.overlap(groupBoxes, groupBullet, overlapsBoxBullet);
			FlxU.overlap(player.body, groupPowerUps, overlapsPlayerPowerUps);
			FlxU.overlap(player.body, groupEnemyBullet, overlapsPlayerEneBullet);
			FlxU.overlap(player.body, groupTurretBullet, overlapsPlayerTurretBullet);
			
			levels.collide(player);
			levels.collide(groupBullet);
			levels.collide(groupEnemies);
			levels.collide(groupEnemyBullet);
			
			timerDelayShoot -= FlxG.elapsed;
			timerDelayBomb -= FlxG.elapsed;
			
			if(player.tankDamage <= 1){
				if (FlxG.mouse.justPressed()) {
					shoot();
				}
			}else {
				if (FlxG.mouse.pressed() && timerDelayShoot <= 0) {
					shoot();
					timerDelayShoot = PLAYER_AUTO_DELAY;
				}
			}
			
			if (FlxG.keys.pressed("SPACE") && timerDelayBomb <= 0) {
				shootBomb();
				timerDelayBomb = PLAYER_BOMB_DELAY;
			}
			
			if (FlxG.keys.justPressed("M")) {
				if (actualLevel < 15) loadNextMap(1); timer = 1;
			}
			
			if (FlxG.keys.justPressed("N")) {
				if(actualLevel > 0) loadNextMap(-1); timer = 1;
			}
			
			if (FlxG.keys.justPressed("K")) {
				timer += 15;
			}
			
			if (FlxG.keys.justPressed("L")) {
				TopLevel.trys++;
			}
			
			if (FlxG.keys.justPressed("J")) {
				TopLevel.bombs++;
			}
			
			if (timer > 0) countTime();
			
			checkForGameOver();
			removeFromBorders();
			
			if (player.body.y < 0) loadNextMap(1);
			
			super.update();
		}
		
		private function loadNextMap(jumps:Number):void {
			if (actualLevel == 15) {
				FlxG.state = new EndState();
				return;
			}
			
			actualLevel += jumps;
			levels.reset(0, 0);
			loadMap(actualLevel);
			TopLevel.score += Math.round(timer) * 100;
			TopLevel.trys++;
			resetStage();
		}
		
		private function removeFromBorders():void {
			if (player.body.x + player.body.width > levels.mapWidth + 24) {
				player.body.x = levels.mapWidth + 24 - player.body.width;
			}else if (player.body.x < -24) {
				player.body.x = -24;
			}
		}
		
		private function loadMap(level:uint):void {
			this.levels.loadMap(level);
			this.details.loadMap(level);
			FlxG.followBounds(0, 0, levels.mapWidth, levels.mapHeight - 32);
		}
		
		private function changeTexts():void {
			scoreText.text = String(TopLevel.score);
			levelText.text = "Level " + String(actualLevel);
			bombText.text = String(TopLevel.bombs);
			
			if (gameMode == "survival+") return;
			healthText.text = String(player.health);
			
			if (gameMode == "survival") return;
			tryText.text = String(TopLevel.trys);
		}
		
		private function countTime():void {
			timer -= FlxG.elapsed;
			timerText.text = String(Math.round(timer) + "s");
			if (timer < 0) {
				player.kill();
			}
		}
		
		private function checkForGameOver():void {
			if (TopLevel.trys <= 0) {
				FlxG.state = new GameOverState();
			}
		}
		
		private function createHud():void {
			
			hudGroup.x = 0;
			hudGroup.y = 0;
			
			add(hudGroup);
			
			hudGroup.scrollFactor.y = 0;
			hudGroup.scrollFactor.x = 0;
			
			timerText.size = 20;
			timerText.shadow = 1;
			
			scoreText.size = 20;
			scoreText.shadow = 1;
			scoreText.color = 0xffff00;
			
			hudGroup.add(scoreText, true);
			hudGroup.add(timerText, true);
			
			levelText.size = 20;
			levelText.shadow = 1;
			levelText.color = 0xffffff;
			
			bombText.size = 20;
			bombText.shadow = 1;
			bombText.color = 0xffffff;
			
			hudGroup.add(scoreText, true);
			hudGroup.add(timerText, true);
			hudGroup.add(levelText, true);
			hudGroup.add(bombText, true);
			
			if (gameMode == "survival+") return;
			
			healthText.size = 20;
			healthText.shadow = 1;
			healthText.color = 0x00ff00;
			
			hudGroup.add(healthText, true);
			
			if (gameMode == "survival") return;
			
			tryText.size = 20;
			tryText.shadow = 1;
			tryText.color = 0xff0000;
			
			hudGroup.add(tryText, true);
		}
		
		private function clearAllObjects():void {
			
			for (var i:int = 0; i < objectsGroupArray.length; i++) {
				
				objectsGroupArray[i].kill();
				
				for (var j:uint = 0; j < objectsGroupArray[i].members.lenght; ++j) {
					objectsGroupArray[i].remove(objectsGroupArray[i].members[j],true);
				}
				objectsGroupArray[i].reset(0, 0);
			}
			
			extraTimeArray.length = 0;
		}
		
		public function resetStage():void {
			TopLevel.trys--;
			
			if (player.health <= 0) {
				timer = 1;
				player.resetTank();
				
				switch(gameMode) {
					case "normal":
						player.health = 3;
					break;
					
					case "survival":
						player.health = 3;
					break;
					
					case "survival+":
						player.health = 1;
					break;
				}
			}
			
			player.body.resetSpeedPowerUp();
			
			clearAllObjects();
			
			player.body.x = levels.mapWidth >> 1;
			player.body.y = levels.mapHeight - 100;
			
			moveCamera();
			
			createObjects();
			
			FlxG.flash.start(0xff000000, 1);
		}
		
		private function createObjects():void {
			
			for (var i:int = 0; i < ObjectsFactory.allArrays[actualLevel].length; i++) 
			{
				if (ObjectsFactory.allArrays[actualLevel][i].type >= 48 && ObjectsFactory.allArrays[actualLevel][i].type <= 53) {
					extraTimeArray.push({y:ObjectsFactory.allArrays[actualLevel][i].y,type:ObjectsFactory.allArrays[actualLevel][i].type});
					continue;
				}
				
				var newObject:FlxObject = ObjectsFactory.createObjects(ObjectsFactory.allArrays[actualLevel][i].type);
				
				if (newObject == null) continue;
				
				if ((gameMode == "survival" || gameMode == "survival+") && ObjectsFactory.allArrays[actualLevel][i].type == 20) continue;
				
				if (gameMode == "survival+" && ObjectsFactory.allArrays[actualLevel][i].type == 18) continue;
				
				newObject.x = ObjectsFactory.allArrays[actualLevel][i].x;
				newObject.y = ObjectsFactory.allArrays[actualLevel][i].y;
				
				if (ObjectsFactory.allArrays[actualLevel][i].type >= 13 && ObjectsFactory.allArrays[actualLevel][i].type <= 17) {
					var turretBase:FlxSprite = ObjectsFactory.createBasicTurretBase(ObjectsFactory.allArrays[actualLevel][i].type);
					turretBase.x = newObject.x;
					turretBase.y = newObject.y;
					newObject.x += 17;
					newObject.y += 10;
					groupDeadEnemies.add(turretBase);
				}
				
				switch(FlxU.getClassName(newObject,true)) {
					case "BoxObject":
						groupBoxes.add(newObject);
					break;
					
					case "GameObject":
						
					break;
					
					case "PowerUpObject":
						groupPowerUps.add(newObject);
					break;
					
					case "SmallTank":
						groupEnemies.add(newObject);
					break;
					
					case "Turret":
						groupTurrets.add(newObject);
					break;
				}
			}
			extraTimeArray.sortOn("y", Array.DESCENDING);
		}
		
		private function moveCamera():void {
			FlxG.follow(cameraPlayer);
			cameraPlayer.x = (player.body.x + secoundPlayer.x) >> 1;
			cameraPlayer.y = (player.body.y + secoundPlayer.y) >> 1;
		}
		
		private function checkForExtraTime():void {
			for (var i:int = 0; i < extraTimeArray.length; i++) {
				if (player.body.y < extraTimeArray[i].y && player.body.y != 0) {
					giveTime(extraTimeArray[i].type);
					extraTimeArray.shift();
				}
			}
		}
		
		private function overlaps(object1:FlxSprite,object2:FlxSprite):void {
			if (object1 is Bullet) {
				object1.kill();
				object2.hurt(player.tankDamage);
			}else if (object2 is Bullet) {
				object2.kill();
				object1.hurt(player.tankDamage);
			}
		}
		
		private function overlapsTurretBullet(object1:FlxSprite,object2:FlxSprite):void {
			if (object1 is Bullet) {
				object1.kill();
				object2.hurt(player.tankDamage);
			}else if (object2 is Bullet) {
				object2.kill();
				object1.hurt(player.tankDamage);
			}
		}
		
		private function overlapsBoxBullet(object1:FlxSprite, object2:FlxSprite):void {
			if (object1 is Bullet) {
				object1.kill();
				object2.hurt(player.tankDamage);
			}else if (object1 is BoxObject) {
				object1.hurt(player.tankDamage);
				object2.kill();
			}
		}
		
		private function overlapsPlayerPowerUps(object1:TankBody, object2:PowerUpObject):void {
			object1.powerUp(object2.type);
			object2.kill();
		}
		
		private function overlapsPlayerEneBullet(object1:TankBody,object2:Bullet):void {
			player.hurt(object2.damage);
			object2.kill();
		}
		
		private function overlapsPlayerTurretBullet(object1:TankBody,object2:Bullet):void {
			player.hurt(object2.damage);
			object2.kill();
		}
		
		private function overlapsBombBox(object1:Bomb, object2:BoxObject):void {
			if (object1.scale.x < 1.1) {
				object1.collide(object2);
			}
		}
		
		private function shoot():void {
			
			if (groupBullet.countLiving() > PLAYER_MAX_SCREEN_BULLETS - 1 && player.tankDamage == 1 || groupBullet.countLiving() > PLAYER_MAX_SCREEN_BULLETS_POWERUP - 1 && player.tankDamage == 2 || player.health <= 0) return;
			
			var actualBullet:Bullet;
			
			if(player.tankDamage == 1){
				actualBullet = BulletFactory.createPlayerBullet();
			}else {
				actualBullet = BulletFactory.createPlayerBulletBuff();
			}
			
			actualBullet.setAngleToVelocity(player.turretAngle);
			
			actualBullet.x = player.cannonEnd.x;
			actualBullet.y = player.cannonEnd.y;
			
			if (player.body.tankDamage > 1) {
				actualBullet.velocity.x += player.body.velocity.x >> 3;
				actualBullet.velocity.y += player.body.velocity.y >> 3;
				actualBullet.speed = actualBullet.speedBuffed;
				actualBullet.updateVelocity();
			}else {
				actualBullet.velocity.x += player.body.velocity.x >> 2;
				actualBullet.velocity.y += player.body.velocity.y >> 2;
			}
			
			groupBullet.add(actualBullet);
			
			ScoreTable.shootsTotal++;
			
			if (Math.round(Math.random())) {
				FlxG.play(Sounds.SndTurretShot1);
			}else {
				FlxG.play(Sounds.SndTurretShot2);
			}
		}
		
		private function shootBomb():void {
			
			if (player.health <= 0 || TopLevel.bombs <= 0) return;
			
			var actualBullet:Bomb = BulletFactory.createPlayerBomb();
			
			actualBullet.setAngleToVelocity(player.turretAngle);
			
			actualBullet.x = player.cannonEnd.x;
			actualBullet.y = player.cannonEnd.y;
			
			actualBullet.addMomentum(player.body.velocity.x >> 1, player.body.velocity.y >> 1);
			
			groupBomb.add(actualBullet);
			
			TopLevel.bombs--;
		}
		
		public function shootEnemy(enemy:SmallTank):void {
			
			if (player.body.y - enemy.y > ENEMY_DISTANCE_TO_SHOOT) return;
			
			var actualBullet:Bullet = BulletFactory.createEnemyBullet(enemy.bulletSpeed,enemy.bulletDamage);
			
			actualBullet.x = enemy.x + enemy.width/2;
			actualBullet.y = enemy.y;
			
			if (player.body.y > enemy.y) {
				actualBullet.velocity.y = actualBullet.speed;
				actualBullet.angle = 90;
				enemy.angle = 0;
				actualBullet.y += enemy.height;
			}else {
				actualBullet.velocity.y = -actualBullet.speed;
				actualBullet.angle = 270;
				enemy.angle = 180;
				actualBullet.y -= enemy.height;
			}
			
			groupEnemyBullet.add(actualBullet);
		}
		
		public function shootTurret(enemy:Turret):void {
			
			enemy.angleTurret = FlxU.getAngle(player.body.x - enemy.turretCenter.x, player.body.y - enemy.turretCenter.y);
			
			if (player.body.y - enemy.y > ENEMY_DISTANCE_TO_SHOOT) return;
			
			var actualBullet:Bullet = BulletFactory.createEnemyBullet(enemy.turretSpeed, enemy.turretDamage);
			
			var vector:SimpleVector = Vector2D.createBySizeAndAngle(44, TWMath.degToRad(enemy.angle));
			
			actualBullet.x = enemy.x + enemy.origin.x + vector.x;
			actualBullet.y = enemy.y + enemy.origin.y + vector.y;
			
			actualBullet.angle = enemy.angle;
			actualBullet.updateVelocity();
			
			groupTurretBullet.add(actualBullet);
		}
		
		public function areaDamage(bomb:Bomb):void {
			var targetTank:SmallTank;
			var targetBox:BoxObject;
			var targetTurret:Turret;
			
			var targetDis:Number;
			
			FlxG.quake.start(0.005, 0.2);
			
			graphics.lineStyle(2,0x00000,1);
			drawMovieClip.graphics.drawCircle(bomb.getScreenXY().x, bomb.getScreenXY().y,bomb.radiusAnim);
			
			for (var i:int = 0; i < groupEnemies.members.length; ++i) {
				
				targetTank = groupEnemies.members[i];
				targetDis = TWMath.getDistanceSqr(new Point(targetTank.x, targetTank.y),new Point(bomb.x, bomb.y));
				
				if (targetDis < bomb.radius && targetTank.onScreen && !targetTank.dead) {
					targetTank.setDeath(0.05 + (targetDis/bomb.radius * 0.2), bomb.damage);
				}
			}
			
			for (i = 0; i < groupBoxes.members.length; ++i) {
				
				targetBox = groupBoxes.members[i];
				targetDis = TWMath.getDistanceSqr(new Point(targetBox.x, targetBox.y), new Point(bomb.x, bomb.y));
				
				if (targetDis < bomb.radius && targetBox.onScreen && !targetBox.dead) {
					targetBox.setDeath(0.05 + (targetDis/bomb.radius * 0.2), bomb.damage);
				}
			}
			
			for (i = 0; i < groupTurrets.members.length; ++i) {
				
				targetTurret = groupTurrets.members[i];
				targetDis = TWMath.getDistanceSqr(new Point(targetTurret.x, targetTurret.y), new Point(bomb.x, bomb.y));
				
				if (targetDis < bomb.radius && targetTurret.onScreen && !targetTurret.dead) {
					targetTurret.setDeath(0.05 + (targetDis/bomb.radius * 0.2), bomb.damage);
				}
			}
		}
		
		private function giveTime(type:uint):void {
			if (player.body.y == 0) return;
			switch(type) {
				case 48:
				timer += 10;
				PointBurst.createTimeText("+10", levels.mapWidth >> 1 - 100, cameraPlayer.y);
				break;
				
				case 49:
				timer += 15;
				PointBurst.createTimeText("+15", levels.mapWidth >> 1 - 100, cameraPlayer.y);
				break;
				
				case 50:
				timer += 20;
				PointBurst.createTimeText("+20", levels.mapWidth >> 1 - 100, cameraPlayer.y);
				break;
				
				case 51:
				timer += 25;
				PointBurst.createTimeText("+25", levels.mapWidth >> 1 - 100, cameraPlayer.y);
				break;
				
				case 52:
				timer += 30;
				PointBurst.createTimeText("+30", levels.mapWidth >> 1 - 100, cameraPlayer.y);
				break;
				
				case 53:
				timer += 35;
				PointBurst.createTimeText("+35", levels.mapWidth >> 1 - 100, cameraPlayer.y);
				break;
			}
		}
		
		public function get playerCenter():Point {
			return new Point(player.body.x , player.body.y);
		}
		
	}

}
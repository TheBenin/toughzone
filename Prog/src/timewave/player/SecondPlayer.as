package timewave.player 
{
	import org.flixel.*;
	import timewave.core.assets.Images;
	import timewave.core.globals.ScoreTable;
	import timewave.math.*;
	import timewave.core.globals.TopLevel;
	import timewave.levels.PowerUpObject;
	import timewave.states.Playstate;
	import timewave.utils.pointburst.PointBurst;
	/**
	 * ...
	 * @author Timewave Games
	 */
	public class SecondPlayer extends FlxSprite
	{
		
		private const bodyVelocity:uint = 300;
		private const bodyVelocityBoost:uint = 350;
		
		private const bodyRotation:uint = 5;
		private const bodyBoostRotation:uint = 15;
		
		private var bodyActualRotation:uint = 5;
		
		private var actualVelocity:Number;
		
		public var tankDamage:Number = 1;
		
		public var positionVector:SimpleVector = Vector2D.createSimpleVector(0, 0);
		public var velocityVector:SimpleVector = Vector2D.createSimpleVector(0, 0);
		
		public function SecondPlayer(posX:Number = 0,posY:Number = 0) 
		{
			this.createGraphic(32, 32, 0xffffff);
			
			this.health = 3;
			this.x = posX;
			this.y = posY;
			this.actualVelocity = bodyVelocity;
			
			this.fixed = true;
		}
		
		override public function update():void 
		{
			if (this.angle > 360) this.angle -= 360;
			if (this.angle < 0) this.angle = 360 + this.angle;
			
			positionVector.x = this.x;
			positionVector.y = this.y;
			
			this.velocity.x *= 0.6;
			this.velocity.y *= 0.6;
			
			if (this.angle % bodyActualRotation != 0) {
				this.angle++;
			}
			
			if (pressLeft()) {
				
				if (pressUp()) {
					
					if (this.angle != 225 && this.angle != 45) {
						if (this.angle >= 135 && this.angle < 225 || this.angle > 315 || this.angle < 45) {
							this.angle += bodyActualRotation;
						}else if (this.angle <= 315 && this.angle > 225 || this.angle > 45 && this.angle < 135) {
							this.angle -= bodyActualRotation;
						}
					}
					
					if (this.angle >= 315 || this.angle <= 135) {
						makeMove(true);
					}else {
						makeMove();
					}
					/*	if (this.velocity.x < -bodyVelocity) {
							this.velocity.x += bodyAcel;
						}else {
							this.velocity.x -= bodyAcel;
						}
						
						if (this.velocity.y < -bodyVelocity) {
							this.velocity.y += bodyAcel;
						}else {
							this.velocity.y -= bodyAcel;
						}*/
					
					/*if (this.velocity.x < -bodyVelocity) {
						this.velocity.x += bodyAcel;
					}else {
						this.velocity.x -= bodyAcel;
					}
					
					if (this.velocity.y < -bodyVelocity) {
						this.velocity.y += bodyAcel;
					}else {
						this.velocity.y -= bodyAcel;
					}*/
					
				}else if (pressDown()) {
					
					if (this.angle != 315 && this.angle != 135) {
						if (this.angle > 225 && this.angle < 315 || this.angle >= 45 && this.angle < 135) {
							this.angle += bodyActualRotation;
						}else if (this.angle < 45 || this.angle > 315 || this.angle <= 225 && this.angle > 135) {
							this.angle -= bodyActualRotation;
						}
					}
					
					if (this.angle >= 45 && this.angle <= 225) {
						makeMove();
					}else {
						makeMove(true);
					}
					
					//if(this.angle >
						/*if (this.velocity.y > bodyVelocity) {
							this.velocity.y -= bodyAcel;
						}else {
							this.velocity.y += bodyAcel;
						}*/
					
					/*if (this.velocity.x < -bodyVelocity) {
						this.velocity.x += bodyAcel;
					}else {
						this.velocity.x -= bodyAcel;
					}*/
					
				}else if (!pressUp() && !pressDown()) {
					
					if (this.angle != 180 && this.angle != 0 && this.angle != 360) {
						if (this.angle > 180 && this.angle <= 270 || this.angle < 90 && this.angle > 0) {
							this.angle -= bodyActualRotation;
						}else if (this.angle < 180 && this.angle >= 90 || this.angle > 270 && this.angle < 360) {
							this.angle += bodyActualRotation;
						}
					}
					
					if (this.angle < 225 && this.angle > 135 && this.velocity.x < 0 || this.angle == 180) {
						makeMove();
					}else if((this.angle > 315 || this.angle <= 45) && this.velocity.x < 0 || this.angle == 0 || this.angle == 360){
						makeMove(true);
					}
						/*if (this.velocity.x < -bodyVelocity) {
							this.velocity.x += bodyAcel;
						}else {
							this.velocity.x -= bodyAcel;
						}
						
						if (this.velocity.y > 0) {
							this.velocity.y -= bodyAcel;
						}
						
						if (this.velocity.y < 0) {
							this.velocity.y += bodyAcel;
						}*/
					/*if (this.velocity.x < -bodyVelocity) {
						this.velocity.x += bodyAcel;
					}else {
						this.velocity.x -= bodyAcel;
					}
					
					if (this.velocity.y > 0) {
						this.velocity.y -= bodyAcel;
					}
					
					if (this.velocity.y < 0) {
						this.velocity.y += bodyAcel;
					}*/
				}
				
			}else if(pressRight()) {
				
				if (pressUp()) {
					
					if (this.angle != 315 && this.angle != 135) {
						if (this.angle < 315 && this.angle >= 225 || this.angle < 135 && this.angle > 45) {
							this.angle += bodyActualRotation;
						}else if (this.angle > 135 && this.angle < 225 || this.angle <= 45 || this.angle > 315 ) {
							this.angle -= bodyActualRotation;
						}
					}
					
					if (this.angle >= 225 || this.angle <= 45) {
						makeMove();
					}else {
						makeMove(true);
					}
						/*if (this.velocity.x > bodyVelocity) {
							this.velocity.x -= bodyAcel;
						}else {
							this.velocity.x += bodyAcel;
						}
					}
					}
						
						if (this.velocity.y < -bodyVelocity) {
							this.velocity.y += bodyAcel;
						}else {
							this.velocity.y -= bodyAcel;
						}*/
					
				}else if (pressDown()) {
					
					if (this.angle != 225 && this.angle != 45) {
						if (this.angle >= 135 && this.angle < 225 || this.angle > 315 || this.angle < 45) {
							this.angle += bodyActualRotation;
						}else if (this.angle <= 315 && this.angle > 225 || this.angle > 45 && this.angle < 135) {
							this.angle -= bodyActualRotation;
						}
					}
					
					if (this.angle >= 315 || this.angle <= 135) {
						makeMove();
					}else {
						makeMove(true);
					}
					/*if (this.velocity.x > bodyVelocity) {
						this.velocity.x -= bodyAcel;
					}else {
						this.velocity.x += bodyAcel;
					}
					
					if (this.velocity.y > bodyVelocity) {
						this.velocity.y -= bodyAcel;
					}else {
						this.velocity.y += bodyAcel;
					}*/
					
				}else if (!pressUp() && !pressDown()) {
					
					if (this.angle != 180 && this.angle != 0 && this.angle != 360) {
						if (this.angle > 180 && this.angle < 270 || this.angle <= 90 && this.angle > 0) {
							this.angle -= bodyActualRotation;
						}else if (this.angle < 180 && this.angle > 90 || this.angle >= 270 && this.angle < 360) {
							this.angle += bodyActualRotation;
						}
					}
					
					if ((this.angle >= 315 || this.angle <= 45) && this.velocity.x > 0 || this.angle == 0 || this.angle == 360) {
						makeMove();
					}else if(this.angle < 225 && this.angle > 135 && this.velocity.x > 0 || this.angle == 180) {
						makeMove(true);
					}
						/*if (this.velocity.x > bodyVelocity) {
							this.velocity.x -= bodyAcel;
						}else {
							this.velocity.x += bodyAcel;
						}
						
						if (this.velocity.y > 0) {
							this.velocity.y -= bodyAcel;
						}
						
						if (this.velocity.y < 0) {
							this.velocity.y += bodyAcel;
						}*/
					
				}
				
			}else if (pressDown() && !pressLeft() && !pressRight()) {
				
				if (this.angle != 270 && this.angle != 90) {
					if (this.angle > 180 && this.angle < 270 || this.angle >= 0 && this.angle < 90) {
						this.angle += bodyActualRotation;
						
					}else if (this.angle > 270 || this.angle <= 180 && this.angle > 90) {
						this.angle -= bodyActualRotation;
					}
				}
				
				if (this.angle <= 315 && this.angle >= 225 && this.velocity.y > 0 || this.angle == 270) {
					makeMove(true);
				}else if (this.angle <= 135 && this.angle >= 45 && this.velocity.y > 0 || this.angle == 90) {
					makeMove();
				}
					/*if (this.velocity.y < bodyVelocity) {
						this.velocity.y += bodyAcel;
					}else {
						this.velocity.y -= bodyAcel;
					}*/
				
			}else if (pressUp() && !pressLeft() && !pressRight()) {
				
				if (this.angle != 270 && this.angle != 90) {
					if (this.angle >= 180 && this.angle < 270 || this.angle > 0 && this.angle < 90) {
						this.angle += bodyActualRotation;
						
					}else if (this.angle > 270 || this.angle < 180 && this.angle > 90 || this.angle == 0) {
						this.angle -= bodyActualRotation;
					}
				}
				
				if (this.angle <= 315 && this.angle >= 225 && this.velocity.y < 0 || this.angle == 270) {
					makeMove();
				}else if (this.angle <= 135 && this.angle >= 45 && this.velocity.y < 0 || this.angle == 90) {
					makeMove(true);
				}
					/*if (this.velocity.y < -bodyVelocity) {
						this.velocity.y += bodyAcel;
					}else {
						this.velocity.y -= bodyAcel;
					}*/
			}
						
			/*if (this.velocity.x > 0) {
				this.velocity.x -= bodyAcel * 0.5;
			}else if (this.velocity.x < 0) {
				this.velocity.x += bodyAcel * 0.5;
			}
			
			if (this.velocity.y > 0) {
				this.velocity.y -= bodyAcel * 0.5;
			}else if(this.velocity.y < 0) {
				this.velocity.y += bodyAcel * 0.5;
			}*/
			
			super.update();
			
		}
		
		override public function hitBottom(Contact:FlxObject, Velocity:Number):void 
		{
			this.velocity.y = 0;
			super.hitBottom(Contact, Velocity);
		}
		
		override public function hitLeft(Contact:FlxObject, Velocity:Number):void 
		{
			this.velocity.x = 0;
			super.hitLeft(Contact, Velocity);
		}
		
		override public function hitRight(Contact:FlxObject, Velocity:Number):void 
		{
			this.velocity.x = 0;
			super.hitRight(Contact, Velocity);
		}
		
		override public function hitTop(Contact:FlxObject, Velocity:Number):void 
		{
			this.velocity.y = 0;
			super.hitTop(Contact, Velocity);
		}
		
		public function resetSpeedPowerUp():void {
			this.actualVelocity = bodyVelocity;
			this.bodyActualRotation = bodyRotation;
			this.loadGraphic(Images.ImgPlayer1);
		}
		
		public function resetDamagePowerUp():void {
			this.tankDamage = 1;
		}
		
		private function makeMove(inverse:Boolean = false):void {
			velocityVector = Vector2D.createBySizeAndAngle(actualVelocity, TWMath.degToRad(this.angle));
			if (inverse) velocityVector = Vector2D.getReverse(velocityVector);
			this.velocity.x = Math.round(velocityVector.x);
			this.velocity.y = Math.round(velocityVector.y);
		}
		
		public function powerUp(type:uint):void {
			switch(type) {
				case PowerUpObject.LIFE_UP:
				TopLevel.actualState.player.health = 5;
				TopLevel.score += ScoreTable.POWERUP_SCORE;
				PointBurst.createBigText("+" + String(ScoreTable.POWERUP_SCORE), this.x, this.y);
				ScoreTable.powerUpStatsHealth++;
				break;
				
				case PowerUpObject.SPEED_UP:
				actualVelocity = bodyVelocityBoost;
				bodyActualRotation = bodyBoostRotation;
				this.loadGraphic(Images.ImgPlayer1Buff);
				TopLevel.score += ScoreTable.POWERUP_SCORE;
				PointBurst.createBigText("+" + String(ScoreTable.POWERUP_SCORE), this.x, this.y);
				ScoreTable.powerUpStatsSpeed++;
				break;
				
				case PowerUpObject.TRY_UP:
				TopLevel.trys++;
				TopLevel.score += ScoreTable.POWERUP_SCORE;
				PointBurst.createBigText("+" + String(ScoreTable.POWERUP_SCORE), this.x, this.y);
				ScoreTable.powerUpStatsTry++;
				break;
				
				case PowerUpObject.WEAPON_UP:
				this.tankDamage = 2;
				TopLevel.actualState.player.turret.loadGraphic(Images.ImgPlayerCannon1Buff);
				TopLevel.actualState.player.turret.origin.x = 18;
				TopLevel.actualState.player.turret.origin.y = 13;
				TopLevel.score += ScoreTable.POWERUP_SCORE;
				PointBurst.createBigText("+" + String(ScoreTable.POWERUP_SCORE), this.x, this.y);
				ScoreTable.powerUpStatsDamage++;
				break;
				
				case PowerUpObject.BOMB_UP:
				TopLevel.score += ScoreTable.POWERUP_SCORE;
				TopLevel.bombs += 5;
				PointBurst.createBigText("+" + String(ScoreTable.POWERUP_SCORE), this.x, this.y);
				ScoreTable.powerUpStatsDamage++;
				break;
			}
		}
		
		private function pressDown():Boolean {
			return (FlxG.keys.pressed("S") && !FlxG.keys.pressed("W"));
		}
		
		private function pressUp():Boolean {
			return (FlxG.keys.pressed("W") && !FlxG.keys.pressed("S"));
		}
		
		private function pressLeft():Boolean {
			return (FlxG.keys.pressed("A") && !FlxG.keys.pressed("D"));
		}
		
		private function pressRight():Boolean {
			return (FlxG.keys.pressed("D") && !FlxG.keys.pressed("A"));
		}
		
	}

}
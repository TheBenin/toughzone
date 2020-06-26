package timewave.enemy 
{
	import flash.geom.Point;
	import org.flixel.*;
	import timewave.core.assets.Images;
	import timewave.core.globals.ScoreTable;
	import timewave.core.globals.TopLevel;
	import flash.utils.setTimeout;
	import timewave.math.SimpleVector;
	import timewave.math.Vector2D;
	import timewave.states.Playstate;
	import timewave.utils.pointburst.PointBurst;
	
	/**
	 * ...
	 * @author Wolff
	 */
	public class Turret extends FlxSprite
	{	
		public var turretDamage:uint = 0;
		public var turretSpeed:uint = 0;
		private var delayShoot:uint = 0;
		
		private var canShoot:Boolean = true;
		private var readyToDie:Boolean = false;
		private var deathCounter:Number = 0;
		private var damageOnDeath:Number = 0;
		
		private const emiter:FlxEmitter = new FlxEmitter();
		
		private var vectorCannon:SimpleVector = new SimpleVector(64, 0);
		
		private var scoreOnDeath:uint;
		
		public function Turret(img:Class,hp:uint,damage:uint,speed:uint,delay:uint,score:uint = 500)
		{	
			this.loadGraphic(img);
			
			this.origin.x = 15;
			
			this.angle = 90;
			
			this.width = 64;
			this.height = 64;
			
			offset.x = -17;
			offset.y = -12;
			
			this.turretSpeed = speed;
			this.turretDamage = damage;
			
			this.health = hp;
			this.scoreOnDeath = score;
			this.delayShoot = delay;
			
			emiter.gravity = 0;
			emiter.createSprites(Images.ImgParticleTank, 15);
			emiter.setXSpeed( -140, 140);
			emiter.setYSpeed( -140, 140);
			emiter.setRotation(0, 20);
			(TopLevel.actualState as Playstate).groupParticles.add(emiter);
			
			this.fixed = true;
		}
		
		override public function update():void 
		{
			
			if (canShoot) {
				(TopLevel.actualState as Playstate).shootTurret(this);
				canShoot = false;
				setTimeout(function():void { canShoot = true; }, delayShoot);
			}
			
			if (readyToDie) {
				deathCounter -= FlxG.elapsed;
				if (deathCounter <= 0) {
					readyToDie = false;
					hurt(damageOnDeath);
				}
			}
			
			if (!flickering()) {
				this.color = 0xffffff;
			}
			
			this.angle = FlxU.getAngle( (TopLevel.actualState as Playstate).playerCenter.x - 
				this.x,(TopLevel.actualState as Playstate).playerCenter.y - this.y);
			
			super.update();
		}
		
		override public function hurt(Damage:Number):void 
		{
			if (!this.active) return;
			
			this.health -= Damage;
			
			this.flicker(0.1);
			this.color = 0xcc0000;
			
			if (this.health <= 0) {
				this.kill();
				randExplosion();
				PointBurst.createBigText("+" + String(scoreOnDeath) , this.x, this.y);
				TopLevel.score += scoreOnDeath;
				ScoreTable.shotsHit++;
			}
		}
		
		override public function kill():void 
		{
			super.kill();
		}
		
		public function setDeath(delay:Number,damage:uint):void {
			if (this.readyToDie) return;
			this.readyToDie = true;
			this.deathCounter = delay;
			this.damageOnDeath = damage;
		}
		
		private function randExplosion():void {
			emiter.at(this);
			emiter.start(true, 0.25, 5);
			
			emiter.x = this.x + (this.width * Math.random());
			emiter.y = this.y + (this.height * Math.random());
			emiter.emitParticle();
			emiter.emitParticle();
			emiter.emitParticle();
			
			emiter.x = this.x + (this.width * Math.random());
			emiter.y = this.y + (this.height * Math.random());
			emiter.emitParticle();
			emiter.emitParticle();
			emiter.emitParticle();
			
			emiter.x = this.x + (this.width * Math.random());
			emiter.y = this.y + (this.height * Math.random());
			emiter.emitParticle();
			emiter.emitParticle();
			emiter.emitParticle();
		}
		
		public function set angleTurret(value:Number):void {
			this.angle = value;
		}
		
		public function get angleTurret():Number {
			return this.angle;
		}
		
		public function get turretCannonPos():SimpleVector {
			return Vector2D.createBySizeAndAngle(32, this.angle);
		}
		
		public function get turretCenter():FlxPoint {
			return new FlxPoint(this.x + 32, this.y + 32);
		}
		
	}

}
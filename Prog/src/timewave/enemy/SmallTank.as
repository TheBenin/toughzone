package timewave.enemy 
{
	import org.flixel.*;
	import timewave.core.assets.Images;
	import flash.utils.setTimeout;
	import timewave.core.assets.Sounds;
	import timewave.core.globals.ScoreTable;
	import timewave.core.globals.TopLevel;
	import timewave.states.Playstate;
	import timewave.utils.pointburst.PointBurst;
	import timewave.utils.pointburst.pointText;
	/**
	 * ...
	 * @author Wolff
	 */
	public class SmallTank extends FlxSprite
	{
		
		private var speed:Number;
		private var canShoot:Boolean = true;
		
		private var readyToDie:Boolean = false;
		private var deathCounter:Number = 0;
		
		private const emiter:FlxEmitter = new FlxEmitter();
		
		private var delayShoot:Number;
		private var scoreOnDeath:Number;
		private var damageOnDeath:uint;
		
		public var bulletSpeed:uint;
		public var bulletDamage:uint;
		
		public function SmallTank(img:Class,lifes:uint = 1,speed:Number = 100,delay:Number = 1000,score:Number = 500,bulletSpeed:uint = 300,bulletDamage:uint = 1,shooter:Boolean = true,animated:Boolean = false,framesPerSec:Number = 20) 
		{
			this.loadGraphic(img, animated);
			if (animated) { 
				this.addAnimation("Animation", [0, 1], framesPerSec, true);
				this.play("Animation");
			}
			this.health = lifes;
			this.speed = speed;
			this.delayShoot = delay;
			this.bulletDamage = bulletDamage;
			this.bulletSpeed = bulletSpeed;
			
			emiter.gravity = 0;
			emiter.createSprites(Images.ImgParticleTank, 15);
			emiter.setXSpeed( -140, 140);
			emiter.setYSpeed( -140, 140);
			emiter.setRotation(0, 20);
			scoreOnDeath = score;
			
			this.fixed = true;
			
			this.canShoot = shooter;
			
			(TopLevel.actualState as Playstate).groupParticles.add(emiter);
		}
		
		override public function update():void 
		{
			this.velocity.y = 0;
			if (this.x - 10 > FlxG.followTarget.x && this.y + 500 > FlxG.followTarget.y) {
				this.velocity.x = -speed;
			}else if (this.x + 10 < FlxG.followTarget.x && this.y + 500 > FlxG.followTarget.y) {
				this.velocity.x = speed;
			}else {
				this.velocity.x = 0;
			}
			
			if (canShoot) {
				(TopLevel.actualState as Playstate).shootEnemy(this);
				canShoot = false;
				setTimeout(function():void {canShoot = true }, delayShoot);
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
		
		override public function hurt(Damage:Number):void 
		{
			if (!this.active) return;
			
			this.health -= Damage;
			
			this.flicker(0.1);
			this.color = 0xcc0000;
			
			if (this.health <= 0) {
				this.kill();
				randExplosion();
				FlxG.play(Sounds.SndEnemyDies,0.5);
				(TopLevel.actualState as Playstate).groupDeadEnemies.add( new FlxSprite(this.x, this.y, Images.ImgDeadEnemyTank));
				PointBurst.createBigText("+" + String(scoreOnDeath) , this.x, this.y);
				TopLevel.score += scoreOnDeath;
			}
		}
		
		override public function kill():void 
		{
			super.kill();
		}
		
		/// delay in secounds to death
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
		
	}

}
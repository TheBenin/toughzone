package timewave.levels 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import timewave.core.assets.Sounds;
	import timewave.core.globals.ScoreTable;
	import timewave.core.globals.TopLevel;
	import timewave.core.assets.Images;
	import timewave.states.Playstate;
	import timewave.utils.pointburst.PointBurst;
	import org.flixel.FlxEmitter;
	/**
	 * ...
	 * @author Wolff
	 */
	public class BoxObject extends FlxSprite
	{
		private var readyToDie:Boolean = false;
		private var deathCounter:Number
		private var damageOnDeath:uint;
		private const emiter:FlxEmitter = new FlxEmitter();
		
		public function BoxObject(img:Class,particles:Class,initHealth:uint = 1) 
		{
			this.loadGraphic(img, false, false);
			this.health = initHealth;
			this.fixed = true;
			
			emiter.gravity = 0;
			emiter.createSprites(particles, 5);
			emiter.setXSpeed( -220, 220);
			emiter.setYSpeed( -220, 220);
			emiter.setRotation(0, 20);
			
			(TopLevel.actualState as Playstate).groupParticles.add(emiter);
		}
		
		override public function update():void 
		{
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
		
		override public function hurt(Damage:Number):void 
		{
			if (!this.active) return;
			
			this.health -= Damage;
			this.flicker(0.1);
			this.color = 0xcc0000;
			
			if (this.health <= 0) {
				this.kill();
				emiter.at(this);
				emiter.start(true,0.2);
				FlxG.play(Sounds.SndCrateDies,0.5);
				PointBurst.createBigText("+" + String(ScoreTable.BOX_SCORE), this.x, this.y);
				TopLevel.score += ScoreTable.BOX_SCORE;
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
		
	}

}
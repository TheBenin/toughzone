package timewave.player 
{
	import flash.geom.Point;
	import flash.utils.setTimeout;
	import org.flixel.*;
	import timewave.core.globals.TopLevel;
	import timewave.levels.PowerUpObject;
	import timewave.math.Vector2D;
	import timewave.math.SimpleVector;
	import timewave.math.TWMath;
	import timewave.core.assets.Images;
	import timewave.states.Playstate;
	
	/**
	 * ...
	 * @author Wolff
	 */
	public class PlayerTank extends FlxGroup
	{
		public var body:TankBody;
		public const turret:FlxSprite = new FlxSprite;
		
		public const turretWidth:uint = 40;
		public const bodyWidth:uint = 24;
		public const invencibleTime:uint = 2;
		
		private const emiterTrail:FlxEmitter = new FlxEmitter();
		private const emiter:FlxEmitter = new FlxEmitter();
		private var invicible:Boolean = false;
		
		public var cannonEnd:SimpleVector = Vector2D.createSimpleVector(turretWidth, 0);
		private var positionVector:SimpleVector = Vector2D.createSimpleVector(0, 0);
		
		public function PlayerTank(posX:Number = 0,posY:Number = 0) 
		{
			turret.loadGraphic(Images.ImgPlayerCannon1);
			
			turret.origin.x = 16;
			turret.origin.y = 11;
			
			body = new TankBody(posX, posY);
			
			add(body, true);
			add(turret, true);
			
			this.health = 3;
			
			emiter.gravity = 0;
			emiter.createSprites(Images.ImgParticleGranada, 20);
			emiter.maxParticleSpeed = new FlxPoint(50, 50);
			emiter.minParticleSpeed = new FlxPoint( -50, -50);
		}
		
		override public function update():void 
		{
			updateMouseVector();
			updatePositionVector();
			turretLoop();
			
			super.update();
			turretLoop();
		}
		
		override public function hurt(Damage:Number):void 
		{
			if (body.flickering() || invicible) return
			
			this.health -= Damage;
			
			if (this.health <= 0) {
				this.kill();
			}
			
			body.color = 0xff0000;
			turret.color = 0xff0000;
			this.invicible = true;
			
			setTimeout(function():void { invicible = false; body.color = 0xffffff; turret.color = 0xffffff; body.flicker(invencibleTime); turret.flicker(invencibleTime); }, 70);
			
			//super.hurt(Damage);
		}
		
		override public function kill():void 
		{
			turret.kill();
			body.loadGraphic(Images.ImgPlayer1Dead);
			body.active = false;
			emiter.at(this.body);
			(TopLevel.actualState as Playstate).groupParticles.add(emiter);
			particleNova();
			setTimeout(function():void { (TopLevel.actualState as Playstate).resetStage(); this.active = true; turret.reset(0, 0); body.active = true; }, 2000);
			
			//super.kill();
		}
		
		public function resetTank():void {
			body.resetSpeedPowerUp();
			body.resetDamagePowerUp();
			turret.loadGraphic(Images.ImgPlayerCannon1);
			turret.origin.x = 16;
			turret.origin.y = 13;
		}
		
		private function updateMouseVector():void {
			TopLevel.mouseVector.x = FlxG.mouse.x;
			TopLevel.mouseVector.y = FlxG.mouse.y;
		}
		
		// work around para o fato da flixel nao ter classe para vetores
		private function updatePositionVector():void {
			positionVector.x = body.x + bodyWidth;
			positionVector.y = body.y + bodyWidth;
		}
		
		private function turretLoop():void {
			
			turret.x = body.x + bodyWidth - turret.origin.x;
			turret.y = body.y + bodyWidth - turret.origin.y;
			
			cannonEnd = Vector2D.opMinus(TopLevel.mouseVector, positionVector);
			cannonEnd = Vector2D.normalize(cannonEnd);
			
			Vector2D.opTimesEqual(cannonEnd, turretWidth);
			
			turret.angle = TWMath.radToDeg(Vector2D.angle(cannonEnd));
			
			Vector2D.opPlusEqual(cannonEnd, positionVector);
			
		}
		
		public function particleNova():void {
			
			var vector:SimpleVector;
			emiter.quantity = 360;
			emiter.start(true, 1, 1);
			for (var i:int = 0; i < 360; ++i) {
				vector = Vector2D.createBySizeAndAngle(200, i);
				emiter.setXSpeed(vector.x, vector.x);
				emiter.setYSpeed(vector.y, vector.y);
				emiter.emitParticle();
			}
		}
		
		public function get turretAngle():Number {
			return turret.angle;
		}
		
		public function get tankDamage():Number {
			return body.tankDamage;
		}
		
		public function get tankVelocity():FlxPoint {
			return body.velocity;
		}
	}

}
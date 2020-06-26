package timewave.bullets 
{
	import org.flixel.*;
	import timewave.core.assets.Images;
	import timewave.core.assets.Sounds;
	import timewave.core.globals.TopLevel;
	import timewave.math.SimpleVector;
	import timewave.math.TWMath;
	import timewave.math.Vector2D;
	import caurina.transitions.Tweener;
	import timewave.states.Playstate;
	
	/**
	 * ...
	 * @author Timewave Games
	 */
	public class Bomb extends FlxSprite
	{
		private var altitude:Number = 0;
		private var speed:Number = 0;
		private var goingUp:Boolean = true;
		
		public var radius:Number;
		public var radiusAnim:uint
		public var damage:uint;
		
		private const rotationSpeed:Number = Math.random() * 5;
		
		public var targetPos:FlxPoint;
		
		private var emiter:FlxEmitter = new FlxEmitter();
		
		private var velocityVector:SimpleVector;
		
		public function Bomb(speed:uint,damage:uint,radius:uint = 200) 
		{
			this.loadGraphic(Images.ImgBomb,true,false);
			this.addAnimation("Bomb", [0, 1], 5, true);
			this.play("Bomb", true);
			this.speed = speed;
			this.damage = damage;
			this.radius = radius * radius;
			this.radiusAnim = radius;
			  
			emiter.gravity = 0;
			emiter.createSprites(Images.ImgParticleGranada, 20);
			emiter.maxParticleSpeed = new FlxPoint(50, 50);
			emiter.minParticleSpeed = new FlxPoint( -50, -50);
			
			(TopLevel.actualState as Playstate).groupParticles.add(emiter);
			
			//this.scale.x = 0.5;
			//this.scale.y = 0.5;
		}
		
		override public function update():void 
		{
			//updateVelocity();
			
			if (this.x == targetPos.x && this.y == targetPos.y) {
				emiter.at(this);
				particleNova();
				(TopLevel.actualState as Playstate).areaDamage(this);
				this.kill();
				FlxG.play(Sounds.SndGranadeExplosion, 1, false);
			}
			
			if(this.scale.x > 1.3){
				goingUp = false
			}
			
			if (goingUp) {
				this.scale.x += 0.02;
				this.scale.y += 0.02;
			}else if (!goingUp && this.scale.x > 1) {
				this.scale.x -= 0.02;
				this.scale.y -= 0.02;
			}
			
		    //this.angle += rotationSpeed;
			
			super.update();
			emiter.update();
		}
		
		public function particleNova():void {
			
			var vector:SimpleVector;
			emiter.at(this);
			emiter.quantity = 720;
			emiter.start(true, 1, 1);
			for (var i:int = 0; i < 360; ++i) {
				vector = Vector2D.createBySizeAndAngle(this.radiusAnim, i);
				emiter.setXSpeed(vector.x, vector.x);
				emiter.setYSpeed(vector.y, vector.y);
				emiter.emitParticle();
			}
		}
		
		public function updateVelocity():void {
			Vector2D.opTimesEqual(velocityVector, 0.97);
			this.velocity.x = velocityVector.x;
			this.velocity.y = velocityVector.y;
		}
		
		public function addMomentum(x:Number,y:Number):void {
			velocityVector.x += x;
			velocityVector.y += y;
		}
		
		public function setAngleToVelocity(newAngle:Number):void {
			//this.angle = newAngle;
			//velocityVector = Vector2D.createBySizeAndAngle(speed, TWMath.degToRad(this.angle));
			//this.velocity.x = velocityVector.x;
			//this.velocity.y = velocityVector.y;
			Tweener.addTween(this, { x:targetPos.x , y:targetPos.y, time:1.5, rounded:true, transition:"bounceOutIn" } );
		}
		
		override public function hitBottom(Contact:FlxObject, Velocity:Number):void 
		{
			velocityVector.y *= -1;
			super.hitBottom(Contact, Velocity);
		}
		
		override public function hitLeft(Contact:FlxObject, Velocity:Number):void 
		{
			velocityVector.x *= -1;
			super.hitLeft(Contact, Velocity);
		}
		
		override public function hitRight(Contact:FlxObject, Velocity:Number):void 
		{
			velocityVector.x *= -1;
			super.hitRight(Contact, Velocity);
		}
		
		override public function hitTop(Contact:FlxObject, Velocity:Number):void 
		{
			velocityVector.y *= -1;
			super.hitTop(Contact, Velocity);
		}
		
		override public function kill():void 
		{
			super.kill();
		}
	}

}
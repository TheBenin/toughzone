package timewave.bullets 
{
	/**
	 * ...
	 * @author ...
	 */
	
	import org.flixel.*;
	import timewave.core.assets.Images;
	import timewave.math.SimpleVector;
	import timewave.math.Vector2D;
	import timewave.math.TWMath;
	import timewave.core.globals.TopLevel;
	import timewave.states.Playstate;
	
	public class Bullet extends FlxSprite
	{
		private var bulletSpeed:uint;
		private var buffedSpeed:uint;
		private var bulletDamage:uint;
		private var bulletVelocityVector:SimpleVector;
		private var emiter:FlxEmitter = new FlxEmitter();
		
		public function Bullet(speed:uint,buffedSpeed:uint,damage:uint,width:uint,height:uint,img:Class,originY:Number = 6,originX:Number = 10,animated:Boolean = false,framesPerSec:uint = 10) 
		{
			this.loadGraphic(img, animated);
			
			this.offset.y = 10;
			this.offset.x = 5;
			
			if (animated) {
				this.addAnimation("bulletAnim", [0, 1], framesPerSec, true);
				this.play("bulletAnim");
			}
			
			this.bulletSpeed = speed;
			this.bulletDamage = damage;
			this.buffedSpeed = buffedSpeed;
			
			emiter.gravity = 0;
			emiter.createSprites(Images.ImgParticleParede, 4);
			
			(TopLevel.actualState as Playstate).groupParticles.add(emiter);
		}
		
		override public function update():void 
		{
			if (!this.onScreen()) {
				this.kill();
			}
			super.update();
		}
		
		public function updateVelocity():void {
			bulletVelocityVector = Vector2D.createBySizeAndAngle(bulletSpeed, TWMath.degToRad(this.angle));
			this.velocity.x = bulletVelocityVector.x;
			this.velocity.y = bulletVelocityVector.y;
		}
		
		public function setAngleToVelocity(newAngle:Number):void {
			this.angle = newAngle;
			updateVelocity();
		}
		
		override public function hitBottom(Contact:FlxObject, Velocity:Number):void 
		{
			emitPart();
			this.kill();
		}
		
		override public function hitLeft(Contact:FlxObject, Velocity:Number):void 
		{
			emitPart();
			this.kill();
		}
		
		override public function hitRight(Contact:FlxObject, Velocity:Number):void
		{
			emitPart();
			this.kill();
		}
		
		override public function hitTop(Contact:FlxObject, Velocity:Number):void 
		{
			emitPart();
			this.kill();
		}
		
		private function emitPart():void {
			emiter.at(this);
			emiter.setXSpeed(0, -(this.velocity.x >> 2));
			emiter.setYSpeed(0, -(this.velocity.y >> 2));
			emiter.start(true, 0.3, 5);
		}
		
		public function get damage():uint {
			return bulletDamage;
		}
		
		override public function hurt(Damage:Number):void 
		{
			//super.hurt(Damage);
		}
		
		public function get speed():Number {
			return bulletSpeed;
		}
		
		public function set speed(newSpeed:Number):void {
			this.bulletSpeed = newSpeed;
		}
		
		public function get speedBuffed():Number {
			return buffedSpeed;
		}
		
		public function set speedBuffed(newSpeed:Number):void {
			this.buffedSpeed = newSpeed;
		}
		
	}

}
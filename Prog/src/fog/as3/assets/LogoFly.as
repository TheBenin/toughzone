package fog.as3.assets {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import fog.as3.FogDevAPI;
	
	/**
	 * FogDev API
	 * fog.as3.LogoFly
	 * ...
	 * @version				2.1
	 * @author				Don Becker, Marc Qualie
	 */

	dynamic public class LogoFly extends MovieClip {
		
		[Embed(source='assets.swf', symbol='LogoFlySprite')]
		private var LogoFlySprite:Class;
		
		private var Core:FogDevAPI;
		private var speed:Number;
		private var fade:Boolean;
		private var grow:Number;
		private var targetX:Number;
		private var targetY:Number;
		
		public function LogoFly(Core:FogDevAPI, x:Number, y:Number) {
			this.Core    = Core;
			this.x       = x;
			this.y       = y;
			this.scaleX  = 0;
			this.scaleY  = 0;
			this.alpha   = 0;
			this.speed   = 100;
			this.grow    = Math.random() / 100;
			this.fade    = false;
			this.cacheAsBitmap = true;
			this.gotoAndStop(Math.random() * 10 + 1);
			
			targetX = Math.random() * 10;
			targetY = 0;
			if (targetX < 5) {
				targetX = Math.random() * 10;
				if (targetX < 5) targetX = -100;
				else targetX = Core.Width + 100;
				targetY = Math.random() * Core.Height;
			} else {
				targetY = Math.random() * 10;
				if (targetY < 5) targetY = -100;
				else targetY = Core.Height + 100;
			}
			targetX = Math.random() * Core.Width;
			
			// Add sprite
			var sprite:MovieClip = new LogoFlySprite() as MovieClip;
			sprite.x = -(sprite.width / 2);
			sprite.y = -(sprite.height / 2);
			sprite.cacheAsBitmap = true;
			addChild(sprite);
				
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(e:Event):void {
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void {
			this.x += (this.targetX - this.x) / this.speed * .5;
			this.y += (this.targetY - this.y) / this.speed * .5;
			this.speed *= .99;
			this.scaleX = this.scaleY += this.grow * 2;
			if (this.alpha < 1 && !this.fade) {
				this.alpha += .01;
			}
			if ((this.x < -50 || this.y < -50 || this.x > this.Core.Width + 50 || this.y > this.Core.Height + 50) || this.scaleX > 2) {
				this.fade = true;
			}
			if (this.fade) {
				this.alpha -= .05;
				if (this.alpha <= 0) {
					this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					this.parent.removeChild(this);
				}
			}
		}
	}

}
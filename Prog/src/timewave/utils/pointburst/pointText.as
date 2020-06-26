package timewave.utils.pointburst 
{
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	import timewave.core.globals.TopLevel;
	import caurina.transitions.*;
	import timewave.states.Playstate;
	
	/**
	 * ...
	 * @author Wolff
	 */
	public class pointText extends FlxText
	{
		
		public function pointText(textIn:String,posX:Number,posY:Number,time:Number,color:Number = 0xffffff,textSize:Number = 15) 
		{
			super(0, 0, 100);
			this.alignment = "center";
			this.size = textSize;
			this.text = textIn;
			this.color = color;
			this.alpha = 1;
			this.shadow = 1;
			this.x = posX;
			this.y = posY;
			Tweener.addTween(this, { y:this.y - 30, time:time } );
		}
		
		override public function update():void 
		{
			this.alpha -= 0.01;
			this.scale.x += 0.005;
			this.scale.y += 0.005;
			
			if (this.alpha <= 0) this.kill();
			if (this.dead) (TopLevel.actualState as Playstate).groupParticles.remove(this, true);
			super.update();
		}
		
	}

}
package timewave.states 
{
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import timewave.core.assets.Images;
	
	/**
	 * ...
	 * @author Timewave Games
	 */
	public class HowState extends FlxState
	{
		
		private const backText:FlxText = new FlxText(0, 0, 100, "Back");
		
		private const backBtn:FlxButton = new FlxButton(390, 480, goMainMenu);
		
		public function HowState() 
		{
			
		}
		
		override public function create():void 
		{	
			backBtn.loadText(backText);
			
			add(new FlxSprite(0, 0, Images.ImgHowTo));
			add(backBtn);
			
			super.create();
		}
		
		private function goMainMenu():void {
			FlxG.state = new MenuState();
		}
		
	}

}
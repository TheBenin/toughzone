package timewave.states 
{
	
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	import timewave.core.assets.Animations;
	import timewave.core.globals.TopLevel;
	import flash.utils.setTimeout;
	import flash.display.MovieClip;
	import flash.display.Loader;//
	import flash.utils.ByteArray;//
	import flash.events.Event;//
	
	/**
	 * Introducao do jogo. Carrega um swf externo e toca. Quando acaba, vai para o MenuState
	 * /index{External clips}	/index{Embed SWF}
	 * 
	 * (Baseada na classe EndState)
	 * 
	 * @author Saurinha, filha de Dino Sauron 7 Cordas
	 */
	public class IntroState extends FlxState
	{
		private var loader:Loader = new Loader();
		private var clipLoaded:Boolean = false;

		//http://www.flashandmath.com/intermediate/externalclips/ext_clip1.html
		
		public function IntroState() 
		{
			/*SwfEnd.x = 0;
			SwfEnd.y = 0;
			addChild(MCEnd);*/
			FlxG.mouse.hide();
			FlxG.frameratePaused 	= 60;	//	para nao cagar tudo se o cara pausar ou tirar o foco
			loader.loadBytes(new Animations.SwfIntro as ByteArray ); 
			loader.contentLoaderInfo.addEventListener(Event.INIT, doneLoading);
		}
		
		private function doneLoading(evt:Event):void {
			addChild(loader);
			clipLoaded = true;
		}
		
		override public function create():void 
		{
			/*saveState.bind("TZdata");
			switch(TopLevel.gameMode) {
				case "normal":
					//titleText.text = "End Animation Normal";
					saveState.data.survOpen = true;
				break;
				
				case "survival":
					//titleText.text = "End Animation Survival";
					saveState.data.survPlusOpen = true;
				break;
				
				case "survival+":
					//titleText.text = "End Animation Survival +";
				break;
			}*/
			
			super.create();
			
		}
		
		override public function update():void 
		{
			super.update();
			
			//	Terminada a animacao ou apertado enter ou clicado o mouse, vai para o MenuState
			if (clipLoaded)
			{
				if ( MovieClip(loader.content).currentFrame == MovieClip(loader.content).totalFrames)
				{
					goMainMenu();
				}
				
				if ( FlxG.keys.pressed("ENTER") || FlxG.mouse.pressed() )
				goMainMenu();
			}

		}
		
		private function goMainMenu():void {
			//FlxG.fade.start(0xff000000, 1, function():void { FlxG.state = new MenuState(); } );
			
			//	Don't forget to remove and unload the swf
			clipLoaded = false;	//	para nao quebrar no update()
			removeChild(loader);
			loader.unloadAndStop();
			
			//	E voltando o frame rate do estado de pause ao normal
			FlxG.framerate 			= 60;
			FlxG.frameratePaused 	= 10;
			
			FlxG.state = new MenuState();
		}		
	}

}
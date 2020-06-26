package timewave.states 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.StaticText;
	import flash.text.TextField;
	import org.flixel.FlxSave;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	import timewave.core.assets.Animations;
	import timewave.core.globals.HelloMetricSplash;
	import timewave.core.globals.TopLevel;
	import flash.utils.setTimeout;
	import flash.display.MovieClip;
	import flash.display.Loader;//
	import flash.utils.ByteArray;//
	import flash.events.Event;//
	
	/**
	 * Fim do jogo. Carrega um swf externo e toca. Quando acaba, volta para o SplashState
	 * /index{External clips}	/index{Embed SWF}
	 * 
	 * @author John Stump
	 */
	public class EndState extends FlxState
	{
		private const saveState:FlxSave = new FlxSave();
		
		/*[Embed(source = "../../../../Art/Release/TankEndingv5.swf")] 		private var SwfEnd:Class;
		private var MCEnd:MovieClip = MovieClip(new SwfEnd());*/
		
		private var loader:Loader = new Loader();
		private var clipLoaded:Boolean = false;
		
		//http://www.flashandmath.com/intermediate/externalclips/ext_clip1.html
		
		private var firstTime:Boolean = true;
		
		/** Splash de metrica "How would you rate this game so far?" */
		private var helloMetricSplash:HelloMetricSplash;
		
		public function EndState() 
		{
			/*SwfEnd.x = 0;
			SwfEnd.y = 0;
			addChild(MCEnd);*/
			//FlxG.mouse.hide();
			
			FlxG.framerate 			= 30;	//	para nao mudar a animacao, que foi feita a 30 FPS
			FlxG.frameratePaused 	= 30;	//	para nao cagar tudo se o cara pausar ou tirar o foco
			loader.loadBytes(new Animations.SwfEnd as ByteArray ); 
			loader.contentLoaderInfo.addEventListener(Event.INIT, doneLoading);
		}
		
		private function doneLoading(evt:Event):void {
			addChild(loader);
			clipLoaded = true;
			FlxG.mouse.show();
		}
		
		override public function create():void 
		{
			saveState.bind("TZdata");
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
			}
			
			super.create();
			
		}
		
		override public function update():void 
		{
			
			//
			//	Se estamos sob a metrica de "HELLO! etc..."
			if (helloMetricSplash)
			{
				//	Estamos tendo que forcar o update(), nao sei porque
				helloMetricSplash.update();
				
				//	Sujeito ja deu o rating (apertou OK)
				if (helloMetricSplash.dead)
				{
					//	Como tivemos que forcar o update() de helloMetricSplash, forcamos o destroy() apenas por garantia...
					helloMetricSplash.destroy();
					helloMetricSplash = null;
					
					//	Vai para onde estava indo - SplashState
					FlxG.state = new SplashState();
				}
				//	Se estamos sob o splash, nao atualizamos o playstate
				return;
			}
			
			super.update();
			if (clipLoaded)
			{
				if ( MovieClip(loader.content).currentFrame == MovieClip(loader.content).totalFrames)
				{
					tryGoSplashState();
				}
			}
		}
		
		/**
		 * 	Descarrega a animacao.
		 * 	Exibe o HelloMetricSplash se este state for sorteado para tal. E so' vai para o SplashState depois 
		 * de o usuario ter dado o rating (apertado OK). Se nao foi sorteado para mostrar o HelloMetricSplash, vai 
		 * direto para o SplashState
		 * 	Loga o score
		 */
		private function tryGoSplashState():void
		{
			//	Don't forget to remove and unload the swf
			clipLoaded = false;	//	para nao quebrar no update()
			removeChild(loader);
			loader.unloadAndStop();
			
			//	E voltando ao frame rate padrao do jogo
			FlxG.framerate 			= 60;
			FlxG.frameratePaused 	= 10;
			
			//	Logando o score
			var scoreLogFailed:Boolean = !TopLevel.SubmitScore();
			//	TODO - TRATAR	if(scoreLogFailed)	
			
			//	Verificando se deve haver metrica de Hello 
			if (TopLevel.isHelloMetricForThisState(this) && !TopLevel.helloMetricLogged)
			{
				TopLevel.helloMetricLogged = true;
				helloMetricSplash = new HelloMetricSplash();
				add(helloMetricSplash);
			}
			else
				goSplashState();
		}
		
		private function goSplashState():void {
			FlxG.fade.start(0xff000000, 1, function():void { FlxG.state = new SplashState(); } );
		}
	}

}
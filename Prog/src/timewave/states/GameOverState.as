package timewave.states 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	import timewave.core.assets.Images;
	import timewave.core.globals.HelloMetricSplash;
	import timewave.core.globals.ScoreTable;
	import timewave.core.globals.TopLevel;
	
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Timewave Games
	 */
	public class GameOverState extends FlxState
	{
		//private const titleText:FlxText = new FlxText(0, 70, 512, "Game Over");
		private const precisionText:FlxText = new FlxText(0, 0.9*512, 512);
		
		/** Splash de metrica "How would you rate this game so far?" */
		private var helloMetricSplash:HelloMetricSplash;
		
		public function GameOverState() 
		{
			
		}
		
		override public function create():void 
		{
			add(new FlxSprite(0, 0, Images.ImgGameOver));
			
			/*switch(TopLevel.gameMode) {
				case "normal":
					titleText.text = "Game Over Normal";
				break;
				
				case "survival":
					titleText.text = "Game Over Survival";
				break;
				
				case "survival+":
					titleText.text = "Game Over Survival +";
				break;
			}
			
			titleText.size = 35;
			titleText.alignment = "center";*/
			
			precisionText.size = 16;
			precisionText.alignment = "center";
			
			//add(titleText);
			add(precisionText);
			
			var prec:Number = Math.round((ScoreTable.shotsHit / ScoreTable.shotsTotal) * 100);
			if (ScoreTable.shotsTotal != 0) {
				precisionText.text = "Precision: " + prec + "%";
			}else {
				precisionText.text = "Precision: Did not shoot";
			}
			
			super.create();
			
			//	Logando o score
			var scoreLogFailed:Boolean = !TopLevel.SubmitScore();
			//	TODO - TRATAR	if(scoreLogFailed)	
			
			setTimeout(tryGoMainMenu, 3000);
		}
		
		/**
		 * 	Se este state for sorteado para exibir o HelloMetricSplash, para tudo agora e a exibe. So' vai
		 * para o MainMenu depois de o usuario ter dado o rating (apertado OK)
		 */
		private function tryGoMainMenu():void
		{
			if (TopLevel.isHelloMetricForThisState(this) && !TopLevel.helloMetricLogged)
			{
				TopLevel.helloMetricLogged = true;
				helloMetricSplash = new HelloMetricSplash();
				add(helloMetricSplash);
			}
			else
				goMainMenu();
		}
		
		private function goMainMenu():void {
			FlxG.state = new MenuState();
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
					
					//	Vai para onde estava indo - MainMenu
					goMainMenu();
				}
				//	Se estamos sob o splash, nao atualizamos este state
				return;
			}
			
			super.update();
		}
	}

}
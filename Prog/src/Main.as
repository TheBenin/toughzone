package  
{
	/**
	 * @author Timewave Games
	 */
	
	import org.flixel.*;
	import timewave.core.globals.TopLevel;
	import timewave.states.SplashState;
	
	import SWFStats.Log;
	
	import flash.display.LoaderInfo;	
	
	[SWF(width = "512", height = "512", backgroundColor = "#000000")]
	
	//	ATENCAO! NOTE! Se for usar Mochi Live Update, nao podemos ter preloader (a Mochi coloca o dela). Portanto,
	//se for o caso, comentar a linha abaixo
	//[Frame(factoryClass="Preloader")]
	
	public class Main extends FlxGame
	{
		public function Main() 
		{			
			//	Definindo em qual state vai aparecer a metrica de "HELLO! ..."
			var NLevels:uint = 16;	//	FIXME - HARD-CODED
			TopLevel.stateWith_HelloMetric = uint((/*Map.NMaps*/NLevels) + 3/*Menu/Intro, GameOver, EndState*/) * Math.random();
			//FlxG.log("TopLevel.stateWith_HelloMetric = " + TopLevel.stateWith_HelloMetric);
			
			TopLevel.firstTimeIntroLoaded = true;
			
			if (CONFIG::USE_MOCHI)
			{
				var _mochiads_game_id:String = "4a9c03c506436ed1";	//	autenticando no Mochi
				
				/////////////////////////////////
				//	Para compatibilizar com o Mochi Live Update, retiramos o Preloader. Aqui, algumas coisas que iam nele:
				
				//	Log.View inicializa o uso dos SWFStats. E' uma comunicacao com o servidor do Playtomic para
				//guardarmos metricas, geolocalizarmos o jogador, etc...
				//	Ja incrementa o numero de Views nas estatisticas deste jogo
				Log.View(585, "2fce39e7-90e0-4b26-976b-a97b2ddb8304", /*root.loaderInfo*/getMainLoaderInfo().loaderURL);
				/////////////////////////////////
			}
			
			/*var urls_allowed:Array = [
				//"www.timewavegames.com",
				//"www.flashgamelicense.com",
				//"brizoman.timewavegames.com"
			];
			
			if (sitelock(urls_allowed) && !(siteLockVerifiedByFOG_API))
			{
				this.root.alpha = 0;	
			}
			else
			{
				
				//	Log.View inicializa o uso dos SWFStats. E' uma comunicacao com o servidor do Playtomic para
				//guardarmos metricas, geolocalizarmos o jogador, etc...
				//	Ja incrementa o numero de Views nas estatisticas deste jogo
				Log.View(585, "2fce39e7-90e0-4b26-976b-a97b2ddb8304", root.loaderInfo.loaderURL);
			}*/
			
			super(512, 512, SplashState, 1);
		}
		
		//////////////////////////////////////////////////
		//	Adaptacao para usar Mochi Live Update (https://www.mochimedia.com/support/dev_doc)
		//	"Since Live Updates loads your code with a flash.display.Loader, the FlashVars and URL 
		//should be accessed somewhat differently than normal. Some third party APIs may need small 
		//changes to use this LoaderInfo instead of root.loaderInfo. This code will get the true 
		//LoaderInfo in a game using Live Updates (but also works if not using Live Updates):"
		
		public function getMainLoaderInfo():LoaderInfo {
			var loaderInfo:LoaderInfo = root.loaderInfo;
			if (loaderInfo.loader != null) {
				loaderInfo = loaderInfo.loader.loaderInfo;
			}
			return loaderInfo;
		}
		//////////////////////////////////////////////////
		
		/*public function sitelock(urls_allowed:Array) : Boolean {
			var lock:Boolean=true;
			var urlString:String = getMainLoaderInfo().url;//stage.loaderInfo.url;
			var urlParts:Array=urlString.split("://");
			var domain:Array=urlParts[1].split("/");

			for (var i:uint = 0; i < urls_allowed.length; i++) 
			{
			 if (urls_allowed[i]==domain[0]) {
			  lock = false;
			 }
			}

			if (urls_allowed.length == 0)
				return false;
			
			return lock;
		}
		
		private function performFOGSitelock():void
		{
			TopLevel.FogAPI.SiteLock();
			siteLockVerifiedByFOG_API = true;
		}*/
		
	}

}
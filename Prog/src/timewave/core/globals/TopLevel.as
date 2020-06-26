package timewave.core.globals 
{
	import flash.utils.getTimer;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import timewave.core.sound.SoundLoop;
	import timewave.levels.Map;
	import timewave.math.SimpleVector;
	import timewave.states.EndState;
	import timewave.states.GameOverState;
	import timewave.states.MenuState;
	import timewave.states.Playstate;
	import timewave.states.SplashState;
	
	//	Playtomic
	//
	import SWFStats.Log;	//	NOTE - DEPRECATED?
	import Playtomic.Leaderboards;
	import Playtomic.PlayerScore;
	
	//	FOG
	//
	import fog.as3.FogDevAPI;
	
	/**
	 * ...
	 * @author Wolff
	 */
	public class TopLevel
	{
		public static var mouseVector:SimpleVector = new SimpleVector(0, 0);
		public static var actualState:FlxState;//Playstate;
		public static var gameMode:String;
		public static var trys:uint = 3; 
		public static var score:uint = 0;
		public static var bombs:uint = 0;
		
		//	Musica in-game, loopante
		public static var inGameMusic:SoundLoop;
		
		public static var defaultPanelLogged:Boolean = false;
		
		//	Para uso com o cliente FOG
		public static var FOGPreloaderFinished:Boolean;
		public static var firstTimeIntroLoaded:Boolean;
		public static var FogAPI:FogDevAPI;
		
		//
		//	Variaveis referentes a metricas
		//
		
		/** Indice do FlxState ao fim do qual aparecera' a metrica de "Hello! etc..."
		 * 0: primeira fase, 1: 2a fase, ..., nFases + 2: Menu/Intro, nFases + 1: GameOver, nFases: EndState */
		static public var stateWith_HelloMetric:uint;
		static public var helloMetricLogged	:	Boolean = false;
		
		/**	Tempo dispendido durante o jogo inteiro em cada level
		/*	NAO zera a cada vez que o jogador joga o level
		/*	NAO CONTA o tempo de pause */
		static public var timeLeft			:	Array	= new Array			;
		
		/** tick do inicio do jogo (contando a partir de depois do SplashState) */
		static public var startTime			:	uint						;
		
		/**	Indica se o jogo ja foi muted alguma vez */
		static public var muteMetricLogged	:	Boolean	= false				;
		
		public function TopLevel() 
		{
			
		}
		
		/*public function initFOG_API():void
		{
			FogAPI = new FogDevAPI( { id:'YOUR_ID_HERE', root:root } );
		}*/
		
		///
		///	Verifica se state foi sorteado para apresentar a HelloMetric ao seu fim
		///	NOTE - Se for adicionado ou retirado algum state ou se mudar a ordem, este metodo deve ser atualizado
		///
		static public function isHelloMetricForThisState(state:FlxState):Boolean
		{
			if (state is Playstate)
				return (stateWith_HelloMetric == (state as Playstate).actualLevel);
			else if (state is MenuState)
				return (stateWith_HelloMetric == Map.NMaps);
			else if (state is GameOverState)
				return (stateWith_HelloMetric == Map.NMaps + 1);
			else if (state is EndState)
				return (stateWith_HelloMetric == Map.NMaps + 2);
			
			return false;
		}
		
		///	Se usou mute pela 1a vez, loga metrica informando que mutou e quanto tempo havia corrido 
		//desde o MenuState (que inclui a intro) ate' agora
		static public function tryLogMutedMetric(a_isMuted:Boolean):void
		{
			if(a_isMuted && !TopLevel.muteMetricLogged)
			{
				Log.CustomMetric("Muted");
				Log.LevelAverageMetric("Time To Mute (s)", SWFStats_thisStateTag, (TopLevel.startTime - getTimer())/1000.); 
				TopLevel.muteMetricLogged = true;
			}
		}
		
		static public function tryReset_TimeLeftCount(level:uint):void
		{
			if (timeLeft[level] == null)
			{
				timeLeft[level] = new uint;
				timeLeft[level] = 0;
			}
			else
			{
				//FlxG.log("---");
				//FlxG.log("timeLeft[" + level + "] = " + timeLeft[level]);
			}
		}

		///
		///	Tag que identifica o state atual, para utilizar no Log do SWFStats
		///	Resulta "Splash", "IntroAndMenu", "00_Level", "01_Level", ..., "10_Level", etc...
		///
		static public function SWFStats_thisStateTag():String
		{
			if (actualState is Playstate)
			{
				if((actualState as Playstate).getActualLevel <= 9)
					return "0" + String((actualState as Playstate).getActualLevel) + "_Level";
				else
					return String((actualState as Playstate).getActualLevel) + "_Level";
			}
			else if (actualState is SplashState)
				return "Splash"
			else if (actualState is MenuState)
				return "IntroAndMenu";
			else if (actualState is GameOverState)
				return "GameOver";
			else
				return "WARNING: Unindentified state";
		}
		
		///
		///	Texto padrao para o painel de log da Flixel. Contem creditos
		///
		static public function logDefaultPanel():void
		{
			if (!defaultPanelLogged)
			{
				FlxG.log("Tough Zone by TimeWave Games");
				FlxG.log("Check www.timewavegames.com for tips, tricks... and other cool games");
				FlxG.log("");
				FlxG.log("Credits:");
				FlxG.log("Game Design: Caio Lopez");
				FlxG.log("Sounds: Caio Lopez");
				FlxG.log("Intro music, in-game music: Caio Lopez");
				FlxG.log("Ending music: Kojiio");
				FlxG.log("Lead programmer: Gustavo Wolff");
				FlxG.log("Programming: Brizoman, Mr. Benin");
				FlxG.log("Graphics, animations: Kojiio");
				FlxG.log("");
				FlxG.log("Press ' to hide this log frame");
				
				defaultPanelLogged = true;
			}
		}
		
		///
		///	Submissao de score (Playtomic, Mochi, FOG, etc...)
		///	@return false no caso de erro
		///
		static public function SubmitScore():Boolean
		{
			
			//	Mochi Scores
			if (CONFIG::USE_MOCHI)
			{
				return false;//	TODO
			}
			//	cliente FOG
			else if (CONFIG::USE_FOG_API)
			{
				var o: Object = {"score": TopLevel.score};
				FogAPI.LibraryCall('ScoresUpdate', o);
				return true;	//	nao sabemos se houve erro ou nao...
			}
			//	Playtomic (nosso padrao)
			else
			{
				//	TODO
				/*var simple_score:PlayerScore = new PlayerScore();
				simple_score.Name = player_name;
				simple_score.Points = score;

				// submit to the highest-is-best table "highscores"
				Leaderboards.Save(simple_score, "highscores"); 

				// submit to the lowest-is-best table "besttimes"
				Leaderboards.Save(simple_score, "besttimes", null, {highest: false}); 

				// submit an advanced score with custom data and a callback function
				var advanced_score:PlayerScore = new PlayerScore();
				advanced_score.Name = player_name;
				advanced_score.Points = player_score;
				advanced_score.CustomData["Character"] = player_character;
				advanced_score.CustomData["Level"] = current_level;

				Leaderboards.Save(advanced_score, "highscores", this.SubmitComplete);*/
				return false;
			}
		}

		///
		///	No momento, para uso com scores do Playtomic
		///
		public function SubmitComplete(/*score:PlayerScore, */response:Object):void
		{
			if(response.Success)
			{
				trace("Score saved!");		
			}
			else
			{
				// submission failed because of response.ErrorCode
			}
		}
	}

}
package  timewave.states
{
	/**
	 * ...
	 * @author Timewave Games
	 */
	
	import caurina.transitions.Tweener;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import org.flixel.*;
	import SWFStats.Log;
	import timewave.bullets.Bomb;
	import timewave.bullets.Bullet;
	import timewave.bullets.BulletFactory;
	import timewave.core.assets.Images;
	import timewave.core.assets.Sounds;
	import timewave.core.globals.HelloMetricSplash;
	import timewave.core.globals.ScoreTable;
	import timewave.core.globals.TopLevel;
	import timewave.core.sound.SoundLoop;
	import timewave.enemy.SmallTank;
	import timewave.enemy.Turret;
	import timewave.levels.BoxObject;
	import timewave.levels.Details;
	import timewave.levels.Map;
	import timewave.levels.ObjectsFactory;
	import timewave.levels.PowerUpObject;
	import timewave.math.SimpleVector;
	import timewave.math.TWMath;
	import timewave.math.Vector2D;
	import timewave.player.PlayerTank;
	import timewave.player.TankBody;
	import timewave.utils.pointburst.PointBurst;
	//import timewave.core.sound.SoundLoop;
	import flash.utils.setTimeout;
	import timewave.utils.TWMuteBtn;
	
	public class Playstate extends FlxState
	{
		//	Segredo do morcego!!
		protected var secretAllowed:Boolean = false;
		
		// timer related
		private var timer:Number;
		private const extraTimeArray:Array = [];
		protected var colorInc:int = 256 * 256 * 0 + 256 * 6 + 1 * 6;
		protected var increasingColor:Boolean = false;
		
		// screen draw
		
		// hud related
		private const hudGroup:FlxGroup = new FlxGroup();
		private const timerText:FlxText = new FlxText(0, 0, 100, "teste");//5
		private const HUDTimerSprite:FlxSprite = new FlxSprite(2, 5, Images.ImgObjectsTimer);
		private const scoreText:FlxText = new FlxText(0, 0, 100, "0");
		private const HUDScoreSprite:FlxSprite = new FlxSprite(94, 5, Images.ImgObjectsScore);
		private const healthText:FlxText = new FlxText(0, 0, 100, "0");
		private const HUDHealthSprite:FlxSprite = new FlxSprite(216, 5, Images.ImgObjectsHealth);
		private const tryText:FlxText = new FlxText(0, 0, 100, "0");
		private const HUDTrySprite:FlxSprite = new FlxSprite(274, 5, Images.ImgObjectsLives);
		private const levelText:FlxText = new FlxText(412, 5, 100, "Level");
		private const bombText:FlxText = new FlxText(0, 0, 50, "0");
		private const HUDGrenadeSprite:FlxSprite = new FlxSprite(336, 5, Images.ImgObjectsGrenades);
		private const HUDalpha:uint = 1.0;
		
		private var btnMuteUnmute:TWFlxButton;
		
		//	Hint (no momento, usada apenas no botao de mute/unmute)
		protected var hint:FlxText = new FlxText(0, 0, 200, "");
		
		// score related
		
		// level related
		public var levels:Map = new Map();
		private var details:Details = new Details();
		/*private*/public var actualLevel:uint = 0;
		private var gameMode:String;
		private var gap:Boolean = false;
		///*public const*/private var soundLoop:SoundLoop = new SoundLoop(SoundLoop.SND_INGAME);	// musica que loopa ao fundo do jogo;
		private var imgGOarrow:FlxSprite;	//	Setinha de "Go!" apontando para cima
		
		// player related
		public const player:PlayerTank = new PlayerTank();
		private const cameraPlayer:FlxObject = new FlxObject();
		private const PLAYER_MAX_SCREEN_BULLETS:uint = 4;
		private const PLAYER_MAX_SCREEN_BULLETS_POWERUP:uint = 5;
		private const PLAYER_MAX_SCREEN_BOMBS:uint = 1;
		private const PLAYER_AUTO_DELAY:Number = 0.1;
		private const PLAYER_REGULAR_DELAY:Number = 0.3;
		private const PLAYER_BOMB_DELAY:Number = 0.3;
		private var timerDelayShoot:Number = 0;
		private var timerDelayBomb:Number = 0;
		private var thisStagePowerUps:Number = 0;
		
		// objects related
		private var groupBullet:FlxGroup = new FlxGroup();
		private var groupBomb:FlxGroup = new FlxGroup();
		private var groupEnemyBullet:FlxGroup = new FlxGroup();
		private var groupTurretBullet:FlxGroup = new FlxGroup();
		private var groupTurretBase:FlxGroup = new FlxGroup();
		private var groupBoxes:FlxGroup = new FlxGroup();
		private var groupPowerUps:FlxGroup = new FlxGroup();
		
		// enemies related
		private var groupEnemies:FlxGroup = new FlxGroup();
		private var groupTurrets:FlxGroup = new FlxGroup();
		public var groupDeadEnemies:FlxGroup = new FlxGroup();
		private const ENEMY_DISTANCE_TO_SHOOT:Number = 500;
		
		// particles related
		public const groupParticles:FlxGroup = new FlxGroup();
		
		// objects to be cleaned
		private const objectsGroupArray:Array = [groupBullet,groupPowerUps,groupBomb,groupEnemyBullet,groupBoxes,groupEnemies,groupParticles,groupDeadEnemies,groupTurrets,groupTurretBullet];
		
		//
		//	metrics related
		
		/**	Conta o tempo de jogo transcorrido em segundos nesta fase (NAO CONTA o tempo de pause - o jogador pode pausar e ficar analisando) */
		protected var m_timeLeft	:	Number	;
		
		/**	Tiros dados (nao confundir com o do jogo todo - ScoreTable.shotsTotal) */
		static public var shotsThisLevel: uint;
		
		/**	Tiros acertados (nao confundir com o do jogo todo - ScoreTable.shotsHit) */
		static public var shotsHitThisLevel: uint;
		
		/** Tiros sofridos */
		static public var shotsTakenThisLevel: uint;
		
		/** Inimigos mortos */
		static public var enemiesKilled: uint;
		static public var lastDeadEnemiesCount: uint;
		
		/** Splash de metrica "How would you rate this game so far?" */
		private var helloMetricSplash:HelloMetricSplash;
		
		//
		//	Musica in-game
		/**public const inGameMusic:SoundLoop = new SoundLoop(SoundLoop.SND_INGAME);/**/
		//	Para carregar nosso swf que contem a musica loopante
		/*SWF_AUDIO
		private var swfMusicLoader:Loader = new Loader();
		private var swfMusicLoaded:Boolean = false;*/
		
		//
		//	Outros
		
		public var gameEnded:Boolean = false;
		
		/** posicionamento da camera acima do player */
		private var camYAbovePlayer:uint = 150;
		
		/** auxiliar */
		private var auxJumps:Number;
		
		public function Playstate() 
		{
			player.body.x = levels.mapWidth >> 1;
			player.body.y = levels.mapHeight - 100;
			
			cameraPlayer.y = player.y + 100;
			cameraPlayer.x = player.x;
			
			//helloMetricSplash.y = levels.getScreenXY().y + levels.mapHeight - 512/*altura da tela*/ - 32/*NOTE - ??*/;
			
			this.gameMode = TopLevel.gameMode;
			
			//	* Seta de "GO!". Criando, fazendo pirlimpimpins e removendo
			//	* Zera score
			//	* Musica in-game
			if (actualLevel == 0)
			{
				TopLevel.score = 0;
				if (imgGOarrow == null)
					imgGOarrow = new FlxSprite(0, 0, Images.ImgGOarrow);
				imgGOarrow.x = (levels.mapWidth - imgGOarrow.width ) >> 1;
				//imgGOarrow.y = levels.mapHeight;
				imgGOarrow.alpha = 1;
				var durationGO:Number = 5;
				imgGOarrow.scrollFactor.y = 0;
				imgGOarrow.y = FlxG.width;
				Tweener.addTween(imgGOarrow, { y:(FlxG.width - 400), time:durationGO, rounded:true, transition:"easeOutBounce" } );
				//Tweener.addTween(imgGOarrow, { y:(levels.mapHeight - 400), time:durationGO, rounded:true, transition:"easeOutBounce" } );
				Tweener.addTween(imgGOarrow, { alpha:0, time:durationGO, rounded:false, transition:"easeInExpo" } );
				setTimeout(function():void { imgGOarrow.kill(); imgGOarrow = null; }, durationGO * 1000 + 1000);
			}
			
			//	Carregando o swf com a musica loopante
			/*SWF_AUDIO
			swfMusicLoader.loadBytes(new Sounds.SwfInGameMusicLoop as ByteArray ); 
			
			//	Setando uma funcao para ser chamada ao termino do carregamento
			swfMusicLoader.contentLoaderInfo.addEventListener(Event.INIT, doneLoading);*/
		}
		
		/**
		 * Acabando de carregar, adiciona o swfMusicLoader e sinaliza q foi carregado
		 * @param	evt
		 */
		/*SWF_AUDIO
		private function doneLoading(evt:Event):void {
			addChild(swfMusicLoader);
		}*/
		
		override public function create():void 
		{
			TopLevel.actualState = this;
			
			//FlxG.sounds.push(soundLoop);
			
			//	Precisa deste gap vazio de audio para conseguirmos tocar a musica (mesmo?)
			//TWFlxG_utils.playAtAnyVolume(Sounds.SndGap, 1, false);
			
			loadMap(actualLevel);
			
			//	Mute/unmute
			btnMuteUnmute = new TWMuteBtn(0.02 * FlxG.width, 0.9 * FlxG.width);
			btnMuteUnmute.on = true;	//	para se comportar como um checkBox
			btnMuteUnmute.loadGraphic(new TWFlxSprite(0, 0, Images.imgMuteOFF), new TWFlxSprite(0, 0,Images.imgMuteON));
			FlxG.mute = false;
			btnMuteUnmute.scrollFactor.x = 0;
			btnMuteUnmute.scrollFactor.y = 0;
			btnMuteUnmute.update();
			
			//	Comecamos sem hint
			hint.visible = false;
			
			//	
			add(levels);
			
			add(groupEnemies);
			add(groupPowerUps);
			add(groupBoxes);
			add(groupDeadEnemies);
			add(groupTurrets);
			add(groupEnemyBullet);
			add(groupTurretBullet);
			add(groupParticles);
			add(groupBullet);
			add(groupBomb);
			
			add(player);
			
			add(details);
			
			add(btnMuteUnmute);
			
			add(imgGOarrow);
			
			add(hint);	//	hint acima de todos
			
			//setTimeout(endGap, 300);
			
			FlxG.mouse.show();
			FlxG.mouse.load(Images.ImgCrossHair,16, 16);
			
			moveCamera();
			createObjects();
			
			FlxG.followBounds(0, 0, levels.mapWidth, levels.mapHeight - 32);
			
			timer = 5;
			
			TopLevel.bombs = 10;
			
			createHud();
			
			switch(gameMode) {
				case "normal":
					TopLevel.trys = 3;
					player.health = 3;
				break;
				
				case "survival":
					TopLevel.trys = 1;
					player.health = 3;
				break;
				
				case "survival+":
					TopLevel.trys = 1;
					player.health = 1;
				break;
			}
			
			timerDelayShoot = PLAYER_AUTO_DELAY;
			timerDelayBomb = PLAYER_BOMB_DELAY;
			
			//	Seta de "GO!". Criando, fazendo pirlimpimpins e removendo
			/*if (actualLevel == 0)
			{
				if (imgGOarrow == null)
					imgGOarrow = new FlxSprite(0, 0, Images.ImgGOarrow);
				imgGOarrow.x = (levels.mapWidth - imgGOarrow.width ) >> 1;
				imgGOarrow.y = levels.mapHeight;
				imgGOarrow.alpha = 1;
				var durationGO:Number = 5;
				Tweener.addTween(imgGOarrow, { y:(levels.mapHeight - 400), time:durationGO, rounded:true, transition:"easeOutBounce" } );
				Tweener.addTween(imgGOarrow, { alpha:0, time:durationGO, rounded:false, transition:"linear" } );
				setTimeout(function():void { imgGOarrow.kill(); imgGOarrow = null; }, durationGO*1000 + 1000);
			}*/
			
			//	Temporizadores
			m_timeLeft 	= 0.0;
			//FlxG.log("TopLevel.tryReset_TimeLeftCount("+actualLevel+")");
			TopLevel.tryReset_TimeLeftCount(actualLevel);	//	reseta apenas se ainda nao foi inicializado
			
			//	Contadores para metricas
			resetShotsAndKills();
			
			super.create();
		}
		
		private function resetShotsAndKills():void
		{
			shotsThisLevel = 0;
			shotsHitThisLevel = 0;
			shotsTakenThisLevel = 0;
			enemiesKilled = 0;
			lastDeadEnemiesCount = getActualDeadEnemiesCount();
		}
		
		private function endGap():void {
			gap = true;
		}
		
		public function get getActualLevel():uint
		{
			return actualLevel;
		}
		
		override public function update():void 
		{
			TopLevel.inGameMusic.update();
			
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
					
					//	Vai para onde estava indo (game over ou o proximo level)
					if (player.health <= 0)
					{
						if (TopLevel.trys <= 0)
							FlxG.state = new GameOverState();
					}
					else
						loadNextMap(auxJumps);
				}
				//	Se estamos sob o splash, nao atualizamos o playstate
				return;
			}
			
			
			moveCamera();
			checkForExtraTime();
			changeTexts();
			
			player.collide(groupBoxes);
			player.collide(groupEnemies);
			player.collide(groupTurrets);
			
			groupEnemies.collide(groupBoxes);
			groupEnemyBullet.collide(groupBoxes);
			
			FlxU.overlap(groupEnemies, groupBullet, overlaps);
			FlxU.overlap(groupTurrets, groupBullet, overlapsTurretBullet);
			FlxU.overlap(groupBoxes, groupBullet, overlapsBoxBullet);
			FlxU.overlap(player.body, groupPowerUps, overlapsPlayerPowerUps);
			FlxU.overlap(player.body, groupEnemyBullet, overlapsPlayerEneBullet);
			FlxU.overlap(player.body, groupTurretBullet, overlapsPlayerTurretBullet);
			
			levels.collide(player);
			levels.collide(groupBullet);
			levels.collide(groupEnemies);
			levels.collide(groupEnemyBullet);
			
			timerDelayShoot -= FlxG.elapsed;
			timerDelayBomb -= FlxG.elapsed;
			
			if(player.tankDamage <= 1){
				if (FlxG.mouse.pressed() && timerDelayShoot <= 0) {
					shoot();
					timerDelayShoot = PLAYER_REGULAR_DELAY;
				}
			}else {
				if (FlxG.mouse.pressed() && timerDelayShoot <= 0) {
					shoot();
					timerDelayShoot = PLAYER_AUTO_DELAY;
				}
			}
			
			if (FlxG.mouse.justReleased()) {
				timerDelayShoot = 0;
			}
			
			if ((FlxG.keys.pressed("SPACE") || FlxG.keys.pressed("NUMPADZERO")) && timerDelayBomb <= 0) {
				shootBomb();
				timerDelayBomb = PLAYER_BOMB_DELAY;
			}
			
			//	Agora pode acabar o tempo e ate' morrer, mas ninguem vai te tirar essa vitoria, Rubinho! Hoje nao!
			if (!this.gameEnded)
			{
				/*	SEGREDO DO MORCEGO - Sequencia secreta SHIFT + T + W para pular de fase */
				if (FlxG.keys.SHIFT && FlxG.keys.T && FlxG.keys.W && secretAllowed) {	//	:o
					secretAllowed = false;
					/*if (TopLevel.isHelloMetricForThisState(this))	
						TopLevel.stateWith_HelloMetric++;	//	(evitando bug - a helloMetricSplash apareceria,
						//mas como estaria fora do alcance da camera, nao a veriamos. Como o jogo so prossegue 
						//apos clique no OK dessa splash, ficariamos com o jogo travado)
					loadNextMap(1);*/tryLoadNextMap(1); timer = 1;
					return;
				}
				//	Se uma das teclas da sequencia secreta nao estiver apertada, entao da proxima que as tres
				//estiverem apertadas, pula de fase
				secretAllowed = (!FlxG.keys.SHIFT || !FlxG.keys.T || !FlxG.keys.W);
				
				/*
				if (FlxG.keys.justPressed("N")) {
					if(actualLevel > 0) tryLoadNextMap(-1); timer = 1;
				}
				
				if (FlxG.keys.justPressed("K")) {
					timer += 15;
				}
				
				if (FlxG.keys.justPressed("L")) {
					TopLevel.trys++;
				}
				
				if (FlxG.keys.justPressed("J")) {
					TopLevel.bombs++;
				}*/
				
				if (timer > 0) countTime();
				
				checkForGameOver();
				//removeFromBorders();
				
				if (player.body.y < 0) {
					tryLoadNextMap(1);
					//timer = 1;
				}
			}
			
			removeFromBorders();
			
			//
			//	Hint...
			if (btnMuteUnmute.overlapsPoint(FlxG.mouse.x, FlxG.mouse.y))
			{
				hint.visible = true;
				hint.text = btnMuteUnmute.getHint();
				hint.x = FlxG.mouse.x - 10;	//	FIXME - HARD-CODED!
				hint.y = FlxG.mouse.y - 10;	//	FIXME - HARD-CODED!
			}
			else
				hint.visible = false;
			
			//	Atualizando a qtd de inimigos mortos
			//	NOTE - Este nao e' o meio mais economico mas e' o mais seguro, pois pode haver inimigos que 
			//comecam a fase com dead == true. E sem contar que os grupos de inimigos nao sao descartados
			//quando mudamos de fase
			var actualDeadEnemiesCount:uint = getActualDeadEnemiesCount();
			enemiesKilled += actualDeadEnemiesCount - lastDeadEnemiesCount;
			lastDeadEnemiesCount = actualDeadEnemiesCount;
			
			//	Logando metricas relativas a mute (se houve mute e depois de quanto tempo)
			TopLevel.tryLogMutedMetric(FlxG.mute);
			
			super.update();
		}
		
		private function getActualDeadEnemiesCount():uint
		{
			var actualDeadEnemiesCount:uint = 0;
			for (var i:uint = 0; i < groupEnemies.members.length; i++)
				if (groupEnemies.members[i].dead)
					actualDeadEnemiesCount++;
			for (i = 0; i < groupTurrets.members.length; i++)
				if (groupTurrets.members[i].dead)
					actualDeadEnemiesCount++;
			return actualDeadEnemiesCount;
		}
		
		/**
		 * 	Se este state nao foi o sorteado para mostrar a HelloMetric, simplesmente chama loadNextMap()
		 * 	Caso contrario, mostra a HelloMetric e so chama loadNextMap depois do OK na 
		 * metrica (verificacao feita no update())
		 */
		private function tryLoadNextMap(jumps:Number):void
		{
			if (TopLevel.isHelloMetricForThisState(this) && !TopLevel.helloMetricLogged)
			{
				TopLevel.helloMetricLogged = true;
				//	NOTE - ATENCAO! NAO TEVE JEITO... nao consegui reposicionar helloMetricSplash aqui... 
				//	Portanto, quando estivermos debugando usando "M" para pular de fase, quando a helloMetricSplash
				//aparecer na tela o jogo vai travar (porque precisamos clicar no OK dela para continuar)
				helloMetricSplash = new HelloMetricSplash();
				add(helloMetricSplash);
				helloMetricSplash.active = true;
				auxJumps = jumps;
			}
			else
				loadNextMap(jumps);
		}
		
		///
		///	Carrega o proximo mapa. Se este era o ultimo, vai para o fim do jogo
		///
		private function loadNextMap(jumps:Number):void {
			
			//	SWFStats: tempo medio para passar desta fase
			//	- NAO conta o tempo de pause
			Log.LevelAverageMetric("Time To Complete", TopLevel.SWFStats_thisStateTag(), m_timeLeft);
			
			//	Idem anterior, mas CONTA as outras vezes que foi jogada esta fase
			Log.LevelAverageMetric("Total Time To Complete", TopLevel.SWFStats_thisStateTag(), TopLevel.timeLeft[actualLevel]);
			TopLevel.timeLeft[actualLevel] = 0;
			
			//	Tempo restante
			Log.LevelAverageMetric("Remaining Time", TopLevel.SWFStats_thisStateTag(), timer);
			
			//	Acuracia, precisao, mira, traquejo, molejo, jeito maroto de atirar...
			Log.LevelAverageMetric("Accuracy", TopLevel.SWFStats_thisStateTag(), shotsThisLevel / shotsHitThisLevel);
			
			//	Tiros sofridos, vacilos, mosqueadas, bobeadas...
			Log.LevelAverageMetric("Damage Taken", TopLevel.SWFStats_thisStateTag(), shotsTakenThisLevel);
			
			//	Os terceiro vacilao - tao de brincadeira...
			Log.LevelAverageMetric("Enemies Killed", TopLevel.SWFStats_thisStateTag(), enemiesKilled);
			
			if (actualLevel == 15 && jumps != -1) {
				var transitionTime:uint = 2;	//	segundos
				FlxG.fade.start(0xff000000, transitionTime, function():void {
					TopLevel.inGameMusic.destroy();
					TopLevel.inGameMusic = null;	//	foi o unico jeito de impedir que a musica in-game comece a tocar
						//se durante o EndState o sujeito tira o foco do jogo e volta (pois e´, esquisito...)
					FlxG.state = new EndState();
				});
				TopLevel.score += TopLevel.trys * 12000;
				gameEnded = true;
				/*SWF_AUDIO
				removeChild(swfMusicLoader);
				swfMusicLoader.unloadAndStop();*/
				return;
			}
			
			thisStagePowerUps = 0;
			actualLevel += jumps;
			levels.reset(0, 0);
			loadMap(actualLevel);
			TopLevel.score += Math.round(timer) * 100;
			TopLevel.trys++;
			resetStage();
		}
		
		private function removeFromBorders():void {
			if (player.body.x + player.body.width > levels.mapWidth + 24) {
				player.body.x = levels.mapWidth + 24 - player.body.width;
			}else if (player.body.x < -24) {
				player.body.x = -24;
			}
			if (player.body.y + player.body.height + 24 > levels.mapHeight) {
				player.body.y = levels.mapHeight - player.body.height - 24;
			}
		}
		
		private function loadMap(level:uint):void {
			this.levels.loadMap(level);
			this.details.loadMap(level);
			FlxG.followBounds(0, 0, levels.mapWidth, levels.mapHeight - 32);
		}
		
		private function changeTexts():void {
			scoreText.text = String(TopLevel.score);
			levelText.text = "Level " + String(actualLevel);
			bombText.text = String(TopLevel.bombs);
			
			if (gameMode == "survival+") return;
			healthText.text = String(player.health);
			
			if (gameMode == "survival") return;
			tryText.text = String(TopLevel.trys);
		}
		
		///
		///	Atualiza timer internamente e na interface.
		///	Se faltam 5s ou menos, bipa.
		///
		private function countTime():void {
			timer -= FlxG.elapsed;
			timerText.text = String(Math.round(timer) + "s");
			if (timer < 0) {
				TWFlxG_utils.playAtAnyVolume(Sounds.SndTimeOverBeep, 1);
				player.resetTank();
				player.kill();
				//	Metrica - causa da morte
				Log.LevelRangedMetric("Death Cause", TopLevel.SWFStats_thisStateTag, 0/* timeout death */); 
			}
			else if (timer < 5)
			{
				shineTimerSprite();
				TWFlxG_utils.playAtAnyVolume(Sounds.SndTimeOverBeep, 1);
			}
			else
			{
				resetTimerSpriteColor();
			}
			
		}
		
		///
		///	"Brilha" o sprite do timer, transformando a cor em tons de vermelho
		///
		private function shineTimerSprite():void
		{
			if (increasingColor == true)	//	aumenta a cor
			{
				if ((HUDTimerSprite.color + colorInc) < 0xffffff)
					HUDTimerSprite.color += colorInc;
				else
					increasingColor = false;
			}
			else	//	diminui a cor
			{
				if ((HUDTimerSprite.color - colorInc) > 0xff0000)
					HUDTimerSprite.color -= colorInc;
				else
					increasingColor = true;
			}
		}
		
		private function resetTimerSpriteColor():void
		{
			HUDTimerSprite.color = 0xffffff;
		}
		
		/**
		 * 	Checa se o player esta' morto e sem vidas. Se for o caso, vai para o Game Over (mas antes mostra
		 * a HelloMetricSplash se este level foi sorteado para isso)
		 */
		private function checkForGameOver():void {
			if (TopLevel.trys <= 0) {
				/***********/TopLevel.inGameMusic.destroy();
				if (TopLevel.isHelloMetricForThisState(this) && !TopLevel.helloMetricLogged)
				{
					TopLevel.helloMetricLogged = true;
					//cameraPlayer.y = 0;	//	colocando a camera la para cima, para nossa splash ficar visivel
					helloMetricSplash = new HelloMetricSplash();
					//helloMetricSplash.y = levels.mapHeight - 512/*altura da tela*/ - 32/*NOTE - ??*/;
					add(helloMetricSplash);
					//helloMetricSplash.x = 0;
					//helloMetricSplash.y = 0;
				}
				else
					FlxG.state = new GameOverState();
				//FlxG.state = new GameOverState();
			}
		}
		
		private function createHud():void {
			
			hudGroup.x = 0;
			hudGroup.y = 0;
			
			add(hudGroup);
			
			hudGroup.scrollFactor.y = 0;
			hudGroup.scrollFactor.x = 0;
			
			timerText.size = 20;
			timerText.shadow = 1;
			
			scoreText.size = 20;
			scoreText.shadow = 1;
			scoreText.color = 0xffff00;
			
			hudGroup.add(scoreText, true);
			hudGroup.add(timerText, true);
			
			levelText.size = 20;
			levelText.shadow = 1;
			levelText.color = 0xffffff;
			
			bombText.size = 20;
			bombText.shadow = 1;
			bombText.color = 0xffffff;
			
			hudGroup.add(scoreText, true);
			hudGroup.add(timerText, true);
			hudGroup.add(levelText, true);
			hudGroup.add(bombText, true);
			
			//if (gameMode == "survival+") return;	[Brizo] Nao ha nenhuma documentacao do que mostrar e o q n mostrar no survival. No momento isto aqui esta' gerando bugre
			
			healthText.size = 20;
			healthText.shadow = 1;
			healthText.color = 0x00ff00;
			
			hudGroup.add(healthText, true);
			
			//if (gameMode == "survival") return;	[Brizo] Nao ha nenhuma documentacao do que mostrar e o q n mostrar no survival. No momento isto aqui esta' gerando bugre
			
			tryText.size = 20;
			tryText.shadow = 1;
			tryText.color = 0xff0000;
			
			hudGroup.add(tryText, true);
			
			//	Centralizando textos com os sprites
			//	posicao centralizada com o texto
			healthText.x 	= HUDHealthSprite.x + HUDHealthSprite.width + 2;
			bombText.x 		= HUDGrenadeSprite.x + HUDGrenadeSprite.width + 2;
			tryText.x 		= HUDTrySprite.x + HUDTrySprite.width + 2;
			scoreText.x 	= HUDScoreSprite.x + HUDScoreSprite.width + 2;
			timerText.x 	= HUDTimerSprite.x + HUDTimerSprite.width + 2;
			healthText.y 	= HUDHealthSprite.y + (HUDHealthSprite.height - healthText.height) / 2;
			bombText.y 		= HUDGrenadeSprite.y + (HUDGrenadeSprite.height - bombText.height) / 2;
			tryText.y 		= HUDTrySprite.y + (HUDTrySprite.height - tryText.height) / 2;
			scoreText.y 	= HUDScoreSprite.y + (HUDScoreSprite.height - scoreText.height) / 2;
			timerText.y 	= HUDTimerSprite.y + (HUDTimerSprite.height - timerText.height) / 2;
			levelText.y		= timerText.y;
			//	alpha
			HUDHealthSprite.alpha = HUDGrenadeSprite.alpha = HUDTrySprite.alpha = HUDScoreSprite.alpha = HUDTimerSprite.alpha = HUDalpha;
			//	adicionando ao grupo do HUD
			hudGroup.add(HUDHealthSprite, true);
			hudGroup.add(HUDGrenadeSprite, true);
			hudGroup.add(HUDTrySprite, true);
			hudGroup.add(HUDScoreSprite, true);
			hudGroup.add(HUDTimerSprite, true);
		}
		
		private function clearAllObjects():void {
			
			for (var i:int = 0; i < objectsGroupArray.length; i++) {
				
				objectsGroupArray[i].kill();
				for (var j:uint = 0; j < objectsGroupArray[i].members.length; ++j) {
					objectsGroupArray[i].remove(objectsGroupArray[i].members[j], true);
				}
				objectsGroupArray[i].reset(0, 0);
			}
			
			extraTimeArray.length = 0;
		}
		
		///
		///		Reinicia a fase. Se era a ultima vida, retorna ja' de cara.
		///		TODO - Documentar isto aqui (e todo o resto, diacho =))
		///
		public function resetStage():void {
			TopLevel.trys--;
			
			if (TopLevel.trys <= 0) return;
			
			TWFlxG_utils.playAtAnyVolume(Sounds.SndPlayerRebirth, 3);
			
			if (player.health <= 0 || timer <= 0) {
				timer = 1;
				player.resetTank();
				TopLevel.score -= thisStagePowerUps;
				this.thisStagePowerUps = 0;
				
				switch(gameMode) {
					case "normal":
						player.health = 3;
					break;
					
					case "survival":
						player.health = 3;
					break;
					
					case "survival+":
						player.health = 1;
					break;
				}
			}
			
			player.body.resetSpeedPowerUp();
			
			clearAllObjects();
			
			player.body.x = levels.mapWidth >> 1;
			player.body.y = levels.mapHeight - 100;
			player.body.angle = 270;
			
			moveCamera();
			
			createObjects();
			
			resetShotsAndKills();
			
			FlxG.flash.start(0xff000000, 1);
		}
		
		private function createObjects():void {
			
			for (var i:int = 0; i < ObjectsFactory.allArrays[actualLevel].length; i++) 
			{
				if (ObjectsFactory.allArrays[actualLevel][i].type >= 48 && ObjectsFactory.allArrays[actualLevel][i].type <= 53) {
					extraTimeArray.push({y:ObjectsFactory.allArrays[actualLevel][i].y,type:ObjectsFactory.allArrays[actualLevel][i].type});
					continue;
				}
				
				var newObject:FlxSprite = ObjectsFactory.createObjects(ObjectsFactory.allArrays[actualLevel][i].type);
				
				if (newObject == null) continue;
				
				if ((gameMode == "survival" || gameMode == "survival+") && ObjectsFactory.allArrays[actualLevel][i].type == 20) {
					newObject == null;
					continue;
				}
				
				if (gameMode == "survival+" && ObjectsFactory.allArrays[actualLevel][i].type == 18) {
					newObject == null;
					continue;
				}
				
				newObject.x = ObjectsFactory.allArrays[actualLevel][i].x;
				newObject.y = ObjectsFactory.allArrays[actualLevel][i].y;
				
				if (ObjectsFactory.allArrays[actualLevel][i].type >= 13 && ObjectsFactory.allArrays[actualLevel][i].type <= 17) {
					var turretBase:FlxSprite = ObjectsFactory.createBasicTurretBase(ObjectsFactory.allArrays[actualLevel][i].type);
					turretBase.x = newObject.x;
					turretBase.y = newObject.y;
					groupDeadEnemies.add(turretBase);
				}
				
				switch(FlxU.getClassName(newObject,true)) {
					case "BoxObject":
						groupBoxes.add(newObject);
					break;
					
					case "GameObject":
						
					break;
					
					case "PowerUpObject":
						groupPowerUps.add(newObject);
					break;
					
					case "SmallTank":
						groupEnemies.add(newObject);
					break;
					
					case "Turret":
						groupTurrets.add(newObject);
					break;
				}
			}
			extraTimeArray.sortOn("y", Array.DESCENDING);
		}
		
		private function moveCamera():void {
			FlxG.follow(cameraPlayer);
			cameraPlayer.x = player.body.x + player.bodyWidth;
			cameraPlayer.y = player.body.y - camYAbovePlayer;
		}
		
		private function checkForExtraTime():void {
			for (var i:int = 0; i < extraTimeArray.length; i++) {
				if (player.body.y < extraTimeArray[i].y && player.body.y != 0) {
					giveTime(extraTimeArray[i].type);
					extraTimeArray.shift();
				}
			}
		}
		
		///
		///		Tanque inimigo atingido por bala
		///
		private function overlaps(object1:FlxSprite, object2:FlxSprite):void {
			TWFlxG_utils.playAtAnyVolume(Sounds.SndDmgInflicted1, 5);
			if (object1 is Bullet) {
				object1.kill();
				object2.hurt(player.tankDamage);
				groupBullet.remove(object1, true);
				ScoreTable.shotsHit++;
				shotsHitThisLevel++;
			}else if (object2 is Bullet) {
				object2.kill();
				object1.hurt(player.tankDamage);
				groupBullet.remove(object2, true);
				ScoreTable.shotsHit++;
				shotsHitThisLevel++;
			}
		}
		
		///
		///		Torre atingida por bala
		///
		private function overlapsTurretBullet(object1:FlxSprite, object2:FlxSprite):void {
			TWFlxG_utils.playAtAnyVolume(Sounds.SndDmgInflicted2, 5);
			if (object1 is Bullet) {
				object1.kill();
				object2.hurt(player.tankDamage);
				groupBullet.remove(object1, true);
				ScoreTable.shotsHit++;
				shotsHitThisLevel++;
			}else if (object2 is Bullet) {
				object2.kill();
				object1.hurt(player.tankDamage);
				groupBullet.remove(object2, true);
				ScoreTable.shotsHit++;
				shotsHitThisLevel++;
			}
		}
		
		///
		///		Caixa atingida por bala
		///
		private function overlapsBoxBullet(object1:FlxSprite, object2:FlxSprite):void {
			//	Som...? (tem o crateDies qdo a caixa morre...)
			if (object1 is Bullet) {
				object1.kill();
				object2.hurt(player.tankDamage);
				groupBullet.remove(object1, true);
				ScoreTable.shotsHit++;
				shotsHitThisLevel++;
			}else if (object1 is BoxObject) {
				object1.hurt(player.tankDamage);
				object2.kill();
				groupBullet.remove(object2, true);
				ScoreTable.shotsHit++;
				shotsHitThisLevel++;
			}
		}
		
		///
		///		Colisao player com PowerUp - o coleta
		///
		private function overlapsPlayerPowerUps(object1:TankBody, object2:PowerUpObject):void {
			TWFlxG_utils.playAtAnyVolume(Sounds.SndPowerupColection, 2);
			object1.powerUp(object2.type,object2);
			object2.kill();
			thisStagePowerUps += ScoreTable.POWERUP_SCORE;
		}
		
		///
		///		Player atingido por bala de tanque inimigo
		///
		private function overlapsPlayerEneBullet(object1:TankBody, object2:Bullet):void {
			
			TWFlxG_utils.playAtAnyVolume(Sounds.SndDmgSuffered, 4);
			player.hurt(object2.damage);
			object2.kill();
			groupBullet.remove(object2, true);
			shotsTakenThisLevel++;
			
			if (player.dead)
				Log.LevelRangedMetric("Death Cause", TopLevel.SWFStats_thisStateTag, 1/* killed by enemy tank */); 
		}
		
		///
		///		Player atingido por bala de torre
		///
		private function overlapsPlayerTurretBullet(object1:TankBody, object2:Bullet):void {
			TWFlxG_utils.playAtAnyVolume(Sounds.SndDmgSuffered, 4);
			player.hurt(object2.damage);
			object2.kill();
			groupBullet.remove(object2, true);
			shotsTakenThisLevel++;
			
			if (player.dead)
				Log.LevelRangedMetric("Death Cause", TopLevel.SWFStats_thisStateTag, 2/* killed by enemy turret */); 
		}
		
		///
		///		????
		///
		private function overlapsBombBox(object1:Bomb, object2:BoxObject):void {
			if (object1.scale.x < 1.1) {
				object1.collide(object2);
			}
		}
		
		///
		///		Player atirando
		///
		private function shoot():void {
			
			if (groupBullet.countLiving() > PLAYER_MAX_SCREEN_BULLETS - 1 && player.tankDamage == 1 || groupBullet.countLiving() > PLAYER_MAX_SCREEN_BULLETS_POWERUP - 1 && player.tankDamage == 2 || player.health <= 0 || player.body.health <= 0 || player.dead == true || player.body.dead == true ) return;
			
			var actualBullet:Bullet;
			
			if(player.tankDamage == 1){
				actualBullet = BulletFactory.createPlayerBullet();
			}else {
				actualBullet = BulletFactory.createPlayerBulletBuff();
			}
			
			actualBullet.setAngleToVelocity(player.turretAngle);
			
			actualBullet.x = player.cannonEnd.x - 5;
			actualBullet.y = player.cannonEnd.y;
			
			if (player.body.tankDamage > 1) {
				actualBullet.velocity.x += player.body.velocity.x >> 3;
				actualBullet.velocity.y += player.body.velocity.y >> 3;
				actualBullet.speed = actualBullet.speedBuffed;
				actualBullet.updateVelocity();
			}else {
				actualBullet.velocity.x += player.body.velocity.x >> 2;
				actualBullet.velocity.y += player.body.velocity.y >> 2;
			}
			
			groupBullet.add(actualBullet);
			
			ScoreTable.shotsTotal++;
			shotsThisLevel++;
			
			///	FIXME - Som de torre atirando???
			if (Math.round(Math.random())) {
				TWFlxG_utils.playAtAnyVolume(Sounds.SndTurretShot1, 4);
			}else {
				TWFlxG_utils.playAtAnyVolume(Sounds.SndTurretShot2, 4);
			}
		}
		
		///
		///		Player atirando bomba
		///		TODO - Som?
		///
		private function shootBomb():void {
			
			if (player.health <= 0 || TopLevel.bombs <= 0) return;
			
			var actualBullet:Bomb = BulletFactory.createPlayerBomb();
			
			actualBullet.targetPos = new FlxPoint(FlxG.mouse.x + (player.body.velocity.x >> 2), FlxG.mouse.y + (player.body.velocity.y >> 2));
			
			actualBullet.setAngleToVelocity(player.turretAngle);
			
			actualBullet.x = player.cannonEnd.x;
			actualBullet.y = player.cannonEnd.y;
			
			//actualBullet.addMomentum(player.body.velocity.x >> 1, player.body.velocity.y >> 1);
			
			groupBomb.add(actualBullet);
			
			TopLevel.bombs--;
		}
		
		///
		///		Tanque inimigo atirando
		///		NOTE - Som???
		///
		public function shootEnemy(enemy:SmallTank):void {
			
			if (player.body.y - enemy.y > ENEMY_DISTANCE_TO_SHOOT) return;
			
			var actualBullet:Bullet = BulletFactory.createEnemyBullet(enemy.bulletSpeed,enemy.bulletDamage);
			
			actualBullet.x = enemy.x + enemy.width/2 - (actualBullet.height >> 1);
			actualBullet.y = enemy.y;
			
			if (player.body.y > enemy.y) {
				actualBullet.velocity.y = actualBullet.speed;
				actualBullet.angle = 90;
				enemy.angle = 0;
				actualBullet.y += enemy.height;
			}else {
				actualBullet.velocity.y = -actualBullet.speed;
				actualBullet.angle = 270;
				enemy.angle = 180;
				actualBullet.y -= enemy.height;
			}
			
			groupEnemyBullet.add(actualBullet);
		}
		
		///
		///		Torre atirando
		///		NOTE - Som???
		///
		public function shootTurret(enemy:Turret):void {
			
			enemy.angleTurret = FlxU.getAngle(player.body.x - enemy.turretCenter.x, player.body.y - enemy.turretCenter.y);
			
			if (player.body.y - enemy.y > ENEMY_DISTANCE_TO_SHOOT) return;
			
			var actualBullet:Bullet = BulletFactory.createEnemyBullet(enemy.turretSpeed, enemy.turretDamage);
			
			var vector:SimpleVector = Vector2D.createBySizeAndAngle(45, TWMath.degToRad(enemy.angle));
			
			actualBullet.x = enemy.x + vector.x + (enemy.width >> 1);
			actualBullet.y = enemy.y + vector.y + (enemy.height >> 1);
			
			//add(new FlxSprite(actualBullet.x, actualBullet.y));
			
			actualBullet.angle = enemy.angle;
			actualBullet.updateVelocity();
			
			groupTurretBullet.add(actualBullet);
		}
		
		public function areaDamage(bomb:Bomb):void {
			var targetTank:SmallTank;
			var targetBox:BoxObject;
			var targetTurret:Turret;
			
			var targetDis:Number;
			
			FlxG.quake.start(0.005, 0.2);
			
			graphics.lineStyle(2,0x00000,1);
			
			for (var i:int = 0; i < groupEnemies.members.length; ++i) {
				
				targetTank = groupEnemies.members[i];
				targetDis = TWMath.getDistanceSqr(new Point(targetTank.x, targetTank.y),new Point(bomb.x, bomb.y));
				
				if (targetDis < bomb.radius && targetTank.onScreen && !targetTank.dead) {
					targetTank.setDeath(0.05 + (targetDis/bomb.radius * 0.2), bomb.damage);
				}
			}
			
			for (i = 0; i < groupBoxes.members.length; ++i) {
				
				targetBox = groupBoxes.members[i];
				targetDis = TWMath.getDistanceSqr(new Point(targetBox.x, targetBox.y), new Point(bomb.x, bomb.y));
				
				if (targetDis < bomb.radius && targetBox.onScreen && !targetBox.dead) {
					targetBox.setDeath(0.05 + (targetDis/bomb.radius * 0.2), bomb.damage);
				}
			}
			
			for (i = 0; i < groupTurrets.members.length; ++i) {
				
				targetTurret = groupTurrets.members[i];
				targetDis = TWMath.getDistanceSqr(new Point(targetTurret.x, targetTurret.y), new Point(bomb.x, bomb.y));
				
				if (targetDis < bomb.radius && targetTurret.onScreen && !targetTurret.dead) {
					targetTurret.setDeath(0.05 + (targetDis/bomb.radius * 0.2), bomb.damage);
				}
			}
		}
		
		//	FIXME - arrumar paliativo descrito mais abaixo
		private function giveTime(type:uint):void {
			if (player.body.y == 0) return;
			switch(type) {
				case 48:
				timer += 10;
				PointBurst.createTimeText("+10", levels.mapWidth >> 1 - 100, cameraPlayer.y);
				break;
				
				case 49:
				timer += 15;
				PointBurst.createTimeText("+15", levels.mapWidth >> 1 - 100, cameraPlayer.y);
				break;
				
				case 50:
				timer += 20;
				PointBurst.createTimeText("+20", levels.mapWidth >> 1 - 100, cameraPlayer.y);
				break;
				
				case 51:
				timer += 25;
				PointBurst.createTimeText("+25", levels.mapWidth >> 1 - 100, cameraPlayer.y);
				break;
				
				case 52:
				timer += 30;
				PointBurst.createTimeText("+30", levels.mapWidth >> 1 - 100, cameraPlayer.y);
				break;
				
				case 53:
				timer += 35;
				PointBurst.createTimeText("+35", levels.mapWidth >> 1 - 100, cameraPlayer.y);
				break;
			}
			
			//	FIXME - PALIATIVO - porque as fases estao com timer muito curto. Arrumar no level design
			if (type > 47 && type < 54)
				timer += 30;
		}
		
		public function get playerCenter():Point {
			return new Point(player.body.x , player.body.y);
		}
		
	}

}
package timewave.states 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.ui.Mouse;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxSave;
	//import org.flixel.TWFlxButton;
	import org.flixel.TWFlxSprite;
	import org.flixel.TWFlxG_utils;
	import timewave.core.assets.Animations;
	import timewave.core.globals.HelloMetricSplash;
	import timewave.core.globals.ScoreTable;
	import timewave.core.globals.TopLevel;
	import timewave.core.sound.SoundLoop;
	//import timewave.utils.TWMuteBtn;
	//import timewave.core.sound.SoundLoop;
	import timewave.core.assets.Sounds;
	import timewave.core.assets.Images;
	import flash.media.Sound;
	
	/**
	 * Introducao e e menu do jogo, carregados por um swf externo
	 * /index{External clips}	/index{Embed SWF}
	 * 
	 * (Baseada na classe EndState)
	 * 
	 * @author Saurinha, filha de Dino Sauron 7 Cordas
	 */
	public class MenuState extends FlxState
	{
		/* Codigo de quando o menu era feito na mao... agora temos um swf externo
		private const startText:FlxText = new FlxText(0, 0, 100, "Start Game");
		private const survivaltText:FlxText = new FlxText(0, 0, 100, "Survival");
		private const plusText:FlxText = new FlxText(0, 0, 100, "Survival +");
		private const howText:FlxText = new FlxText(0, 0, 100, "How to play");
		
		private const backText:FlxText = new FlxText(0, 0, 100, "Back");
		
		private const btnStart:FlxButton = new FlxButton(150, 200,startGame);
		private const btnSurvival:FlxButton = new FlxButton(150, 240,startGameSurv);
		private const btnSurvivalPlus:FlxButton = new FlxButton(150, 280,startGameSurvPlus);
		private const btnHowToPlay:FlxButton = new FlxButton(150, 320, arrangeHowToScreen);
		
		private const btnBack:FlxButton = new FlxButton(390, 480, arrangeMenuScreen);
		
		private const spriteBtnStartGame:FlxSprite = new FlxSprite(24, 408, Images.ImgBtnStartGame);
		private const spriteBtnHighScores:FlxSprite = new FlxSprite(24, 433, Images.ImgBtnHighScores);
		private const spriteBtnSurvival:FlxSprite = new FlxSprite(24, 458, Images.ImgBtnSurvival);
		
		private const MO_OTHER:uint 		= 0;
		private const MO_STARTGAME:uint 	= 1;
		private const MO_HIGHSCORES:uint 	= 2;
		private const MO_SURVIVAL:uint 		= 3;
		private var mouseOverAt:uint = MO_OTHER;
		
		private var background:FlxSprite = new FlxSprite(0, 0, Images.ImgMenuScreen);
		
		private var soundLoop:SoundLoop = new SoundLoop(SoundLoop.SND_INTRO); // musica loopante
		
		private var cursorHalfWidth:uint = FlxG.mouse.cursor.width / 2;
		private var cursorHalfHeight:uint = FlxG.mouse.cursor.height / 2;*/
		
		private const saveState:FlxSave = new FlxSave();
		
		private var helloMetricSplash:HelloMetricSplash = new HelloMetricSplash();
		
		//	Para carregar nosso swf
		/*private*/static public var loader:Loader = new Loader();
		/*private*/static public var clipLoaded:Boolean;
		private var menuScreenMCsLinked:Boolean = true;	//	sinaliza se os botoes do menu ja tiverem eventos de mouse associados
		//private var alreadyPLaying:Boolean = false;
		private var menuInitialFrame:uint = 881;//	no swf, frame onde os botoes do menu estao acessiveis menu - NOTE - HARD-CODED!
		private var explosionFrame:uint = 868/*864*/;	//	no swf, frame onde esta' a explosao - NOTE - HARD-CODED!
		private var howToPlayFrame:uint = 1800;	//	no swf, frame onde esta' a tela de How To Play - NOTE - HARD-CODED!
		
		private var menuEventsAssigned:Boolean = false;
		private var howToPlayEventsAssigned:Boolean = false;
		
		public function MenuState() 
		{
			//	Escondemos o mouse da Flixel (que e' um FlxSprite)...
			FlxG.mouse.hide();	//	... e mostramos o mouse do Flash no update(), ja que estaremos com um swf externo rodando e 
				//a flixel apaga o cursor do Flash toda a hora
			
			clipLoaded = false;
				
			helloMetricSplash.x = 0;
				
			//	Carregando a animacao
			loader.loadBytes(new Animations.SwfIntro as ByteArray ); 
			
			//	Setando uma funcao para ser chamada ao termino do carregamento
			loader.contentLoaderInfo.addEventListener(Event.INIT, doneLoading);
			
			//	Musica in-game loopante. Comeca parada e sera' tocada quando sairmos do menu. Faz parte de um xunxo
			//que impede que a musica so toque depois que alguma caixa do cenario for destruida
			TopLevel.inGameMusic = new SoundLoop(SoundLoop.SND_INGAME);
			//FlxG.log("FlxG.sounds.length = " + FlxG.sounds.length);
			FlxG.sounds.push(TopLevel.inGameMusic);
			//FlxG.log("FlxG.sounds.length = " + FlxG.sounds.length);
			TopLevel.inGameMusic.stop();
			
			//	Tempo de inicio do jogo (ou seja, menu em diante)
			TopLevel.startTime = getTimer();
		}
		
		/**
		 * Acabando de carregar, adiciona o loader e sinaliza q foi carregado
		 * @param	evt
		 */
		private function doneLoading(evt:Event):void {
			//FlxG.framerate 		= 30	//	para nao mudar a animacao, que foi feita a 30 FPS
			//FlxG.frameratePaused 	= 30;	//	para nao cagar tudo se o cara pausar ou tirar o foco
			
			addChild(loader);
			
			MovieClip(loader.content).soundTransform = new SoundTransform(0.5);
						
			//MovieClip(loader.content).stop();	/////////////////// mandando tocar so depois de carregar p ver se nao laga... nao adiantou
			clipLoaded = true;
		}
		
		override public function create():void 
		{
			/* Codigo de quando o menu era feito na mao... agora temos um swf externo 
			FlxG.mouse.show();
			
			FlxG.sounds.push(soundLoop);
			//	Precisa deste gap vazio de audio para conseguirmos tocar a musica
			FlxG.play(Sounds.SndGap, 1, false);
			
			TopLevel.actualState = null;
			
			ScoreTable.resetStats();
			TopLevel.score = 0;
			
			btnStart.loadText(startText);
			btnSurvival.loadText(survivaltText);
			btnSurvivalPlus.loadText(plusText);
			btnHowToPlay.loadText(howText);
			btnBack.loadText(backText);
			
			btnBack.visible = false;
			
			btnSurvival.active = false;
			btnSurvivalPlus.active = false;
			
			if (saveState.bind("TZdata")) {
				if (saveState.data.survOpen) {
					btnSurvival.active = true;
				}
				
				if (saveState.data.survPlusOpen) {
					btnSurvivalPlus.active = true;
				}
			}
			
			add(background);
			//add(titleText);
			add(btnStart);
			add(btnSurvival);
			add(btnSurvivalPlus);
			add(spriteBtnStartGame);
			add(spriteBtnHighScores);
			add(spriteBtnSurvival);
			
			add(btnHowToPlay);
			add(btnBack);*/
			
			super.create();
		}
		
		override public function update():void
		{
			/*	No tempo em que Dodo^ jogava no Andarai' (menu feito na munheca)
			var centerX:uint = FlxG.mouse.x + cursorHalfWidth;
			var centerY:uint = FlxG.mouse.y + cursorHalfHeight;
			if (centerX >= spriteBtnStartGame.x && centerX < (spriteBtnStartGame.x + spriteBtnStartGame.width)
				&& centerY >= spriteBtnStartGame.y && centerY < (spriteBtnStartGame.y + spriteBtnStartGame.height))
			{
				mouseOverAt = MO_STARTGAME;
				spriteBtnStartGame.color = 0x993333;
				spriteBtnHighScores.color = 0xffffff;
				spriteBtnSurvival.color = 0xffffff;
			}
			else if (centerX >= spriteBtnHighScores.x && centerX < (spriteBtnHighScores.x + spriteBtnHighScores.width)
				&& centerY >= spriteBtnHighScores.y && centerY < (spriteBtnHighScores.y + spriteBtnHighScores.height))
			{
				mouseOverAt = MO_HIGHSCORES;
				spriteBtnStartGame.color = 0xffffff;
				spriteBtnHighScores.color = 0x993333;
				spriteBtnSurvival.color = 0xffffff;

			}
			else if (centerX >= spriteBtnSurvival.x && centerX < (spriteBtnSurvival.x + spriteBtnSurvival.width)
				&& centerY >= spriteBtnSurvival.y && centerY < (spriteBtnSurvival.y + spriteBtnSurvival.height))
			{
				mouseOverAt = MO_SURVIVAL;
				spriteBtnStartGame.color = 0xffffff;
				spriteBtnHighScores.color = 0xffffff;
				spriteBtnSurvival.color = 0x993333;
			}
			else
			{
				spriteBtnStartGame.color = 0xffffff;
				spriteBtnHighScores.color = 0xffffff;
				spriteBtnSurvival.color = 0xffffff;

				return;
			}
			
			if (FlxG.mouse.justReleased())
			{
				switch(mouseOverAt)
				{
					case MO_STARTGAME: startGame();	break;
					case MO_HIGHSCORES: startHighScores();  break;	//	TODO
					case MO_SURVIVAL: startGameSurv();	break;
				}
			}*/
			
			//	So' toca depois de carregar... para nao lagar
			/*	--> Nao adiantou...
			if (clipLoaded && !alreadyPLaying)
			{
				MovieClip(loader.content).play();
				alreadyPLaying = true;
			}*/
			
			//	A flixel esconde o mouse nativo do Flash
			Mouse.show();
			
			//	Se helloMetricSplash foi invocado:
			//	* Temos que forcar o update (aparentemente porque helloMetricSplash foi adicionado 
			//somente depois do construtor MenuState())
			//	* Verifica se podemos ir para o PlayState (usuario apertou OK)
			if (helloMetricSplash.x < FlxG.width)
			{
				helloMetricSplash.update();
				//FlxG.mouse.cursor.update();
				if (helloMetricSplash.dead)
					end();
			}
			
			//	A partir do frame menuInitialFrame, os movieClips do menu ficam acessiveis. Entao, associamos
			//eventos de clique a cada botao (sim, o designer de interface tem que passar os nomes dos botoes 
			//e o frame a partir do qual eles estao disponiveis)
			if (clipLoaded && /*!menuEventsAssigned && */MovieClip(loader.content).currentFrame >= menuInitialFrame)
			{
				/* FlxG.log("."); */
				setChildrenEvents(DisplayObjectContainer(loader.content), MovieClip(loader.content).currentFrame);
				menuEventsAssigned = true;
				/* FlxG.log(".."); */
			}
			
			//	- Se clicar durante a intro, vai direto pro menu
			//	- Controle do swf acompanha volume da Flixel
			if (clipLoaded)
			{
				if (CONFIG::USE_FOG_API)	//	esse nosso comprador nao quer sons antes do usuario clicar em algum lugar do menu
				{
					if (TopLevel.firstTimeIntroLoaded)	//	... mas isso apenas em seguida do jogo ser carregado. Se nao e´ a 1a 
														//vez que a intro aparece, agora ela nao estara´ muted
					{
						FlxG.mute = true;
					}
				}
				
				if (FlxG.mute)
					MovieClip(loader.content).soundTransform = new SoundTransform(0);
				else
					MovieClip(loader.content).soundTransform = new SoundTransform(FlxG.volume);
				
				if (FlxG.mouse.justReleased())
					if (MovieClip(loader.content).currentFrame < explosionFrame)
					{
						goToMenu();
						//setChildrenEvents(DisplayObjectContainer(loader.content, MovieClip(loader.content).currentFrame));
						//menuScreenMCsLinked = false;
					}
			}
		}
		
		/**
		 * 	Localiza movieClips dentro de dsObject (no caso, o loader do nosso SWF) e adiciona a eles eventos de click,
		 * de acordo com o currentFrame (em certos frames, alguns movieClips estarao disponiveis e outros nao)
		 * @param	dsObject
		 * @param	iDepth
		 */
		private function setChildrenEvents(dsObject:DisplayObjectContainer, currentFrame:uint, iDepth:int = 0):void 
		{
			/* FlxG.log("setChildrenEvents"); */
			var i:int = 0;
			var sDummyTabs:String = "";
			var dsoChild:DisplayObject;
			for (i ; i < iDepth ; i++)
				sDummyTabs += "\t";
			//FlxG.log(sDummyTabs + "\t" + "dsObject.numChildren = " + dsObject.numChildren);
			//FlxG.log(sDummyTabs + dsObject);
			/* FlxG.log(dsObject.numChildren); */
			for (i = 0; i < dsObject.numChildren ; ++i)
			{
				dsoChild = dsObject.getChildAt(i);
				if (dsoChild is DisplayObjectContainer && 0 < DisplayObjectContainer(dsoChild).numChildren)
				{
					if (dsoChild is MovieClip)
					{
						//	Associando eventos aos botoes do menu
						if(currentFrame >= menuInitialFrame)
						{
							if (dsoChild.name == "btn_startgame")
							{
								dsoChild.addEventListener(MouseEvent.CLICK, mouseClickStartGame);
								/* FlxG.log("btn_startgame"); /**/
							}
							else if (dsoChild.name == "btn_survival")
							{
								dsoChild.addEventListener(MouseEvent.CLICK, mouseClickStartGameSurvival);
								/* FlxG.log("btn_survival"); /**/
							}
							else if (dsoChild.name == "btn_survival_plus")
							{
								dsoChild.addEventListener(MouseEvent.CLICK, mouseClickStartGameSurvivalPlus);
								/* FlxG.log("btn_survival_plus"); /**/
							}
							else if (dsoChild.name == "btn_howtoplay")
							{
								dsoChild.addEventListener(MouseEvent.CLICK, mouseClickHowTo);
								/* FlxG.log("btn_howtoplay"); /**/
							}
							else if (dsoChild.name == "btn_highscores")
							{
								dsoChild.addEventListener(MouseEvent.CLICK, mouseClickHighScores);
								/* FlxG.log("btn_highscores"); /**/
							}
							else if (dsoChild.name == "btn_sponsor")
							{
								dsoChild.addEventListener(MouseEvent.CLICK, mouseClickSponsor);
								/* FlxG.log("btn_sponsor"); /**/
							}
						}
						//	Associando evento ao clicar no MovieClip da tela de How To Play
						if (currentFrame >= howToPlayFrame)
						{
							if (dsoChild.name == "area_tela_howtoplay")
							{
								dsoChild.addEventListener(MouseEvent.CLICK, mouseClickHowToScreen);
								/* FlxG.log("area_tela_howtoplay"); /**/
							}
						}
						
					}	
					/* FlxG.log("n e' MC: " + dsoChild.name); */
					setChildrenEvents(dsoChild as DisplayObjectContainer, currentFrame, ++iDepth);
				}
				else
				{
					/*if(dsoChild is TextField)
						FlxG.log(TextField(dsoChild).text);
					else if(dsoChild is StaticText)
						FlxG.log(StaticText(dsoChild).text);
					else if (dsoChild is Shape)
						FlxG.log("This Shape x = " + dsoChild.x);
					else
						FlxG.log(sDummyTabs + "\t" + dsoChild);*/
				}
			}
		}
		
		/**
		 * Localiza os MovieClips dentro de dsObject (no caso, o loader do nosso SWF) e remove deles os eventos de click
		 * @param	dsObject
		 * @param	iDepth
		 */
		private function removeChildrenEvents(dsObject:DisplayObjectContainer, iDepth:int = 0):void 
		{
			//FlxG.log("removeChildrenEvents");
			var i:int = 0;
			var sDummyTabs:String = "";
			var dsoChild:DisplayObject;
			for (i ; i < iDepth ; i++)
				sDummyTabs += "\t";
			//FlxG.log(sDummyTabs + "\t" + "dsObject.numChildren = " + dsObject.numChildren);
			//FlxG.log(sDummyTabs + dsObject);
			if (dsObject == null)
				return;
			for (i = 0; i < dsObject.numChildren ; ++i)
			{
				dsoChild = dsObject.getChildAt(i);
				if (dsoChild is DisplayObjectContainer && 0 < DisplayObjectContainer(dsoChild).numChildren)
				{
					if (dsoChild is MovieClip)
					{
						if (dsoChild.name == "btn_startgame")
						{
							//FlxG.log("*");
							dsoChild.removeEventListener(MouseEvent.CLICK, mouseClickStartGame);
							//FlxG.log(".");
						}
						else if (dsoChild.name == "btn_survival")
						{
							//FlxG.log("*");
							dsoChild.removeEventListener(MouseEvent.CLICK, mouseClickStartGameSurvival);
							//FlxG.log(".");
						}
						else if (dsoChild.name == "btn_survival_plus")
						{
							//FlxG.log("*");
							dsoChild.removeEventListener(MouseEvent.CLICK, mouseClickStartGameSurvivalPlus);
							//FlxG.log(".");
						}
						else if (dsoChild.name == "btn_howtoplay")
						{
							//FlxG.log("*");
							dsoChild.removeEventListener(MouseEvent.CLICK, mouseClickHowTo);
							//FlxG.log(".");
						}
						else if (dsoChild.name == "btn_highscores")
						{
							//FlxG.log("*");
							dsoChild.removeEventListener(MouseEvent.CLICK, mouseClickHighScores);
							//FlxG.log(".");
						}
						else if (dsoChild.name == "btn_sponsor")
						{
							//FlxG.log("*");
							dsoChild.removeEventListener(MouseEvent.CLICK, mouseClickSponsor);
							//FlxG.log(".");
						}
						else if (dsoChild.name == "area_tela_howtoplay")
						{
							dsoChild.addEventListener(MouseEvent.CLICK, mouseClickHowToScreen);
							/* FlxG.log("area_tela_howtoplay"); */
						}
					}
					removeChildrenEvents(dsoChild as DisplayObjectContainer,++iDepth);
				}
				else
				{
					/*if(dsoChild is TextField)
						FlxG.log(TextField(dsoChild).text);
					else if(dsoChild is StaticText)
						FlxG.log(StaticText(dsoChild).text);
					else if (dsoChild is Shape)
						FlxG.log("This Shape x = " + dsoChild.x);
					else
						FlxG.log(sDummyTabs + "\t" + dsoChild);*/
				}
			}
		}
		
		/**
		 * 	Se este state nao foi o sorteado para mostrar a HelloMetric, simplesmente chama end()
		 * 	Caso contrario, esconde a animacao, mostra a HelloMetric e so chama end depois do OK na 
		 * metrica (verificacao feita no update())
		 */
		private function tryEnd():void
		{
			if (TopLevel.isHelloMetricForThisState(this) && !TopLevel.helloMetricLogged)
			{
				TopLevel.helloMetricLogged = true;
				
				//	NAO TEVE JEITO... nao consegui reposicionar helloMetricSplash aqui. So´ deixou eu fazer isso em MenuState()...
				//Entao mantive helloMetricSplash sempre no (0,0) e adicionei ela aqui, por cima do MovieClip carregado do swf
				add(helloMetricSplash);	//	por cima de tudo

				MovieClip(loader.content).x = FlxG.width + 10;
			}
			else
				end();
		}
		
		/**
		 * 	Indo embora. Descarrega a animacao, remove os event listeners, remove o helloMetricSplash (se for o caso)
		 * e restaura o frame rate
		 * 	NOTE - Estava tentando dar override no destroy, mas por alguma razao ele acabava chamando o destroy duas
		 * vezes, o que quebrava tudo
		 */
		/*override public function destroy*/private function end():void 
		{			
			//	removendo os event listeners dos botoes
			removeChildrenEvents(DisplayObjectContainer(loader.content));
			
			//	Don't forget to remove and unload the swf
			clipLoaded = false;	//	para nao quebrar no update()
			
			removeChild(loader);
			loader.unloadAndStop();
			
			//	NOTE - Como tivemos que forcar o update() de helloMetricSplash, forcamos o destroy() aqui apenas por garantia
			if (helloMetricSplash)
				helloMetricSplash.destroy();
			
			//	Voltando ao frame rate padrao do jogo
			FlxG.framerate 			= 60;
			FlxG.frameratePaused 	= 10;
			
			//	Musica com direito a pegalandra do Madinho...
			FlxG.play(Sounds.SndCrateDies, 0);	//	Super xunxo contra o baixo astral
			TopLevel.inGameMusic.play();
			
			//	E vamos ao jogo!
			FlxG.state = new Playstate();
			
			//super.destroy();
		}
		
		private function startGame():void {
			/* FlxG.log("startGame()"); */
			TWFlxG_utils.playAtAnyVolume(Sounds.SndStartGameButtonClick,1.0,false,true/*Survive! Senao e' cortado*/);
			TopLevel.gameMode = "normal";
			tryEnd();
		}
		
		private function startGameSurv():void {
			/* FlxG.log("startGameSurvival()"); */
			TWFlxG_utils.playAtAnyVolume(Sounds.SndStartGameButtonClick,1.0,false,true/*Survive! Senao e' cortado*/);
			TopLevel.gameMode = "survival";
			tryEnd();
		}
		
		private function startGameSurvPlus():void {
			/* FlxG.log("startGameSurvival+()"); */
			TWFlxG_utils.playAtAnyVolume(Sounds.SndStartGameButtonClick,1.0,false,true/*Survive! Senao e' cortado*/);
			TopLevel.gameMode = "survival+";
			tryEnd();
		}
		
		/**
		 * Alem de ir para o frame com a tela de How To Play, linka o clique no MovieClip dessa tela a goToMenu()
		 */
		private function goHowTo():void {
			/* FlxG.log("goHowTo()"); */
			MovieClip(loader.content).gotoAndPlay(howToPlayFrame);
			//if(!howToPlayEventsAssigned)
				setChildrenEvents(DisplayObjectContainer(loader.content), howToPlayFrame);
			howToPlayEventsAssigned = true;
		}
		
		private function startHighScores():void {
			//	TODO
			
		}
		
		private function goToSponsor():void {
			//	TODO
		}
		
		private function goToMenu():void {
			/* FlxG.log("goToMenu()"); */
			MovieClip(loader.content).gotoAndPlay(explosionFrame);
		}
		/*
		private function arrangeMenuScreen():void
		{
			btnBack.visible = false;
			background.loadGraphic(Images.ImgMenuScreen);
		}
		
		private function arrangeHowToScreen():void
		{
			btnBack.visible = true;
			background.loadGraphic(Images.ImgHowTo);
		}*/
		
		/**
		 * Funcao interna para mouseUp no botao Start Game
		 * Tambem sinaliza que a intro/menu ja foi carregada pela 1a vez (ver update())
		 */
		protected function mouseClickStartGame(event:MouseEvent):void
		{
			startGame();
			TopLevel.firstTimeIntroLoaded = false;
		}
		
		/**
		 * Funcao interna para mouseUp no botao Survival
		 * Tambem sinaliza que a intro/menu ja foi carregada pela 1a vez (ver update())
		 */
		protected function mouseClickStartGameSurvival(event:MouseEvent):void
		{
			startGameSurv();
			TopLevel.firstTimeIntroLoaded = false;
		}
		
		/**
		 * Funcao interna para mouseUp no botao Survival+
		 * Tambem sinaliza que a intro/menu ja foi carregada pela 1a vez (ver update())
		 */
		protected function mouseClickStartGameSurvivalPlus(event:MouseEvent):void
		{
			startGameSurvPlus();
			TopLevel.firstTimeIntroLoaded = false;
		}
		
		/**
		 * Funcao interna para mouseUp no botao HighScores
		 * Tambem sinaliza que a intro/menu ja foi carregada pela 1a vez (ver update())
		 */
		protected function mouseClickHighScores(event:MouseEvent):void
		{
			startHighScores();
			TopLevel.firstTimeIntroLoaded = false;
		}
		
		/**
		 * Funcao interna para mouseUp no botao HowTo
		 * Tambem sinaliza que a intro/menu ja foi carregada pela 1a vez (ver update())
		 */
		protected function mouseClickHowTo(event:MouseEvent):void
		{
			goHowTo();
			TopLevel.firstTimeIntroLoaded = false;
		}
		
		/**
		 * Funcao interna para mouseUp no botao Sponsor Space
		 * Tambem sinaliza que a intro/menu ja foi carregada pela 1a vez (ver update())
		 */
		protected function mouseClickSponsor(event:MouseEvent):void
		{
			goToSponsor();
			TopLevel.firstTimeIntroLoaded = false;
		}
		
		/**
		 * Funcao interna para mouseUp no botao Sponsor Space
		 * Tambem sinaliza que a intro/menu ja foi carregada pela 1a vez (ver update())
		 */
		protected function mouseClickHowToScreen(event:MouseEvent):void
		{
			/* FlxG.log("mouseClickHowToScreen"); */
			goToMenu();
			TopLevel.firstTimeIntroLoaded = false;
		}
		
	}

}
package timewave.states 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import timewave.core.assets.Images;
	//import SWFStats.Log;
	import SWFStats.*;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import timewave.core.globals.TopLevel;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import flash.ui.Mouse;	//	Para mostrar o mouse que a Flixel esconde durante o preloader da FOG API
	
	/**
	 * ...
	 * @author Brian May
	 */
	public class SplashState extends FlxState
	{
		
		private const splashTimewave:FlxSprite = new FlxSprite(0, 0, Images.ImgSplashTimeWave);
		private const splashSponsor:FlxSprite = new FlxSprite(0, 0, Images.ImgSplashSponsor);
		private var timer:uint;
		private var cursorHalfWidth:uint;
		private var cursorHalfHeight:uint;
		
		private var splashClicked:Boolean;
		
		//	Para uso com a FOG API (um cliente nosso)
		//	No background do preloader deles colocamos um mapa e alguns tanques
		/*[Embed(source = '../../../../Art/Release/BGFOG_Layer0.txt', mimeType = "application/octet-stream")] private var MapLayer1:Class;
		[Embed(source = '../../../../Art/Release/BGFOG_Layer1.txt', mimeType = "application/octet-stream")] private var MapLayer2:Class;
		private const layer1:FlxTilemap = new FlxTilemap();
		private const layer2:FlxTilemap = new FlxTilemap();
		private var levels:Map = new Map();
		private const player:PlayerTank = new PlayerTank();
		private var finallyStarted:Boolean;
		private var vy:Number = -1;*/
		
		private var finallyStarted:Boolean;
		
		public function SplashState() 
		{
			FlxG.mouse.load(Images.ImgCrossHair);
			cursorHalfWidth = FlxG.mouse.cursor.width / 2;
			cursorHalfHeight = FlxG.mouse.cursor.height / 2;
			
			splashClicked = false;
			
			finallyStarted = false;
			
			TopLevel.logDefaultPanel();
			
			/*if(CONFIG::USE_FOG_API)
			{
				//	Layers do mapa...
				layer1.loadMap(new MapLayer1, Images.ImgTiles, 32, 32);
				layer1.drawIndex = 1;
				layer1.collideIndex	= 168;
				layer1.fixed = true;
				add(layer1);//,true
				
				layer2.loadMap(new MapLayer2, Images.ImgTiles, 32, 32);
				layer2.drawIndex = 1;
				layer2.collideIndex = 168;
				layer2.fixed = true;
				add(layer2);//,true
				
				//	tanque
				player.body.x = 32;
				player.body.y = layer1.height - 64;
				player.body.angle = 90;
				add(player);
			}*/
		}
		
		override public function create():void 
		{	
			if(!CONFIG::USE_FOG_API)
			{
				FlxG.flash.start(0xff000000, 1, showTimewave);
				add(splashSponsor);
				add(splashTimewave);
			}
			
			super.create();
			
			/*FlxG.state = new MenuState();/////////////////	DEBUGRE! APAGAR!!*/
		}
		
		override public function update():void 
		{
			//	Se utilizando a API da FOG (um cliente nosso), ficamos travados ate´ terminar o preloader deles
			if (CONFIG::USE_FOG_API)
			{
				if(TopLevel.FOGPreloaderFinished)
				{
					if (!finallyStarted)
					{
						FlxG.flash.start(0xff000000, 1, showTimewave);
						//add(splashSponsor);
						add(splashTimewave);
						finallyStarted = true;
						Mouse.hide();
					}
				}
				/*else	//	enquanto o preloader carrega, o tanque fica andando pra cima e pra baixo
				{
					if (player.body.y <= 0 || player.body.y > (layer1.height - 64))
						vy = -vy;

					player.body.y += vy;
					player.body.update();	
					
					Mouse.show();
					//return;
				}*/
			}
			
			FlxG.mouse.show();
			FlxG.mouse.cursor.x -= cursorHalfWidth;	//	frescura
			FlxG.mouse.cursor.y -= cursorHalfHeight;//	"
			
			//	Ao clique ou Enter: Se foi na tela da logo da TW, abre o site
			if (!CONFIG::USE_FOG_API)	//	(Dependendo do comprador, nao permite splash clicavel)
			{
				if ( FlxG.keys.pressed("ENTER") || (FlxG.mouse.justPressed() && !splashClicked))
				{
					if (splashTimewave.visible/* && mouseVisible*/)
					{
						splashClicked = true;
						try {
							Log.CustomMetric("TimeWave splash clicked");
							//	TODO FIXME - Enquanto no nosso site e no FGL, nao linkamos
							//	FIXME - Colocar o link para a secao do site correspondente a esse jogo
							//	FIXME - Atualizar a API do Playtomic (playtomic.com - accounts@timewavegames.com/passpadrão) para
							//poder usar o comando Link
							navigateToURL(new URLRequest("http://www.timewavegames.com/#games"), '_blank'); // second argument is target
							//Link.Open("http://www.timewavegames.com/site/trace/game/tnk", "Splash", "TWG");
						} catch (e:Error) {
							 trace("Error occurred!");
						}
					}
					//else	//	...senao, vai para o menu
					//	goMainMenu();
				}
			}
			
			super.update();
		}
		
		private function showTimewave():void {
			timer = setTimeout(fadeToSponsor, 1500);
		}
		
		private function fadeToSponsor():void {
			//FlxG.fade.start(0xff000000, 1, flashToSponsor);	com splash de sponsor
			goIntroAndMenuState();	//	sem splash de sponsor
		}
		
		private function flashToSponsor():void {
			FlxG.fade.stop();
			FlxG.flash.start(0xff000000, 1, showSponsor);
			splashTimewave.visible = false;
		}
		
		private function showSponsor():void {
			timer = setTimeout(goIntroAndMenuState, 1000);
		}
		
		private function goIntroAndMenuState():void {
			clearTimeout(timer);
			FlxG.fade.stop();
			FlxG.flash.stop();
			FlxG.fade.start(0xff000000, 1, function():void { FlxG.state = new MenuState() } );
		}
		
	}

}
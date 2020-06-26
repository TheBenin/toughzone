package fog.as3 {
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import fog.as3.utils.Debug;
	import fog.as3.FogDevAPI;
	import fog.as3.assets.LogoFly;
	
	/**
	 * FogDev API
	 * fog.as3.FogDevPreloader
	 * ...
	 * @version				2.1
	 * @author				Marc Qualie
	 */
	
	public class FogDevPreloader extends MovieClip {
		
		[Embed(source = 'assets/assets.swf', symbol='LogoSpin')]
		public const LogoSpin:Class;
		[Embed(source = 'assets/assets.swf', symbol='LogoStill')]
		public const LogoStill:Class;
		[Embed(source = 'assets/assets.swf', symbol='PreloaderHolder')]
		public const PreloaderHolder:Class;
		[Embed(source = 'assets/assets.swf', symbol='ProgressBar')]
		public const ProgressBar:Class;
		[Embed(source = 'assets/assets.swf', symbol='ProgressText')]
		public const ProgressText:Class;
		[Embed(source = 'assets/assets.swf', symbol = 'VoiceOver')]
		public const VoiceOver:Class;
		
		// Clips
		public var Core:FogDevAPI;
		public var IDE:String;
		public var Background:Sprite		= new Sprite();
		public var Logo:MovieClip;
		public var Logo2:MovieClip;
		public var PreloaderClip:MovieClip;
		public var ProgBar:MovieClip;
		public var ProgText:MovieClip;
		public var Button:MovieClip;
		
		// Variables
		public var TimerStart:int;
		public var PreloaderSize:int		= 0;
		public var Density:int				= 10;
		public var Duration:int				= 5000;
		public var DurationFade:int			= 1000;
		public var DurationWait:int			= 5000;
		public var FadeSteps:int			= 50;
		public var Percent:int;
		public var PercentGame:Number;
		public var PercentDura:Number;
		private var g:Graphics;
		
		public function FogDevPreloader(C:FogDevAPI) {
			Core = C;
			SetBackgroundColor(0x000000);
		}
		
		// Customization
		public function SetBackground(mv:MovieClip): void {
			Background.addChild(mv);
		}
		public function SetBackgroundColor(cl:int): void {
			g = Background.graphics;
			g.clear();
			g.beginFill(cl);
			g.drawRect(0, 0, Core.Width, Core.Height);
			g.endFill();
		}
		
		// Start Preloader
		public function Start(F:* = null): void {
			
			// Handle Callback Function
			if (typeof F == 'function') {
				Core.addEventListener('loaded', F);
			} else {
				Core.addEventListener('loaded', function(e:Event): void { Core.Clip.play(); } );
			}
			
			// Get Remote Library
			TimerStart = getTimer();
			Core.Tracking.Ping();
			
			Core.addChild(this);
		//	if (root.loaderInfo.bytesLoaded == root.loaderInfo.bytesTotal) Debug.log("There may be a probelm with your preloader, please check your export settings");
			PreloaderSize = root.loaderInfo.bytesLoaded;
			if (PreloaderSize == root.loaderInfo.bytesTotal) PreloaderSize = 0;
			
			// Background (Needs improving)
			//addChild(Background);
			
			// Logo
			Logo = new LogoStill() as MovieClip;
			Logo.x = Core.Width / 2;
			Logo.y = Core.Height / 2 - Logo.height / 4;
			addChild(Logo);
			
			// Loader Bar
			PreloaderClip = new PreloaderHolder() as MovieClip;
			PreloaderClip.x = Logo.x;
			PreloaderClip.y = Logo.y + Logo.height / 2 + PreloaderClip.height / 2;
			addChild(PreloaderClip);
			
			// Progress bar
			ProgBar = new ProgressBar() as MovieClip;
			ProgBar.x = -39.0;
			ProgBar.y = -8.1;
			PreloaderClip.addChild(ProgBar);
			
			// Progress text
			ProgText = new ProgressText() as MovieClip;
			ProgText.stop();
			ProgText.x = -62.8;
			ProgText.y = -14.1;
			ProgText.width = 17.6;
			ProgText.height = 21.1;
			PreloaderClip.addChild(ProgText);

			// Cover Button (Sends users to FOG)
			Button = new MovieClip();
			Button.buttonMode = true;
			g = Button.graphics;
			g.beginFill(0x000000);
			g.drawRect(0, 0, Core.Width, Core.Height);
			g.endFill();
			Button.alpha = 0;
			Button.GotoURL = Core.Tracking.HomeURL;
			Button.addEventListener(MouseEvent.CLICK, Core.Tracking.Click);
			addChild(Button);
			
			// Fix Stuff?
			if (DurationFade > Duration) Duration = DurationFade;
			
			// Start loader..
			if (!typeof F == 'function')	/////////////////////	[Brizo]
				Core.Clip.stop();
			FadeIn();
			stage.addEventListener(Event.ENTER_FRAME, showProgress);
			
			// Play voice over
			//var vo:Sound = new VoiceOver() as Sound;
			//vo.play(0, 1);
		}
		
		// Progress
		private function showProgress(e:Event): void {
			PercentGame = Math.floor((root.loaderInfo.bytesLoaded - PreloaderSize) / (root.loaderInfo.bytesTotal - PreloaderSize) * 100);
			PercentDura = Math.floor(((getTimer() - TimerStart) / Duration) * 100);
			Percent = Math.round(Math.min(Math.min(PercentGame, PercentDura), 100));
			ProgText.gotoAndStop(Percent + 1);
			ProgBar.width = Percent * 0.98;
			if (Percent > 99) {
				stage.removeEventListener(Event.ENTER_FRAME, showProgress);
				SpinLogo();
				Wait();
			}
			loadingBar(e);
		}
		public function SpinLogo(): void {
			Logo2 = new LogoSpin() as MovieClip;
			Logo2.x = Logo.x;
			Logo2.y = Logo.y;
			addChild(Logo2);
			Logo2.play();
			removeChild(Logo);
			swapChildren(Button, Logo2);
		}
		private function loadingBar(e:Event): void {
			if (getTimer() % Math.round(root.stage.frameRate / Density) === 0) {
				var fog:LogoFly = new LogoFly(Core, Core.Width / 2, Core.Height / 2);
				Background.addChild(fog);
			}
		}

		// Attach objects to library, under the game
		public function addObject(o:*): void {
			addChild(o);
		}
		
		// Wait, play bramding, start game, fade out
		private function Wait(): void {
			setTimeout(Unload, DurationWait);
		}
		private function Unload(): void {
			if (Core.Game.Disabled) {
				trace("> Game will never start! :)");
			} else if (Core.Tracking.Library) {
				Core.Tracking.LibraryCall('LoadHandle', { } );
			} else {
				FadeOut();
			}
		}
		private function FadeIn(): void {
			if (DurationFade < 1) return;
			alpha = 0;
			for (var i:int, l:int = FadeSteps; i < l; i++) {
				setTimeout(function(t:DisplayObject): void { if (t) t.alpha += 1 / FadeSteps; }, (DurationFade / FadeSteps) * i, this);
			}
		}
		public function FadeOut(): void {
			setTimeout(Clean, 1000);
			Core.dispatchEvent(new Event("loaded"));
			if (DurationWait < 1) return;
			alpha = 1;
			for (var i:int, l:int = FadeSteps; i < l; i++) {
				setTimeout(function(t:DisplayObject): void { if (t) t.alpha -= 1 / FadeSteps; }, (DurationFade / FadeSteps) * i, this);
			}
		}
		public function Clean(force:Boolean = false): void {
			Button.removeEventListener(MouseEvent.CLICK, Core.Tracking.Click);
			for (var i:int = 0; i < numChildren; i++) {
				removeChildAt(0);
			}
			Core.removeChild(this);
			Core.dispatchEvent(new Event('cleaned'));
		}
		
	}

}
package fog.as3 {
	
	import flash.display.MovieClip;	
	import fog.as3.utils.Debug;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	/**
	 * FogDev API
	 * fog.as3.FogDevAPI
	 * ...
	 * @version				2.1
	 * @author				Marc Qualie
	 */
	public class FogDevAPI extends MovieClip {
		
		// References
		public var Preloader:FogDevPreloader;
		public var Tracking:FogDevTracking;
		public var Assets:FogDevAssets;
		
		// Variables
		public var Clip:Object				= new Object;
		public var Options:Object			= new Object();
		public var Sandbox:Boolean			= false;
		public var Width:int;
		public var Height:int;
		public var Version:String			= '2.1';
		public var Build:String				= '0.15.0.0';
		private var TestID:String			= '4d4018e4964ac';
		public var ID:String				= '';
		public var Game:Object				= new Object();
		public var Locked:Boolean			= false;
		
		// Main Class
		public function FogDevAPI(opt:Object) {
			
			// Define Defaults
			var defaults:Object = { }
			Options = parseOptions(opt, defaults);
			Clip = Options.root;
			Game.URL = '';
			Game.Tag = '';
			Game.Title = '';
			Game.Related = new Array();
			
			// Define Sandbox
			ID = Options.id ? Options.id : "";
			Sandbox = Options.sandbox ? true : false;
			if (ID == 'YOUR_ID_HERE') ID = TestID;
			if (!ID) Locked = true;
			
			// Add To Stage
			Clip.stage.addChild(this);
			Width = Options.width ? Options.width : Clip.stage.stageWidth;
			Height = Options.height ? Options.height : Clip.stage.stageHeight;
			
			// Add References
			this.Preloader = new FogDevPreloader(this);
			this.Tracking = new FogDevTracking(this);
			this.Assets = new FogDevAssets(this);
			
			// Context Menu
			var ctxMenu:ContextMenu = new ContextMenu();
			ctxMenu.hideBuiltInItems();
			var ctx1:ContextMenuItem = new ContextMenuItem("Play More Games");
				ctx1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (e:ContextMenuEvent) : void {
					Tracking.GotoURL();
				});
			var ctx2:ContextMenuItem = new ContextMenuItem("Free Games For Your Website");
				ctx2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (e:ContextMenuEvent) : void {
					Tracking.GotoURL("http://www.freegamesforyourwebsite.com/");
				});
			var ctx3:ContextMenuItem = new ContextMenuItem("Copyright © Free Online Games");
				ctx3.separatorBefore = true;
			var ctx4:ContextMenuItem = new ContextMenuItem("FOG API Version " + Version);
				ctx4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (e:ContextMenuEvent) : void {
					Tracking.GotoURL(Tracking.DevURL);
				});
			ctxMenu.customItems.push(ctx1, ctx2, ctx3, ctx4);
			Clip.contextMenu = ctxMenu;
			
			// Output
			Debug.log(" ");
			Debug.log("- *", "   ", "Welcome to FogDevAPI v" + this.Version + " (Build " + this.Build + ")");
			Debug.log("- *", "   ", "If you need assistance or examples for this API, please visit:");
			Debug.log("- *", "   ", "; http://www.marcqualie.com/projects/fogdev/");
			Debug.log("- *");
			Debug.log("- *", "   ", "ID:", ID, (Sandbox ? " (This Game is running in Sandbox Mode)" : ""));
			Debug.log("- *", "   ", "Domain:", Tracking.Info.domain + " (" + (Tracking.isFogDomain() ? "Internal" : "External") + ")");
			Debug.log("- *", "   ", "Resolution:", Width, " x ", Height);
			
			// Warn about ID
			if (ID == TestID) {
				Debug.log(" ");
				Debug.log("- *", "   ", "=| This is a Demo ID. Please update your ID as soon as possible! |=");
			}
			
		}
		
		// Backwards compatibility for old library
		public function debug(s:String): void { return Debug.log(s); }
		
		// Parse Options
		private function parseOptions(options:Object, defaults:Object): Object {
            var optcopy:Object = {}, k:String;
            for (k in defaults) { optcopy[k] = defaults[k]; }
            if (options) { for (k in options) { optcopy[k] = options[k]; } }
			return optcopy;
		}
		
		// Library Call Alias
		public function LibraryCall(f:String, o:Object): * {
			try {
				if (Tracking.Library[f]) {
					return Tracking.Library[f](o);
				} else {
					trace("> Library Error: " + f + " function not found");
				}
			} catch (e:Error) {
				trace("> Fatal Library Error: " + e.message);
			}
		}
		
		//
		public function SiteLock(): void {
			Locked = true;
		}
		
	}
	
}
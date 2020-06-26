package fog.as3 {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.system.Security;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import fog.as3.FogDevAPI;
	import fog.as3.utils.Debug;
	
	/**
	 * FogDev API
	 * fog.as3.FogDevTracking
	 * ...
	 * @version				2.1
	 * @author				Marc Qualie
	 */
	public class FogDevTracking {
		
		private var Core:FogDevAPI;
		public var HomeURL:String				= 'http://www.freeonlinegames.com/';
		public var GameURL:String				= 'http://www.freeonlinegames.com/game/{game.url}.html';
		public var TagURL:String				= 'http://www.freeonlinegames.com/tag/{game.tag}/';
		public var DevURL:String				= 'http://www.fogdev.com/';
		public var FGFYWURL:String				= 'http://www.freegamesforyourwebsite.com/game/{game.url}/';
		public var WalkthroughURL:String		= 'http://www.freeonlinegames.com/walkthrough/{game.url}.html';
		public var Info:Object					= new Object();
		public var LocalMode:Boolean			= false;
		public var Server:String				= 'x.fogdev.com';
		private var LibFile:String				= 'api/library-v2.swf';
		private var LibPath:String				= '';
		public var Library:MovieClip;
		private var rLoader:Loader;
		private var rRequest:URLRequest;
		
		public function FogDevTracking(C:FogDevAPI) {
			Core = C;
			Info = GetUrlInfo(Core.root.loaderInfo.url);
		}
		
		// Triggered from mouse click events
		public function Click(e:MouseEvent): void {
			var u:String = e.currentTarget.GotoURL;
			GotoURL(u);
		}
		
		// Take the user to a URL
		public function GotoURL(u:String = ''): void {
			var base:String = u ? u : HomeURL;
			if (base.indexOf('{game.url}') > -1) {
				if (Core.Game.URL.length > 0) {
					base = base.replace("{game.url}", Core.Game.URL);
					base = base.replace("{game.tag}", Core.Game.Tag);
				} else {
					trace("> Tracking Error: FogAPI.Game.URL is not defined");
					base = base.replace("{game.url}", Core.ID);
				}
			}
			if (base.indexOf('{game.tag}') > -1) {
				if (Core.Game.Tag.length > 0) {
					trace("Tag: " + Core.Game.Tag);
					base = base.replace("{game.tag}", Core.Game.Tag);
				} else {
					trace("> Tracking Error: FogAPI.Game.Tag is not defined");
					base = base.replace("{game.tag}", "misc-games");
				}
			}
			var pars:String = "?utm_source=" + Info.domain + "&utm_medium=api-game&utm_campaign=" + Core.ID;
			if (isFogDomain()) pars = "";
			var url:String = base + pars;
			trace(" ");
			trace("Tracking: ", url);
			var LibCallSuccess:Boolean = Core.ID ? Core.LibraryCall("GotoURL", { 'url':url } ) : false;
			if (!LibCallSuccess) {
				trace("GotoURL (Local): " + url);
				if (Core.Sandbox) return;
				navigateToURL(new URLRequest(url), "_blank");
			}
		}
		
		// Ping Server with Data
		public function Ping(t:String = ''): void {
			Debug.log(" ");
			Debug.log("Remote Tracking");
//			if (!Core.ID) { Debug.log("> Disabled due to Site Lock. This is normal"); return; }
			if (Core.Sandbox) { Debug.log("> Disabled due Sandbox. Try correcting your ID?"); return; }
			Security.allowDomain(Server);
			Security.loadPolicyFile('http://' + Server + '/crossdomain.xml');
			LibPath = "http://" + Server + "/" + LibFile + "?v=" + Core.Version + "&c=" + Math.random();
			Debug.log('> SWF: ' + LibPath);
			rLoader = new Loader();
			rRequest = new URLRequest(LibPath);
			rLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event): void {
				Library = MovieClip(e.target.content);
				try {
					Library.Connect(Core);
				} catch (e:Error) {
					Library = null;
					Debug.log("> Corrupt Library: ", e.message);
				}
			});
			rLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent): void { Debug.log('> IO Error (SWF): ' + e.text); });
			rLoader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, function(e:HTTPStatusEvent): void { /*Debug.log('> HTTP Event (SWF): ' + e.status);*/ });
			rLoader.load(rRequest);
		}
		
		// Attempts to call functions from the Library (Alias)
		public function LibraryCall(f:String, o:Object): * { return Core.LibraryCall(f, o); }
		
		// Get where the game is currently being played, for tracking
		private function GetUrlInfo(url:String): Object {
			LocalMode = new RegExp("file://").test(url);
			var domain:String = '', uri:String = '';
			if (LocalMode) {
				domain = 'local';
				uri = '';
			} else {
				var urlStart:Number = url.indexOf("://") + 3;
				var urlEnd:Number = url.indexOf("/", urlStart);
				domain = url.substring(urlStart, urlEnd);
				var LastDot:Number = domain.lastIndexOf(".") - 1;
				var domEnd:Number = domain.lastIndexOf(".", LastDot) + 1;
				uri = url.substr(urlEnd);
			}
			return {'domain':domain, 'uri':uri};
		}
		public function isFogDomain(): Boolean {
			return Info.domain.indexOf('freeonlinegames.com') > -1
				|| Info.domain.indexOf('fog.com') > -1
				|| Info.domain.indexOf('fogdev.com') > -1
				|| Info.domain.indexOf('freegamesforyourwebsite.com') > -1
			? true : false;
		}
		
	}

}
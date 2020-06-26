package fog.as3 {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import fog.as3.FogDevAPI;
	
	/**
	 * FogDev API
	 * fog.as3.FogDevAssets
	 * ...
	 * @version				2.1
	 * @author				Marc Qualie
	 */
	
	public class FogDevAssets extends MovieClip {
		
		private var Core:FogDevAPI;
		
		// MovieClips
		[Embed(source='assets/assets.swf', symbol='MiniLogo')]
		private var MiniLogoClass:Class;
		
		// Sprites
		
		
		public function FogDevAssets(C:FogDevAPI) {
			Core = C;
		}
		
		// Mini Logo
		public function MiniLogo(): MovieClip {
			var m:MovieClip = new MiniLogoClass() as MovieClip;
		//	m.assignLink = function(u:String): void {
		//		this.GotoURL = u;
		//		this.addEventListener(MouseEvent.CLICK, Core.Tracking.Click);
		//	}
			return m;
		}
		
	}

}
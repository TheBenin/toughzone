package fog.as3.utils {
	
	/**
	 * FogDev API
	 * fog.as3.utils.Debug
	 * ...
	 * @version				2.1
	 * @author				Marc Qualie
	 */
	
	public class Debug {
		
		public static var Enabled:Boolean = true;
		
		public static function log(s:*, s1:* = '', s2:* = '', s3:* = '', s4:* = '', s5:* = '', s6:* = ''): void {
			if (!Debug.Enabled) return;
			for (var i:int = 1; i < arguments.length; i++) {
				s += " " + arguments[i];
			}
			trace(s);
		}
		
	}

}
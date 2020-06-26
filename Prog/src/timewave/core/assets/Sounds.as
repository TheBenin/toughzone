package timewave.core.assets 
{
	/**
	 * ...
	 * @author Max
	 */
	public class Sounds
	{
		
		[Embed(source = '../../../../../Audio/Release/grenadeExplosion.mp3')] public static var SndGranadeExplosion:Class;
		
		[Embed(source = '../../../../../Audio/Release/EnemyDies.mp3')] 		public static var SndEnemyDies:Class;
		[Embed(source = '../../../../../Audio/Release/crateDies.mp3')] 		public static var SndCrateDies:Class;
		
		[Embed(source = '../../../../../Audio/Release/turretShot1.mp3')] 	public static var SndTurretShot1:Class;
		[Embed(source = '../../../../../Audio/Release/turretShot2.mp3')] 	public static var SndTurretShot2:Class;
		[Embed(source = '../../../../../Audio/Release/dmgInflicted1.mp3')] 	public static var SndDmgInflicted1:Class;
		[Embed(source = '../../../../../Audio/Release/dmgInflicted2.mp3')] 	public static var SndDmgInflicted2:Class;
		[Embed(source = '../../../../../Audio/Release/dmgSuffered.mp3')] 	public static var SndDmgSuffered:Class;
		[Embed(source = '../../../../../Audio/Release/heavyShot1.mp3')] 	public static var SndHeavyShot1:Class;
		
		[Embed(source = '../../../../../Audio/Release/playerRebirth.mp3')] 	public static var SndPlayerRebirth:Class;
		[Embed(source = '../../../../../Audio/Release/powerupColection.mp3')] 	public static var SndPowerupColection:Class;
		
		[Embed(source = '../../../../../Audio/Release/startGameButtonClick.mp3')] 	public static var SndStartGameButtonClick:Class;
		
		[Embed(source = '../../../../../Audio/Release/timeOverBeep.mp3')] 	public static var SndTimeOverBeep:Class;
		
		//[Embed(source = "../../../../../Audio/Release/silentGap.mp3")] 		public static var SndGap:Class;
		//[Embed(source = "../../../../../Audio/Release/tankintro.637024virgula5.mp3")] 	public static var MusicIntro:Class;
		[Embed(source = "../../../../../Audio/Release/ingame2_2117241.mp3")] 	public static var MusicInGame:Class;
		
		//	Pois e'! Vamos tocar a musica como um swf externo gerado pelo Flash CS5 p nao nos incomodar com audio q nao loopa direito
		[Embed(source = "../../../../../Audio/Release/IngameMusicLoop.swf", mimeType = "application/octet-stream")] public static var SwfInGameMusicLoop:Class;
		
		
		public function Sounds() 
		{
			
		}
		
	}

}
package timewave.core.globals 
{
	/**
	 * ...
	 * @author Wolff, Brizoman and The Wailers
	 */
	public class ScoreTable
	{
		public static const BOX_SCORE:uint = 10;
		public static const POWERUP_SCORE:uint = 7500;
		
		public static var powerUpStatsSpeed:uint = 0;
		public static var powerUpStatsDamage:uint = 0;
		public static var powerUpStatsTry:uint = 0;
		public static var powerUpStatsHealth:uint = 0;
		public static var powerUpStatsBomb:uint = 0;
		
		/**	Tiros dados durante todo o jogo */
		public static var shotsTotal:uint = 0;
		
		/** Tiros acertados durante todo o jogo */
		public static var shotsHit:uint = 0;
		
		public function ScoreTable() 
		{
			
		}
		
		///
		///	Reseta estatisticas que se aplicam ao jogo todo (powerUpStatsSpeed, powerUpStatsDamage, shootsTotal, shootsHit...)
		///
		public static function resetOverallStats():void {
			ScoreTable.powerUpStatsSpeed = ScoreTable.powerUpStatsDamage = ScoreTable.powerUpStatsHealth = ScoreTable.powerUpStatsTry = 0;
			ScoreTable.shotsTotal = ScoreTable.shotsHit = 0;
		}
	}

}
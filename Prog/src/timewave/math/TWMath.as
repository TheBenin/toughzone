package timewave.math 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Wolff
	 */

	 
	public class TWMath
	{
		
		public function TWMath() 
		{
			
		}
		
		public static function areEqual(num1:Number, num2:Number, tolerancy:Number=(Number.MIN_VALUE / 2)):Boolean
		{
			return Math.abs(num1 - num2) < tolerancy;
		}
		
		/// converte radianos para graus
		public static function radToDeg(radians:Number):Number {
			return radians * 180 / Math.PI;
		}
		
		/// converte graus para radianos
		public static function degToRad(degrees:Number):Number {
			return degrees * Math.PI / 180;
		}
		
		///	Retorna o quadrado da distancia entre dois pontos
		public static function getDistanceSqr(point1:Point, point2:Point):Number {
			var diffX:Number = point2.x - point1.x;
			var diffY:Number = point2.y - point1.y;
			var newDiff:Number = Math.abs(diffX * diffY + diffX * diffY);
			return newDiff;
		}
		
	}

}
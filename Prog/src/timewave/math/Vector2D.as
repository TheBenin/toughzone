package timewave.math 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import timewave.math.SimpleVector;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Wolff
	 */
	public class Vector2D
	{
		private static const lines:MovieClip = new MovieClip();
		private static const vectorDraw:Vector.<SimpleVector> = new Vector.<SimpleVector>();
		
		public function Vector2D() 
		{
		}
		
		public static function addDrawVector(vetor:SimpleVector):void {
			Vector2D.vectorDraw.push(vetor);
		}
		
		public static function replaceDrawVector(vetor:SimpleVector):void {
			for (var i:int = 0; i < vectorDraw.length; i++) 
			{
				if (vectorDraw[i] == vetor) {
					vectorDraw.splice(i, 1);
				}
			}
			vectorDraw.push(vetor);
		}
		
		public static function drawVector():void 
		{
			FlxG.stage.addChild(Vector2D.lines);
			Vector2D.lines.graphics.clear();
			for (var i:int = 0; i < vectorDraw.length; i++) 
			{
				Vector2D.lines.graphics.moveTo(0, 0);
				Vector2D.lines.graphics.lineStyle(2,0xff00ffff, 1);
				Vector2D.lines.graphics.lineTo(vectorDraw[i].x, vectorDraw[i].y);
			}
		}
		
		public static function createSimpleVector(posX:Number,posY:Number):SimpleVector {
			return new SimpleVector(posX, posY);
		}
		
		/// retorna um vetor criado a partir de seu modulo e seu angulo(radianos) com o eixo x
		public static function createBySizeAndAngle(modulus:Number,angle:Number):SimpleVector {
			return new SimpleVector(modulus * Math.cos(angle), modulus * Math.sin(angle));
		}
		
		public static function createPerpendicular(vetor:SimpleVector):SimpleVector {
			return new SimpleVector(-vetor.y,vetor.x);
		}
		
		public static function opSum(vetor1:SimpleVector, vetor2:SimpleVector):SimpleVector {
			return new SimpleVector(vetor1.x + vetor2.x, vetor1.y + vetor2);
		}
		
		public static function opTimes(vetor:SimpleVector, number:Number):SimpleVector {
			return new SimpleVector(vetor.x * number, vetor.y * number);
		}
		
		public static function opMinus(vetor1:SimpleVector, vetor2:SimpleVector):SimpleVector {
			return new SimpleVector(vetor1.x - vetor2.x,vetor1.y - vetor2.y);
		}
		
		public static function opDivide(vetor:SimpleVector, number:Number):SimpleVector {
			return new SimpleVector(vetor.x / number, vetor.y / number);
		}
		
		public static function opPlusEqual(vetor1:SimpleVector, vetor2:SimpleVector):void {
			vetor1.x += vetor2.x;
			vetor1.y += vetor2.y;
		}
		
		public static function opMinusEqual(vetor1:SimpleVector, vetor2:SimpleVector):void {
			vetor1.x -= vetor2.x;
			vetor1.y -= vetor2.y;
		}
		
		public static function opTimesEqual(vetor1:SimpleVector, number:Number):void {
			vetor1.x *= number;
			vetor1.y *= number;
		}
		
		public static function opDivisionEqual(vetor1:SimpleVector, number:Number):void {
			vetor1.x /= number;
			vetor1.y /= number;
		}
		
		/// retorna o angulo que um vetor faz com o eixo X no sentido anti-horario (segundo a regra da mao direita),
		/// de 0 a 2 PI
		public static function angle(vetor:SimpleVector):Number {
			var number:Number = Math.atan2(vetor.y, vetor.x);
			if (number < 0) {
				number += 2 * Math.PI;
			}
			return number;
		}
		
		/// o mesmo que angle mas de 0 a -PI e 0 a PI
		public static function angle2(vetor:SimpleVector):Number {
			return Math.atan2(vetor.y, vetor.x);
		}
		
		/// retorna o modulo (comprimento) de um vetor
		public static function modulus(vetor:SimpleVector):Number {
			return Math.sqrt(vetor.x * vetor.x + vetor.y * vetor.y);
		}
		
		public static function modulusSqr(vetor:SimpleVector):Number {
			return vetor.x * vetor.x + vetor.y * vetor.y;
		}
		
		/// retorna -1 se o vetor2 for anti-horario em relacao ao vetor 1, caso o contrario 1
		public static function getClockWise(vetor1:SimpleVector, vetor2:SimpleVector):Number {
			if (vetor1.y * vetor2.x > vetor1.x * vetor2.y) {
				return -1;
			}
			else
			{
				return 1;
			}
		}
		
		//	Retorna a distancia entre dois pontos representados por vetor1 e vetor2
		public static function getDistance(vetor1:SimpleVector, vetor2:SimpleVector):Number {
			var separationX:Number = vetor2.x - vetor1.x;
			var separationY:Number = vetor2.y - vetor1.y;
			return Math.sqrt(separationX*separationX + separationY*separationY);
		}
		
		//	Retorna o quadrado da distancia entre dois pontos representados por vetor1 e vetor2
		public static function getDistanceSq(vetor1:SimpleVector, vetor2:SimpleVector):Number {
			var separationX:Number = vetor2.x - vetor1.x;
			var separationY:Number = vetor2.y - vetor1.y;
			return separationX * separationX + separationY * separationY;
		}
		
		//	Trunca o modulo (tamanho) do vetor para max
		public static function truncate(vetor:SimpleVector, max:Number):void
		{
		  if (Vector2D.modulus(vetor) > max)
		  {
			Vector2D.normalize(vetor);
			Vector2D.opTimesEqual(vetor,max);
		  }
		}
		
		// retorna o produto escalar entre vetor1 e vetor2
		public static function dot(vetor1:SimpleVector, vetor2:SimpleVector):Number {
			return vetor1.x * vetor2.x + vetor1.y * vetor2.y;
		}
		
		public static function areEqual(vetor1:SimpleVector, vetor2:SimpleButton):Boolean {
			return TWMath.areEqual(vetor1.x,vetor2.x) && TWMath.areEqual(vetor1.y,vetor2.y);
		}
		
		public static function areDifferent(vetor1:SimpleVector, vetor2:SimpleVector):Boolean {
			return !(TWMath.areEqual(vetor1.x,vetor2.x) && TWMath.areEqual(vetor1.y,vetor2.y));
		}
		
		///	Reflete o vetor1 em relacao ao (normalizado) vetor2 (como uma bola rebatendo numa parede)
		public static function reflect(vetor1:SimpleVector, vetorNorm:SimpleVector): void
		{
			vetor1.x += 2.0 * Vector2D.dot(vetor1, vetorNorm) * (Vector2D.getReverse(vetorNorm)).x;
			vetor1.y += 2.0 * Vector2D.dot(vetor1, vetorNorm) * (Vector2D.getReverse(vetorNorm)).y;
		}
		
		//	Retorna o vetor inverso de vetor1
		public static function getReverse(vetor1:SimpleVector): SimpleVector
		{
			return new SimpleVector(-vetor1.x, -vetor1.y);
		}
		
		///		Rotaciona este vetor de angle radianos (no sentido anti-horario se
		///	os eixos corrdenados forem assim):
		///		y
		///		|
		///		|____x
		///
		public static function rotate(vetor1:SimpleVector, angle:Number): void
		{
			var s:Number = Math.sin(angle);
			var c:Number = Math.cos(angle);
			var newX:Number = vetor1.x * c - vetor1.y * s;
			var newY:Number = vetor1.x * s + vetor1.y * c;
			vetor1.x = newX;
			vetor1.y = newY;
		}
		
		public static function normalize(vetor1:SimpleVector):SimpleVector {
			var modulus:Number = Vector2D.modulus(vetor1);
			return new SimpleVector(vetor1.x / modulus, vetor1.y / modulus);
		}
		
		public static function angleBetween(vetor1:SimpleVector, vetor2:SimpleVector):Number {
			var dp:Number = Vector2D.dot(vetor1, vetor2);
			//Força que o valor esteja na faixa esperada pelo C++
			//Se os floats fossem totalmente precisos,
			//não precisaríamos fazer esses testes
			if (dp >= 1) {
				dp = 1;
			}else if (dp <= -1) {
				dp = -1;
			}
			//Faz o cálculo do ângulo.
			var angPi:Number = Math.acos(dp);
			//teste de lado para definir o sinal
			if ( vetor1.y * (vetor2.x) > vetor1.x * (vetor2.y)) {
				return -angPi;
			}else {
				return angPi;
			}
		}
	}

}

//treats a window as a toroid
/*inline void WrapAround(Vector2D &pos, int MaxX, int MaxY)
{
  if (pos.x > MaxX) {pos.x = 0.0;}

  if (pos.x < 0)    {pos.x = (float)MaxX;}

  if (pos.y < 0)    {pos.y = (float)MaxY;}

  if (pos.y > MaxY) {pos.y = 0.0;}
}

//returns true if the point p is not inside the region defined by top_left
//and bot_rgt
inline bool NotInsideRegion(Vector2D p,
                            Vector2D top_left,
                            Vector2D bot_rgt)
{
  return (p.x < top_left.x) || (p.x > bot_rgt.x) || 
         (p.y < top_left.y) || (p.y > bot_rgt.y);
}

inline bool InsideRegion(Vector2D p,
                         Vector2D top_left,
                         Vector2D bot_rgt)
{
  return !((p.x < top_left.x) || (p.x > bot_rgt.x) || 
         (p.y < top_left.y) || (p.y > bot_rgt.y));
}

inline bool InsideRegion(Vector2D p, int left, int top, int right, int bottom)
{
  return !( (p.x < left) || (p.x > right) || (p.y < top) || (p.y > bottom) );
}

//------------------ isSecondInFOVOfFirst -------------------------------------
//
//  returns true if the target position is in the field of view of the entity
//  positioned at posFirst facing in facingFirst
//-----------------------------------------------------------------------------
inline bool isSecondInFOVOfFirst(Vector2D posFirst,
                                 Vector2D facingFirst,
                                 Vector2D posSecond,
                                 float    fov)
{
  Vector2D toTarget = Vec2DNormalize(posSecond - posFirst);

  return facingFirst.Dot(toTarget) >= cos(fov/2.0);
}
*/

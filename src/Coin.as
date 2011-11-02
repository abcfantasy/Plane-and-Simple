package
{
	import flash.geom.Point;
	import org.flixel.FlxSprite
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	
	public class Coin extends FlxSprite
	{
		[Embed(source="../assets/coin.png")] public var coinImage:Class;
		
		protected static const COIN_RADIUS:int = 8;		// radius of coin, used for collision
		
		private var player_:*;							// reference to player, used for collision
		
		public function Coin(x:int, y:int, player:*)
		{
			player_ = player;
			super(x, y, coinImage);
		}
		
		/**
		   Original function by Pieter Iserbyt:
		   http://local.wasp.uwa.edu.au/~pbourke/geometry/pointline/DistancePoint.java
		   from Paul Bourke's website:
		   http://local.wasp.uwa.edu.au/~pbourke/geometry/pointline/
		 */
		private function pointToLineDistance(p1x:int, p1y:int, p2x:int, p2y:int, p3x:int, p3y:int):Number
		{
			var xDelta:Number = p2x - p1x;
			var yDelta:Number = p2y - p1y;
			if ((xDelta == 0) && (yDelta == 0))
			{
				// p1 and p2 cannot be the same point
				p2x += 1;
				p2y += 1;
				xDelta = 1;
				yDelta = 1;
			}
			var u:Number = ((p3x - p1x) * xDelta + (p3y - p1y) * yDelta) / (xDelta * xDelta + yDelta * yDelta);
			var closestPoint:Point;
			if (u < 0)
			{
				closestPoint = new Point(p1x, p1y);
			}
			else if (u > 1)
			{
				closestPoint = new Point(p2x, p2y);
			}
			else
			{
				closestPoint = new Point(p1x + u * xDelta, p1y + u * yDelta);
			}
			return Point.distance(closestPoint, new Point(p3x, p3y));
		}
		
		override public function update():void
		{
			// get player plane coordinates
			var p1Coord:Point = player_.getLeftPlaneCoord();
			var p2Coord:Point = player_.getRightPlaneCoord();
			
			// check collision with string
			var dist:Number = pointToLineDistance( 
				p1Coord.x + 20, p1Coord.y + 20, 
				p2Coord.x + 20, p2Coord.y + 20, 
				this.x + Coin.COIN_RADIUS, this.y + Coin.COIN_RADIUS );
			
			// within distance threshold
			if (dist >= -1 && dist <= 1)
				this.kill();
			
			super.update();
		}
	
	}

}
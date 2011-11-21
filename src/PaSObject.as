package  
{
	import flash.geom.Point;
	import org.flixel.FlxSprite
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	
	public class PaSObject extends FlxSprite
	{
		public static const RADIUS:int = 8;		// radius of coin, used for collision
		public static const THRESHOLD:int = 5;	// distance from line to coint must be smaller than this
		public var player_:*;					// reference to player, used for collision
		protected var emitter_:*;
		
		public function PaSObject(x:int, y:int, player:*, emitter:*) 
		{
			super(x, y);
			player_ = player;
			emitter_ = emitter;
		}
		
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
		
		public function withinRange():Boolean
		{
			// get player plane coordinates
			var p1Coord:Point = this.player_.getLeftPlaneCoord();
			var p2Coord:Point = this.player_.getRightPlaneCoord();
			
			// check collision with string
			var dist:Number = this.pointToLineDistance( 
				p1Coord.x + 20, p1Coord.y + 20, 
				p2Coord.x + 20, p2Coord.y + 20, 
				this.x + RADIUS, this.y + RADIUS );
			
			return (dist >= -THRESHOLD && dist <= THRESHOLD);
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}
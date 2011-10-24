package  
{
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	
	/*
	 * Note about drag: Drag in flixel automatically decelerates an object ONLY when 
	 * there is no acceleration. Therefore, if object is moving to the left, and player
	 * accelerates to the right, the object should first slow down according to the 
	 * "rightwards" acceleration + drag acceleration. This drag needs to be added
	 * manually. - Andrew
	 */
	public class Player extends FlxObject
	{
		// images of the planes
		[Embed(source = "../assets/left.png")]public var leftPlaneImage:Class;
		[Embed(source = "../assets/right.png")]public var rightPlaneImage:Class;
		
		// sprite objects
		private var playerLeft:FlxSprite;
		private var playerRight:FlxSprite;
		
		// constants
		protected static const PLAYER_RUN_SPEED:int = 300;
		protected static const STRING_DISTANCE:int = 80;
		
		public function Player( x:int, y:int, parent:FlxState ) 
		{
			// create the plane sprites
			playerLeft = new FlxSprite( x - 40, y, leftPlaneImage );
			playerRight = new FlxSprite( x + 40, y, rightPlaneImage );
			
			// set the drag and maximum velocity of left plane
			playerLeft.drag.x = PLAYER_RUN_SPEED * 1.5;
			playerLeft.drag.y = PLAYER_RUN_SPEED * 1.5;
			playerLeft.maxVelocity.x = 300;
			playerLeft.maxVelocity.y = 300;
			
			// set the drag and maximum velocity of right plane
			playerRight.drag.x = PLAYER_RUN_SPEED * 1.5;
			playerRight.drag.y = PLAYER_RUN_SPEED * 1.5;
			playerRight.maxVelocity.x = 300;
			playerRight.maxVelocity.y = 300;
			
			// add the planes to the parent game state
			parent.add( playerLeft );
			parent.add( playerRight );
			
			super( x, y );
		}
		
		private function updateLeftPlane():void
		{
			// reset acceleration every frame
			playerLeft.acceleration.x = 0;
			playerLeft.acceleration.y = 0;
			
			// keys input
			if ( FlxG.keys.RIGHT )		// right direction
			{
				if ( playerLeft.velocity.x < 0 )		// if moving left, add drag to acceleration (note above)
					playerLeft.acceleration.x = PLAYER_RUN_SPEED + playerLeft.drag.x;
				else
					playerLeft.acceleration.x = PLAYER_RUN_SPEED;
			}
			if ( FlxG.keys.LEFT )		// left direction
			{
				if ( playerLeft.velocity.x > 0 )
					playerLeft.acceleration.x = -PLAYER_RUN_SPEED - playerLeft.drag.x;
				else
					playerLeft.acceleration.x = -PLAYER_RUN_SPEED;
			}
			if ( FlxG.keys.UP )			// up direction
			{
				if ( playerLeft.velocity.y > 0 )
					playerLeft.acceleration.y = -PLAYER_RUN_SPEED - playerLeft.drag.y;
				else
					playerLeft.acceleration.y = -PLAYER_RUN_SPEED;		
			}
			if ( FlxG.keys.DOWN )		// down direction
			{
				if ( playerLeft.velocity.y < 0 )
					playerLeft.acceleration.y = PLAYER_RUN_SPEED + playerLeft.drag.y;
				else
					playerLeft.acceleration.y = PLAYER_RUN_SPEED;
			}
			
			// check string limitations
			/*
			if ( playerLeft.velocity.x != 0 )
			{
			if ( playerLeft.x - playerRight.x > STRING_DISTANCE )
				playerRight.x += playerLeft.x - playerRight.x - STRING_DISTANCE;
			else if ( playerRight.x - playerLeft.x > STRING_DISTANCE )
				playerRight.x -= playerRight.x - playerLeft.x - STRING_DISTANCE;
			}
			
			if ( playerLeft.velocity.y != 0 )
			{
				if ( playerLeft.y - playerRight.y > STRING_DISTANCE )
					playerRight.y += playerLeft.y - playerRight.y - STRING_DISTANCE;
				else if ( playerRight.y - playerLeft.y > STRING_DISTANCE )
					playerRight.y -= playerRight.y - playerLeft.y - STRING_DISTANCE;
			}
			*/
		}
		
		private function updateRightPlane():void
		{
			// reset acceleration every frame
			playerRight.acceleration.x = 0;
			playerRight.acceleration.y = 0;
			
			// keys input
			if ( FlxG.keys.D )		// right direction
			{
				if ( playerRight.velocity.x < 0 )
					playerRight.acceleration.x = PLAYER_RUN_SPEED + playerRight.drag.x;
				else
					playerRight.acceleration.x = PLAYER_RUN_SPEED;
			}
			
			if ( FlxG.keys.A )		// left direction
			{
				if ( playerRight.velocity.x > 0 )
					playerRight.acceleration.x = -PLAYER_RUN_SPEED - playerRight.drag.x;
				else
					playerRight.acceleration.x = -PLAYER_RUN_SPEED;
			}
			if ( FlxG.keys.W )		// up direction
			{
				if ( playerRight.velocity.y > 0 )
					playerRight.acceleration.y = -PLAYER_RUN_SPEED - playerRight.drag.y;
				else
					playerRight.acceleration.y = -PLAYER_RUN_SPEED;		
			}
			if ( FlxG.keys.S )		// down direction
			{
				if ( playerRight.velocity.y < 0 )
					playerRight.acceleration.y = PLAYER_RUN_SPEED + playerRight.drag.y;
				else
					playerRight.acceleration.y = PLAYER_RUN_SPEED;
			}
			
			// string limitations
			/*
			if ( playerRight.velocity.x != 0 )
			{
			if ( playerLeft.x - playerRight.x > 80 )
				playerLeft.x -= playerLeft.x - playerRight.x - 80;
			else if ( playerRight.x - playerLeft.x > 80 )
				playerLeft.x += playerRight.x - playerLeft.x - 80;
			}
			
			if ( playerRight.velocity.y != 0 )
			{
				if ( playerRight.y - playerLeft.y > STRING_DISTANCE )
					playerLeft.y += playerRight.y - playerLeft.y - STRING_DISTANCE;
				else if ( playerLeft.y - playerRight.y > STRING_DISTANCE )
					playerLeft.y -= playerLeft.y - playerRight.y - STRING_DISTANCE;
			}
			*/
		}
		
		override public function update():void 
		{
			updateLeftPlane();
			updateRightPlane();

			super.update();
		}
	}

}
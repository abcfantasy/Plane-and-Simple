package  
{
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	
	public class Player extends FlxObject
	{
		[Embed(source = "../assets/left.png")]public var leftPlaneImage:Class;
		[Embed(source = "../assets/right.png")]public var rightPlaneImage:Class;
		
		private var playerLeft:FlxSprite;
		private var playerRight:FlxSprite;
		
		protected static const PLAYER_RUN_SPEED:int = 300;
		protected static const STRING_DISTANCE:int = 80;
		
		public function Player( x:int, y:int, parent:FlxState ) 
		{
			playerLeft = new FlxSprite( x - 40, y, leftPlaneImage );
			playerRight = new FlxSprite( x + 40, y, rightPlaneImage );
			
			playerLeft.drag.x = PLAYER_RUN_SPEED * 1.5;
			playerLeft.drag.y = PLAYER_RUN_SPEED * 1.5;
			playerLeft.maxVelocity.x = 300;
			playerLeft.maxVelocity.y = 300;
			
			playerRight.drag.x = PLAYER_RUN_SPEED * 1.5;
			playerRight.drag.y = PLAYER_RUN_SPEED * 1.5;
			playerRight.maxVelocity.x = 300;
			playerRight.maxVelocity.y = 300;
			
			parent.add( playerLeft );
			parent.add( playerRight );
			
			super( x, y );
		}
		
		private function updateLeftPlane():void
		{
			playerLeft.acceleration.x = 0;
			playerLeft.acceleration.y = 0;
			
			// keys input
			if ( FlxG.keys.RIGHT )
			{
				if ( playerLeft.velocity.x < 0 )
					playerLeft.acceleration.x = PLAYER_RUN_SPEED + playerLeft.drag.x;
				else
					playerLeft.acceleration.x = PLAYER_RUN_SPEED;
			}
			if ( FlxG.keys.LEFT )
			{
				if ( playerLeft.velocity.x > 0 )
					playerLeft.acceleration.x = -PLAYER_RUN_SPEED - playerLeft.drag.x;
				else
					playerLeft.acceleration.x = -PLAYER_RUN_SPEED;
			}
			if ( FlxG.keys.UP )
			{
				if ( playerLeft.velocity.y > 0 )
					playerLeft.acceleration.y = -PLAYER_RUN_SPEED - playerLeft.drag.y;
				else
					playerLeft.acceleration.y = -PLAYER_RUN_SPEED;		
			}
			if ( FlxG.keys.DOWN )
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
			playerRight.acceleration.x = 0;
			playerRight.acceleration.y = 0;
			
			// keys input
			if ( FlxG.keys.D )
			{
				if ( playerRight.velocity.x < 0 )
					playerRight.acceleration.x = PLAYER_RUN_SPEED + playerRight.drag.x;
				else
					playerRight.acceleration.x = PLAYER_RUN_SPEED;
			}
			
			if ( FlxG.keys.A )
			{
				if ( playerRight.velocity.x > 0 )
					playerRight.acceleration.x = -PLAYER_RUN_SPEED - playerRight.drag.x;
				else
					playerRight.acceleration.x = -PLAYER_RUN_SPEED;
			}
			if ( FlxG.keys.W )
			{
				if ( playerRight.velocity.y > 0 )
					playerRight.acceleration.y = -PLAYER_RUN_SPEED - playerRight.drag.y;
				else
					playerRight.acceleration.y = -PLAYER_RUN_SPEED;		
			}
			if ( FlxG.keys.S )
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
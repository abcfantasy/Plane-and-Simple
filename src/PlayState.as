package  
{
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	
	public class PlayState extends FlxState
	{
		public var _world:b2World;
		private var p:Player;		// the player object
		
		
		// sort of "constructor"
		override public function create():void 
		{
			super.create();
			setupWorld();
			this.add( p = new Player(100, 50, this, _world ) );		// add the player object
			
		}
		
		private function setupWorld():void 
		{
			var gravity:b2Vec2 = new b2Vec2(0, 0); 
			_world = new b2World(gravity, false);
		}
		
		override public function update():void 
		{
			_world.Step(FlxG.elapsed, 10, 10);
			_world.DrawDebugData();
			
			super.update();
			
			// boundaries
			/*
			if ( player.x < 0 ) {
				player.x = 0;
			}
			else if ( (player.x + player.width) > FlxG.width ) {
				player.x = (FlxG.width - player.width)
			}
			
			if ( player.y < 0 ) {
				player.y = 0;
			}
			else if ( (player.y + player.height ) > FlxG.height ) {
				player.y = (FlxG.height - player.height )
			}
			
			if ( player2.x < 0 ) {
				player2.x = 0;
			}
			else if ( (player2.x + player2.width) > FlxG.width ) {
				player2.x = (FlxG.width - player2.width)
			}
			
			if ( player2.y < 0 ) {
				player2.y = 0;
			}
			else if ( (player2.y + player2.height ) > FlxG.height ) {
				player2.y = (FlxG.height - player2.height )
			}*/
		}
	}

}
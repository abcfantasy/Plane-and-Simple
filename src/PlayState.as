package  
{
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	
	public class PlayState extends FlxState
	{
		private var p:Player;
		
		override public function create():void 
		{
			super.create();
			this.add( p = new Player(100, 50, this ) );
			//this.add( player = new PlayerPlane( 50, 50 ) );
			//this.add( player2 = new PlayerPlane2( 100, 50 ) );
		}
		
		override public function update():void 
		{
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
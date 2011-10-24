package 
{
	import org.flixel.FlxGame;
	
	public class Main extends FlxGame 
	{
		public function Main()
		{
			// initialize first game state
			super(800, 600, PlayState, 1 );	
		}
	}
	
}
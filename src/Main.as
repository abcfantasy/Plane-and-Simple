package 
{
	import org.flixel.FlxGame;
/*	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Joints;
	import Box2D.Dynamics.Contacts.*;*/
	
	public class Main extends FlxGame 
	{
		public function Main()
		{
			// initialize first game state at 800x600 1x zoom
			super(800, 621, PlayState, 1 );	
		}
	}
	
}
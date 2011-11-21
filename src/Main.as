package 
{
	import org.flixel.FlxGame;
	import States.MenuState;
	import Managers.SettingsManager;
	
	public class Main extends FlxGame 
	{
		public function Main()
		{
			// initialize first game state at 800x600 1x zoom
			//super(1200, 700, PlayState, 1);
			//super(800, 621, PlayState, 1 );
			super(800, 600, MenuState, 1 );	
			SettingsManager.loadGame();
		}
	}
}
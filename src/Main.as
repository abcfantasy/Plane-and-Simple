package 
{
	import org.flixel.FlxGame;
	import States.MenuState;
	import Managers.SettingsManager;
	
	public class Main extends FlxGame 
	{
		public function Main()
		{
			// initialize first game state at 800x500 1x zoom
			super(800, 500, MenuState, 1 );	
			SettingsManager.loadGame();
		}
	}
}
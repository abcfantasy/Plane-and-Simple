package Managers
{
	import org.flixel.FlxG;
	import Managers.SettingsManager;
	
	// this class handles input mainly for menus (not for gameplay)
	public class InputManager 
	{
		// input to confirm (such as ENTER)
		public static function confirm():Boolean
		{
			return FlxG.keys.justPressed( "ENTER" ) || FlxG.keys.justPressed( "SPACE" ); // add xbox input
		}
		
		// input to exit (such as ESC)
		public static function exit():Boolean
		{
			return FlxG.keys.justPressed( "ESCAPE" ); // add xbox input
		}
		
		// input for up
		public static function up():Boolean
		{
			return FlxG.keys.justPressed( "UP" ) || FlxG.keys.justPressed( "W" ); // add xbox input
		}
		
		// input for down
		public static function down():Boolean
		{
			return FlxG.keys.justPressed( "DOWN" ) || FlxG.keys.justPressed( "S" ); // add xbox input
		}
	}

}
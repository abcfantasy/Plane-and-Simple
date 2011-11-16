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
			if ( SettingsManager.Game_Controller == SettingsManager.KEYBOARD )
				return FlxG.keys.justPressed( "ENTER" ) || FlxG.keys.justPressed( "SPACE" );
			// else handle input for Xbox
			
			return false;
		}
		
		// input to exit (such as ESC)
		public static function exit():Boolean
		{
			if ( SettingsManager.Game_Controller == SettingsManager.KEYBOARD )
				return FlxG.keys.justPressed( "ESCAPE" );
			// else handle input for Xbox
			
			return false;
		}
		
		// input for up
		public static function up():Boolean
		{
			if ( SettingsManager.Game_Controller == SettingsManager.KEYBOARD )
				return FlxG.keys.justPressed( "UP" ) || FlxG.keys.justPressed( "W" );
			// else handle input for Xbox
			
			return false;
		}
		
		// input for down
		public static function down():Boolean
		{
			if ( SettingsManager.Game_Controller == SettingsManager.KEYBOARD )
				return FlxG.keys.justPressed( "DOWN" ) || FlxG.keys.justPressed( "S" );
			// else handle input for Xbox
			
			return false;
		}
	}

}
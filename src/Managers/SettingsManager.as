package Managers
{
	import org.flixel.FlxSave;
	public class SettingsManager 
	{
		// enumeration of controller types
		public static const KEYBOARD:int = 0;
		public static const XBOX:int = 1;
		
		// controller used (default KEYBOARD)
		public static var Game_Controller:int = KEYBOARD;
		
		// max level player can play
		public static var Max_Level:int = 1;
		
		// save file
		private static const _saveName:String = "Planeandsimple"
		private static var _save:FlxSave;
		private static var _loaded:Boolean = false; //Did bind() work? Do we have a valid SharedObject?
		
		// loads the game
		public static function loadGame():void
		{
			_save = new FlxSave();
			_loaded = _save.bind(_saveName);
			if ( _loaded )
			{
				if ( _save.data.levels == null )
					_save.data.levels = 1;
				if ( _save.data.controller == null )
					_save.data.controller = 0;

				// set settings
				SettingsManager.Max_Level = _save.data.levels;
				SettingsManager.Game_Controller = _save.data.controller;
			}
		}
		
		// saves the game
		public static function saveGame():void
		{
			_save.data.levels = SettingsManager.Max_Level;
			_save.data.controller = SettingsManager.Game_Controller;
		}
		
		// gets the game controller used as string
		public static function getGameControllerString():String
		{
			if ( Game_Controller == KEYBOARD )
				return "Keyboard";
			else
				return "Xbox";
		}
		
		// changes the controller option
		public static function toggleController():void
		{
			if ( Game_Controller == KEYBOARD )
				Game_Controller = XBOX;
			else
				Game_Controller = KEYBOARD;
		}
	}

}
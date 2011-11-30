package Managers
{
	import org.flixel.FlxSave;
	import GamePads.*;
	public class SettingsManager 
	{
		// enumeration of controller types
		public static const KEYBOARD:int = 0;
		public static const XBOX:int = 1;
		
		// controller used (default KEYBOARD)
		public static var Game_Controller:int = KEYBOARD;
		
		// enumeration of player modes
		public static const SINGLEPLAYER:int = 0;
		public static const MULTIPLAYER:int = 1;
		
		// player mode used (default SINGLEPLAYER)
		public static var Player_mode:int = SINGLEPLAYER;
		
		// enumeration of game modes
		public static const TIME_MODE:int = 1;
		public static const POINT_MODE:int = 2;
		
		// game mode used (default TIME_MODE)
		public static var Game_mode:int = TIME_MODE;
		
		// max level player can play
		public static var Max_Level:int = 1; // Not working as intended?
		public static var Last_Level:int = 5;
		
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
			_save.forceSave();
		}
		
		// save time of a level if better than previous
		public static function saveLevelTime( level:int, time:Number ):void
		{
			if ( _save.read( level + "time" ) == null || ( (Number)(_save.read( level + "time" )) * 1000 ) > ( time * 1000 ) )
			{
				_save.write( level + "time", time );
			}
			saveGame();
		}
		
		// load time of a level
		public static function loadLevelTime( level:int ):Number
		{
			if ( _save.read( level + "time" ) == null )
				return 0;
			else
				return (Number)(_save.read( level + "time" ));
		}
		
		// gets the game controller used as string
		public static function getGameControllerString():String
		{
			if ( Game_Controller == KEYBOARD )
				return "KEYBOARD";
			else
				return "XBOX";
		}
		
		// gets the player mode as string
		public static function getPlayerModeString():String
		{
			if (Player_mode == SINGLEPLAYER)
				return "Singleplayer";
			else
				return "Multiplayer";
		}
		
		// gets the game mode as string
		public static function getGameModeString():String
		{
			if ( Game_mode == TIME_MODE )
				return "Time-based";
			else
				return "Point-based";
		}
		
		// changes the controller option
		public static function toggleController():void
		{
			if ( Game_Controller == KEYBOARD )
				Game_Controller = XBOX;
			else
				Game_Controller = KEYBOARD;
		}
		
		// changes the player mode option
		public static function togglePlayerMode():void
		{
			if ( Player_mode == SINGLEPLAYER )
				Player_mode = MULTIPLAYER;
			else
				Player_mode = SINGLEPLAYER;
		}
		
		// changes the game mode option
		public static function toggleGameMode():void
		{
			if ( Game_mode == TIME_MODE )
				Game_mode = POINT_MODE;
			else
				Game_mode = TIME_MODE;
		}
		
		// erases the saved data
		public static function clearData():void
		{
			if ( _save != null ) {
				_save.erase();
				loadGame();
			}
		}
	}

}
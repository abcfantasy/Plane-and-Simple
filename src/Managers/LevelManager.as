package Managers
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxG;
	
	public class LevelManager 
	{
		// level 1 background - but, we only use one background at the moment?
		[Embed(source = "../../assets/graphics/1-5bg.jpg")] public static var level1BgImage:Class;		
		// level 1 tiles - but, we only use one tileset at the moment?
		[Embed(source="../../assets/graphics/tiles_asteroid_line3.png")] private static var stage1Tiles:Class;
		// Maps:
		[Embed(source = "../../assets/maps/1tutlvl.txt", mimeType = "application/octet-stream")] private static var level1MapString:Class;
		[Embed(source = "../../assets/maps/2tutlvl.txt", mimeType = "application/octet-stream")] private static var level2MapString:Class;
		[Embed(source = "../../assets/maps/3tutlvl.txt", mimeType = "application/octet-stream")] private static var level3MapString:Class;
		[Embed(source = "../../assets/maps/4tutlvl.txt", mimeType = "application/octet-stream")] private static var level4MapString:Class;
		[Embed(source = "../../assets/maps/5tutlvl.txt", mimeType = "application/octet-stream")] private static var level5MapString:Class;
		// Coins:
		
		private static const GAME_WIDTH:int = 800;
		private static const GAME_HEIGHT:int = 600;
		private static const TILE_SIZE:int = 16;
		
		// gets background image for given level
		public static function getBackgroundImage( level:int ) : FlxSprite
		{
			var background:FlxSprite = new FlxSprite();
			switch ( level ) {
				case 1:
					background = background.loadGraphic( level1BgImage, false, false, GAME_WIDTH, GAME_HEIGHT );
					break;
			}
			return background;
		}
		
		// gets the tile map for given level
		public static function getTileMap( level:int ) : FlxTilemap
		{
			var groundMap:FlxTilemap = new FlxTilemap();
			var chosenMap:String;
			switch ( level ) {
				case 1:
					chosenMap = new level1MapString;
					break;
				case 2:
					chosenMap = new level2MapString;
					break;
				case 3:
					chosenMap = new level3MapString;
					break;
				case 4:
					chosenMap = new level4MapString;
					break;
				case 5:
					chosenMap = new level5MapString;
					break;
			}
			groundMap = groundMap.loadMap(chosenMap, stage1Tiles, TILE_SIZE, TILE_SIZE);
			return groundMap;
		}
		
		// gets the list of coins for a given level
		public static function getCoins( level:int ) : Array
		{
			var coinList:Array = new Array();
			switch ( level ) {
				case 1:
					coinList.push( new FlxPoint( 158, 135 ) );
					coinList.push( new FlxPoint( 240, 380 ) );
					break;
			}
			return coinList;
		}
		
		// Returns the position of the Player
		public static function getPlayerPosition (level:int ) : FlxPoint
		{
			var position:FlxPoint;
			switch( level ) {
				case 1:
					position = new FlxPoint( 174, 67 );
					break;
				case 2:
					position = new FlxPoint( 106, 90 );
					break;
				case 3:
					position = new FlxPoint( 121, 67 );
					break;
				case 4:
					position = new FlxPoint( 184, 69 );
					break;
				case 5:
					position = new FlxPoint( 50, 220 );
					break;
			}	
			return position;
		}
	}
}
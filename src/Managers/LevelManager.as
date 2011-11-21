package Managers
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxG;
	
	public class LevelManager 
	{
		// level 1 background - but, we only use one background at the moment?
		[Embed(source = "../../assets/graphics/1-5bg.jpg")] public static var level5BgImage:Class;		
		// level 1 tiles - but, we only use one tileset at the moment?
		[Embed(source="../../assets/graphics/tiles_asteroid.png")] private static var stage1Tiles:Class;
		// Maps:
		[Embed(source = "../../assets/maps/tut1.txt", mimeType = "application/octet-stream")] private static var level1MapString:Class;
		[Embed(source = "../../assets/maps/tut2.txt", mimeType = "application/octet-stream")] private static var level2MapString:Class;
		[Embed(source = "../../assets/maps/tut3.txt", mimeType = "application/octet-stream")] private static var level3MapString:Class;
		[Embed(source = "../../assets/maps/tut4.txt", mimeType = "application/octet-stream")] private static var level4MapString:Class;
		[Embed(source = "../../assets/maps/tut5.txt", mimeType = "application/octet-stream")] private static var level5MapString:Class;
		// Coins:
		[Embed(source = "../../assets/maps/tut1coins.txt", mimeType = "application/octet-stream")] private static var level1Coins:Class;
		[Embed(source = "../../assets/maps/tut2coins.txt", mimeType = "application/octet-stream")] private static var level2Coins:Class;
		[Embed(source = "../../assets/maps/tut3coins.txt", mimeType = "application/octet-stream")] private static var level3Coins:Class;
		[Embed(source = "../../assets/maps/tut4coins.txt", mimeType = "application/octet-stream")] private static var level4Coins:Class;
		[Embed(source = "../../assets/maps/tut5coins.txt", mimeType = "application/octet-stream")] private static var level5Coins:Class;
		
		private static const GAME_WIDTH:int = 800;
		private static const GAME_HEIGHT:int = 600;
		private static const TILE_SIZE:int = 16;
		
		// gets background image for given level
		public static function getBackgroundImage( level:int ) : FlxSprite
		{
			var background:FlxSprite = new FlxSprite();
			switch ( level ) {
				case 1: // lovely ugly-hack to apply same bg to all 5 levels. :)
				case 2:
				case 3:
				case 4:
				case 5:
					background = background.loadGraphic( level5BgImage, false, false, GAME_WIDTH, GAME_HEIGHT );
					break;
			}
			return background;
		}
		
		// gets the tile map for given level
		public static function getTileMap( level:int ) : FlxTilemapExt
		{
			var groundMap:FlxTilemapExt = new FlxTilemapExt();
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
			groundMap = groundMap.loadMapExt(chosenMap, stage1Tiles, TILE_SIZE, TILE_SIZE);
			return groundMap;
		}
		
		// gets the list of coins for a given level
		public static function getCoins( level:int ) : Array
		{
			var coinData:String;
			var tempCoordList:Array = new Array();
			var tempCoin:Array = new Array();
			var coinList:Array = new Array();
			
			switch ( level ) {
				case 1:
					coinData = new level1Coins;
					break;
				case 2:
					coinData = new level2Coins;
					break;
				case 3:
					coinData = new level3Coins;
					break;
				case 4:
					coinData = new level4Coins;
					break;
				case 5:
					coinData = new level5Coins;
					break;
			}
			tempCoordList = coinData.split("\n");
			for (var i:int = 0; i < tempCoordList.length; i++)
			{
				tempCoin = tempCoordList[i].split(",");
				coinList.push( new FlxPoint( tempCoin[0], tempCoin[1] ) );
			}
			
			return coinList;
		}
		public static function getjewels( level:int ) : Array 
		{
			var jewelList:Array = new Array();
			switch ( level ) {
				case 1:
					jewelList.push( new FlxPoint( 500, 500 ) );
					jewelList.push( new FlxPoint( 100, 500 ) );
					break;
			}
			return jewelList;
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
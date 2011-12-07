package Managers
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxG;
	
	public class LevelManager 
	{
		// level 1-5 background
		[Embed(source = "../../assets/graphics/1-5bg.jpg")] public static var level1_5BgImage:Class;		
		// level 6-10 background
		[Embed(source = "../../assets/graphics/6-10.jpg")] public static var level6_10BgImage:Class;		
		// level 1-5 tiles
		[Embed(source = "../../assets/graphics/tiles_asteroid.png")] private static var stage1_5Tiles:Class;
		// level 6-10
		[Embed(source = "../../assets/graphics/tiles_blue_in_line2.png")] private static var stage6_10Tiles:Class;
		// boundary tiles
		[Embed(source="../../assets/graphics/edge_in_line.png")] private static var boundaryTiles:Class;
		
		// Maps:
		[Embed(source = "../../assets/maps/tut1.txt", mimeType = "application/octet-stream")] private static var level1MapString:Class;
		[Embed(source = "../../assets/maps/tut2.txt", mimeType = "application/octet-stream")] private static var level2MapString:Class;
		[Embed(source = "../../assets/maps/tut3.txt", mimeType = "application/octet-stream")] private static var level3MapString:Class;
		[Embed(source = "../../assets/maps/tut4.txt", mimeType = "application/octet-stream")] private static var level4MapString:Class;
		[Embed(source = "../../assets/maps/tut5.txt", mimeType = "application/octet-stream")] private static var level5MapString:Class;
		[Embed(source = "../../assets/maps/lvl6.txt", mimeType = "application/octet-stream")] private static var level6MapString:Class;
		// Coins:
		[Embed(source = "../../assets/maps/tut1coins.txt", mimeType = "application/octet-stream")] private static var level1Coins:Class;
		[Embed(source = "../../assets/maps/tut2coins.txt", mimeType = "application/octet-stream")] private static var level2Coins:Class;
		[Embed(source = "../../assets/maps/tut3coins.txt", mimeType = "application/octet-stream")] private static var level3Coins:Class;
		[Embed(source = "../../assets/maps/tut4coins.txt", mimeType = "application/octet-stream")] private static var level4Coins:Class;
		[Embed(source = "../../assets/maps/tut5coins.txt", mimeType = "application/octet-stream")] private static var level5Coins:Class;
		[Embed(source = "../../assets/maps/lvl6coins.txt", mimeType = "application/octet-stream")] private static var level6Coins:Class;
		// Jewels:
		[Embed(source = "../../assets/maps/tut1jewels.txt", mimeType = "application/octet-stream")] private static var level1Jewels:Class;
		[Embed(source = "../../assets/maps/tut2jewels.txt", mimeType = "application/octet-stream")] private static var level2Jewels:Class;
		[Embed(source = "../../assets/maps/tut3jewels.txt", mimeType = "application/octet-stream")] private static var level3Jewels:Class;
		[Embed(source = "../../assets/maps/tut4jewels.txt", mimeType = "application/octet-stream")] private static var level4Jewels:Class;
		[Embed(source = "../../assets/maps/tut5jewels.txt", mimeType = "application/octet-stream")] private static var level5Jewels:Class;
		[Embed(source = "../../assets/maps/lvl6jewels.txt", mimeType = "application/octet-stream")] private static var level6Jewels:Class;
		
		private static const GAME_WIDTH_SMALL:int = 800;
		private static const GAME_HEIGHT_SMALL:int = 600;
		private static const GAME_WIDTH_LARGE:int = 1600;
		private static const GAME_HEIGHT_LARGE:int = 1200;
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
					background = background.loadGraphic( level1_5BgImage, false, false, GAME_WIDTH_SMALL, GAME_HEIGHT_SMALL );
					break;
				case 6:
				case 7:
				case 8:
				case 9:
				case 10:
					background = background.loadGraphic( level6_10BgImage, false, false, GAME_WIDTH_LARGE, GAME_HEIGHT_LARGE );
					break;
			}
			return background;
		}
		
		// gets the tile map for given level
		public static function getTileMap( level:int ) : FlxTilemapExt
		{
			var groundMap:FlxTilemapExt = new FlxTilemapExt();
			var chosenMap:String;
			var tiles:Class;
			switch ( level ) {
				case 1:
					chosenMap = new level1MapString;
					tiles = stage1_5Tiles;
					break;
				case 2:
					chosenMap = new level2MapString;
					tiles = stage1_5Tiles;
					break;
				case 3:
					chosenMap = new level3MapString;
					tiles = stage1_5Tiles;
					break;
				case 4:
					chosenMap = new level4MapString;
					tiles = stage1_5Tiles;
					break;
				case 5:
					chosenMap = new level5MapString;
					tiles = stage1_5Tiles;
					break;
				case 6:
					chosenMap = new level6MapString;
					tiles = stage6_10Tiles;
					break;
			}
			groundMap = groundMap.loadMapExt(chosenMap, tiles, TILE_SIZE, TILE_SIZE);
			return groundMap;
		}
		
		public static function getBoundaries(_widthInTiles:uint, _heightInTiles:uint):FlxTilemapExt
		{
			var boundaries:FlxTilemapExt = new FlxTilemapExt();
			boundaries = boundaries.createBoundaries(boundaryTiles, TILE_SIZE, TILE_SIZE, _widthInTiles, _heightInTiles);
			return boundaries;
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
				case 6:
					coinData = new level6Coins;
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
			var jewelData:String;
			var tempCoordList:Array = new Array();
			var tempJewel:Array = new Array();
			var jewelList:Array = new Array();
			switch ( level ) {
				case 1:
					jewelData = new level1Jewels;
					break;
				case 2:
					jewelData = new level2Jewels;
					break;
				case 3:
					jewelData = new level3Jewels;
					break;
				case 4:
					jewelData = new level4Jewels;
					break;
				case 5:
					jewelData = new level5Jewels;
					break;
				case 6:
					jewelData = new level6Jewels;
					break;
			}
			tempCoordList = jewelData.split("\n");
			for (var i:int = 0; i < tempCoordList.length; i++)
			{
				tempJewel = tempCoordList[i].split(",");
				jewelList.push( new FlxPoint( tempJewel[0], tempJewel[1] ) );
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
				case 6:
					position = new FlxPoint( 224, 72 );
					break;
			}	
			return position;
		}
	}
}
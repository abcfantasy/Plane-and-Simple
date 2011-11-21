package Managers
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxG;
	
	public class LevelManager 
	{
		// level 1 background
		[Embed(source = "../../assets/graphics/1-5bg.jpg")] public static var level1BgImage:Class;		
		// level 1 tiles
		[Embed(source="../../assets/graphics/tiles_asteroid_line3.png")] private static var stage1Tiles:Class;
		// level 1 map
		[Embed(source = "../../assets/maps/1tutlvl.txt", mimeType = "application/octet-stream")] private static var level1MapString:Class;
		[Embed(source = "../../assets/maps/2tutlvl.txt", mimeType = "application/octet-stream")] private static var level2MapString:Class;
		[Embed(source = "../../assets/maps/3tutlvl.txt", mimeType = "application/octet-stream")] private static var level3MapString:Class;
		[Embed(source = "../../assets/maps/4tutlvl.txt", mimeType = "application/octet-stream")] private static var level4MapString:Class;
		
		private static const GAME_WIDTH:int = 800;
		private static const GAME_HEIGHT:int = 600;
		private static const TILE_SIZE:int = 16;
		
		// gets background image for given level
		public static function getBackgroundImage( level:int ) : FlxSprite
		{
			var background:FlxSprite = new FlxSprite();
			switch ( level ) {
				case 1, 2, 3, 4:
					background = background.loadGraphic( level1BgImage, false, false, GAME_WIDTH, GAME_HEIGHT );
					break;
			}
			return background;
		}
		
		// gets the tile map for given level
		public static function getTileMap( level:int ) : FlxTilemap
		{
			var groundMap:FlxTilemap = new FlxTilemap();
			switch ( level ) {
				case 1:
					groundMap = groundMap.loadMap(new level1MapString, stage1Tiles, TILE_SIZE, TILE_SIZE);
					break;
				case 2:
					groundMap = groundMap.loadMap(new level2MapString, stage1Tiles, TILE_SIZE, TILE_SIZE);
					break;
				case 3:
					groundMap = groundMap.loadMap(new level3MapString, stage1Tiles, TILE_SIZE, TILE_SIZE);
					break;
				case 4:
					groundMap = groundMap.loadMap(new level4MapString, stage1Tiles, TILE_SIZE, TILE_SIZE);
					break;
			}
			return groundMap;
		}
		
		public static function getStartingPoint( level:int ) : FlxPoint
		{
			var result:FlxPoint;
			switch ( level )
			{
				case 1:
					result = new FlxPoint( 174, 67 );
					break;
				case 2:
					result = new FlxPoint( 106, 90 );
					break;
				case 3:
					result = new FlxPoint( 121, 67 );
					break;
				case 4:
					result = new FlxPoint( 184, 69 );
					break;
			}
			return result;
		}
		
		// gets the list of coins for a given level
		public static function getCoins( level:int ) : Array
		{
			var coinList:Array = new Array();
			switch ( level ) {
				case 1:
					coinList.push( new FlxPoint( 175,159 ) );
					coinList.push( new FlxPoint( 325,360 ) );
					coinList.push( new FlxPoint( 345,375 ) );
					coinList.push( new FlxPoint( 503,247 ) );
					coinList.push( new FlxPoint( 608,447 ) );
					break;
				case 2:
					coinList.push( new FlxPoint( 160,367) );
					coinList.push( new FlxPoint( 271,207) );
					coinList.push( new FlxPoint( 350,445) );
					coinList.push( new FlxPoint( 520,120) );
					coinList.push( new FlxPoint( 535,135) );
					coinList.push( new FlxPoint( 550,345) );
					coinList.push( new FlxPoint( 568,327) );
					coinList.push( new FlxPoint( 688,175) );
					break;
				case 3:
					coinList.push( new FlxPoint( 112,175) );
					coinList.push( new FlxPoint( 110,259) );
					coinList.push( new FlxPoint( 128,353) );
					coinList.push( new FlxPoint( 148,430) );
					coinList.push( new FlxPoint( 225,496) );
					coinList.push( new FlxPoint( 288,529) );
					coinList.push( new FlxPoint( 352,490) );
					coinList.push( new FlxPoint( 383,447) );
					coinList.push( new FlxPoint( 400,367) );
					coinList.push( new FlxPoint( 406,308) );
					coinList.push( new FlxPoint( 415,238) );
					coinList.push( new FlxPoint( 454,167) );
					coinList.push( new FlxPoint( 497,111) );
					coinList.push( new FlxPoint( 570,84) );
					coinList.push( new FlxPoint( 640,127) );
					coinList.push( new FlxPoint( 639,221) );
					coinList.push( new FlxPoint( 626,306) );
					coinList.push( new FlxPoint( 623,405) );
					break;
				case 4:
					coinList.push( new FlxPoint( 167,150) );
					coinList.push( new FlxPoint( 181,166) );
					coinList.push( new FlxPoint( 150,235) );
					coinList.push( new FlxPoint( 126,319) );
					coinList.push( new FlxPoint( 137,394) );
					coinList.push( new FlxPoint( 151,456) );
					coinList.push( new FlxPoint( 168,471) );
					coinList.push( new FlxPoint( 205,517) );
					coinList.push( new FlxPoint( 263,518) );
					coinList.push( new FlxPoint( 277,502) );
					coinList.push( new FlxPoint( 345,494) );
					coinList.push( new FlxPoint( 365,485) );
					coinList.push( new FlxPoint( 392,469) );
					coinList.push( new FlxPoint( 440,440) );
					coinList.push( new FlxPoint( 456,422) );
					coinList.push( new FlxPoint( 489,387) );
					coinList.push( new FlxPoint( 519,361) );
					coinList.push( new FlxPoint( 551,327) );
					coinList.push( new FlxPoint( 565,311) );
					coinList.push( new FlxPoint( 575,282) );
					coinList.push( new FlxPoint( 573,246) );
					coinList.push( new FlxPoint( 575,199) );
					coinList.push( new FlxPoint( 575,185) );
					coinList.push( new FlxPoint( 566,137) );
					coinList.push( new FlxPoint( 538,106) );
					coinList.push( new FlxPoint( 487,78) );
					coinList.push( new FlxPoint( 470,78) );
					coinList.push( new FlxPoint( 418,92) );
					coinList.push( new FlxPoint( 375,117) );
					coinList.push( new FlxPoint( 359,133) );
					coinList.push( new FlxPoint( 344,180) );
					coinList.push( new FlxPoint( 338,214) );
					coinList.push( new FlxPoint( 335,247) );
					coinList.push( new FlxPoint( 335,262) );
					coinList.push( new FlxPoint( 331,314) );
					coinList.push( new FlxPoint( 335,368) );
					coinList.push( new FlxPoint( 568,454) );
					coinList.push( new FlxPoint( 607,465) );
					coinList.push( new FlxPoint( 647,438) );
					coinList.push( new FlxPoint( 682,408) );
					coinList.push( new FlxPoint( 706,389) );
					coinList.push( new FlxPoint( 727,359) );
					coinList.push( new FlxPoint( 744,340) );
					break;
			}
			return coinList;
		}
	}

}
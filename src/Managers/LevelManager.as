package Managers
{
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
		[Embed(source = "../../assets/maps/5tutlvl.txt", mimeType = "application/octet-stream")] private static var level1MapString:Class;
		
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
			switch ( level ) {
				case 1:
					groundMap = groundMap.loadMap(new level1MapString, stage1Tiles, TILE_SIZE, TILE_SIZE);
					break;
			}
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
	}

}
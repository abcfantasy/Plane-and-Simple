package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxG;
	
	public class LevelManager 
	{
		// level 1 background
		[Embed(source = "../assets/graphics/universe3.jpg")] public static var level1BgImage:Class;		
		// level 1 tiles
		[Embed(source="../assets/graphics/newTiles.png")] private static var stage1Tiles:Class;
		// level 1 map
		[Embed(source = "../assets/test_map.txt", mimeType = "application/octet-stream")] private static var level1MapString:Class;
		
		private static const GAME_WIDTH:int = 800;
		private static const GAME_HEIGHT:int = 621;
		private static const TILE_SIZE:int = 23;
		
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
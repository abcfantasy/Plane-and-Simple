package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flixel.*;

	public class FlxTilemapExt extends FlxTilemap
	{
		private var objPoint:FlxPoint = new FlxPoint();
		private var slopePoint:FlxPoint = new FlxPoint();
		private var objWidth:uint = 0;
		private var objHeight:uint = 0;

		public function loadMapExt(Level:String, TileGraphics:Class, TileWidth:uint=0, TileHeight:uint=0):FlxTilemapExt
		{
			this.loadMap(Level, TileGraphics, TileWidth, TileHeight);
			return this;
		}

		public function solveSlopeCollide(Map:FlxTilemapExt, Plane:B2FlxSprite):Boolean
		{
			var r:uint;
			var c:uint;
			var d:uint;
			var i:uint;
			var dd:uint;
			var blocks:Array = new Array();
			
			//First make a list of all the blocks we'll use for collision
			// ix: n-th block from the left corresponding to left side of plane
			var ix:uint = Math.floor((Plane.x - x) / _tileWidth);
			// iy: n-th block from the top corresponding to top side of plane
			var iy:uint = Math.floor((Plane.y - y) / _tileHeight);
			// iw: number of blocks from left to right side of plane (based on tileWidth)
			var iw:uint = Math.ceil((Plane.x - x + Plane.width) / _tileWidth) - ix;
			// ih: number of blocks from top to bottom of plane (based on tileHeight)
			var ih:uint = Math.ceil((Plane.y - y + Plane.height + 2)/_tileHeight) - iy;

			for (r = 0; r < ih; r++) // the number of blocks that corresponds to the width of the object are traversed
			{
				if ((r < 0) || (r >= heightInTiles)) break;
				// d corresponds to the n-th block in question, used for _data of GroundMap (index for .csv file)
				d = (iy+r)*widthInTiles+ix;
				
				for(c = 0; c < iw; c++) // the number of blocks that corresponds to the height of the object are traversed
				{				
					if ((c < 0) || (c >= widthInTiles)) break;				
					
					dd = _data[d+c]; // dd is the value from the .csv file of the current block (6,7, 9 or 10 for slope blocks)
					if (dd >= collideIndex) {
						// blockImage stores the image of the current block
						var blockImage:BitmapData = new BitmapData(16, 16);
						// it copies the pixels from tiles_asteroid.png that the current block uses
						blockImage.copyPixels(_pixels, new Rectangle(dd * 16, 0, 16, 16), new Point( 0, 0));
						// we create a bitmap based on this bitmapdata
						var bitmap:Bitmap = new Bitmap(blockImage);
						// we set its position to the current block's position (x and y are 0, but this provides support for multiple or movable tilemaps)
						bitmap.x = x + (ix + c) * _tileWidth;
						bitmap.y = y + (iy + r) * _tileHeight;
						// we perform a perfect per-pixel check of overlap between the plane and the bitmap of the block with maximum accuracy (6)
						return FlxHitTest.complexHitTestObject(Plane, bitmap, 6);
					}
				}
			}
			return false;
		}
	}
}
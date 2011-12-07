package
{
	import Box2D.Dynamics.b2Body;
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
		
		public function createBoundaries(TileGraphic:Class, TileWidth:uint, TileHeight:uint, _widthInTiles:uint, _heightInTiles:uint):FlxTilemapExt
		{
			refresh = true;
			
			var cols:Array;
			var rows:Array = new Array;
			rows[0] = new String("6");
			for (var i:uint = 0; i < _widthInTiles - 2; i++)
				rows[0] = rows[0].concat(",1");
			rows[0] = rows[0].concat(",7");
			for (var j:uint = 1; j < _heightInTiles - 1; j++)
			{
				rows[j] = new String("3");
				for (var k:uint = 0; k < _widthInTiles - 2; k++)
					rows[j] = rows[j].concat(",0");
				rows[j] = rows[j].concat(",2");
			}
			rows[_heightInTiles - 1] = new String("5");
			for (var l:uint = 0; l < _widthInTiles - 2; l++)
				rows[_heightInTiles - 1] = rows[_heightInTiles - 1].concat(",4");
			rows[_heightInTiles - 1] = rows[_heightInTiles - 1].concat(",8");
			heightInTiles = rows.length;

			_data = new Array();
			var r:uint = 0;
			var c:uint;
			while(r < heightInTiles)
			{
				cols = rows[r++].split(",");
				if(cols.length <= 1)
				{
					heightInTiles = heightInTiles - 1;
					continue;
				}
				if(widthInTiles == 0)
					widthInTiles = cols.length;
				c = 0;
				while(c < widthInTiles)
					_data.push(uint(cols[c++]));
			}
			
			//Pre-process the map data if it's auto-tiled
			var i:uint;
			totalTiles = widthInTiles*heightInTiles;
			if(auto > OFF)
			{
				collideIndex = startingIndex = drawIndex = 1;
				i = 0;
				while(i < totalTiles)
					autoTile(i++);
			}
			
			//Figure out the size of the tiles
			_pixels = FlxG.addBitmap(TileGraphic);
			_tileWidth = TileWidth;
			if(_tileWidth == 0)
				_tileWidth = _pixels.height;
			_tileHeight = TileHeight;
			if(_tileHeight == 0)
				_tileHeight = _tileWidth;
			_block.width = _tileWidth;
			_block.height = _tileHeight;
			
			//Then go through and create the actual map
			width = widthInTiles*_tileWidth;
			height = heightInTiles*_tileHeight;
			_rects = new Array(totalTiles);
			i = 0;
			while(i < totalTiles)
				updateTile(i++);
			
			//Also need to allocate a buffer to hold the rendered tiles
			var bw:uint = (FlxU.ceil(FlxG.width / _tileWidth) + 1)*_tileWidth;
			var bh:uint = (FlxU.ceil(FlxG.height / _tileHeight) + 1)*_tileHeight;
			_buffer = new BitmapData(bw,bh,true,0);
			
			//Pre-set some helper variables for later
			_screenRows = Math.ceil(FlxG.height/_tileHeight)+1;
			if(_screenRows > heightInTiles)
				_screenRows = heightInTiles;
			_screenCols = Math.ceil(FlxG.width/_tileWidth)+1;
			if(_screenCols > widthInTiles)
				_screenCols = widthInTiles;
			
			_bbKey = String(TileGraphic);
			generateBoundingTiles();
			refreshHulls();
			
			_flashRect.x = 0;
			_flashRect.y = 0;
			_flashRect.width = _buffer.width;
			_flashRect.height = _buffer.height;
			
			return this;
		}

		public function solveSlopeCollide(Map:FlxTilemapExt, Plane:B2FlxSprite):uint
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
						if (FlxHitTest.complexHitTestObject(Plane, bitmap, 6))
							return dd;
					}
				}
			}
			return 0;
		}		
	}
}
package  
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxGradient;
	
	public class SimpleBar extends FlxSprite
	{
		private var value:Number;
		
		private var pxPerHealth:Number;
		private var min:uint;
		private var max:uint;
		
		private var zeroOffset:Point = new Point;
		
		private var emptyBar:BitmapData;
		private var emptyBarRect:Rectangle;
		
		private var filledBar:BitmapData;
		private var filledBarRect:Rectangle;
		
		public function SimpleBar( X:int, Y:int, Width:int, Height:int, Min:uint = 0, Max:uint = 100 ):void 
		{
			super();

			this.createGraphic( Width + 2, Height + 2, 0xffffffff, true );
			//makeGraphic(Width + 2, Height + 2, 0xffffffff, true);
			width = Width + 2;
			height = Height + 2;
			this.x = X;
			this.y = Y;
			
			setRange(Min, Max);
			
			//createFilledBar(0xff005100, 0xff00F400, Border);
		}
		
		/**
		 * Set the minimum and maximum allowed values for the parents health value
		 * 
		 * @param	Min		Minimum allowed health value
		 * @param	Max		Maximum allowed health value
		 */
		public function setRange(Min:uint, Max:uint):void
		{
			if (Max == 0)
			{
				return;
			}
			
			if (Min == Max)
			{
				return;
			}
			
			if (Max < Min)
			{
				throw Error("FlxHealthBar: max cannot be less than min");
				return;
			}
			
			min = Min;
			max = Max;
			
			pxPerHealth = (width / max);
		}
		
		/**
		 * Creates a gradient filled health bar using the given colour ranges, with optional 1px thick border.<br />
		 * All colour values are in 0xAARRGGBB format, so if you want a slightly transparent health bar give it lower AA values.
		 * 
		 * @param	empty		Array of colour values used to create the gradient of the health bar when empty, each colour must be in 0xAARRGGBB format (the background colour)
		 * @param	fill		Array of colour values used to create the gradient of the health bar when full, each colour must be in 0xAARRGGBB format (the foreground colour)
		 * @param	chunkSize	If you want a more old-skool looking chunky gradient, increase this value!
		 * @param	rotation	Angle of the gradient in degrees. 90 = top to bottom, 180 = left to right. Any angle is valid
		 * @param	showBorder	Should the bar be outlined with a 1px solid border?
		 * @param	border		The border colour in 0xAARRGGBB format
		 */
		public function createGradientBar(empty:Array, fill:Array, chunkSize:int = 1, rotation:int = 180, showBorder:Boolean = false, border:uint = 0xffffffff):void
		{
			//barType = BAR_GRADIENT;
			
			//if (showBorder)
			//{
				emptyBar = new BitmapData(width, height, true, border);
				FlxGradient.overlayGradientOnBitmapData(emptyBar, width - 2, height - 2, empty, 1, 1, chunkSize, rotation);
				
				filledBar = new BitmapData(width, height, true, border);
				FlxGradient.overlayGradientOnBitmapData(filledBar, width - 2, height - 2, fill, 1, 1, chunkSize, rotation);
			//}
			//else
			//{
			//	emptyBar = FlxGradient.createGradientBitmapData(width, height, empty, chunkSize, rotation);
			//	filledBar = FlxGradient.createGradientBitmapData(width, height, fill, chunkSize, rotation);
			//}
			
			emptyBarRect = new Rectangle(0, 0, emptyBar.width, emptyBar.height);
			filledBarRect = new Rectangle(0, 0, filledBar.width, filledBar.height);
		}
		
		/**
		 * Internal
		 * Called when the health bar detects a change in the health of the parent.
		 */
		private function updateBar():void
		{
			var temp:BitmapData = pixels;
			
			temp.copyPixels(emptyBar, emptyBarRect, new Point(0, 0));
			
			if (value < min)
			{
				filledBarRect.width = int(min * pxPerHealth);
			}
			else if (value > max)
			{
				filledBarRect.width = int(max * pxPerHealth);
			}
			else
			{
				filledBarRect.width = int(value * pxPerHealth);
			}
			
			if (value != 0)
			{
				filledBarRect.x = int((width / 2) - (filledBarRect.width / 2));
				temp.copyPixels(filledBar, filledBarRect, new Point((width / 2) - (filledBarRect.width / 2), 0));
				/*
				switch (fillDirection)
				{
					case FILL_LEFT_TO_RIGHT:
						temp.copyPixels(filledBar, filledBarRect, zeroOffset);
						break;
						
					case FILL_RIGHT_TO_LEFT:
						filledBarRect.x = width - filledBarRect.width;
						temp.copyPixels(filledBar, filledBarRect, new Point(width - filledBarRect.width, 0));
						break;
						
					case FILL_INSIDE_OUT:
						filledBarRect.x = int((width / 2) - (filledBarRect.width / 2));
						temp.copyPixels(filledBar, filledBarRect, new Point((width / 2) - (filledBarRect.width / 2), 0));
						break;
				}
				*/
			}
			
			pixels = temp;
					
			//prevHealth = parent.health;
		}
		
		public function setValue( newValue:Number ):void
		{
			this.value = newValue;
			updateBar();
		}
		
		override public function update():void
		{
			super.update();
		}
	}

}
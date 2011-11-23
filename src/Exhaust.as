package  
{
	import org.flixel.FlxSprite;
	public class Exhaust extends FlxSprite
	{
		// image of exhaust
		[Embed(source = "../assets/graphics/exhaust_animated.png")]public var exhaustImage:Class;
		
		public function Exhaust() 
		{
			this.x = -42;		// this is the answer to a weird problem and everything else
			this.loadGraphic( exhaustImage, true, false, 15, 15 );
			this.addAnimation( "exhaust", [0, 1, 2, 3, 4], 5, false );
		}
		
		override public function onEmit():void 
		{
			super.onEmit();
			
			this.visible = true;
			play("exhaust");
		}
		

		override public function update():void 
		{
			super.update();
			
			if ( this.frame == 4 )
				this.visible = false;
		}
	}

}
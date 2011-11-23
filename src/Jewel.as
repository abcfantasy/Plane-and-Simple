package  
{
	import org.flixel.FlxG;
	
	public class Jewel extends PaSObject
	{
		[Embed(source = "../assets/graphics/jewel2_animated.png")] public var jewelImage:Class;
		
		private var onTaken_:Function;
		
		public function Jewel(x:int, y:int, player:*, emitter:*, onTaken:Function )
		{
			super(x, y, player, emitter);
			onTaken_ = onTaken;
			this.loadGraphic(jewelImage, false, false, 16, 16);
			this.addAnimation("shine", [0, 1, 2, 3, 4, 5, 6, 7], 3);
			play("shine");
		}
		
		override public function update():void
		{
		
			if (this.withinRange())
			{	
				if ( this.onTaken_ != null )
					onTaken_(this);
				else
					this.kill();		// kill jewel if no coinTaken function callback is set
			}
			
			super.update();
		}
	}
}
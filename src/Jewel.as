package  
{
	import org.flixel.FlxG;
	
	public class Jewel extends PaSObject
	{
		[Embed(source = "../assets/graphics/jewel.png")] public var jewelImage:Class;
		
		private var onTaken_:Function;
		
		public function Jewel(x:int, y:int, player:*, emitter:*, onTaken:Function )
		{
			super(x, y, player, emitter);
			onTaken_ = onTaken;
			this.loadGraphic(jewelImage, false, false, 16, 16);
		}
		
		override public function update():void
		{
		
			if (this.withinRange())
			{	
				if ( this.onTaken_ != null )
					onTaken_(this);
				else
					this.kill();		// kill coin if no coinTaken function callback is set
			}
			
			super.update();
		}
	}
}
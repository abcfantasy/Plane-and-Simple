package  
{
	import org.flixel.FlxG;
	
	public class Jewel extends PaSObject
	{
		[Embed(source="../assets/graphics/jewel.png")] public var jewelImage:Class;
		
		public function Jewel(x:int, y:int, player:*, emitter:*)
		{
			super(x, y, player, emitter);
			this.loadGraphic(jewelImage, false, false, 16, 16);
		}
		
		override public function update():void
		{
		
			if (this.withinRange())
			{	
				emitter_.at(this);
				emitter_.start(true, 0.5, 10);
				FlxG.score += 5;
				this.kill();
			}
			
			super.update();
		}
	}
}
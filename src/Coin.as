package
{
	import org.flixel.FlxG;
	
	public class Coin extends PaSObject
	{
		[Embed(source="../assets/graphics/coin.png")] public var coinImage:Class;
		private var emitter_:*;
		
		public function Coin(x:int, y:int, player:*, emitter:*)
		{
			super(x, y, player);
			emitter_ = emitter;
			
			this.loadGraphic( coinImage, true, false, 16, 16 );
			this.addAnimation( "spin", [0, 1, 2, 3, 4, 5, 6, 7], 16 );
			
			play( "spin" );
		}
		
		override public function update():void
		{
			// within distance threshold
			if (this.withinRange())
			{
				// emit particles
				emitter_.at( this );
				emitter_.start( true, 0.5, 10 );
				
				// play coin
				SoundManager.TakeCoin();
				
				// add score
				FlxG.score++;
				
				this.kill();
			}
			
			super.update();
		}
	}
}
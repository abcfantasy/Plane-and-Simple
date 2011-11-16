package
{
	import org.flixel.FlxG;
	
	public class Coin extends PaSObject
	{
		[Embed(source="../assets/graphics/coin.png")] public var coinImage:Class;

		private var emitter_:*;		
		private var onTaken_:Function;
		
		public function Coin(x:int, y:int, player:*, emitter:*, onTaken:Function )
		{
			super(x, y, player);
			emitter_ = emitter;
			onTaken_ = onTaken;
			
			this.loadGraphic( coinImage, true, false, 16, 16 );
			this.addAnimation( "spin", [0, 1, 2, 3, 4, 5, 6, 7], 16 );
			
			play( "spin" );
		}
		
		override public function update():void
		{
			// within distance threshold
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
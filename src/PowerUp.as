package  
{
	import org.flixel.FlxG;
	
	public class PowerUp extends PaSObject
	{
		// [Embed(source="../assets/graphics/powerUp.png")] public var powerUpImage:Class;
		private var type;
		
		public function PowerUp(x:int, y:int, player:*, powerUpType:String)
		{
			super(x, y, player, null);
			
			type = powerUpType;		
		}
		
		override public function update():void
		{
		
			if (this.withinRange())
			{	
				// play coin
				//SoundManager.TakeCoin();
				
				// add score
				//FlxG.score++;
				
				this.kill();
			}
			
			super.update();
		}
	}
}
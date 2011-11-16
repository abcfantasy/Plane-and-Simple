package Managers
{
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	
	public class SoundManager 
	{
		// explosion
		[Embed(source = "../../assets/sounds/Boom_all.mp3")] private static var boomSound:Class;
		
		// coins
		[Embed(source = "../../assets/sounds/coin1.mp3")] private static var coin1Sound:Class;
		[Embed(source = "../../assets/sounds/coin2.mp3")] private static var coin2Sound:Class;
		[Embed(source = "../../assets/sounds/coin3.mp3")] private static var coin3Sound:Class;
		[Embed(source = "../../assets/sounds/coin4.mp3")] private static var coin4Sound:Class;
		
		public static function Explosion():void
		{
			FlxG.play( boomSound );
		}
		
		public static function TakeCoin():void
		{
			var index:int = Math.random() * 3;
			switch ( index )
			{
				case 0:
					FlxG.play( coin1Sound );
					break;
				case 1:
					FlxG.play( coin2Sound );
					break;
				case 2:
					FlxG.play( coin3Sound );
					break;
				case 3:
					FlxG.play( coin4Sound );
					break;
			}
		}
	}

}
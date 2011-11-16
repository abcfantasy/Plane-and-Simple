package States
{
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	
	public class EndLevelState extends FlxState
	{
		override public function create():void 
		{
			super.create();
			
			// create level complete
			var levelComplete:FlxText = new FlxText( 20, 50, FlxG.width - 20, "Level " + FlxG.level + " Complete!" );
			levelComplete.setFormat( null, 25, 0xFFFFFFFF, "center" );
			this.add( levelComplete );
			
			var instructions:FlxText = new FlxText( 20, 150, FlxG.width - 20, "Press ENTER/SPACE to play next level or ESC to go back to the main menu." );
			instructions.setFormat( null, 14, 0xFFFFFFFF, "center" );
			this.add( instructions );
		}
		
		override public function update():void 
		{
			super.update();
			
			//if ( FlxG.keys.justPressed( "ENTER" ) || FlxG.keys.justPressed( "SPACE" ) )
			//{
				
			//}
		}
	}

}
package  
{
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	
	public class MenuState extends FlxState
	{
		// sort of "constructor"
		override public function create():void 
		{
			super.create();
			
			// create title
			var title:FlxText = new FlxText( 0, 70, FlxG.width, "Plane And Simple" );
			title.setFormat( null, 48, 0xFFFFFFFF, "center", 0xFFFF8888 );
			this.add( title );
			
			// show instructions
			var instructions:FlxText = new FlxText( 20, 220, FlxG.width - 20, "Press space to begin." );
			instructions.setFormat( null, 14, 0xFFFFFFFF, "center" );
			this.add( instructions );
		}
		
		override public function update():void 
		{
			super.update();
			
			// check input
			if ( FlxG.keys.justPressed("SPACE") )
			{
				FlxG.level = 1;
				FlxG.score = 0;
				FlxG.state = new PlayState();
			}
		}
	}

}